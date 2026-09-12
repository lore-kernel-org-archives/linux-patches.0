Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0E0386C0D;
	Sat, 12 Sep 2026 07:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199466; cv=none; b=Z6keXSdNMzbTHC00BNhgIlV3KBkwDbsQ0gOQX82xxGgRD7mxumuAhOsqm6cdSLXRW5acaDGgvpXvcFgY/AvaMMEEQVJ1f1teOJ3Bmki0aRyK8l08/0HVnt3wS0e1ADSaBXT1RyVAa0mjb18ncQm2Pki41f+UoHdlKYAuJSSKgnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199466; c=relaxed/simple;
	bh=oOys9PIkhlUDj4X/2j4D72CUb1DiX/08clodenk5etI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HzBsktWOa7O6cXOzmng14JAYjElkOVBWNLKv0P+EodItl+QbXcC/V4YNPwdHrSXVpB1zdrORhlcqIOFnOSHkbCbBO+fZVVU39ZBXp/r4YoT+ObFHECyfkK1edWFohjaSNphetm8i3lIgYkoWC/DRtRCQHAFDhH1txaPCYzx8EtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQ1fTyg3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQ1fTyg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88AF1F000FF;
	Sat, 12 Sep 2026 07:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199463;
	bh=J623iYWpE+RYY1ytHSMrrDZyl5vlvvpAEKMX9Wnet/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HQ1fTyg3TgK1SADcztTVfsZblKUtPFPzITMu4fnq0dhO4qjOtsn+y/j5rbvmq2kEN
	 Yix0+ijiBVrMt4abNFjTfjiREHl1gpSkkBrBAFvitxYbDaegKv1afgZBMryxE3Laug
	 YVi/ejrp3G6D1u36rr61ySw/hJWyS7I/3RqINzx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0588/1815] iommu/amd: Fix undefined behavior in devid_write debugfs function
Date: Sat, 12 Sep 2026 08:38:58 +0200
Message-ID: <20260912065702.684623093@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 843e149989665f8309ad2efe6048dc76591e1f94 ]

When for_each_pci_segment() loop completes without finding a matching
segment, the pci_seg pointer is not NULL but points to an invalid memory
location (the list head). Accessing pci_seg->id after the loop causes
undefined behavior.

Fix this by handling the successful case inside the loop and returning
-EINVAL after the loop if no matching segment is found.

Fixes: 2e98940f123d9 ("iommu/amd: Add support for device id user input")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Ankit Soni <Ankit.Soni@amd.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/debugfs.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/amd/debugfs.c b/drivers/iommu/amd/debugfs.c
index 4c53b63613148..5c573ec8e27a4 100644
--- a/drivers/iommu/amd/debugfs.c
+++ b/drivers/iommu/amd/debugfs.c
@@ -176,19 +176,13 @@ static ssize_t devid_write(struct file *filp, const char __user *ubuf,
 			kfree(srcid_ptr);
 			return -ENODEV;
 		}
-		break;
-	}
-
-	if (pci_seg->id != seg) {
+		sbdf = PCI_SEG_DEVID_TO_SBDF(seg, devid);
 		kfree(srcid_ptr);
-		return -EINVAL;
+		return cnt;
 	}
 
-	sbdf = PCI_SEG_DEVID_TO_SBDF(seg, devid);
-
 	kfree(srcid_ptr);
-
-	return cnt;
+	return -EINVAL;
 }
 
 static int devid_show(struct seq_file *m, void *unused)
-- 
2.53.0



