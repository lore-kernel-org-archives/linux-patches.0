Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A8B1E492;
	Wed, 19 Jun 2024 13:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803872; cv=none; b=DQltRRwPw//EamzWh0aQlmtuJpVw0a0gHMGbgLzxnrOGXpXpNSoSEPOtTPRSS9mjn2mW9GnSaiEaRy+v5N37n91n3yY04wZWtu/8hPbWqOLbV5LBdt0OY7x5WuB3BqelfktCzmUVNtOJocyuEqqdbB7Pq5ay7cVunY5hTsrScVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803872; c=relaxed/simple;
	bh=/Ecka8V3B8LjAamGzmXqlxlDgeJWPSYrprd7Kc8fajc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxYxvkKX0WqbxFAYPn2tFIiqr2uY8z9XqtjShD1aSrsFgsZ/062th1jiheA465dfKGlrHxDFiw5tXH6VFWGGMyvYoAtpDOsRDs1+XWmB2zDe1r9Q1xHDzbN1h5y7CA7YhLewcGVHO4PZBlJ9olFiY3m+CihtJB1IJnZDmGWT9Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DzObCKh6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DzObCKh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBCFC2BBFC;
	Wed, 19 Jun 2024 13:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803872;
	bh=/Ecka8V3B8LjAamGzmXqlxlDgeJWPSYrprd7Kc8fajc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DzObCKh6+STpj8WV77qKvTSo5Pa/how3OzrE7wkwScF4sYUoQ6b/G8hsjZiz8JfvU
	 udNhqJdFKFCBw42YxKsg3SWxCEUXC7WdAynxk4F5tPRTywNpnmwCiynusQqv1Gtf+b
	 NV6MNJvHH6qXAYeLDZ4wOYTLD2O2EtGT/gzPBahA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kun(llfl)" <llfl@linux.alibaba.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/217] iommu/amd: Fix sysfs leak in iommu init
Date: Wed, 19 Jun 2024 14:56:14 +0200
Message-ID: <20240619125601.744485372@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cc94ac6662339..c9598c506ff94 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -1655,8 +1655,17 @@ static void __init free_pci_segments(void)
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



