Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60F727CCD7;
	Wed, 23 Apr 2025 15:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421397; cv=none; b=rEp4oz+Z4mTXf9uGVLA8bEamOs81rI0Lm6JIr2C9C+RDqKWaT7YBiSjgy133MbgMyzlwBEXsPHpfFc+vszRGcn8/C11LoxYFclc0SLyv3+LxxhkMXVttP2z/WYvazgjzF7+dQ3o2H4Y5UCyl0ReFF3z9/RP11hcQic9ssCexs8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421397; c=relaxed/simple;
	bh=URHFYbZAYtBX43KYmLCYSLaR8yWjyDDSPmSdATV3A/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ni5BtBydFSXyYe+qUgGre2x8O/7Q3sByP0H7isBIrXUB6yCSbH2w6LmHj1CZwcEIrSE34doQh2TZ2+DXYKrL8UsXddQTG1YZMNRed8PurCnOQDNSE+C5RkCoKoOpA+E/IeOAlZS/9DMhyHjIpSbTE6NW3ovJHqbJaKObdCaAyrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D7eDttMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D7eDttMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D583FC4CEE2;
	Wed, 23 Apr 2025 15:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421397;
	bh=URHFYbZAYtBX43KYmLCYSLaR8yWjyDDSPmSdATV3A/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D7eDttMo6e2xDJw2lST9aiFV+cxqG8hrUsnhd8bQkEIXcLyASfKDBraKgiM/WmmcZ
	 Hp+OHmkScF2f3/KXztqUs/ugaCASg62HJi0Li+x9XttcnNJQNH1/gcPUKICefLrmgb
	 pY3+SEQ7US+4aSUbNVSyPNVmoAf4b4R5BHXU+kEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.14 166/241] RAS/AMD/FMPM: Get masked address
Date: Wed, 23 Apr 2025 16:43:50 +0200
Message-ID: <20250423142627.314153574@linuxfoundation.org>
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

From: Yazen Ghannam <yazen.ghannam@amd.com>

commit 58029c39cdc54ac4f4dc40b4a9c05eed9f9b808a upstream.

Some operations require checking, or ignoring, specific bits in an address
value. For example, this can be comparing address values to identify unique
structures.

Currently, the full address value is compared when filtering for duplicates.
This results in over counting and creation of extra records.  This gives the
impression that more unique events occurred than did in reality.

Mask the address for physical rows on MI300.

  [ bp: Simplify. ]

Fixes: 6f15e617cc99 ("RAS: Introduce a FRU memory poison manager")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ras/amd/atl/internal.h |    3 +++
 drivers/ras/amd/atl/umc.c      |    2 --
 drivers/ras/amd/fmpm.c         |    9 ++++++++-
 3 files changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/ras/amd/atl/internal.h
+++ b/drivers/ras/amd/atl/internal.h
@@ -362,4 +362,7 @@ static inline void atl_debug_on_bad_intl
 	atl_debug(ctx, "Unrecognized interleave mode: %u", ctx->map.intlv_mode);
 }
 
+#define MI300_UMC_MCA_COL	GENMASK(5, 1)
+#define MI300_UMC_MCA_ROW13	BIT(23)
+
 #endif /* __AMD_ATL_INTERNAL_H__ */
--- a/drivers/ras/amd/atl/umc.c
+++ b/drivers/ras/amd/atl/umc.c
@@ -229,7 +229,6 @@ int get_umc_info_mi300(void)
  * Additionally, the PC and Bank bits may be hashed. This must be accounted for before
  * reconstructing the normalized address.
  */
-#define MI300_UMC_MCA_COL	GENMASK(5, 1)
 #define MI300_UMC_MCA_BANK	GENMASK(9, 6)
 #define MI300_UMC_MCA_ROW	GENMASK(24, 10)
 #define MI300_UMC_MCA_PC	BIT(25)
@@ -360,7 +359,6 @@ static void _retire_row_mi300(struct atl
  *
  * See MI300_UMC_MCA_ROW for the row bits in MCA_ADDR_UMC value.
  */
-#define MI300_UMC_MCA_ROW13	BIT(23)
 static void retire_row_mi300(struct atl_err *a_err)
 {
 	_retire_row_mi300(a_err);
--- a/drivers/ras/amd/fmpm.c
+++ b/drivers/ras/amd/fmpm.c
@@ -250,6 +250,13 @@ static bool rec_has_valid_entries(struct
 	return true;
 }
 
+/*
+ * Row retirement is done on MI300 systems, and some bits are 'don't
+ * care' for comparing addresses with unique physical rows.  This
+ * includes all column bits and the row[13] bit.
+ */
+#define MASK_ADDR(addr)	((addr) & ~(MI300_UMC_MCA_ROW13 | MI300_UMC_MCA_COL))
+
 static bool fpds_equal(struct cper_fru_poison_desc *old, struct cper_fru_poison_desc *new)
 {
 	/*
@@ -258,7 +265,7 @@ static bool fpds_equal(struct cper_fru_p
 	 *
 	 * Also, order the checks from most->least likely to fail to shortcut the code.
 	 */
-	if (old->addr != new->addr)
+	if (MASK_ADDR(old->addr) != MASK_ADDR(new->addr))
 		return false;
 
 	if (old->hw_id != new->hw_id)


