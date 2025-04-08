Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3D0225412;
	Tue,  8 Apr 2025 12:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114227; cv=none; b=ItPghTLrPcW0Qe06nM7m/NcA+wJfS4BOj7EzDCGNQNDA5sQSiRAa+fy1tbRs99CkrcO1o7MY6pAjYSHDcSmd9gShIuXgxwMCU5fVYkSHoFInq4rleTmw/tuFXEc7v74c4n/bVljYJJH2/FmEn98vvY8FB4+v3YZ8OQnzXd5Q5YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114227; c=relaxed/simple;
	bh=Brj5tYxNbviByNPgZbNjRzud/C1h08wJRKOC3S86OFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5fD92ozVbtzid+8G0B+8AbGFtYtvTY/uyFmFkWwLkaicud7NZSulrfGXzweF18c00cA7xemvr0Q3bPxwBmSZFklumWWiCMF9z8FCqaWyfDCtrlu+HULNkwsI/LG2NmpWPP9Y7WDleBFiVnp0wQLnIz18wlXHnYfru3DPxbX3M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fgn9FhfT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fgn9FhfT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153D2C4CEE7;
	Tue,  8 Apr 2025 12:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114226;
	bh=Brj5tYxNbviByNPgZbNjRzud/C1h08wJRKOC3S86OFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fgn9FhfTEsQ4zk9g/dMFlN1ab/uTFuvMZZ5rPpZT3HNSfK3qcqe4ICb4e9QkPQEaP
	 vL2d4DqFvFUx37rID819viMg5AVpIFLKXWDiAr/zWyW7U00jfydRf04v+UApXS29Hf
	 ZCgUzdKpXrk6e/6gxBe/llnuOtSEsg7XjWYNkp5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Gary Wang <gary.c.wang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 028/499] EDAC/ie31200: Fix the error path order of ie31200_init()
Date: Tue,  8 Apr 2025 12:44:00 +0200
Message-ID: <20250408104851.948169443@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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
index da4008c22f0d3..9b02a6b43ab58 100644
--- a/drivers/edac/ie31200_edac.c
+++ b/drivers/edac/ie31200_edac.c
@@ -621,7 +621,7 @@ static int __init ie31200_init(void)
 
 	pci_rc = pci_register_driver(&ie31200_driver);
 	if (pci_rc < 0)
-		goto fail0;
+		return pci_rc;
 
 	if (!mci_pdev) {
 		ie31200_registered = 0;
@@ -632,11 +632,13 @@ static int __init ie31200_init(void)
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
@@ -644,12 +646,12 @@ static int __init ie31200_init(void)
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



