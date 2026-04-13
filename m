Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3E323E342;
	Mon, 13 Apr 2026 16:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098825; cv=none; b=UGLNA3ZiRIKj9pehLPJAXMKwOHB6boxFbqHynRDgS5OaQzBCEXAF5ZvffmRUGrY00HxGKGPKYGSXI+ZgzAnDf+2lRR78aUyH8wWc4H+M2JMFYqQFJvtdPrmHrvdK9IL9bAXUbq0iiqQDPskX69elX2yy7BnAestm0PlC/80vsnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098825; c=relaxed/simple;
	bh=u8bluIY8cGULGsv4BlrGBh/ofjeGq0pjy30uG3EX6Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmpCTIrYxdlK1NANYwlLkPqJvpS4bKpemS2IA7muecdITCGLxNshykkk3WfNHO/Oa6xKdxIWECq8ZxYOYixLr5bsKpUD9Ql87jRljZtbqFv8D+EFoksDu69jSsLU9dUH6NNUo2NLaRABKUqJ5fVYQSf10jZX7dSxqoCrri03fTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Qn3d8Y4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Qn3d8Y4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21773C2BCAF;
	Mon, 13 Apr 2026 16:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098825;
	bh=u8bluIY8cGULGsv4BlrGBh/ofjeGq0pjy30uG3EX6Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Qn3d8Y4Cg9q9ph/YsjpCJLIjO4yo3A5zrwn5kkkN/9UXdv+SYvQGIV6QrJ04Xwtk
	 BwDF63Jj5r16djSvyr97N1Rj4inTjicSDR0ugoDDD8hkyrQLNBTGXq8Q5D1yBmYZ9w
	 xUpD1gdtfW0NA7Xryg0jLw686aHuMSIQdPlJ3x+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Fan Wu <fanwu01@zju.edu.cn>
Subject: [PATCH 5.10 102/491] usb: renesas_usbhs: fix use-after-free in ISR during device removal
Date: Mon, 13 Apr 2026 17:55:47 +0200
Message-ID: <20260413155822.863183646@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -804,6 +804,15 @@ static int usbhs_remove(struct platform_
 
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


