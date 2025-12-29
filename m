Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137921B6D08;
	Mon, 29 Dec 2025 16:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025648; cv=none; b=nXoVZGD1Q7kR9xIHS1cNebIZ+B7zujQksHessL7H5R1vlXn+KyPR7ITnpDT/gao6OHUu1fKygdixwTWTUsSJWRLFBvNVj422tJqNlb5hbRjEV4HI/yRhBpFJ1qoq3xb+Sl+AKNaFFBBEzfCoPBlW2f5St4aUZEUpB7XMiwd1WI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025648; c=relaxed/simple;
	bh=m0gFZW7/IfVHe3376zZveDBGAiMaTuDrRIkIJ9mHDFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUl7wxJoeuLBwgYcVUT7Q1QxFYwfeUmJ5ZqoCeKRNFw4/EJBkKwE7F0zqZzLjpagJ78M2OCmcYKchPzScMArY4SZdKG3UbDkZbGB851Tm8P3O6MkyellntxjvjQL4R3grRfOsBnC0z7BJ0v4WE3SG0faeUkSFOfJ6pOCVzOM99s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gGQe1bSW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gGQe1bSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC80C4CEF7;
	Mon, 29 Dec 2025 16:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025647;
	bh=m0gFZW7/IfVHe3376zZveDBGAiMaTuDrRIkIJ9mHDFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gGQe1bSWKDe3ZzaLlSs1vsHhpRimF9Swx3DfXUX1uczFVOJJAzENy6ps62haaUtII
	 Jb9+PWaiUBg4dCjGZZPxaBmlq8ouC5ycs2HAL4CmRUxwBd0fqtlW5C9WXUhVU6Dmr6
	 j4us9L59FDxp1E27hIHR/DOdS5YdSlzh1P3Kp6gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH 6.18 288/430] usb: phy: fsl-usb: Fix use-after-free in delayed work during device removal
Date: Mon, 29 Dec 2025 17:11:30 +0100
Message-ID: <20251229160734.943052298@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -988,6 +988,7 @@ static void fsl_otg_remove(struct platfo
 {
 	struct fsl_usb2_platform_data *pdata = dev_get_platdata(&pdev->dev);
 
+	disable_delayed_work_sync(&fsl_otg_dev->otg_event);
 	usb_remove_phy(&fsl_otg_dev->phy);
 	free_irq(fsl_otg_dev->irq, fsl_otg_dev);
 


