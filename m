Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FD833F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301248; cv=none; b=B0Rozr9GC3EGAsjOD0tbcIk737Xr8Gh8ebMp9JbcssPm5o4GxHuG9+cZxHbNV5FKIKJhTs85UlYzEHEXW8r2U7CiI9yoOhoE8a73E8y25aqrxyfuaveJS2NOs+49UsH9PywPUKeHJC+txgx132/vhEMc1+5NvobtmsQhDMpu008=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301248; c=relaxed/simple;
	bh=FOVZccThjzX5jpjZciAJSYUfVFAGtqZV59rU7m4t+vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeKc0IEMx3xqLcY9aEdp5laRZdI/NQC4qyiMQQYp8/4dCXmBrFXfIfwbMofFLj2VZaN3k2zjICEhRVjfgu6a44hMHibFrMDufOK8S3MtgYGzArPiAouhedbM3HY8HThJzykMhMoR0YxZpHjMLRIxQ2TZWUExGDZZ1K8Kv+Ar28M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iGfOazC5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iGfOazC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D615C19423;
	Sat, 28 Feb 2026 17:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301248;
	bh=FOVZccThjzX5jpjZciAJSYUfVFAGtqZV59rU7m4t+vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGfOazC5wN6EuTiOxj6AEGHgKI82nAJkCH8GOLhV0Y3Z7JBWhPShEzXrP5jLlJVfS
	 n1GPJJ3M7+oM8U04NItgkvuxr5Wgxkq6qMbG++CqiFWuL51YMxFmcA+udIbIClNHmG
	 qmeuTnL8nHMs5HwWnX70S5711/jsmy55WJTZ2okFwqiWIOy5dakwwm7cAhjbFceT9l
	 l7DhKdX5oPTEKlx6Qoy5qxnZdGKY7+eI8s2mzNoV0lNfoZEo17ZK7VH/xPn00DvB0+
	 S7ODqjRumIJQK6UjnV1TUDgVJCOTbJNaYHKKGmyM38WavL/YABidKOydQxglzKY2YY
	 wjT15KkpOVfDQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ivan Vecera <ivecera@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 430/752] dpll: zl3073x: fix REF_PHASE_OFFSET_COMP register width for some chip IDs
Date: Sat, 28 Feb 2026 12:42:21 -0500
Message-ID: <20260228174750.1542406-430-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 4cfe066a82cdf9e83e48b16000f55280efc98325 ]

The REF_PHASE_OFFSET_COMP register is 48-bit wide on most zl3073x chip
variants, but only 32-bit wide on chip IDs 0x0E30, 0x0E93..0x0E97 and
0x1F60. The driver unconditionally uses 48-bit read/write operations,
which on 32-bit variants causes reading 2 bytes past the register
boundary (corrupting the value) and writing 2 bytes into the adjacent
register.

Fix this by storing the chip ID in the device structure during probe
and adding a helper to detect the affected variants. Use the correct
register width for read/write operations and the matching sign extension
bit (31 vs 47) when interpreting the phase compensation value.

Fixes: 6287262f761e ("dpll: zl3073x: Add support to adjust phase")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260220155755.448185-1-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/zl3073x/core.c |  1 +
 drivers/dpll/zl3073x/core.h | 28 ++++++++++++++++++++++++++++
 drivers/dpll/zl3073x/dpll.c |  7 +++++--
 drivers/dpll/zl3073x/ref.c  | 25 ++++++++++++++++++++-----
 drivers/dpll/zl3073x/regs.h |  1 +
 5 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/drivers/dpll/zl3073x/core.c b/drivers/dpll/zl3073x/core.c
index 383e2397dd033..b20d4f24c0e94 100644
--- a/drivers/dpll/zl3073x/core.c
+++ b/drivers/dpll/zl3073x/core.c
@@ -1023,6 +1023,7 @@ int zl3073x_dev_probe(struct zl3073x_dev *zldev,
 				     "Unknown or non-match chip ID: 0x%0x\n",
 				     id);
 	}
+	zldev->chip_id = id;
 
 	/* Read revision, firmware version and custom config version */
 	rc = zl3073x_read_u16(zldev, ZL_REG_REVISION, &revision);
diff --git a/drivers/dpll/zl3073x/core.h b/drivers/dpll/zl3073x/core.h
index fe8b70e25d3cc..08f1b49cccca4 100644
--- a/drivers/dpll/zl3073x/core.h
+++ b/drivers/dpll/zl3073x/core.h
@@ -35,6 +35,7 @@ struct zl3073x_dpll;
  * @dev: pointer to device
  * @regmap: regmap to access device registers
  * @multiop_lock: to serialize multiple register operations
+ * @chip_id: chip ID read from hardware
  * @ref: array of input references' invariants
  * @out: array of outs' invariants
  * @synth: array of synths' invariants
@@ -48,6 +49,7 @@ struct zl3073x_dev {
 	struct device		*dev;
 	struct regmap		*regmap;
 	struct mutex		multiop_lock;
+	u16			chip_id;
 
 	/* Invariants */
 	struct zl3073x_ref	ref[ZL3073X_NUM_REFS];
@@ -144,6 +146,32 @@ int zl3073x_write_hwreg_seq(struct zl3073x_dev *zldev,
 
 int zl3073x_ref_phase_offsets_update(struct zl3073x_dev *zldev, int channel);
 
+/**
+ * zl3073x_dev_is_ref_phase_comp_32bit - check ref phase comp register size
+ * @zldev: pointer to zl3073x device
+ *
+ * Some chip IDs have a 32-bit wide ref_phase_offset_comp register instead
+ * of the default 48-bit.
+ *
+ * Return: true if the register is 32-bit, false if 48-bit
+ */
+static inline bool
+zl3073x_dev_is_ref_phase_comp_32bit(struct zl3073x_dev *zldev)
+{
+	switch (zldev->chip_id) {
+	case 0x0E30:
+	case 0x0E93:
+	case 0x0E94:
+	case 0x0E95:
+	case 0x0E96:
+	case 0x0E97:
+	case 0x1F60:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static inline bool
 zl3073x_is_n_pin(u8 id)
 {
diff --git a/drivers/dpll/zl3073x/dpll.c b/drivers/dpll/zl3073x/dpll.c
index a8001c9760382..d7194418d1568 100644
--- a/drivers/dpll/zl3073x/dpll.c
+++ b/drivers/dpll/zl3073x/dpll.c
@@ -459,8 +459,11 @@ zl3073x_dpll_input_pin_phase_adjust_get(const struct dpll_pin *dpll_pin,
 	ref_id = zl3073x_input_pin_ref_get(pin->id);
 	ref = zl3073x_ref_state_get(zldev, ref_id);
 
-	/* Perform sign extension for 48bit signed value */
-	phase_comp = sign_extend64(ref->phase_comp, 47);
+	/* Perform sign extension based on register width */
+	if (zl3073x_dev_is_ref_phase_comp_32bit(zldev))
+		phase_comp = sign_extend64(ref->phase_comp, 31);
+	else
+		phase_comp = sign_extend64(ref->phase_comp, 47);
 
 	/* Reverse two's complement negation applied during set and convert
 	 * to 32bit signed int
diff --git a/drivers/dpll/zl3073x/ref.c b/drivers/dpll/zl3073x/ref.c
index aa2de13effa87..6b65e61039999 100644
--- a/drivers/dpll/zl3073x/ref.c
+++ b/drivers/dpll/zl3073x/ref.c
@@ -121,8 +121,16 @@ int zl3073x_ref_state_fetch(struct zl3073x_dev *zldev, u8 index)
 		return rc;
 
 	/* Read phase compensation register */
-	rc = zl3073x_read_u48(zldev, ZL_REG_REF_PHASE_OFFSET_COMP,
-			      &ref->phase_comp);
+	if (zl3073x_dev_is_ref_phase_comp_32bit(zldev)) {
+		u32 val;
+
+		rc = zl3073x_read_u32(zldev, ZL_REG_REF_PHASE_OFFSET_COMP_32,
+				      &val);
+		ref->phase_comp = val;
+	} else {
+		rc = zl3073x_read_u48(zldev, ZL_REG_REF_PHASE_OFFSET_COMP,
+				      &ref->phase_comp);
+	}
 	if (rc)
 		return rc;
 
@@ -179,9 +187,16 @@ int zl3073x_ref_state_set(struct zl3073x_dev *zldev, u8 index,
 	if (!rc && dref->sync_ctrl != ref->sync_ctrl)
 		rc = zl3073x_write_u8(zldev, ZL_REG_REF_SYNC_CTRL,
 				      ref->sync_ctrl);
-	if (!rc && dref->phase_comp != ref->phase_comp)
-		rc = zl3073x_write_u48(zldev, ZL_REG_REF_PHASE_OFFSET_COMP,
-				       ref->phase_comp);
+	if (!rc && dref->phase_comp != ref->phase_comp) {
+		if (zl3073x_dev_is_ref_phase_comp_32bit(zldev))
+			rc = zl3073x_write_u32(zldev,
+					       ZL_REG_REF_PHASE_OFFSET_COMP_32,
+					       ref->phase_comp);
+		else
+			rc = zl3073x_write_u48(zldev,
+					       ZL_REG_REF_PHASE_OFFSET_COMP,
+					       ref->phase_comp);
+	}
 	if (rc)
 		return rc;
 
diff --git a/drivers/dpll/zl3073x/regs.h b/drivers/dpll/zl3073x/regs.h
index d837bee72b178..5573d7188406b 100644
--- a/drivers/dpll/zl3073x/regs.h
+++ b/drivers/dpll/zl3073x/regs.h
@@ -194,6 +194,7 @@
 #define ZL_REF_CONFIG_DIFF_EN			BIT(2)
 
 #define ZL_REG_REF_PHASE_OFFSET_COMP		ZL_REG(10, 0x28, 6)
+#define ZL_REG_REF_PHASE_OFFSET_COMP_32	ZL_REG(10, 0x28, 4)
 
 #define ZL_REG_REF_SYNC_CTRL			ZL_REG(10, 0x2e, 1)
 #define ZL_REF_SYNC_CTRL_MODE			GENMASK(2, 0)
-- 
2.51.0

