Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A661F9A9C;
	Tue,  3 Dec 2024 15:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240198; cv=none; b=N8t8oQvRGDip0rE3HiVB1N3FAXabAc14yWjC+FaUR8vhBJm8voMTnlAHYUyFVc60A744k0UDjy27RwuRoWovaDhbG/yNF+CUHvYJr9j0PlQ2FxvaAhtBoJN+xB8gMR9a6M75NGYkbzNBqA/pzSLQ7TD5zUVgsrQplg0UoK3DgtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240198; c=relaxed/simple;
	bh=VuPgSoudHi5ACZVlwrCBoxIrZo2yOqSnbbk3IkO7J4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7fCtBdIHmeEU2LKfbz7TFHY9oejTcNpbBhQ5TBcZOANTti8Y2BAZi2aZtuJN56Jdx+ob8z4BEQwKMwmlxn1m9yaZ2krb9ljiMnNe7MZHduQlQhXxye+6tOe4xbobLNT0eK3/Z0waGExfasQi+x8ExTsH7Yzo/5/AipQuWm2Z7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nhH2k6kI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhH2k6kI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16447C4CECF;
	Tue,  3 Dec 2024 15:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240197;
	bh=VuPgSoudHi5ACZVlwrCBoxIrZo2yOqSnbbk3IkO7J4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhH2k6kI6OYNjEey/LarXP57PBC2nFIlWvkOq4UuGhm27m8l0c2FWKOU6jgaKZy8J
	 WJ2x/sHVYew+p+7vIW5OLP99Q7VfbtEZnRA8wjtVrQ9uOggRXC8wn8Xsd8Qsb/Wekd
	 4AWgBuIaEN2bfsBGBgr2/P+iAiN/UciOKvkPVBNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Diego Garcia Rodriguez <diego.garcia.rodriguez@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/826] EDAC/skx_common: Differentiate memory error sources
Date: Tue,  3 Dec 2024 15:36:23 +0100
Message-ID: <20241203144745.659765288@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit 2397f795735219caa9c2fe61e7bcdd0652e670d3 ]

The current skx_common determines whether the memory error source is the
near memory of the 2LM system and then retrieves the decoded error results
from the ADXL components (near-memory vs. far-memory) accordingly.

However, some memory controllers may have limitations in correctly
reporting the memory error source, leading to the retrieval of incorrect
decoded parts from the ADXL.

To address these limitations, instead of simply determining whether the
memory error is from the near memory of the 2LM system, it is necessary to
distinguish the memory error source details as follows:

  Memory error from the near memory of the 2LM system.
  Memory error from the far memory of the 2LM system.
  Memory error from the 1LM system.
  Not a memory error.

This will enable the i10nm_edac driver to take appropriate actions for
those memory controllers that have limitations in reporting the memory
error source.

Fixes: ba987eaaabf9 ("EDAC/i10nm: Add Intel Granite Rapids server support")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Tested-by: Diego Garcia Rodriguez <diego.garcia.rodriguez@intel.com>
Link: https://lore.kernel.org/r/20241015072236.24543-2-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/skx_common.c | 34 ++++++++++++++++------------------
 drivers/edac/skx_common.h |  7 +++++++
 2 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/edac/skx_common.c b/drivers/edac/skx_common.c
index 85713646957b3..52b4628998700 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -119,7 +119,7 @@ void skx_adxl_put(void)
 }
 EXPORT_SYMBOL_GPL(skx_adxl_put);
 
-static bool skx_adxl_decode(struct decoded_addr *res, bool error_in_1st_level_mem)
+static bool skx_adxl_decode(struct decoded_addr *res, enum error_source err_src)
 {
 	struct skx_dev *d;
 	int i, len = 0;
@@ -136,7 +136,7 @@ static bool skx_adxl_decode(struct decoded_addr *res, bool error_in_1st_level_me
 	}
 
 	res->socket  = (int)adxl_values[component_indices[INDEX_SOCKET]];
-	if (error_in_1st_level_mem) {
+	if (err_src == ERR_SRC_2LM_NM) {
 		res->imc     = (adxl_nm_bitmap & BIT_NM_MEMCTRL) ?
 			       (int)adxl_values[component_indices[INDEX_NM_MEMCTRL]] : -1;
 		res->channel = (adxl_nm_bitmap & BIT_NM_CHANNEL) ?
@@ -620,31 +620,27 @@ static void skx_mce_output_error(struct mem_ctl_info *mci,
 			     optype, skx_msg);
 }
 
-static bool skx_error_in_1st_level_mem(const struct mce *m)
+static enum error_source skx_error_source(const struct mce *m)
 {
-	u32 errcode;
+	u32 errcode = GET_BITFIELD(m->status, 0, 15) & MCACOD_MEM_ERR_MASK;
 
-	if (!skx_mem_cfg_2lm)
-		return false;
-
-	errcode = GET_BITFIELD(m->status, 0, 15) & MCACOD_MEM_ERR_MASK;
-
-	return errcode == MCACOD_EXT_MEM_ERR;
-}
+	if (errcode != MCACOD_MEM_CTL_ERR && errcode != MCACOD_EXT_MEM_ERR)
+		return ERR_SRC_NOT_MEMORY;
 
-static bool skx_error_in_mem(const struct mce *m)
-{
-	u32 errcode;
+	if (!skx_mem_cfg_2lm)
+		return ERR_SRC_1LM;
 
-	errcode = GET_BITFIELD(m->status, 0, 15) & MCACOD_MEM_ERR_MASK;
+	if (errcode == MCACOD_EXT_MEM_ERR)
+		return ERR_SRC_2LM_NM;
 
-	return (errcode == MCACOD_MEM_CTL_ERR || errcode == MCACOD_EXT_MEM_ERR);
+	return ERR_SRC_2LM_FM;
 }
 
 int skx_mce_check_error(struct notifier_block *nb, unsigned long val,
 			void *data)
 {
 	struct mce *mce = (struct mce *)data;
+	enum error_source err_src;
 	struct decoded_addr res;
 	struct mem_ctl_info *mci;
 	char *type;
@@ -652,8 +648,10 @@ int skx_mce_check_error(struct notifier_block *nb, unsigned long val,
 	if (mce->kflags & MCE_HANDLED_CEC)
 		return NOTIFY_DONE;
 
+	err_src = skx_error_source(mce);
+
 	/* Ignore unless this is memory related with an address */
-	if (!skx_error_in_mem(mce) || !(mce->status & MCI_STATUS_ADDRV))
+	if (err_src == ERR_SRC_NOT_MEMORY || !(mce->status & MCI_STATUS_ADDRV))
 		return NOTIFY_DONE;
 
 	memset(&res, 0, sizeof(res));
@@ -667,7 +665,7 @@ int skx_mce_check_error(struct notifier_block *nb, unsigned long val,
 	/* Try driver decoder first */
 	if (!(driver_decode && driver_decode(&res))) {
 		/* Then try firmware decoder (ACPI DSM methods) */
-		if (!(adxl_component_count && skx_adxl_decode(&res, skx_error_in_1st_level_mem(mce))))
+		if (!(adxl_component_count && skx_adxl_decode(&res, err_src)))
 			return NOTIFY_DONE;
 	}
 
diff --git a/drivers/edac/skx_common.h b/drivers/edac/skx_common.h
index f945c1bf5ca46..cd47f81868319 100644
--- a/drivers/edac/skx_common.h
+++ b/drivers/edac/skx_common.h
@@ -146,6 +146,13 @@ enum {
 	INDEX_MAX
 };
 
+enum error_source {
+	ERR_SRC_1LM,
+	ERR_SRC_2LM_NM,
+	ERR_SRC_2LM_FM,
+	ERR_SRC_NOT_MEMORY,
+};
+
 #define BIT_NM_MEMCTRL	BIT_ULL(INDEX_NM_MEMCTRL)
 #define BIT_NM_CHANNEL	BIT_ULL(INDEX_NM_CHANNEL)
 #define BIT_NM_DIMM	BIT_ULL(INDEX_NM_DIMM)
-- 
2.43.0



