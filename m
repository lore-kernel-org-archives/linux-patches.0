Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483444CF49A;
	Sat, 17 Oct 2026 16:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253654; cv=none; b=eFXR0X3sa+d91WDuJ/t9rORmKlrLF3P8i5/GJZ9VkTJSHHdc9mQqUDkmHYZV4YPzFCPAQXPSPEh6bvO+ryqGOj9piubJdMwZyjvcUDFpgxMyXFFdOEL7dON6PxdNX9fdghnCKAeQhm51ps+h6eqcSH0KDygcSEYGvg84Ok+yuAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253654; c=relaxed/simple;
	bh=8wibhijurDDSCNVfdLO7bmJpc73NJL4nYjeDGbIoTIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhLcxOiEJC70HHz6bPta9eRp7nf0SZCuhnT1YsiSYsYolbleS5WFuw17lvzUVU4VrXUCSkgxQKVhVg6v1by5PuWWHMQY77kmISD+36zgA26Dxk9iLrlGfD3XR6GxdGqPyhgtF0hx3wXjbY6PC97d+5cRJJWSigS14RjAuPANC2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WYQKaLml; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WYQKaLml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962DE1F000C4;
	Sat, 17 Oct 2026 16:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253653;
	bh=s8UUKOE+MOx2HsCxBVRl21rKgND3+RdlAg0rG0zQ5/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WYQKaLmlUW+ktv0PIr24tQ553knnA9ESVjIo4/MeHE9GAKb6wM626ZGwv+ZTIURPv
	 Tli5YT0X3DshzPMM8jOzFiBXQIFpe7wm4VacOas2iyBWAW+zEclklNpj+QuM5Z1Ioi
	 z3OKPMbRHO/0UAFqmoYhuuAgmAvTtHJCZL2SjOFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	stable <stable@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 188/869] serial: core: fix infinite loop in handle_tx() for PORT_UNKNOWN
Date: Sat, 17 Oct 2026 17:50:29 +0200
Message-ID: <20261017160041.878656725@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3d5ad8975bf57..816f83141afd3 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -646,7 +646,10 @@ static unsigned int uart_write_room(struct tty_struct *tty)
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
-- 
2.53.0



