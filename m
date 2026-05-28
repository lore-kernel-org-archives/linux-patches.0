Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34172D1303;
	Thu, 28 May 2026 20:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999336; cv=none; b=LDQ2TutlIRQm5IA858W/Yeu9C0VZkAO9VyF2NvSjUFJUpzFjELIbAst0lkKQEaLwmN7eUgrfwCjnALdPhs4AHTT+CbkLJ1y+eF2DPkbAkNceZBpJtvCx5kKg8aXjlMEGF/DmddhWWBaxvVnSLr7rauzZ2qtlpZ9B9AbIFlereU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999336; c=relaxed/simple;
	bh=+tA/g8Dk/YQLNS6Up9U6+Wrx0IrdbJDljERzNNgmyU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SovApl04nfoAMWXOlJZ21f3vzNa+QWTVvpUhLIRyC7uz48CHVtA2lUUy3Tvo8EqX+T2rAs0WbQCrqCvu2gdFYvmfT3my7TLnkxX7Ddascuih6ephc/Qesotxh224jEd1wnf4zy2oCyrY8ZciLr5T/2mWvteJO2oVGLhQZXBsWl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=maZT/Kf4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="maZT/Kf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4061F000E9;
	Thu, 28 May 2026 20:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999335;
	bh=IlsyPIPOhoXlTC/7CR318X34AKuWKbBVVc+D5LIGVjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=maZT/Kf4CJXlRm/gS6z6vx17C5BOYTVCYoyANtrJwr/yl7twyhE3PA6ah1A5ozI6C
	 sEOtLGEh75Bo2MnMy8vyzFLOYqFwOFDypnbtOy8vRkAld1MUlsvy6Odgw6PJpQb4cd
	 2+kS+HymxkjvlhlusDu719utGDy4BLiC/gprK9PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eder Zulian <ezulian@redhat.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 003/377] iommu/amd: Remove latent out-of-bounds access in IOMMU debugfs
Date: Thu, 28 May 2026 21:44:01 +0200
Message-ID: <20260528194638.480808288@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Eder Zulian <ezulian@redhat.com>

[ Upstream commit 8dfd3d8d74435344ee8dc9237596959c8b2a6cbe ]

In iommu_mmio_write() and iommu_capability_write(), the variables
dbg_mmio_offset and dbg_cap_offset are declared as int. However, they
are populated using kstrtou32_from_user(). If a user provides a
sufficiently large value, it can become a negative integer.

Prior to this patch, the AMD IOMMU debugfs implementation was already
protected by different mechanisms.

1. #define OFS_IN_SZ 8 ensures the user string <= 8 bytes, so
   e.g. 0xffffffff isn't a valid input.

  if (cnt > OFS_IN_SZ)
     return -EINVAL;

2. Implicit type promotion in iommu_mmio_write(), dbg_mmio_offset is int
   and iommu->mmio_phys_end is u64

  if (dbg_mmio_offset > iommu->mmio_phys_end - sizeof(u64))
      return -EINVAL;

3. The show handlers would currently catch the negative number and
   refuse to perform the read.

Replace kstrtou32_from_user() with kstrtos32_from_user() to parse the
input, and check for negative values to explicitly prevent out-of-bounds
memory accesses directly in iommu_mmio_write() and
iommu_capability_write().

Signed-off-by: Eder Zulian <ezulian@redhat.com>
Fixes: 7a4ee419e8c1 ("iommu/amd: Add debugfs support to dump IOMMU MMIO registers")
Cc: stable@vger.kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/debugfs.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd/debugfs.c b/drivers/iommu/amd/debugfs.c
index 0584ca2f859d9..3909a1fb218e9 100644
--- a/drivers/iommu/amd/debugfs.c
+++ b/drivers/iommu/amd/debugfs.c
@@ -31,11 +31,12 @@ static ssize_t iommu_mmio_write(struct file *filp, const char __user *ubuf,
 	if (cnt > OFS_IN_SZ)
 		return -EINVAL;
 
-	ret = kstrtou32_from_user(ubuf, cnt, 0, &dbg_mmio_offset);
+	ret = kstrtos32_from_user(ubuf, cnt, 0, &dbg_mmio_offset);
 	if (ret)
 		return ret;
 
-	if (dbg_mmio_offset > iommu->mmio_phys_end - sizeof(u64))
+	if (dbg_mmio_offset < 0 || dbg_mmio_offset >
+			iommu->mmio_phys_end - sizeof(u64))
 		return -EINVAL;
 
 	iommu->dbg_mmio_offset = dbg_mmio_offset;
@@ -71,12 +72,12 @@ static ssize_t iommu_capability_write(struct file *filp, const char __user *ubuf
 	if (cnt > OFS_IN_SZ)
 		return -EINVAL;
 
-	ret = kstrtou32_from_user(ubuf, cnt, 0, &dbg_cap_offset);
+	ret = kstrtos32_from_user(ubuf, cnt, 0, &dbg_cap_offset);
 	if (ret)
 		return ret;
 
 	/* Capability register at offset 0x14 is the last IOMMU capability register. */
-	if (dbg_cap_offset > 0x14)
+	if (dbg_cap_offset < 0 || dbg_cap_offset > 0x14)
 		return -EINVAL;
 
 	iommu->dbg_cap_offset = dbg_cap_offset;
-- 
2.53.0



