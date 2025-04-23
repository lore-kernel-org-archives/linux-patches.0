Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2C617B421;
	Wed, 23 Apr 2025 15:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420442; cv=none; b=CPbSBztBtcuRHqoE3iSlYuyzPngOdKJNo80sH6685PP50rA4XPCuEAk0g1AZq+Lwl8gIUitG+UamG3lCBYvazKmp9oH/Ski5x4d4Sj+9cV3/qERKePfwmgvRFJUTIRd/jYY3Jude8GL7k9EADZSv47hxBQc5DZkxFYIv+vO9kho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420442; c=relaxed/simple;
	bh=/5tddqCoVXmTkR/JGF9F6oV/9kg+EOnjl+W2BrIifdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YC3sqkCSnMhwJ5ZDgOucC+RD9FfWitKmoiI2KYQkte1j226MutG0m4MMqg/64XuCCcqjtQP2u1CxUnxNtlgada3Cb2F5UcwPuql2PUqN3kZeowLkb332ch5VOOce50rKAv5ghaG9422EcRY3/wK4Oky2IXvrOGfcf2V6irnC2q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yCpY00jj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yCpY00jj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E70C4CEE3;
	Wed, 23 Apr 2025 15:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420442;
	bh=/5tddqCoVXmTkR/JGF9F6oV/9kg+EOnjl+W2BrIifdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yCpY00jjPq7PZYxCz/z3P1TaZkMY+AZPqrtB0cG0NSPYn9r2+GEwhLKvtMByLyyga
	 CIWrFbpyLlBebkRC7ZTChSL9aCsSBF7vO5r0d9uHbtemxbX3uFzuKmY4rJvAcDaz9i
	 xarpIaqyASVHMU7SQvUlD5pE32vSVD36l6gBPd5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 092/241] thermal: intel: int340x: Fix Panther Lake DLVR support
Date: Wed, 23 Apr 2025 16:42:36 +0200
Message-ID: <20250423142624.339374713@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 00c5ff5e9a55dca2e7ca29af4e5f8708731faf11 ]

Panther Lake uses the same DLVR register offsets as Lunar Lake, but the
driver uses the default register offsets table for it by mistake.

Move the selection of register offsets table from the actual attribute
read/write callbacks to proc_thermal_rfim_add() and make it handle
Panther Lake the same way as Lunar Lake.  This way it is clean and in
the future such issues can be avoided.

Fixes: e50eeababa94 ("thermal: intel: int340x: Panther Lake DLVR support")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20250411115438.594114-1-srinivas.pandruvada@linux.intel.com
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../int340x_thermal/processor_thermal_rfim.c  | 33 ++++++++++---------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
index dad63f2d5f90f..3a028b78d9afc 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
@@ -166,15 +166,18 @@ static const struct mmio_reg adl_dvfs_mmio_regs[] = {
 	{ 0, 0x5A40, 1, 0x1, 0}, /* rfi_disable */
 };
 
+static const struct mapping_table *dlvr_mapping;
+static const struct mmio_reg *dlvr_mmio_regs_table;
+
 #define RFIM_SHOW(suffix, table)\
 static ssize_t suffix##_show(struct device *dev,\
 			      struct device_attribute *attr,\
 			      char *buf)\
 {\
-	const struct mapping_table *mapping = NULL;\
+	const struct mmio_reg *mmio_regs = dlvr_mmio_regs_table;\
+	const struct mapping_table *mapping = dlvr_mapping;\
 	struct proc_thermal_device *proc_priv;\
 	struct pci_dev *pdev = to_pci_dev(dev);\
-	const struct mmio_reg *mmio_regs;\
 	const char **match_strs;\
 	int ret, err;\
 	u32 reg_val;\
@@ -186,12 +189,6 @@ static ssize_t suffix##_show(struct device *dev,\
 		mmio_regs = adl_dvfs_mmio_regs;\
 	} else if (table == 2) { \
 		match_strs = (const char **)dlvr_strings;\
-		if (pdev->device == PCI_DEVICE_ID_INTEL_LNLM_THERMAL) {\
-			mmio_regs = lnl_dlvr_mmio_regs;\
-			mapping = lnl_dlvr_mapping;\
-		} else {\
-			mmio_regs = dlvr_mmio_regs;\
-		} \
 	} else {\
 		match_strs = (const char **)fivr_strings;\
 		mmio_regs = tgl_fivr_mmio_regs;\
@@ -214,12 +211,12 @@ static ssize_t suffix##_store(struct device *dev,\
 			       struct device_attribute *attr,\
 			       const char *buf, size_t count)\
 {\
-	const struct mapping_table *mapping = NULL;\
+	const struct mmio_reg *mmio_regs = dlvr_mmio_regs_table;\
+	const struct mapping_table *mapping = dlvr_mapping;\
 	struct proc_thermal_device *proc_priv;\
 	struct pci_dev *pdev = to_pci_dev(dev);\
 	unsigned int input;\
 	const char **match_strs;\
-	const struct mmio_reg *mmio_regs;\
 	int ret, err;\
 	u32 reg_val;\
 	u32 mask;\
@@ -230,12 +227,6 @@ static ssize_t suffix##_store(struct device *dev,\
 		mmio_regs = adl_dvfs_mmio_regs;\
 	} else if (table == 2) { \
 		match_strs = (const char **)dlvr_strings;\
-		if (pdev->device == PCI_DEVICE_ID_INTEL_LNLM_THERMAL) {\
-			mmio_regs = lnl_dlvr_mmio_regs;\
-			mapping = lnl_dlvr_mapping;\
-		} else {\
-			mmio_regs = dlvr_mmio_regs;\
-		} \
 	} else {\
 		match_strs = (const char **)fivr_strings;\
 		mmio_regs = tgl_fivr_mmio_regs;\
@@ -448,6 +439,16 @@ int proc_thermal_rfim_add(struct pci_dev *pdev, struct proc_thermal_device *proc
 	}
 
 	if (proc_priv->mmio_feature_mask & PROC_THERMAL_FEATURE_DLVR) {
+		switch (pdev->device) {
+		case PCI_DEVICE_ID_INTEL_LNLM_THERMAL:
+		case PCI_DEVICE_ID_INTEL_PTL_THERMAL:
+			dlvr_mmio_regs_table = lnl_dlvr_mmio_regs;
+			dlvr_mapping = lnl_dlvr_mapping;
+			break;
+		default:
+			dlvr_mmio_regs_table = dlvr_mmio_regs;
+			break;
+		}
 		ret = sysfs_create_group(&pdev->dev.kobj, &dlvr_attribute_group);
 		if (ret)
 			return ret;
-- 
2.39.5



