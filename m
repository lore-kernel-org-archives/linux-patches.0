Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD76A4315F;
	Wed, 19 Jun 2024 13:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803049; cv=none; b=B9XsgggGmdQRLRNOoynUOho3Zg/BH8EHBgMDpRQJLsOpXaO+UfXKDQVGKQOYEzPncG4q5qbvCrrO22TV1E3j7Ed0e+DF+gpypMwKi/FMneDxShboqGWpv7ENNAAS2b2colyaWPKCQCZ+n3kS/sf9Fv2m7BeBRV77C2kDBTcm/8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803049; c=relaxed/simple;
	bh=EdoSEatLao7np4qdFTljLsLhQ2t98eWG3zq3SGh6Y7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfhMm4zK06F4ouheh0mIsB0HNFYIBU0OzcYvZnPocZQjpdbgd7lJyQK3CFX0+vvxI+EeCTJKWE4wX4SU0flB7GVk8FAKfvfoJJTk2RGSCarabybzBipAm0mkFJW/SCR28k2tgjopF/uAZm7ZvMVrA6k1yTt2gtdscGuQ+Jv4FA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSnpe65I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSnpe65I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6154DC2BBFC;
	Wed, 19 Jun 2024 13:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803048;
	bh=EdoSEatLao7np4qdFTljLsLhQ2t98eWG3zq3SGh6Y7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSnpe65IaXVw48+vTdebKCjuJxUHO/J3TqKGIuipFVwf1psd4IRELBBuCTX/RvHLf
	 GtanCUguSIgDXnCTBbt8cljc3V2Xxi1GZZBGDe42XCFJ2x6IE8ShMW9X5rSjz+HMPp
	 So2RVqaL4bBmbgBUtQP9QuNtQyGIY/cEP3R3fitk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kun(llfl)" <llfl@linux.alibaba.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 135/281] iommu/amd: Fix sysfs leak in iommu init
Date: Wed, 19 Jun 2024 14:54:54 +0200
Message-ID: <20240619125615.038511226@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kun(llfl) <llfl@linux.alibaba.com>

[ Upstream commit a295ec52c8624883885396fde7b4df1a179627c3 ]

During the iommu initialization, iommu_init_pci() adds sysfs nodes.
However, these nodes aren't remove in free_iommu_resources() subsequently.

Fixes: 39ab9555c241 ("iommu: Add sysfs bindings for struct iommu_device")
Signed-off-by: Kun(llfl) <llfl@linux.alibaba.com>
Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Link: https://lore.kernel.org/r/c8e0d11c6ab1ee48299c288009cf9c5dae07b42d.1715215003.git.llfl@linux.alibaba.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index f440ca440d924..e740dc54c4685 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -1678,8 +1678,17 @@ static void __init free_pci_segments(void)
 	}
 }
 
+static void __init free_sysfs(struct amd_iommu *iommu)
+{
+	if (iommu->iommu.dev) {
+		iommu_device_unregister(&iommu->iommu);
+		iommu_device_sysfs_remove(&iommu->iommu);
+	}
+}
+
 static void __init free_iommu_one(struct amd_iommu *iommu)
 {
+	free_sysfs(iommu);
 	free_cwwb_sem(iommu);
 	free_command_buffer(iommu);
 	free_event_buffer(iommu);
-- 
2.43.0



