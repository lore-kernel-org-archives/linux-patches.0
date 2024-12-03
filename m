Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8401DA4E;
	Tue,  3 Dec 2024 15:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238024; cv=none; b=CBPPyUMiM+hqJvT53718A5mM9CIScwu3nlMPoQo1i9pjVucWJhANdXikzzyAJKypnk8Xc5mVOcuaK7TpJ/qPhHXcrD0nDqHorGtBJRm1fmhle1BD36kWq3JTjlj2hWo8RsPrwpdHIN1bDYrnVgkgj9OM9TIiLr+FkYhRsay+kao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238024; c=relaxed/simple;
	bh=UyLc1KWnJOr8gc/r5FHWTli30Xvx3zdoBeaFhFTtJfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SG+6pGjFx5kbNd8v61NTKfZyIkSjKIKPlMS2+/yc75N5V9dSxzGG8fqYvPZXeeh4CsKvorOFtBTnjD+E9f3feZYh/SciyCe8ixH5TWiIhzpU94tkVTmq8i8ndIka7IczR4T75fRJuBRG9CeE8o8jrGr8iBNCTWFlK+sUOV3YOow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kzvb2gxT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kzvb2gxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E396AC4CECF;
	Tue,  3 Dec 2024 15:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238024;
	bh=UyLc1KWnJOr8gc/r5FHWTli30Xvx3zdoBeaFhFTtJfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kzvb2gxTtAuyzIqdpvi0T4hTvD1R04B5byjJWZIRYvFE7jN5RhbvvjBijXlFJSEKg
	 ltNgRqAlLY1n+sm6sTE78Cwigucbcko3H94R1FTQSqjurNLkGS1FrDzNOh8fMfYKFH
	 gDoAmqWd5ZolqCOzIQRuL9qlAra+mZLozd/2wrUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Diego Garcia Rodriguez <diego.garcia.rodriguez@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 106/817] EDAC/{skx_common,i10nm}: Fix incorrect far-memory error source indicator
Date: Tue,  3 Dec 2024 15:34:38 +0100
Message-ID: <20241203143959.846732811@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 24dd896d9a9d5..4e98fe16f0913 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -1089,6 +1089,7 @@ static int __init i10nm_init(void)
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
index 58b8ac62becf5..5a7111791c109 100644
--- a/drivers/edac/skx_common.h
+++ b/drivers/edac/skx_common.h
@@ -241,6 +241,7 @@ int skx_adxl_get(void);
 void skx_adxl_put(void);
 void skx_set_decode(skx_decode_f decode, skx_show_retry_log_f show_retry_log);
 void skx_set_mem_cfg(bool mem_cfg_2lm);
+void skx_set_res_cfg(struct res_config *cfg);
 
 int skx_get_src_id(struct skx_dev *d, int off, u8 *id);
 int skx_get_node_id(struct skx_dev *d, u8 *id);
-- 
2.43.0



