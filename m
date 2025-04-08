Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DC42135CD;
	Tue,  8 Apr 2025 12:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113964; cv=none; b=BDsJ/VIWiSt88HsRcMgLJ/vChBa18NMpwVl5ybsbJ7/a8AAVpTERGyUliIBDJavvw78xXe/2VArLZWH/75OHuTdCe38T597g6LjtdRTwPVxy4vEwvrLOeKTcroLhPfBWg/+kvpyPB/AlyMVK4MQi0twFlBwjbXAPxAfd4LtmKcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113964; c=relaxed/simple;
	bh=DmNz35AsAaym69/FfxwNnufQS4evPocroWGRUjfplO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIGKYPrPzs01A5Af9HcKPrMh+Rtynb+GFOYKcLsV8Jjo5qnMHjvGB9u5SiNWwb+o7u+KBOC8w9Fxdq8qOMygrAiQTaZSyyWFq3sDeW3C+Ig0OOJ9i2cRhn5v0nxorXqr8zeXC2/zTtquYHK5SKZ04lr8QACwa8q07faNXKQq36A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BCPBpVtc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BCPBpVtc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5022C4CEE5;
	Tue,  8 Apr 2025 12:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113964;
	bh=DmNz35AsAaym69/FfxwNnufQS4evPocroWGRUjfplO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BCPBpVtcdpZp8Y6FiWp4ecQhNxtIjVUH6fWXUdJeT30QrDJwRy+2ByYIc3i6p4QET
	 4PmjQZA8phvCrOugZ4qJd5D8JIRJy7UPnzbc83NIak9qx55rXXCdHnhGvR9fcHp7kH
	 YepgUR0RUp9K5UQhN22H0JCUYVqvU2Cmi2gqpJfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Gary Wang <gary.c.wang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/154] EDAC/ie31200: Fix the error path order of ie31200_init()
Date: Tue,  8 Apr 2025 12:50:28 +0200
Message-ID: <20250408104818.104365230@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0fc78a922e3f3..d3d9916b1ba3f 100644
--- a/drivers/edac/ie31200_edac.c
+++ b/drivers/edac/ie31200_edac.c
@@ -611,7 +611,7 @@ static int __init ie31200_init(void)
 
 	pci_rc = pci_register_driver(&ie31200_driver);
 	if (pci_rc < 0)
-		goto fail0;
+		return pci_rc;
 
 	if (!mci_pdev) {
 		ie31200_registered = 0;
@@ -622,11 +622,13 @@ static int __init ie31200_init(void)
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
@@ -634,12 +636,12 @@ static int __init ie31200_init(void)
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



