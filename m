Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3519178CFA;
	Wed,  3 Jul 2024 11:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004581; cv=none; b=JAxRtAoMTMg+wcFN5oxSuO8UjweCbKb2oRuPVxZ7De8LaoJACaNCB7ehN9EERy7cX6mMMuntY3wjmL7gdT5sM2J1f89c6VWMfpDU5jgErCK5dU3rwO88O+NL5pMAwMqvjsSMOFPvvGF46tCqR41oiKvb4Iwgnwmkz6REIAh7IGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004581; c=relaxed/simple;
	bh=vY7R03sCBw1Hu03yY+Iapvltf2VN0MMOSDbEAmAN3HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5vPS17s1mDAokB5s1T8/EFCyaQkr69FYSEbuTIfxenZ7jYWJV2atl6V2igATRkdKjyGdYql0pgw2HKTC3bm0d+0+uUjtxbmTwN7UNusOHVqJIHwUBw29TtfpPkXecZIeeyLt9kh4Athvo7y50oIzIWAamnwXeynTT0eqgJZwVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B0Ggt/Fq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B0Ggt/Fq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B949C4AF12;
	Wed,  3 Jul 2024 11:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004581;
	bh=vY7R03sCBw1Hu03yY+Iapvltf2VN0MMOSDbEAmAN3HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B0Ggt/FqtdkfexUy2HKzCUAWAzCPaqQailZn7+MG4ODN3++iDR1Tft++xrrFYmNTw
	 WdTgLRF631/ozVoRH2rkZSvENF86AdquxDV5I4APJeA+CbmPnpTrBvMOebjfm21oHd
	 ATy6ZSvGKK51LxLzJ2LcYaq6Fh1YEq3OXfYXZ9Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kun(llfl)" <llfl@linux.alibaba.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/290] iommu/amd: Fix sysfs leak in iommu init
Date: Wed,  3 Jul 2024 12:37:19 +0200
Message-ID: <20240703102906.392841170@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 22d28dbe092ee..917ee5a67e787 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -1494,8 +1494,17 @@ static void __init free_pci_segments(void)
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



