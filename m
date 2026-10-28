Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210996;
	b=4nBUerT02yMo2yBmYgACCE7U12ku78fV4Yynp8VLMG92HWeNFWldt318gXohDaWE01Gg
	 zQpzjw/uIz/zEt/on0SmJfotUkcLButpJK7Noqrvxs57NqkfRmWnoAbwQvtuaCb8gzf0z
	 3PjgYJcN/IPY+IKbfpeUxkYwc+MtcFjlZIRHweoYOMCgeXiU/ct/gOSC8/l8QEr8JO0y0
	 97SpuzRPV34tvhyMIZebCaenNngWBN4cVz8xzTQ6BIJFCquVmjIWKgEmxF4bFERYj+QSf
	 lb08I1FSSVE1sbPf7kiEeVuSwIJsBRQ6cqxHS6HeqwrK7c7+/Y6u7jnqaoGL6MVUNiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210996;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yznWJI+8O8iwONyrU9mwEEuSCWxPRrpHAALq2b/SDC8=;
	b=n+cf8YUKodPnHlTtP3n6WyAqOuB9ZuyHpUIWrV5UqJSQd+Ityl4a7eMSqIFONN4sPiVk
	 +/LJEVA7ZNB3Fbg4+eJg+1pBvjgmAtvF49yUz6HlUWbPiDda4nvanL7uXRl4wtRfA1r5R
	 Vdfe271W7Sa8hJ0M3aypRTu7mH16MU+cCmGEplgn//h6b3XRAiASitiBnXlXibuxteJvi
	 I/8C43JVqfP0qAwXuzV75QLQcbNdKgA2xNPDmyqZA3Do7Q65v6gZ9CyYTbdVOCawyByKO
	 zi6XH88ALgqARkFv6J6i2pc08F+vcHtSW+XUh0K6CcAxwJBCb+scC7St2u+pOfwgJiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b7iGCzX4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7FD606A31D;
	Wed, 28 Oct 2026 18:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b7iGCzX4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5DC1F01829;
	Wed, 28 Oct 2026 18:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210995;
	bh=yznWJI+8O8iwONyrU9mwEEuSCWxPRrpHAALq2b/SDC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b7iGCzX4W6p805SmmQoeKEllzbIdvfhiCKs/+qSMxdveUgkwF1uoXPUMQ0yT2PR0M
	 Jxk2iY2dtw127Mcjjvuz19DQ8BXG1NMM0h02kBmLVCxWFUvIetdphacgBImS0hfbtu
	 jcmhFO442cGBXWjZr4mTLJnASgSNHzdIVAR4oWTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 5.15 220/571] serial: 8250_bcm7271: fix use-after-free in brcmuart_remove()
Date: Wed, 28 Oct 2026 17:56:07 +0100
Message-ID: <20261028170013.221799450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 189b9dc8c96ec9486482f27c1372b04a7152175e upstream.

brcmuart_handle_irq() starts priv->hrt to work around a receive-timeout
quirk of the 8250 core when hardware flow control is enabled; the timer
callback brcmuart_hrtimer_func() dereferences priv.

brcmuart_remove() cancels the hrtimer before it unregisters the port, so
a receive-timeout interrupt that arrives in between re-arms the timer.
After devm frees priv, the callback runs on freed memory.

Unregister the port before cancelling the hrtimer.
serial8250_unregister_port() shuts the port down and frees its IRQ, so
brcmuart_handle_irq() can no longer restart the timer, and the final
hrtimer_cancel() drains any timer that was armed before or during the
unregister.

This issue was found by an in-house static analysis tool.

Fixes: 41a469482de2 ("serial: 8250: Add new 8250-core based Broadcom STB driver")
Cc: stable@kernel.org
Assisted-by: Codex:gpt-5.6
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260909084002.686911-1-fanwu01@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_bcm7271.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_bcm7271.c
+++ b/drivers/tty/serial/8250/8250_bcm7271.c
@@ -1155,8 +1155,8 @@ static int brcmuart_remove(struct platfo
 	struct brcmuart_priv *priv = platform_get_drvdata(pdev);
 
 	debugfs_remove_recursive(priv->debugfs_dir);
-	hrtimer_cancel(&priv->hrt);
 	serial8250_unregister_port(priv->line);
+	hrtimer_cancel(&priv->hrt);
 	brcmuart_free_bufs(&pdev->dev, priv);
 	clk_disable_unprepare(priv->baud_mux_clk);
 	if (priv->dma_enabled)


