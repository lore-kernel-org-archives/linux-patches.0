Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F422D3225;
	Sat, 17 Oct 2026 17:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258387; cv=none; b=ZtLsiZzmzq6vFtubX2OQSbby7VD/eGLEOEIth7IqIrxMrOp0QipmDYQ5UhVL+uHqgI5NdxramfhIdmOo2MdFIfThTuQDTNfg8ptR2Mfc/3ZEmQhJCV+QI2gnq2a54PxEqbV2fLywAMe03RnKef52eBMY128b0y8fMhD8xX6+avs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258387; c=relaxed/simple;
	bh=GIfXLFz3vycGb2IiqO7c8JcC5wOUmnDT71SYx0dSxWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdw2nerfxr+VJIFpaynWCuEVKAmN9PIrQPpLxPR2pG2k4DGRmzSZ8gkuFvtXvBX8F1LhpDWUeCSbI/EVz12ANFARlK8+P9EL4Dl2tK8bJcI00Opi4H9sTl03HfAme1KG2/YYrdKq5FUotL+ZwMhHdB/wrd3azLUzY3deBI2RJ1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YFGtthCH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFGtthCH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798B51F000C4;
	Sat, 17 Oct 2026 17:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258386;
	bh=rejx/gVmbEXW0OQ1Gwlxp7/a2B6oyRUljgbYFVQCMD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YFGtthCHUWph4QbCXAGYaMZ5f5CpOjkdeUPTjr7aW7fe1esVIa6mV0Jp6lSr9vHkf
	 oDyx96XZ1/YYSUm5rNlhkiJ4mH+LNo0OAoQ0j/SHjsliwb5Q4bhWcn9YHfrInuZKYV
	 7mLzozeKObdBp4KPmhX2y62ZFsfJrbbU0yghJz9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	stable <stable@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0867/1674] serial: core: fix infinite loop in handle_tx() for PORT_UNKNOWN
Date: Sat, 17 Oct 2026 17:52:19 +0200
Message-ID: <20261017160453.367555255@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@shopee.com>

[ Upstream commit 455ce986fa356ff43a43c0d363ba95fa152f21d5 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 87bd1be81f77c..e28f2e0c4b10f 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -643,7 +643,10 @@ static unsigned int uart_write_room(struct tty_struct *tty)
 	unsigned int ret;
 
 	port = uart_port_lock(state, flags);
-	ret = uart_circ_chars_free(&state->xmit);
+	if (!state->xmit.buf)
+		ret = 0;
+	else
+		ret = uart_circ_chars_free(&state->xmit);
 	uart_port_unlock(port, flags);
 	return ret;
 }
-- 
2.53.0



