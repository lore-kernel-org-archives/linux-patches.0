Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E08176AC4;
	Wed,  3 Jul 2024 11:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005472; cv=none; b=nBwxwTwvGJbNI9OV2z4lZW5Utn/3NNwLsq8anGmFzGsaHWQKwnGaXVEJBViLmzL/pxKzCiMqhvOhqM98YJBtpckNkhkUPpMwdMePIXKtdov3N2DjFJLgFAV8tXavBzCJhXWr96keHQcskQgebeunZtAyzk3pFl4IZ+lkep3DfBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005472; c=relaxed/simple;
	bh=EYWLlwdBjQb+mhYrRIrEE8qahc9RDmWbXWMK/PfCmf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4VqVCoretdaM6IBP+aRzPoLMOD3fANQ6wMcBvsDIELxYg4Ux+CuzF3wgsN2gS+G6yOuMuz7TArOo4yRiGA5pR/d34/u5T6k8iZYENZqpkCZrWJAp67PR6GA/oTgb3WQNoeOrU3/v4UP2mmpBiE38IrTC7toUJhqR3IQ440l7NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BYCB15o9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BYCB15o9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FC6C2BD10;
	Wed,  3 Jul 2024 11:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005472;
	bh=EYWLlwdBjQb+mhYrRIrEE8qahc9RDmWbXWMK/PfCmf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BYCB15o9YSbOlt2d3G18vsbrexW/8GtLmiCEcr0lT31AHUgO62xzMF0fDdeBQmsPl
	 Co0hnT6GhtR1cCZwQuNL2C4SCw01SFUisT66Yjda7UsNX8KsPZQyuDDBmtHAiq6XYz
	 V/qeanBKsoFu2LmEtel6Xc/OajG2ddnX3AVebu/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kun(llfl)" <llfl@linux.alibaba.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/356] iommu/amd: Fix sysfs leak in iommu init
Date: Wed,  3 Jul 2024 12:37:09 +0200
Message-ID: <20240703102916.617943356@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 724874ad0b2a8..70f3720d96c7e 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -1493,8 +1493,17 @@ static void __init free_pci_segments(void)
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



