Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EC86FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC981C433EF;
	Mon,  3 Apr 2023 14:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532388;
	bh=rXWSQnHDgzO1HxIYihPpQoqa/ubR1to9glHIIiPKF8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GB6ZbqNpx1pLfLQrvrOzvsP1RT/ErZ1Lhz/U6tIzmPKuFM6Q2lWzA+gWPNZ+YHGO2
	 5vfJ3uYse4OV9ZAuMGfXQ03IQGYDw1mUmiPubTLPjC3Ag57AUOUeBq3JVx9If2rj64
	 Llkx6IVMFd3oBiP4+pIbkCnvB9ahSgTZFt2K1ie8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raghunathan Srinivasan <raghunathan.srinivasan@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 64/99] iommu/vt-d: Allow zero SAGAW if second-stage not supported
Date: Mon,  3 Apr 2023 16:09:27 +0200
Message-Id: <20230403140405.856596121@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit bfd3c6b9fa4a1dc78139dd1621d5bea321ffa69d ]

The VT-d spec states (in section 11.4.2) that hardware implementations
reporting second-stage translation support (SSTS) field as Clear also
report the SAGAW field as 0. Fix an inappropriate check in alloc_iommu().

Fixes: 792fb43ce2c9 ("iommu/vt-d: Enable Intel IOMMU scalable mode by default")
Suggested-by: Raghunathan Srinivasan <raghunathan.srinivasan@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20230318024824.124542-1-baolu.lu@linux.intel.com
Link: https://lore.kernel.org/r/20230329134721.469447-3-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/dmar.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index bff2420fc3e14..7c20083d4a798 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1080,7 +1080,8 @@ static int alloc_iommu(struct dmar_drhd_unit *drhd)
 	}
 
 	err = -EINVAL;
-	if (cap_sagaw(iommu->cap) == 0) {
+	if (!cap_sagaw(iommu->cap) &&
+	    (!ecap_smts(iommu->ecap) || ecap_slts(iommu->ecap))) {
 		pr_info("%s: No supported address widths. Not attempting DMA translation.\n",
 			iommu->name);
 		drhd->ignored = 1;
-- 
2.39.2



