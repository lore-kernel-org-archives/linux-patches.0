Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECE526B082;
	Thu, 13 Feb 2025 15:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459283; cv=none; b=CBBFKiyxIRemMFkPmo8gmV7LMODTdLYK4f2CVEDoWk6lLrTc945AB5L941pMI02wx0R/iNstHkgI+aRLHRIImpymQRItUOCMfAzFN4wPK5uDU4SAmKvKxP8U8UzSBtmbdJFKeHDvyfQgoXIqyU7PTIbqLD1xoUqFixa4/jeh2q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459283; c=relaxed/simple;
	bh=Zy+9KjbU9AvxBXLPgzdgpwU9IMUKwFIzZFsZ/w7eFQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WiuJ2nIX6TM+CKWAPHpT7CbsnRTfSMIQ+j4knm8hBsRGC/VPrncesI8arF7502EwNGUQbWC93vsUOhomOjYS3qoWtxVz1+sjYZiAwPyPVNUmSfMcp5zJZYWpvlBJGqblqlDP8VNPpCL8QekxI6j0dhNiK+x3neV/oBbKFAeNPYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0XPggbK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0XPggbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3855C4CED1;
	Thu, 13 Feb 2025 15:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459283;
	bh=Zy+9KjbU9AvxBXLPgzdgpwU9IMUKwFIzZFsZ/w7eFQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v0XPggbKbtLk7R73zKof0EeSCSpjvdf3KYgq2iT80ZA84+ZMU8sDE1AVp63gT4cvS
	 T/ndwAcs63PhY39kgCANk4MOI6m55BxYBehZWSsCIaKuUdVUgKDb9+59b+5anqHMrC
	 EBBPjkNftoKQpTdR5F+wo5h3SBfU16vcCwEWKmXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.13 220/443] Input: bbnsm_pwrkey - add remove hook
Date: Thu, 13 Feb 2025 15:26:25 +0100
Message-ID: <20250213142449.102658024@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

commit 55b75306c3edf369285ce22ba1ced45e335094c2 upstream.

Without remove hook to clear wake irq, there will be kernel dump when
doing module test.
"bbnsm_pwrkey 44440000.bbnsm:pwrkey: wake irq already initialized"

Add remove hook to clear wake irq and set wakeup to false.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Fixes: 40e40fdfec3f ("Input: bbnsm_pwrkey - add bbnsm power key support")
Link: https://lore.kernel.org/r/20241212030322.3110017-1-peng.fan@oss.nxp.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/nxp-bbnsm-pwrkey.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/input/misc/nxp-bbnsm-pwrkey.c
+++ b/drivers/input/misc/nxp-bbnsm-pwrkey.c
@@ -187,6 +187,12 @@ static int bbnsm_pwrkey_probe(struct pla
 	return 0;
 }
 
+static void bbnsm_pwrkey_remove(struct platform_device *pdev)
+{
+	dev_pm_clear_wake_irq(&pdev->dev);
+	device_init_wakeup(&pdev->dev, false);
+}
+
 static int __maybe_unused bbnsm_pwrkey_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -223,6 +229,8 @@ static struct platform_driver bbnsm_pwrk
 		.of_match_table = bbnsm_pwrkey_ids,
 	},
 	.probe = bbnsm_pwrkey_probe,
+	.remove = bbnsm_pwrkey_remove,
+
 };
 module_platform_driver(bbnsm_pwrkey_driver);
 


