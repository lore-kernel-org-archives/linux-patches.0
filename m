Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C668486
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDD3C433C1;
	Thu, 27 Oct 2022 17:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890025;
	bh=tg7VOWAdAXNdE0usHFj+Eb/M4aKMUiKIyTE+0djZB2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0eVrKs97evMeHgv+MUfQsqOvQQ8nZ+7Cb+yj+cfHdln11ttxMFTKl+Lkj7e6KZUgH
	 MIJFWV4ILLCX6XyitBsSNSw2QqGc1KbEzHAVIqB0agS6DcIqCcVLAAOmIti5OzRoGi
	 uggtY9xZhM+GUR7mPKgY/IxHR+VS7yaUBb3Yu+ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 87/94] iommu/vt-d: Clean up si_domain in the init_dmars() error path
Date: Thu, 27 Oct 2022 18:55:29 +0200
Message-Id: <20221027165100.700650985@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jerry Snitselaar <jsnitsel@redhat.com>

[ Upstream commit 620bf9f981365c18cc2766c53d92bf8131c63f32 ]

A splat from kmem_cache_destroy() was seen with a kernel prior to
commit ee2653bbe89d ("iommu/vt-d: Remove domain and devinfo mempool")
when there was a failure in init_dmars(), because the iommu_domain
cache still had objects. While the mempool code is now gone, there
still is a leak of the si_domain memory if init_dmars() fails. So
clean up si_domain in the init_dmars() error path.

Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Fixes: 86080ccc223a ("iommu/vt-d: Allocate si_domain in init_dmars()")
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
Link: https://lore.kernel.org/r/20221010144842.308890-1-jsnitsel@redhat.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 31bc50e538a3..ecc0b05b2796 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2400,6 +2400,7 @@ static int __init si_domain_init(int hw)
 
 	if (md_domain_init(si_domain, DEFAULT_DOMAIN_ADDRESS_WIDTH)) {
 		domain_exit(si_domain);
+		si_domain = NULL;
 		return -EFAULT;
 	}
 
@@ -3042,6 +3043,10 @@ static int __init init_dmars(void)
 		disable_dmar_iommu(iommu);
 		free_dmar_iommu(iommu);
 	}
+	if (si_domain) {
+		domain_exit(si_domain);
+		si_domain = NULL;
+	}
 
 	return ret;
 }
-- 
2.35.1



