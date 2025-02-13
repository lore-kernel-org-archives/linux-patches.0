Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077EC26B08E;
	Thu, 13 Feb 2025 15:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458859; cv=none; b=HuWFgk6CtlI1stiwobsxKeK9p42fzQz/vq29VLCd2sWSlQV7CuxsTJD55f6FM8QLY6ZcKN0c2HJmswkaXFBecGWme/zw7Sa/nKMsb/JgyxMp77gU8bnmhuIaOXSsybt5DBB4Wh8PehFaM47hzJJM+35cf52PACkyVF7P1rBl1fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458859; c=relaxed/simple;
	bh=24PGGdkytZRchtFZeGNQ1QQ836Z5Q2iHmWNWUsdMn5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+v1WODjHqTfsRLKq+EZ/5ReeYrd71KPCM2OiLYwavtkYB1E/uilmAuehiNtzXLHXY5v7P/2pu0zA0ooG7DjBBX2vphgwbZfdoIhSv1DpG0SVB9459QobwNp9CSt6kgLajITsOvMRPRT9xBSlyHTlajLkWs/bUAzgo30pdeUdJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdLgRExi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdLgRExi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80579C4CED1;
	Thu, 13 Feb 2025 15:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458858;
	bh=24PGGdkytZRchtFZeGNQ1QQ836Z5Q2iHmWNWUsdMn5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdLgRExiF/NC1jDlPJvi/7W0EiiI4itvp+Q0fFiPhU2QvusO71YykR3AYQ+cfbUVp
	 JKfgmyFsEosG/aWluyjM5i4eIkXy69fOc2Sz7qHvzvNzfz5cA/QZzpnXh4ihd3mCbe
	 fP7FjI/3UGABmSWX0o8dsiYw3rGwqdcRfMOEmGGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Bakker <kees@ijzerbout.nl>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 096/443] iommu/vt-d: Avoid use of NULL after WARN_ON_ONCE
Date: Thu, 13 Feb 2025 15:24:21 +0100
Message-ID: <20250213142444.312579607@linuxfoundation.org>
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

From: Kees Bakker <kees@ijzerbout.nl>

[ Upstream commit 60f030f7418d3f1d94f2fb207fe3080e1844630b ]

There is a WARN_ON_ONCE to catch an unlikely situation when
domain_remove_dev_pasid can't find the `pasid`. In case it nevertheless
happens we must avoid using a NULL pointer.

Signed-off-by: Kees Bakker <kees@ijzerbout.nl>
Link: https://lore.kernel.org/r/20241218201048.E544818E57E@bout3.ijzerbout.nl
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 79e0da9eb626c..8f75c11a3ec48 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4090,13 +4090,14 @@ void domain_remove_dev_pasid(struct iommu_domain *domain,
 			break;
 		}
 	}
-	WARN_ON_ONCE(!dev_pasid);
 	spin_unlock_irqrestore(&dmar_domain->lock, flags);
 
 	cache_tag_unassign_domain(dmar_domain, dev, pasid);
 	domain_detach_iommu(dmar_domain, iommu);
-	intel_iommu_debugfs_remove_dev_pasid(dev_pasid);
-	kfree(dev_pasid);
+	if (!WARN_ON_ONCE(!dev_pasid)) {
+		intel_iommu_debugfs_remove_dev_pasid(dev_pasid);
+		kfree(dev_pasid);
+	}
 }
 
 static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
-- 
2.39.5



