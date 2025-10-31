Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3876D1F37D4;
	Fri, 31 Oct 2025 14:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919494; cv=none; b=DeNUx9M4/WefqSwNMlMUBjYH9TU1gw0H2Vqyk1jrFL88k99Eu2xQaFryfbx1iPJAyU6roYjh5IL4m2K+mBVyN+LRZdksnZ+AcIozZG9PwTluC2Ah7PuPcjBPmX1j3Wf/x5kd/DzxhhiVqBINGaG5R1vYlLSCOjhg/+LG+HyuUs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919494; c=relaxed/simple;
	bh=RwJxASIQoclL04t05kEwVJ9/v0iey5xqJVVsv9Tak/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wa1n6OozpNca37oVaWuB1Vbbc09ZwFfMf7HJRGLr/gp9q0L6CIHmY06I8qM0nDhY/eBNzIlhATKdE8xOr1SkOMLR/yH3DCWlo+7vYAsG1VI6zbzGxHrxrS5dAe/y5M3eblKKjguzuOuxPnfHamXkNUITjRSrid8I6dSG0e6SiLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YpA2vkQO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YpA2vkQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EF7C4CEE7;
	Fri, 31 Oct 2025 14:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919494;
	bh=RwJxASIQoclL04t05kEwVJ9/v0iey5xqJVVsv9Tak/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YpA2vkQOFjALblKQC/6ZEeQfN2Cbs3Ho166j5vpU0xKyWuSb+AymWFf4gg2ASuFEL
	 rF3EOrcKRqXqnYGxcLPaNhnNHawhbcCh1+GvW1znxF56Pxr/JtGHPYzLdrqM7zKtEy
	 aKq4c9oyaUJPX+ay1Mbbom0sQrFdnzz5s06Nd3Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Bakker <kees@ijzerbout.nl>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Amelia Crate <acrate@waldn.net>
Subject: [PATCH 6.12 37/40] iommu/vt-d: Avoid use of NULL after WARN_ON_ONCE
Date: Fri, 31 Oct 2025 15:01:30 +0100
Message-ID: <20251031140044.920190931@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
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

From: Kees Bakker <kees@ijzerbout.nl>

[ Upstream commit 60f030f7418d3f1d94f2fb207fe3080e1844630b ]

There is a WARN_ON_ONCE to catch an unlikely situation when
domain_remove_dev_pasid can't find the `pasid`. In case it nevertheless
happens we must avoid using a NULL pointer.

Signed-off-by: Kees Bakker <kees@ijzerbout.nl>
Link: https://lore.kernel.org/r/20241218201048.E544818E57E@bout3.ijzerbout.nl
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Amelia Crate <acrate@waldn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4328,13 +4328,14 @@ static void intel_iommu_remove_dev_pasid
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
 	intel_pasid_tear_down_entry(iommu, dev, pasid, false);
 	intel_drain_pasid_prq(dev, pasid);
 }


