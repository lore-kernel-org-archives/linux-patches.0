Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6BE36403C;
	Tue, 16 Dec 2025 12:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887770; cv=none; b=AffDP8kzMpc5CMuc9MTPHB02pEHXjvdVcWz55XJq55zVNHolusTqIyhYYSp3OIm4VNryGHQ+BApck2M6XYHGZiK627jiTpmbSti41KQGQ/BrjZeUPwn23Ck3IzaKgAPkZdp7ursMLqqV5fKYKj3hO8iYD6rGc35tBN8MnjcnjME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887770; c=relaxed/simple;
	bh=K7A9gzEHXKFvasfWiI6R3YNUmqHZs82ShIAOjyFPisU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nv+tqq0jfjghIbKNQMlVbhE0Rupuvb2riKjIFAQBZ/cRNwJdaxkEQ+TbcHCMx5F9UiokrjkYTCpmLrBX/Hh5I/xRGldIq6e/sQiUzHpkSs0bBk44lkTCiMckZxZuuZQekOYgJc31thHlM1h2Po4nSaY7MhXzOExrqDyOMrdS5ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vgr73qNx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vgr73qNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DD1C4CEF1;
	Tue, 16 Dec 2025 12:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887769;
	bh=K7A9gzEHXKFvasfWiI6R3YNUmqHZs82ShIAOjyFPisU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vgr73qNx/wa5bNOw51xxi3tAnaU0Oz7Rfs5DII4kTfAUFCmgqj+VO05nzviBfhv6u
	 2/Kc2WVNwc/bzxCFiu3F+SGmUBT4On4odAENBpk98CqhnK9QW0CP73RwPGgk/ONiPs
	 bbWFq1+yYfSIoOW1qEGlXTpAS/Dl6dRpFfe9kGzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 332/614] iommu/vt-d: Set INTEL_IOMMU_FLOPPY_WA depend on BLK_DEV_FD
Date: Tue, 16 Dec 2025 12:11:39 +0100
Message-ID: <20251216111413.394766469@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineeth Pillai (Google) <vineeth@bitbyteword.org>

[ Upstream commit cb3db5a39e2a6b6396df1780d39a250f649d2e3a ]

INTEL_IOMMU_FLOPPY_WA workaround was introduced to create direct mappings
for first 16MB for floppy devices as the floppy drivers were not using
dma apis. We need not do this direct map if floppy driver is not
enabled.

INTEL_IOMMU_FLOPPY_WA is generally not a good idea. Iommu will be
mapping pages in this address range while kernel would also be
allocating from this range(mostly on memory stress). A misbehaving
device using this domain will have access to the pages that the
kernel might be actively using. We noticed this while running a test
that was trying to figure out if any pages used by kernel is in iommu
page tables.

This patch reduces the scope of the above issue by disabling the
workaround when floppy driver is not enabled. But we would still need to
fix the floppy driver to use dma apis so that we need not do direct map
without reserving the pages. Or the other option is to reserve this
memory range in firmware so that kernel will not use the pages.

Fixes: d850c2ee5fe2 ("iommu/vt-d: Expose ISA direct mapping region via iommu_get_resv_regions")
Fixes: 49a0429e53f2 ("Intel IOMMU: Iommu floppy workaround")
Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
Link: https://lore.kernel.org/r/20251002161625.1155133-1-vineeth@bitbyteword.org
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/Kconfig b/drivers/iommu/intel/Kconfig
index f2f538c706503..17a91f881b2e9 100644
--- a/drivers/iommu/intel/Kconfig
+++ b/drivers/iommu/intel/Kconfig
@@ -66,7 +66,7 @@ config INTEL_IOMMU_DEFAULT_ON
 
 config INTEL_IOMMU_FLOPPY_WA
 	def_bool y
-	depends on X86
+	depends on X86 && BLK_DEV_FD
 	help
 	  Floppy disk drivers are known to bypass DMA API calls
 	  thereby failing to work when IOMMU is enabled. This
-- 
2.51.0



