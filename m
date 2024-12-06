Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7A9149C51;
	Fri,  6 Dec 2024 14:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496722; cv=none; b=DLo+0/rU5twE92stz+b6JJq9wNgzPzXLQVinJyLSIPXuXlKlQ9hK7CqBNpXrVJQoWqg21ZrxmAs1RWLEYLAoZFM4Z9iySp/Rvor+XuKseKFMI3BpWgf2NB4IcNk61aNonI/zglKiY+E6gRXEtm6dswgSVttf2HD5wWD1fiG79cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496722; c=relaxed/simple;
	bh=W+trR3k2avWbcXMU/jIps/yEbu+LUOaIZG3Q2YlQ/DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzCEIVkNLCQr33GbpGYRRC+MvduRZzqMKHHbk/CM7CTmXcv3YczpflXLtcEljrXrlzrI1s93LiWXLekyRKhSqGXcd+ErF4c2xMuqgzJHah+9pQLhFLSOm7CTA4NgAWf2ML67WQIbAJ8UdD68+fdM12tHM1LrAlAkp5o9e7dpKoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4EtvWyJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4EtvWyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CA2C4CED1;
	Fri,  6 Dec 2024 14:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496722;
	bh=W+trR3k2avWbcXMU/jIps/yEbu+LUOaIZG3Q2YlQ/DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4EtvWyJfjlXa7UvS6tJ8fQ2J2QfeC9KQelTGZUoVgi2fXamBZ/vIhOVejKA5zvgP
	 es3MshtjQfLGLffqHhOIWu2HRZ/lZbwutiagnIVlel1hmwMjrxDwZkL5b6SBz9+13y
	 EdFPCDt4mP5hfdK8s3tPG/w+MmNauChfrcdJENvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Diego Garcia Rodriguez <diego.garcia.rodriguez@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/676] EDAC/{skx_common,i10nm}: Fix incorrect far-memory error source indicator
Date: Fri,  6 Dec 2024 15:28:25 +0100
Message-ID: <20241206143656.720995575@linuxfoundation.org>
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

[ Upstream commit a36667037a0c0e36c59407f8ae636295390239a5 ]

The Granite Rapids CPUs with Flat2LM memory configurations may
mistakenly report near-memory errors as far-memory errors, resulting
in the invalid decoded ADXL results:

  EDAC skx: Bad imc -1

Fix this incorrect far-memory error source indicator by prefetching the
decoded far-memory controller ID, and adjust the error source indicator
to near-memory if the far-memory controller ID is invalid.

Fixes: ba987eaaabf9 ("EDAC/i10nm: Add Intel Granite Rapids server support")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Tested-by: Diego Garcia Rodriguez <diego.garcia.rodriguez@intel.com>
Link: https://lore.kernel.org/r/20241015072236.24543-3-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i10nm_base.c |  1 +
 drivers/edac/skx_common.c | 23 +++++++++++++++++++++++
 drivers/edac/skx_common.h |  1 +
 3 files changed, 25 insertions(+)

diff --git a/drivers/edac/i10nm_base.c b/drivers/edac/i10nm_base.c
index 2b83d6de9352b..535f058b48eef 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -1088,6 +1088,7 @@ static int __init i10nm_init(void)
 		return -ENODEV;
 
 	cfg = (struct res_config *)id->driver_data;
+	skx_set_res_cfg(cfg);
 	res_cfg = cfg;
 
 	rc = skx_get_hi_lo(0x09a2, off, &tolm, &tohm);
diff --git a/drivers/edac/skx_common.c b/drivers/edac/skx_common.c
index 42266120ef427..0b8aaf5f77d9f 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -47,6 +47,7 @@ static skx_show_retry_log_f skx_show_retry_rd_err_log;
 static u64 skx_tolm, skx_tohm;
 static LIST_HEAD(dev_edac_list);
 static bool skx_mem_cfg_2lm;
+static struct res_config *skx_res_cfg;
 
 int skx_adxl_get(void)
 {
@@ -135,6 +136,22 @@ static bool skx_adxl_decode(struct decoded_addr *res, enum error_source err_src)
 		return false;
 	}
 
+	/*
+	 * GNR with a Flat2LM memory configuration may mistakenly classify
+	 * a near-memory error(DDR5) as a far-memory error(CXL), resulting
+	 * in the incorrect selection of decoded ADXL components.
+	 * To address this, prefetch the decoded far-memory controller ID
+	 * and adjust the error source to near-memory if the far-memory
+	 * controller ID is invalid.
+	 */
+	if (skx_res_cfg && skx_res_cfg->type == GNR && err_src == ERR_SRC_2LM_FM) {
+		res->imc = (int)adxl_values[component_indices[INDEX_MEMCTRL]];
+		if (res->imc == -1) {
+			err_src = ERR_SRC_2LM_NM;
+			edac_dbg(0, "Adjust the error source to near-memory.\n");
+		}
+	}
+
 	res->socket  = (int)adxl_values[component_indices[INDEX_SOCKET]];
 	if (err_src == ERR_SRC_2LM_NM) {
 		res->imc     = (adxl_nm_bitmap & BIT_NM_MEMCTRL) ?
@@ -191,6 +208,12 @@ void skx_set_mem_cfg(bool mem_cfg_2lm)
 }
 EXPORT_SYMBOL_GPL(skx_set_mem_cfg);
 
+void skx_set_res_cfg(struct res_config *cfg)
+{
+	skx_res_cfg = cfg;
+}
+EXPORT_SYMBOL_GPL(skx_set_res_cfg);
+
 void skx_set_decode(skx_decode_f decode, skx_show_retry_log_f show_retry_log)
 {
 	driver_decode = decode;
diff --git a/drivers/edac/skx_common.h b/drivers/edac/skx_common.h
index 30a795d8b8d36..e7f18ada16681 100644
--- a/drivers/edac/skx_common.h
+++ b/drivers/edac/skx_common.h
@@ -242,6 +242,7 @@ int skx_adxl_get(void);
 void skx_adxl_put(void);
 void skx_set_decode(skx_decode_f decode, skx_show_retry_log_f show_retry_log);
 void skx_set_mem_cfg(bool mem_cfg_2lm);
+void skx_set_res_cfg(struct res_config *cfg);
 
 int skx_get_src_id(struct skx_dev *d, int off, u8 *id);
 int skx_get_node_id(struct skx_dev *d, u8 *id);
-- 
2.43.0



