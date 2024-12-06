Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0271442E8;
	Fri,  6 Dec 2024 14:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496719; cv=none; b=U0jD5TeDXKcm3hzMUCifuutxwSzOTR7waw2kzo8kXxonimvkXgNbcHdO+R/mnyYrI0lWql3fr5sKePao6UINa5F3aUCMvFHGWGYrFi56GeP1D6kKySI6QbQSIsGE2zwBqe5OnO3Qxzok1YMJo7rnPFo0a/Ds5YoM1HTx1BoAlNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496719; c=relaxed/simple;
	bh=fRwtkiO/CFsJcRVO7tWxNLnJL02HIh0E7kc9g3X7ir4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZZ0hDRTXF48hrMqGSNIC6Eu/QQQ8ypaQPEE4y+D9LEAy8BRE4UZHTJQDqlvziL7x/jpQmfJeJv/+9nCKQkhTB4cWLAbKTlzvNMeBTTMVcxwHgM53ySQeUp28LzuvzJWBCU+v3V12LPoLcEJOQUzZaJvn1kELzqkfeOe4H+DqpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PaPEngsC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PaPEngsC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7865DC4CED1;
	Fri,  6 Dec 2024 14:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496719;
	bh=fRwtkiO/CFsJcRVO7tWxNLnJL02HIh0E7kc9g3X7ir4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PaPEngsCXC4df3ztGYRDdM49eiuQkzKWCAuiFAYnd6kfjxQ6g0ZQifhL8pblmhr/P
	 PPnTafjumgrbs2ZgnRhjc5iDLyXWecf/3hRKmT6QvW5wdpqRYucF2GeGADZm5BPemz
	 OQJgKvwzm2Y4aNkv/oAyKUzR7vtgVpQE/f0qayXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Diego Garcia Rodriguez <diego.garcia.rodriguez@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/676] EDAC/skx_common: Differentiate memory error sources
Date: Fri,  6 Dec 2024 15:28:24 +0100
Message-ID: <20241206143656.682733331@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8d18099fd528c..42266120ef427 100644
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
index 11faf1db4fa48..30a795d8b8d36 100644
--- a/drivers/edac/skx_common.h
+++ b/drivers/edac/skx_common.h
@@ -147,6 +147,13 @@ enum {
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



