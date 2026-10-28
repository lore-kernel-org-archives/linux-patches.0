Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214686;
	b=3IzPyPs8g8BniUQQ5AZg36Mk8XPG+5VPR89au8p4Jh0fIGSKn3JQInESj2ZTpECDKkAv
	 UquC1mkUrqISN58i0rDJwaCxFLBxkQ8DRT8+BCh7/+HUn5d2gZXJXWWOmf/w+0nalA6EQ
	 0mUr9IwWtiS/7ZrObDCQkLrDuEVZ8qw2YE69FzcxU1m/ydY1Y87Qz+LziMIRAf6YtrUK+
	 X3ckJ08OklyJei8c0aOzsRUclzcN5ShKesyh/NIzEeiOFuYYbbJMM15PCcXR/EqYhggzD
	 9VQP0jcyu0tyhS45adCl/7A+nD8Q5R+QIos8hjY7wdpo0THryQ0jKRwtTtue/S2W7vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xfc8NQucg1kPtyhTfEdIC5wzWe9R4iDFJsTmXD9HQPo=;
	b=dKdyLJgoG8Xo6xNTZs0QTFfWHSzDOX/akk/1VunOqH6qBE7VrQKbv/ZvrJnTWH96yDUS
	 0ugysUhTAmNLXRJcCgV1HEyvLX71fk3lrQbGieHyV2kDUPbJDWlOOXh7e3gAJ4sxjROQY
	 ry4MrdEgIz82/auOd4hy4FXuYcMgF4uGWjoIMp4jwXNDWVEmDyvxRTLWv5TcWH296O0UO
	 JeWN7hGo38tG9pYrnT0JCsVgFpda2nVbUFhqnJiZULqJyjDJWcIpy41696D3WH3q86NYb
	 1ExvNSa/gjYBWv8j//4gzHsmCRnbvjHJ0EWjOX8wKJb8Xd9aYqBJ0syAh/Oo5pttiNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YnHLB71j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62131606A31D;
	Wed, 28 Oct 2026 19:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YnHLB71j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7149B1F01829;
	Wed, 28 Oct 2026 19:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214686;
	bh=xfc8NQucg1kPtyhTfEdIC5wzWe9R4iDFJsTmXD9HQPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YnHLB71jMuudDIylTCgRgVnmyMZ9AacJutA880Voqg9bmkW1bCZRCg2Vdv0Uy8nRF
	 gA+bswRkFJW+nJAsDgQPBg01NufDbZ7N/ia3FxsJpXUIG58psiIQwCLm1/OUze2QgE
	 CM+HPJyY8Z1XBCB/WYv+bJSexaf2roXKg7PEvDyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	stable <stable@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0944/1887] serial: core: fix infinite loop in handle_tx() for PORT_UNKNOWN
Date: Wed, 28 Oct 2026 17:50:40 +0100
Message-ID: <20261028170520.892488146@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index dafbd24b91484..4b035292a3840 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -610,7 +610,10 @@ static unsigned int uart_write_room(struct tty_struct *tty)
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



