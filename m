Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0FF1A6818;
	Mon, 23 Mar 2026 13:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273982; cv=none; b=om70gsOR+hzngpO0skBOH0GQJVZO6C+SEU4fdTP8XvzIuubYzznoxEeoFrxm46Scpx0vzkK1qrbyAf1Eltlcs42JRW+8uTZqxJuWMsT+y/ab1G0/GETs2ylR1BZ7dPRRE4VHzfrSzixDBqgVMwYHZPqntiymklZe9sX45FIxB+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273982; c=relaxed/simple;
	bh=u2TWXPDAAprn1JRvLcG0kyBkjzenOjJuJAT1GU8hsrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akqhYlioQb+zSbuEFX/DadAmzFG/aWTrIxuYzyU+GyeKrG0KFgBRmZi+wBnbNlEWEwn1gJLHBtWIA/dtOKzU6svwtwCcVKsR8Rb8s+LlTZj6gOO/T8ymJR0M6pazqXp24mN/sV9BlaQqk9u1ZdMGOFwjaYPY74WWoG/BCQQ/L7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVwy8KcK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVwy8KcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF5CC4CEF7;
	Mon, 23 Mar 2026 13:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273982;
	bh=u2TWXPDAAprn1JRvLcG0kyBkjzenOjJuJAT1GU8hsrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVwy8KcKgoPg1bLUz//UmJ2QJlFf0qC9uifrN9z/eba3HGZ/kt5lXTgXOEoTAcIft
	 mt7rTELpTDopEWclBvAMbHEosqNZI66WiyQxiuDZsq59oMAK8Tukc6cJU1692KXNYN
	 BuJQLmeO6pxvpA0biOJQq2C3jnMMoJozRFZqnV7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.19 069/220] serial: core: fix infinite loop in handle_tx() for PORT_UNKNOWN
Date: Mon, 23 Mar 2026 14:44:06 +0100
Message-ID: <20260323134506.775093276@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@shopee.com>

commit 455ce986fa356ff43a43c0d363ba95fa152f21d5 upstream.

uart_write_room() and uart_write() behave inconsistently when
xmit_buf is NULL (which happens for PORT_UNKNOWN ports that were
never properly initialized):

- uart_write_room() returns kfifo_avail() which can be > 0
- uart_write() checks xmit_buf and returns 0 if NULL

This inconsistency causes an infinite loop in drivers that rely on
tty_write_room() to determine if they can write:

  while (tty_write_room(tty) > 0) {
      written = tty->ops->write(...);
      // written is always 0, loop never exits
  }

For example, caif_serial's handle_tx() enters an infinite loop when
used with PORT_UNKNOWN serial ports, causing system hangs.

Fix by making uart_write_room() also check xmit_buf and return 0 if
it's NULL, consistent with uart_write().

Reproducer: https://gist.github.com/mrpre/d9a694cc0e19828ee3bc3b37983fde13

Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260204074327.226165-1-jiayuan.chen@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -643,7 +643,10 @@ static unsigned int uart_write_room(stru
 	unsigned int ret;
 
 	port = uart_port_ref_lock(state, &flags);
-	ret = kfifo_avail(&state->port.xmit_fifo);
+	if (!state->port.xmit_buf)
+		ret = 0;
+	else
+		ret = kfifo_avail(&state->port.xmit_fifo);
 	uart_port_unlock_deref(port, flags);
 	return ret;
 }


