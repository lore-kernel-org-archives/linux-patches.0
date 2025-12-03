Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF16A393DF8;
	Wed,  3 Dec 2025 16:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780705; cv=none; b=st2h7TJjQjvI95XA8NAVMEiJWDZLRy6+0TjDHRvZRxS+8p0kW9rqALo5mptwtgDZH2qJSubVGvys+gwoH8uMe4QupIJo2F8YY3CKMQciCEdEBTrqVLOR/fLSx/mVir+n7yoCAtrptvWGz3kb/QdxYWwwqZif9d2662y4OtUrZq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780705; c=relaxed/simple;
	bh=BDLYrGdMt4iSy0b2tzU82CyuzOle/quiUHFsvY1VNUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDCIW2PvNONPU02+rNcbHm0zq3j4b2wBG+1WNMZRLu28cdxA/K9Fcea2QXnBuJeNkOM52yz9zo4ANEWDWkJ5SgYTzPom2lmp9Gl/Nuok09HPttJ+2s5/iS7nhLGKF6ZXGP6Sv+qGXKIm5MqJJDDDYGV1OI6H6O+ZDU8alvg8ddk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+aVGAhQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+aVGAhQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C4BC4CEF5;
	Wed,  3 Dec 2025 16:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780705;
	bh=BDLYrGdMt4iSy0b2tzU82CyuzOle/quiUHFsvY1VNUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+aVGAhQr78SR3kLNdZUFJG+k4B9Obduwou230l2zo2QSdHIvDmqSSf7ySc8etZ0f
	 ALE7Y/grsnB0FYGzspuuGQow9J4h3OzdsKVaAhvio1M9BVwHID1lTuAFvIHXE1E/13
	 YqqtnNoeDT1xXjRCTRNs3X1Y/8bI4WEig7vzLFBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Herve Codina <herve.codina@bootlin.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/132] usb: gadget: renesas_usbf: Handle devm_pm_runtime_enable() errors
Date: Wed,  3 Dec 2025 16:28:32 +0100
Message-ID: <20251203152344.525444324@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 74851fbb6d647304f8a7dc491434d3a335ef4b8d ]

devm_pm_runtime_enable() can fail due to memory allocation.
The current code ignores its return value, potentially causing
pm_runtime_resume_and_get() to operate on uninitialized runtime
PM state.

Check the return value of devm_pm_runtime_enable() and return on failure.

Fixes: 3e6e14ffdea4 ("usb: gadget: udc: add Renesas RZ/N1 USBF controller support")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Acked-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20251124022215.1619-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/renesas_usbf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/renesas_usbf.c b/drivers/usb/gadget/udc/renesas_usbf.c
index 657f265ac7cc5..8463f681ae673 100644
--- a/drivers/usb/gadget/udc/renesas_usbf.c
+++ b/drivers/usb/gadget/udc/renesas_usbf.c
@@ -3262,7 +3262,9 @@ static int usbf_probe(struct platform_device *pdev)
 	if (IS_ERR(udc->regs))
 		return PTR_ERR(udc->regs);
 
-	devm_pm_runtime_enable(&pdev->dev);
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret)
+		return ret;
 	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0)
 		return ret;
-- 
2.51.0



