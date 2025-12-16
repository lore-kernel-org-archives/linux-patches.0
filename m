Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB2D3148B3;
	Tue, 16 Dec 2025 11:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885539; cv=none; b=llT/ukN4jNE1D3B52Xjrf4P8ztHWPaTB/mGHFU6bWYQ0u6vxhyvZMOApsCqOvko3b6LyqLbDzc1X/yzdQ8ULidpHl1E1XCmKj+Fs8DXVVgx4OsOYNLZfXKf7oa/JJq5qKAbeHRnNGApTK4XVHlvRf202ejFFvjbkXWZ3k+l2DbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885539; c=relaxed/simple;
	bh=xpglEzNQof+bReeL75Nv/IuaY2ckSVoRuLsMTie1I1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdLoZ0s1Yg7G5suohzAS44kSHJiAWdmUva9+jGB6UOGYBShBfSlT2ad69TVzUodaQrDle2G1Ul9eLfZSfE9ZpETcbFxIEpMXtMkrhu7ZrKkT+iEdHtPEvQLat2FO8a7FwEXPaAY3zqei07TJ/WJid0UpFFdNSWQMSIJTAYRG0po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eddGp4Pr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eddGp4Pr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3A2C4CEF1;
	Tue, 16 Dec 2025 11:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885539;
	bh=xpglEzNQof+bReeL75Nv/IuaY2ckSVoRuLsMTie1I1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eddGp4Pr4vNXi5niafhibQFmMlYo923M7d7hJjyUrPc1OI8Gp+UTQM12oyOBlMs/m
	 eOwHOUF1hZhr3e67ZxeGxA87bajFcM/GU0NYVup00T3jEd2tfCIYJtk3tXc1sOeDsU
	 V0Gd29dy3Or5vrlzDCXMA7j1K9E6FiLsWEvRi2lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Songtang Liu <liusongtang@bytedance.com>,
	Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 168/507] iommu/amd: Fix potential out-of-bounds read in iommu_mmio_show
Date: Tue, 16 Dec 2025 12:10:09 +0100
Message-ID: <20251216111351.605312202@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Songtang Liu <liusongtang@bytedance.com>

[ Upstream commit a0c7005333f9a968abb058b1d77bbcd7fb7fd1e7 ]

In iommu_mmio_write(), it validates the user-provided offset with the
check: `iommu->dbg_mmio_offset > iommu->mmio_phys_end - 4`.
This assumes a 4-byte access. However, the corresponding
show handler, iommu_mmio_show(), uses readq() to perform an 8-byte
(64-bit) read.

If a user provides an offset equal to `mmio_phys_end - 4`, the check
passes, and will lead to a 4-byte out-of-bounds read.

Fix this by adjusting the boundary check to use sizeof(u64), which
corresponds to the size of the readq() operation.

Fixes: 7a4ee419e8c1 ("iommu/amd: Add debugfs support to dump IOMMU MMIO registers")
Signed-off-by: Songtang Liu <liusongtang@bytedance.com>
Reviewed-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
Tested-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/debugfs.c b/drivers/iommu/amd/debugfs.c
index 10fa217a71199..20b04996441d6 100644
--- a/drivers/iommu/amd/debugfs.c
+++ b/drivers/iommu/amd/debugfs.c
@@ -37,7 +37,7 @@ static ssize_t iommu_mmio_write(struct file *filp, const char __user *ubuf,
 	if (ret)
 		return ret;
 
-	if (iommu->dbg_mmio_offset > iommu->mmio_phys_end - 4) {
+	if (iommu->dbg_mmio_offset > iommu->mmio_phys_end - sizeof(u64)) {
 		iommu->dbg_mmio_offset = -1;
 		return  -EINVAL;
 	}
-- 
2.51.0



