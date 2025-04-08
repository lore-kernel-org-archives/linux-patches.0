Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E77267F4F;
	Tue,  8 Apr 2025 12:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115544; cv=none; b=OzKicHBpcjDu1qF6A1wYDxe7Y5xxJKRVGL7/VnlYdSDxbnOuzs2Tfyblv2zrHXzilkyo3Vt76zhrd+W9GSNfHbUOS3IMZRZc6fMm//wH/fm3i0PXiurOOeAb/4oqPjp7pi4e9CDXStD5jfwwMiTue1KWXUO8Zb2Tqnj0pBT3nAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115544; c=relaxed/simple;
	bh=+qg2zHkyX5NUE+z1H9K0e5T0E5cADtAOuuKe3gtLbuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4m1fhwTbXM8Ikhaqr2Kcmt8Y+AGizONTOLc/woa/D/wSwZkzv4yfc7JUqpANxk17FEOiF02tcmR+vdyw+wfDNCf48DGG7Dza650mPNv52VVPGnyOYCai7jaSX0nWIlQF0ZZuSZXClKnqqHNcBJQfe06XIsHbrXNIwmGKrL8ubA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c2ximI9Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c2ximI9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BE9C4CEE5;
	Tue,  8 Apr 2025 12:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115544;
	bh=+qg2zHkyX5NUE+z1H9K0e5T0E5cADtAOuuKe3gtLbuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c2ximI9QGFq7FdRVIO3SilUppW3iR4c6+M3kAcKhA+/+5ma/JrVCQfxLPadGx5hgl
	 998gdaM8pfJ4sXkTfKGUNZVaxG36I/5L7nhDfj1RiFHqUmkDJKepXpLGBpR1VsF1rT
	 3kYb2kaiLGvNnvKCGu1DUvI1F01789UEOmazOGCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Gary Wang <gary.c.wang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/204] EDAC/ie31200: Fix the error path order of ie31200_init()
Date: Tue,  8 Apr 2025 12:49:05 +0200
Message-ID: <20250408104820.764539221@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit 231e341036d9988447e3b3345cf741a98139199e ]

The error path order of ie31200_init() is incorrect, fix it.

Fixes: 709ed1bcef12 ("EDAC/ie31200: Fallback if host bridge device is already initialized")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Tested-by: Gary Wang <gary.c.wang@intel.com>
Link: https://lore.kernel.org/r/20250310011411.31685-4-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/ie31200_edac.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/ie31200_edac.c b/drivers/edac/ie31200_edac.c
index 92714dd88b3f6..56be8ef40f376 100644
--- a/drivers/edac/ie31200_edac.c
+++ b/drivers/edac/ie31200_edac.c
@@ -617,7 +617,7 @@ static int __init ie31200_init(void)
 
 	pci_rc = pci_register_driver(&ie31200_driver);
 	if (pci_rc < 0)
-		goto fail0;
+		return pci_rc;
 
 	if (!mci_pdev) {
 		ie31200_registered = 0;
@@ -628,11 +628,13 @@ static int __init ie31200_init(void)
 			if (mci_pdev)
 				break;
 		}
+
 		if (!mci_pdev) {
 			edac_dbg(0, "ie31200 pci_get_device fail\n");
 			pci_rc = -ENODEV;
-			goto fail1;
+			goto fail0;
 		}
+
 		pci_rc = ie31200_init_one(mci_pdev, &ie31200_pci_tbl[i]);
 		if (pci_rc < 0) {
 			edac_dbg(0, "ie31200 init fail\n");
@@ -640,12 +642,12 @@ static int __init ie31200_init(void)
 			goto fail1;
 		}
 	}
-	return 0;
 
+	return 0;
 fail1:
-	pci_unregister_driver(&ie31200_driver);
-fail0:
 	pci_dev_put(mci_pdev);
+fail0:
+	pci_unregister_driver(&ie31200_driver);
 
 	return pci_rc;
 }
-- 
2.39.5



