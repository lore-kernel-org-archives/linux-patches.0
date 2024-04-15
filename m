Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A461D556;
	Mon, 15 Apr 2024 14:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191761; cv=none; b=mhvOGU4naQMAeFGQufHt+INibBpjaGIEaonSUMpPS/eDi7IWSzX8/BFWrDTTiQvoTJn0x0ssx+RAXqlMXy9L71OnJDpK9ZhKxsEvqzVBz8OEp7U7AUVog6tbN5JXqZ7o/PS1LfcGFcjv+MDKswWAasiocT+5M7XyKMk6JjVLRWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191761; c=relaxed/simple;
	bh=bpPkqQQeNnAQZVP+i7bS5OenvX0vw0TFt8xedQQdoaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CO9naWrBCRyc6E7MAutNPNK9mcPiqrL1BucwsUuFdr/Sfnpld+pqaWtFKXky2UdFU9NX2EIYwAUesGxNdXKZbGow/JZJGgq30jxbMewGSvfjmUGV0cH1fmJUdolSdz7f5daOuJW9AbmQl4IUCSRJj6oN1XjYbCJZCG4w1UWqvZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=irPxzLB5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="irPxzLB5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E158C113CC;
	Mon, 15 Apr 2024 14:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191760;
	bh=bpPkqQQeNnAQZVP+i7bS5OenvX0vw0TFt8xedQQdoaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=irPxzLB5rLz/QU79Z9wVr2iqeENwQy6kb0FszQk3Onu9RSmlyi7Eny9sCia6Kw0u9
	 tKsJX/+f1lJhdvkBfjWey08t6dFYK3S1XWA/lchS7QscOeOFaZ4O/gopWHoMNjwIMc
	 AKWf9/Zv43NX6yaMYUI2/FS8uJigIM0E23hLtl1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuchun Shang <xuchun.shang@linux.alibaba.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/122] iommu/vt-d: Fix wrong use of pasid config
Date: Mon, 15 Apr 2024 16:20:41 +0200
Message-ID: <20240415141955.657609174@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuchun Shang <xuchun.shang@linux.alibaba.com>

[ Upstream commit 5b3625a4f6422e8982f90f0c11b5546149c962b8 ]

The commit "iommu/vt-d: Add IOMMU perfmon support" introduce IOMMU
PMU feature, but use the wrong config when set pasid filter.

Fixes: 7232ab8b89e9 ("iommu/vt-d: Add IOMMU perfmon support")
Signed-off-by: Xuchun Shang <xuchun.shang@linux.alibaba.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20240401060753.3321318-1-xuchun.shang@linux.alibaba.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/perfmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/perfmon.c b/drivers/iommu/intel/perfmon.c
index cf43e798eca49..44083d01852db 100644
--- a/drivers/iommu/intel/perfmon.c
+++ b/drivers/iommu/intel/perfmon.c
@@ -438,7 +438,7 @@ static int iommu_pmu_assign_event(struct iommu_pmu *iommu_pmu,
 	iommu_pmu_set_filter(domain, event->attr.config1,
 			     IOMMU_PMU_FILTER_DOMAIN, idx,
 			     event->attr.config1);
-	iommu_pmu_set_filter(pasid, event->attr.config1,
+	iommu_pmu_set_filter(pasid, event->attr.config2,
 			     IOMMU_PMU_FILTER_PASID, idx,
 			     event->attr.config1);
 	iommu_pmu_set_filter(ats, event->attr.config2,
-- 
2.43.0



