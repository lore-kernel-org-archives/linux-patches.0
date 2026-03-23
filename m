Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F7C40DFC4;
	Mon, 23 Mar 2026 14:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275472; cv=none; b=Da0lRUOkbT5qcrDP+y9n1zgiOcw9H4n/Gpt99bOSHEuGoGCfbNFxsl9Q1YdCn+GRJqSNOgC52S+wW4N8OZ+ebuGhaNb/1Z6bDCzwyJkRVrX85p+5+Ndhyi5VM0sGGaz9CNn6Kzn6jKl0fUwiN3oN+2wwxUb5j9Z9mGl/KwfIstE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275472; c=relaxed/simple;
	bh=tq34NGZOWzPQFUbwQot+pB3uV+lCBHYYgziPI9Ji6nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uh1mh7NJ8hsCO96MZzAsjiSikUMEoz48ck29Y2RUVh4X7+pXbXVF+nBiRZ+ZVV+9y+dS/nPRF49g0JLlsZ5chcea/etmaLBwyD0i83WBDy2cYhvF5J0RFxMMqKiCTZgpe6M9IDtTOliQ+iCV4sHZSYJlhjaWs8Cw09F0W5kG92I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8ulgR2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8ulgR2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70954C4CEF7;
	Mon, 23 Mar 2026 14:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275471;
	bh=tq34NGZOWzPQFUbwQot+pB3uV+lCBHYYgziPI9Ji6nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8ulgR2+n4i3LYaFAp7XlAXMxy7dUjua97ixpe7xym8SyfTUr/9qwbbqyuJdHOdde
	 WRzJ/MIZ327KKoxpdjLFsAz3pL+zI7RMLj7M+H9xdIWXLXJZpqrvtl0CyNmHNVBoqj
	 EClXAwJrdj1ufSiRuQnzG9PH76JaexSWdbwHB53M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Fan Wu <fanwu01@zju.edu.cn>
Subject: [PATCH 6.12 114/460] usb: renesas_usbhs: fix use-after-free in ISR during device removal
Date: Mon, 23 Mar 2026 14:41:50 +0100
Message-ID: <20260323134529.438351484@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit 3cbc242b88c607f55da3d0d0d336b49bf1e20412 upstream.

In usbhs_remove(), the driver frees resources (including the pipe array)
while the interrupt handler (usbhs_interrupt) is still registered. If an
interrupt fires after usbhs_pipe_remove() but before the driver is fully
unbound, the ISR may access freed memory, causing a use-after-free.

Fix this by calling devm_free_irq() before freeing resources. This ensures
the interrupt handler is both disabled and synchronized (waits for any
running ISR to complete) before usbhs_pipe_remove() is called.

Fixes: f1407d5c6624 ("usb: renesas_usbhs: Add Renesas USBHS common code")
Cc: stable <stable@kernel.org>
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260303073344.34577-1-fanwu01@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/renesas_usbhs/common.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/renesas_usbhs/common.c
+++ b/drivers/usb/renesas_usbhs/common.c
@@ -811,6 +811,15 @@ static void usbhs_remove(struct platform
 
 	usbhs_platform_call(priv, hardware_exit, pdev);
 	reset_control_assert(priv->rsts);
+
+	/*
+	 * Explicitly free the IRQ to ensure the interrupt handler is
+	 * disabled and synchronized before freeing resources.
+	 * devm_free_irq() calls free_irq() which waits for any running
+	 * ISR to complete, preventing UAF.
+	 */
+	devm_free_irq(&pdev->dev, priv->irq, priv);
+
 	usbhs_mod_remove(priv);
 	usbhs_fifo_remove(priv);
 	usbhs_pipe_remove(priv);


