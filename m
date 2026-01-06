Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AE835503F;
	Tue,  6 Jan 2026 17:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720266; cv=none; b=mYP8ZBTL6hSdJyyTtiSd3pjKmkRhkK0MBx7OtyqRHqn2Z/la+rDEQEyiFWdpIxvtde66zOApkYDy3fEj1l9I8I0by87d6Q+qWllQvcPdRbzE0ejCSp0TMi0PZShru3AGEsYpz5R2GeQmEOjxKwA7U/lDh5yE18f17S3+a4ejx9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720266; c=relaxed/simple;
	bh=sjQTya3zhyfiG+dAPH32PdDc40xX9tVHUg1KeABOgb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXcoeVnyQ4LYeEu74YTQytUqvTsZ6utBvJGuO0mphM+rcmZfpPuYyFzGKiijrGm1O2P6PB8O9mpqWR3vOwnGIb1bgMJuqMIQZ9lQx8kTcFg10isWNd+HycXY9r0445NApa+2bmAHu2+mMGET+r5wezZwcKHD3Zn3uExpCLT6IDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCpUC1Ot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCpUC1Ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7878EC116C6;
	Tue,  6 Jan 2026 17:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720265;
	bh=sjQTya3zhyfiG+dAPH32PdDc40xX9tVHUg1KeABOgb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XCpUC1OtQUeOYhiMc5iPYra+LbG5HfNUDdEJ2hXKOD+y3RN5Ti4ouT1Y5cNwe3Pul
	 MBUzYx1seF/jsLgPqFKrpf7TlB4EAQB0oY2iWvr0hVr8QgzIbZ654GQQjRnDAA9mqB
	 dBAJGP9emGOnBhST3XWaR/WbySBhGMOEHak28PNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH 6.12 185/567] usb: phy: fsl-usb: Fix use-after-free in delayed work during device removal
Date: Tue,  6 Jan 2026 17:59:27 +0100
Message-ID: <20260106170458.172868650@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Duoming Zhou <duoming@zju.edu.cn>

commit 41ca62e3e21e48c2903b3b45e232cf4f2ff7434f upstream.

The delayed work item otg_event is initialized in fsl_otg_conf() and
scheduled under two conditions:
1. When a host controller binds to the OTG controller.
2. When the USB ID pin state changes (cable insertion/removal).

A race condition occurs when the device is removed via fsl_otg_remove():
the fsl_otg instance may be freed while the delayed work is still pending
or executing. This leads to use-after-free when the work function
fsl_otg_event() accesses the already freed memory.

The problematic scenario:

(detach thread)            | (delayed work)
fsl_otg_remove()           |
  kfree(fsl_otg_dev) //FREE| fsl_otg_event()
                           |   og = container_of(...) //USE
                           |   og-> //USE

Fix this by calling disable_delayed_work_sync() in fsl_otg_remove()
before deallocating the fsl_otg structure. This ensures the delayed work
is properly canceled and completes execution prior to memory deallocation.

This bug was identified through static analysis.

Fixes: 0807c500a1a6 ("USB: add Freescale USB OTG Transceiver driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://patch.msgid.link/20251205034831.12846-1-duoming@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/phy/phy-fsl-usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/phy/phy-fsl-usb.c
+++ b/drivers/usb/phy/phy-fsl-usb.c
@@ -987,6 +987,7 @@ static void fsl_otg_remove(struct platfo
 {
 	struct fsl_usb2_platform_data *pdata = dev_get_platdata(&pdev->dev);
 
+	disable_delayed_work_sync(&fsl_otg_dev->otg_event);
 	usb_remove_phy(&fsl_otg_dev->phy);
 	free_irq(fsl_otg_dev->irq, fsl_otg_dev);
 


