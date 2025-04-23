Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB7A57C9F;
	Wed, 23 Apr 2025 15:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420569; cv=none; b=gJ9/Iqw8DVULteepvLKMqY1Vr73v0Ui9L/8jfKsp7V9OWGhtaxM0P95Oa5o3H9coB1rVrVh7pKkj4kcWBcDuHjFgEC/AHsKayFwQsbCPlllxNKp8JQLICeqgv5xVEvO2ngLYb7o1c8co1CdfYk8RrrihAnN6uaNYTrZGO/Wsork=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420569; c=relaxed/simple;
	bh=LKhvvbJhgwYo9lh84MCLbZeo8+MJ0BC2XVNPh3VBNUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGsql9l9XiBKSOANsLvk2AFdkKwIMBRWSj6LLJHrZ5L1tustoVJEbhtI/XXuC2AwhDJqZFQiqxQvLg7jnUo/kA7CfbiDL9fKUwONrvlomyhAeyYX/VuJ1MQhKEYaaL6V5YPa15yULoEVJ16/nBwEa0on+StLtxY1egDo7j0v79o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DF05aClW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DF05aClW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04747C4CEEB;
	Wed, 23 Apr 2025 15:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420569;
	bh=LKhvvbJhgwYo9lh84MCLbZeo8+MJ0BC2XVNPh3VBNUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DF05aClWAYiC9bXt4H8oVG/BXHg7l316pl7CsDWeySNoV4PYxqnaEKEl2o34YyJUw
	 JBYnKHXy/LmnhFYRTweF4jICYAKPCX1VdZdP7uA+dt9VhKgK4zh8SUbWQslLsMaMAt
	 qoZYuhQXaukT7wDYibnRTNai85pSiGpcKJVw8ZOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.12 142/223] RAS/AMD/FMPM: Get masked address
Date: Wed, 23 Apr 2025 16:43:34 +0200
Message-ID: <20250423142622.971270210@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -361,4 +361,7 @@ static inline void atl_debug_on_bad_intl
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


