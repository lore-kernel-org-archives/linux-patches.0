Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1484143C43;
	Wed, 19 Jun 2024 13:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802240; cv=none; b=ayr/FeEsHcJnLBsy6YhnInNJ1bJkuWe1mh4nhCmPP9WvBYeLOdmcSUknZ6Omjag2I0KCbp2U535DhonLNQRAmNYIXZSor+tBampFTt+mwAYPmq2QZ6Z43ds+z1U8qUlrt40gVo7xTs0J62fDZ07jbBZ+NPvlm+opcRT1TIFs2eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802240; c=relaxed/simple;
	bh=++zPPp/xfinhWiGnZXcRCll0Y4y7nh+0ZhfGenOpH0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o676w1rZf3fVVKYP5H2zbAnceGbxRzw28TioitflVaXW5ehX/gJ9qNsQ8IdF9LE8LRIWtCP9TT6JCOL+jLIB/AW00d2iQaAHvwXE9xOBPtd8nmIuyAepe/H1BInp2ARkKRQG/hXK0PwU1Ve8/Ep6quqeesXRM6XDfXZ6rB5zHXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GhcFP7ld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GhcFP7ld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3CBC2BBFC;
	Wed, 19 Jun 2024 13:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802240;
	bh=++zPPp/xfinhWiGnZXcRCll0Y4y7nh+0ZhfGenOpH0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GhcFP7ldj3aldM3EzA60K2+qbNpnvMeProX4spVhLnO8lkSOk0gZlR0/Go4zmzATa
	 bacwhXnD/XnXtO0SV+TLTk6MD8zJrKhLBQiLlGS8VID/pHYfs1W5H92ZeK46qOcr+D
	 TN+isC1yK9NhNhzmQpBoumPI1oEDt7NcmmYzL+rE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kun(llfl)" <llfl@linux.alibaba.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/267] iommu/amd: Fix sysfs leak in iommu init
Date: Wed, 19 Jun 2024 14:54:41 +0200
Message-ID: <20240619125611.341159844@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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
index a2ad2dbd04d92..ef3fae113dd64 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -1692,8 +1692,17 @@ static void __init free_pci_segments(void)
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



