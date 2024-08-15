Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB45B1AC8AE;
	Thu, 15 Aug 2024 14:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731111; cv=none; b=soKUILrKf3tbPqaGDX9to/LdsgUxpeXmrBqB/EfZkj5pL7PXKRqEvEuW0WlnHKBcd76oP0myyJep1pgZ/Ry9o09qrR74bBZaay4oY7UDYXHHhdHCigdt6bfro9K5dk9ru0TMWotbKdzbxj5hKk+CJLFP8jPgRg5hF/Q0fJgHYWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731111; c=relaxed/simple;
	bh=Ry7BonjC3Lo/oVib4PDKxluW/+6+8tEgf/0KlA4LVMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMm46ANwxcGhkq9b6zDrfDu+VPKp8oFXYd5b4fkwIXmP3mR+F0NTR99zQMkHh8wXuIMZam/dXvad5fNonpo8/D3BS3PkevkJFLKHrrPjms2q7TMMs84q5mjyyOjrgZuwcde3VtQLw/ir/YuDodaYxAgN1kbIwrvIaeV7jfwKJso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHPPk02i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHPPk02i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA3AC32786;
	Thu, 15 Aug 2024 14:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731111;
	bh=Ry7BonjC3Lo/oVib4PDKxluW/+6+8tEgf/0KlA4LVMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JHPPk02iraqzyW9yf8/QevXxBeB5wF7NxlK7RXM2Bshm3omxuYoI8mBjCWdY0h7m0
	 TRwL6eUqIEuZn0hCNn9AkHkAQnGJMYGGU1Ew8rT+SyF2+zSE5q1eJQCGckusyQ+RlB
	 bX8Dql98bscToj1d17ARLAyW4XlLS+qBSGZI+NoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 003/259] EDAC/skx_common: Add new ADXL components for 2-level memory
Date: Thu, 15 Aug 2024 15:22:16 +0200
Message-ID: <20240815131902.919787338@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit 2f4348e5a86198704368a699a7c4cdeb21d569f5 ]

Some Intel servers may configure memory in 2 levels, using
fast "near" memory (e.g. DDR) as a cache for larger, slower,
"far" memory (e.g. 3D X-point).

In these configurations the BIOS ADXL address translation for
an address in a 2-level memory range will provide details of
both the "near" and far components.

Current exported ADXL components are only for 1-level memory
system or for 2nd level memory of 2-level memory system. So
add new ADXL components for 1st level memory of 2-level memory
system to fully support 2-level memory system and the detection
of memory error source(1st level memory or 2nd level memory).

Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20210611170123.1057025-2-tony.luck@intel.com
Stable-dep-of: 123b15863550 ("EDAC, i10nm: make skx_common.o a separate module")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/skx_common.c | 67 ++++++++++++++++++++++++++++++++-------
 drivers/edac/skx_common.h | 11 +++++++
 2 files changed, 67 insertions(+), 11 deletions(-)

diff --git a/drivers/edac/skx_common.c b/drivers/edac/skx_common.c
index dfeefacc90d6d..76d340db2c46b 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -23,10 +23,13 @@
 #include "skx_common.h"
 
 static const char * const component_names[] = {
-	[INDEX_SOCKET]	= "ProcessorSocketId",
-	[INDEX_MEMCTRL]	= "MemoryControllerId",
-	[INDEX_CHANNEL]	= "ChannelId",
-	[INDEX_DIMM]	= "DimmSlotId",
+	[INDEX_SOCKET]		= "ProcessorSocketId",
+	[INDEX_MEMCTRL]		= "MemoryControllerId",
+	[INDEX_CHANNEL]		= "ChannelId",
+	[INDEX_DIMM]		= "DimmSlotId",
+	[INDEX_NM_MEMCTRL]	= "NmMemoryControllerId",
+	[INDEX_NM_CHANNEL]	= "NmChannelId",
+	[INDEX_NM_DIMM]		= "NmDimmSlotId",
 };
 
 static int component_indices[ARRAY_SIZE(component_names)];
@@ -34,12 +37,14 @@ static int adxl_component_count;
 static const char * const *adxl_component_names;
 static u64 *adxl_values;
 static char *adxl_msg;
+static unsigned long adxl_nm_bitmap;
 
 static char skx_msg[MSG_SIZE];
 static skx_decode_f skx_decode;
 static skx_show_retry_log_f skx_show_retry_rd_err_log;
 static u64 skx_tolm, skx_tohm;
 static LIST_HEAD(dev_edac_list);
+static bool skx_mem_cfg_2lm;
 
 int __init skx_adxl_get(void)
 {
@@ -56,14 +61,25 @@ int __init skx_adxl_get(void)
 		for (j = 0; names[j]; j++) {
 			if (!strcmp(component_names[i], names[j])) {
 				component_indices[i] = j;
+
+				if (i >= INDEX_NM_FIRST)
+					adxl_nm_bitmap |= 1 << i;
+
 				break;
 			}
 		}
 
-		if (!names[j])
+		if (!names[j] && i < INDEX_NM_FIRST)
 			goto err;
 	}
 
+	if (skx_mem_cfg_2lm) {
+		if (!adxl_nm_bitmap)
+			skx_printk(KERN_NOTICE, "Not enough ADXL components for 2-level memory.\n");
+		else
+			edac_dbg(2, "adxl_nm_bitmap: 0x%lx\n", adxl_nm_bitmap);
+	}
+
 	adxl_component_names = names;
 	while (*names++)
 		adxl_component_count++;
@@ -99,7 +115,7 @@ void __exit skx_adxl_put(void)
 	kfree(adxl_msg);
 }
 
-static bool skx_adxl_decode(struct decoded_addr *res)
+static bool skx_adxl_decode(struct decoded_addr *res, bool error_in_1st_level_mem)
 {
 	struct skx_dev *d;
 	int i, len = 0;
@@ -116,11 +132,20 @@ static bool skx_adxl_decode(struct decoded_addr *res)
 	}
 
 	res->socket  = (int)adxl_values[component_indices[INDEX_SOCKET]];
-	res->imc     = (int)adxl_values[component_indices[INDEX_MEMCTRL]];
-	res->channel = (int)adxl_values[component_indices[INDEX_CHANNEL]];
-	res->dimm    = (int)adxl_values[component_indices[INDEX_DIMM]];
+	if (error_in_1st_level_mem) {
+		res->imc     = (adxl_nm_bitmap & BIT_NM_MEMCTRL) ?
+			       (int)adxl_values[component_indices[INDEX_NM_MEMCTRL]] : -1;
+		res->channel = (adxl_nm_bitmap & BIT_NM_CHANNEL) ?
+			       (int)adxl_values[component_indices[INDEX_NM_CHANNEL]] : -1;
+		res->dimm    = (adxl_nm_bitmap & BIT_NM_DIMM) ?
+			       (int)adxl_values[component_indices[INDEX_NM_DIMM]] : -1;
+	} else {
+		res->imc     = (int)adxl_values[component_indices[INDEX_MEMCTRL]];
+		res->channel = (int)adxl_values[component_indices[INDEX_CHANNEL]];
+		res->dimm    = (int)adxl_values[component_indices[INDEX_DIMM]];
+	}
 
-	if (res->imc > NUM_IMC - 1) {
+	if (res->imc > NUM_IMC - 1 || res->imc < 0) {
 		skx_printk(KERN_ERR, "Bad imc %d\n", res->imc);
 		return false;
 	}
@@ -151,6 +176,11 @@ static bool skx_adxl_decode(struct decoded_addr *res)
 	return true;
 }
 
+void skx_set_mem_cfg(bool mem_cfg_2lm)
+{
+	skx_mem_cfg_2lm = mem_cfg_2lm;
+}
+
 void skx_set_decode(skx_decode_f decode, skx_show_retry_log_f show_retry_log)
 {
 	skx_decode = decode;
@@ -566,6 +596,21 @@ static void skx_mce_output_error(struct mem_ctl_info *mci,
 			     optype, skx_msg);
 }
 
+static bool skx_error_in_1st_level_mem(const struct mce *m)
+{
+	u32 errcode;
+
+	if (!skx_mem_cfg_2lm)
+		return false;
+
+	errcode = GET_BITFIELD(m->status, 0, 15);
+
+	if ((errcode & 0xef80) != 0x280)
+		return false;
+
+	return true;
+}
+
 int skx_mce_check_error(struct notifier_block *nb, unsigned long val,
 			void *data)
 {
@@ -585,7 +630,7 @@ int skx_mce_check_error(struct notifier_block *nb, unsigned long val,
 	res.addr = mce->addr;
 
 	if (adxl_component_count) {
-		if (!skx_adxl_decode(&res))
+		if (!skx_adxl_decode(&res, skx_error_in_1st_level_mem(mce)))
 			return NOTIFY_DONE;
 	} else if (!skx_decode || !skx_decode(&res)) {
 		return NOTIFY_DONE;
diff --git a/drivers/edac/skx_common.h b/drivers/edac/skx_common.h
index 319f9b2f1f893..deb4f21db1ab3 100644
--- a/drivers/edac/skx_common.h
+++ b/drivers/edac/skx_common.h
@@ -9,6 +9,8 @@
 #ifndef _SKX_COMM_EDAC_H
 #define _SKX_COMM_EDAC_H
 
+#include <linux/bits.h>
+
 #define MSG_SIZE		1024
 
 /*
@@ -90,9 +92,17 @@ enum {
 	INDEX_MEMCTRL,
 	INDEX_CHANNEL,
 	INDEX_DIMM,
+	INDEX_NM_FIRST,
+	INDEX_NM_MEMCTRL = INDEX_NM_FIRST,
+	INDEX_NM_CHANNEL,
+	INDEX_NM_DIMM,
 	INDEX_MAX
 };
 
+#define BIT_NM_MEMCTRL	BIT_ULL(INDEX_NM_MEMCTRL)
+#define BIT_NM_CHANNEL	BIT_ULL(INDEX_NM_CHANNEL)
+#define BIT_NM_DIMM	BIT_ULL(INDEX_NM_DIMM)
+
 struct decoded_addr {
 	struct skx_dev *dev;
 	u64	addr;
@@ -119,6 +129,7 @@ typedef void (*skx_show_retry_log_f)(struct decoded_addr *res, char *msg, int le
 int __init skx_adxl_get(void);
 void __exit skx_adxl_put(void);
 void skx_set_decode(skx_decode_f decode, skx_show_retry_log_f show_retry_log);
+void skx_set_mem_cfg(bool mem_cfg_2lm);
 
 int skx_get_src_id(struct skx_dev *d, int off, u8 *id);
 int skx_get_node_id(struct skx_dev *d, u8 *id);
-- 
2.43.0



