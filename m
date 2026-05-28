Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5833322A80D;
	Thu, 28 May 2026 20:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999306; cv=none; b=EQnvM8/lzahw3AhQ86fB0ea9Q1dTXxwJnjB8KdmPar+oqSrqE9Rl3zY82J/6CgSXNzMllbyB5w8AVUthuXHXi8gymjYYL+4yGHYgyVADKq23coHn9zHgYdYw7lDl5Mg/YjlM6epUnu4CcrE1HRnPjcGxoVhJtPSNCzbHESjSjLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999306; c=relaxed/simple;
	bh=AX3uCKaMLiMo6v9Hquhjajn4qgarKjO1insa6LY6Yjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cgi3O5TmTTjiyD6MS1ooLkXy7MxQMXpWY+GIOu7B0PMtNHQCa3mrKok5qDZOv6/+0uyoHouLyTiqUwZcyBHs9fSW4K+ZPD590143m+60u+9sF2BZwyD1Fx4+IHCBrQvbFi/LHs0EGFiL+7acgKI7Bzg+9iAxHRCFV81CszxwLa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sROE39wa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sROE39wa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8B61F000E9;
	Thu, 28 May 2026 20:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999305;
	bh=4SeqesLROjVK1wQpM2RtDMAU9mU3Htzo8Pn4gQXKARE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sROE39wavqRi53R7wQVgpuJBSa1Z54wist1vP/Z9RE2isIoG1jUDl8YnyAnwpX5vo
	 jg2wmDMADpThelHN/VNVuQUkFoVL3StGzp8Gmvg+hvMv4GjD4MLEF+gPw4/mZORLpu
	 gnsPzbsA+e7F2hj6Tev7Li/KR7flRQrssR9C6di8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanghui Feng <guanghuifeng@linux.alibaba.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 002/377] iommu/amd: Fix illegal cap/mmio access in IOMMU debugfs
Date: Thu, 28 May 2026 21:44:00 +0200
Message-ID: <20260528194638.449417214@linuxfoundation.org>
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

From: Guanghui Feng <guanghuifeng@linux.alibaba.com>

[ Upstream commit 0e59645683b7b6fa20eceb21a6f420e4f7412943 ]

In the current AMD IOMMU debugfs, when multiple processes simultaneously
access the IOMMU mmio/cap registers using the IOMMU debugfs, illegal
access issues can occur in the following execution flow:

1. CPU1: Sets a valid access address using iommu_mmio/capability_write,
and verifies the access address's validity in iommu_mmio/capability_show

2. CPU2: Sets an invalid address using iommu_mmio/capability_write

3. CPU1: accesses the IOMMU mmio/cap registers based on the invalid
address, resulting in an illegal access.

This patch modifies the execution process to first verify the address's
validity and then access it based on the same address, ensuring
correctness and robustness.

Signed-off-by: Guanghui Feng <guanghuifeng@linux.alibaba.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Stable-dep-of: 8dfd3d8d7443 ("iommu/amd: Remove latent out-of-bounds access in IOMMU debugfs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/debugfs.c | 42 +++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/iommu/amd/debugfs.c b/drivers/iommu/amd/debugfs.c
index 20b04996441d6..0584ca2f859d9 100644
--- a/drivers/iommu/amd/debugfs.c
+++ b/drivers/iommu/amd/debugfs.c
@@ -26,22 +26,19 @@ static ssize_t iommu_mmio_write(struct file *filp, const char __user *ubuf,
 {
 	struct seq_file *m = filp->private_data;
 	struct amd_iommu *iommu = m->private;
-	int ret;
-
-	iommu->dbg_mmio_offset = -1;
+	int ret, dbg_mmio_offset = iommu->dbg_mmio_offset = -1;
 
 	if (cnt > OFS_IN_SZ)
 		return -EINVAL;
 
-	ret = kstrtou32_from_user(ubuf, cnt, 0, &iommu->dbg_mmio_offset);
+	ret = kstrtou32_from_user(ubuf, cnt, 0, &dbg_mmio_offset);
 	if (ret)
 		return ret;
 
-	if (iommu->dbg_mmio_offset > iommu->mmio_phys_end - sizeof(u64)) {
-		iommu->dbg_mmio_offset = -1;
-		return  -EINVAL;
-	}
+	if (dbg_mmio_offset > iommu->mmio_phys_end - sizeof(u64))
+		return -EINVAL;
 
+	iommu->dbg_mmio_offset = dbg_mmio_offset;
 	return cnt;
 }
 
@@ -49,14 +46,16 @@ static int iommu_mmio_show(struct seq_file *m, void *unused)
 {
 	struct amd_iommu *iommu = m->private;
 	u64 value;
+	int dbg_mmio_offset = iommu->dbg_mmio_offset;
 
-	if (iommu->dbg_mmio_offset < 0) {
+	if (dbg_mmio_offset < 0 || dbg_mmio_offset >
+			iommu->mmio_phys_end - sizeof(u64)) {
 		seq_puts(m, "Please provide mmio register's offset\n");
 		return 0;
 	}
 
-	value = readq(iommu->mmio_base + iommu->dbg_mmio_offset);
-	seq_printf(m, "Offset:0x%x Value:0x%016llx\n", iommu->dbg_mmio_offset, value);
+	value = readq(iommu->mmio_base + dbg_mmio_offset);
+	seq_printf(m, "Offset:0x%x Value:0x%016llx\n", dbg_mmio_offset, value);
 
 	return 0;
 }
@@ -67,23 +66,20 @@ static ssize_t iommu_capability_write(struct file *filp, const char __user *ubuf
 {
 	struct seq_file *m = filp->private_data;
 	struct amd_iommu *iommu = m->private;
-	int ret;
-
-	iommu->dbg_cap_offset = -1;
+	int ret, dbg_cap_offset = iommu->dbg_cap_offset = -1;
 
 	if (cnt > OFS_IN_SZ)
 		return -EINVAL;
 
-	ret = kstrtou32_from_user(ubuf, cnt, 0, &iommu->dbg_cap_offset);
+	ret = kstrtou32_from_user(ubuf, cnt, 0, &dbg_cap_offset);
 	if (ret)
 		return ret;
 
 	/* Capability register at offset 0x14 is the last IOMMU capability register. */
-	if (iommu->dbg_cap_offset > 0x14) {
-		iommu->dbg_cap_offset = -1;
+	if (dbg_cap_offset > 0x14)
 		return -EINVAL;
-	}
 
+	iommu->dbg_cap_offset = dbg_cap_offset;
 	return cnt;
 }
 
@@ -91,21 +87,21 @@ static int iommu_capability_show(struct seq_file *m, void *unused)
 {
 	struct amd_iommu *iommu = m->private;
 	u32 value;
-	int err;
+	int err, dbg_cap_offset = iommu->dbg_cap_offset;
 
-	if (iommu->dbg_cap_offset < 0) {
+	if (dbg_cap_offset < 0 || dbg_cap_offset > 0x14) {
 		seq_puts(m, "Please provide capability register's offset in the range [0x00 - 0x14]\n");
 		return 0;
 	}
 
-	err = pci_read_config_dword(iommu->dev, iommu->cap_ptr + iommu->dbg_cap_offset, &value);
+	err = pci_read_config_dword(iommu->dev, iommu->cap_ptr + dbg_cap_offset, &value);
 	if (err) {
 		seq_printf(m, "Not able to read capability register at 0x%x\n",
-			   iommu->dbg_cap_offset);
+			   dbg_cap_offset);
 		return 0;
 	}
 
-	seq_printf(m, "Offset:0x%x Value:0x%08x\n", iommu->dbg_cap_offset, value);
+	seq_printf(m, "Offset:0x%x Value:0x%08x\n", dbg_cap_offset, value);
 
 	return 0;
 }
-- 
2.53.0



