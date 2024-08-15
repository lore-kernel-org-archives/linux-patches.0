Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6403A1AB50A;
	Thu, 15 Aug 2024 14:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731089; cv=none; b=e+24+8+2Lrf725JkNHtFPmDNxwgtjW7NO0pZNgr11f82M+myRCtnmj1QAzQorKYEhOYnva13Ycyl1RkmH5f2vgw8prmGCYMAKmX0YNbAVDB3Utk69nOSxNR1QC3rXkjvgxROwcAoDlTbWIUY0Q9OTnIMuI+215a0RaQFdOKxgb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731089; c=relaxed/simple;
	bh=bPe566r+l8Yz6uQtMvaqwa/4W8KYEf1fQ+THH+g/weA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWPKAZdChPxH/l/ddrRb8TSLnitHnPZrBb1zhXdkMM/7AnsJu0pUIcJDoQbZ7ZRjE+BvCZ6FeOnUzW9e4ss4wBtvjWGGE4lOkGAxGTPrzXwv4GcsLgS1yWWvvD37KjQ/qkxceb8oaA6q2Jw+j3PzooGf4KBL8Sn50NTcCMkUsWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/ECyEv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/ECyEv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9517C4AF0A;
	Thu, 15 Aug 2024 14:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731089;
	bh=bPe566r+l8Yz6uQtMvaqwa/4W8KYEf1fQ+THH+g/weA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/ECyEv9f+JlzydWmYcUJR5AKrPXB22pl2ayp+G8lxW27DyX+pPR8NRFULgvpSWZK
	 u9beekVDJ9TzdcavN4xrOmOeeDmMzYZ8mQU1qAyt05T3y0CNjhhFcryU3p095big2X
	 /i8kxgmxjqZQNdrFfH7381j/vrkYNHDsKUsxMU2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aristeu Rozanski <aris@redhat.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 002/259] EDAC, skx: Retrieve and print retry_rd_err_log registers
Date: Thu, 15 Aug 2024 15:22:15 +0200
Message-ID: <20240815131902.880801772@linuxfoundation.org>
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

From: Tony Luck <tony.luck@intel.com>

[ Upstream commit e80634a75aba90e7485cd1fdb463fcac5d45f14d ]

Skylake logs some additional useful information in per-channel
registers in addition the the architectural status/addr/misc
logged in the machine check bank.

Pick up this information and add it to the EDAC log:

	retry_rd_err_[five 32-bit register values]

Sorry, no definitions for these registers. OEMs and DIMM vendors
will be able to use them to isolate which cells in the DIMM are
causing problems.

	correrrcnt[per rank corrected error counts]

Note that if additional errors are logged while these registers are
being read, you may see a jumble of values some from earlier errors,
others from later errors (since the registers report the most recent
logged error). The correrrcnt registers provide error counts per possible
rank. If these counts only change by one since the previous error logged
for this channel, then it is safe to assume that the registers logged
provide a coherent view of one error.

With this change EDAC logs look like this:

EDAC MC4: 1 CE memory read error on CPU_SrcID#2_MC#0_Chan#1_DIMM#0 (channel:1 slot:0 page:0x8f26018 offset:0x0 grain:32 syndrome:0x0 -  err_code:0x0101:0x0091 socket:2 imc:0 rank:0 bg:0 ba:0 row:0x1f880 col:0x200 retry_rd_err_log[0001a209 00000000 00000001 04800001 0001f880] correrrcnt[0001 0000 0000 0000 0000 0000 0000 0000])

Acked-by: Aristeu Rozanski <aris@redhat.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Stable-dep-of: 123b15863550 ("EDAC, i10nm: make skx_common.o a separate module")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/skx_base.c   | 51 ++++++++++++++++++++++++++++++++++++---
 drivers/edac/skx_common.c | 12 ++++++---
 drivers/edac/skx_common.h |  4 ++-
 3 files changed, 60 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/skx_base.c b/drivers/edac/skx_base.c
index f382cc70f9aaa..fb0a9369bc1a7 100644
--- a/drivers/edac/skx_base.c
+++ b/drivers/edac/skx_base.c
@@ -46,7 +46,8 @@ static struct skx_dev *get_skx_dev(struct pci_bus *bus, u8 idx)
 }
 
 enum munittype {
-	CHAN0, CHAN1, CHAN2, SAD_ALL, UTIL_ALL, SAD
+	CHAN0, CHAN1, CHAN2, SAD_ALL, UTIL_ALL, SAD,
+	ERRCHAN0, ERRCHAN1, ERRCHAN2,
 };
 
 struct munit {
@@ -68,6 +69,9 @@ static const struct munit skx_all_munits[] = {
 	{ 0x2040, { PCI_DEVFN(10, 0), PCI_DEVFN(12, 0) }, 2, 2, CHAN0 },
 	{ 0x2044, { PCI_DEVFN(10, 4), PCI_DEVFN(12, 4) }, 2, 2, CHAN1 },
 	{ 0x2048, { PCI_DEVFN(11, 0), PCI_DEVFN(13, 0) }, 2, 2, CHAN2 },
+	{ 0x2043, { PCI_DEVFN(10, 3), PCI_DEVFN(12, 3) }, 2, 2, ERRCHAN0 },
+	{ 0x2047, { PCI_DEVFN(10, 7), PCI_DEVFN(12, 7) }, 2, 2, ERRCHAN1 },
+	{ 0x204b, { PCI_DEVFN(11, 3), PCI_DEVFN(13, 3) }, 2, 2, ERRCHAN2 },
 	{ 0x208e, { }, 1, 0, SAD },
 	{ }
 };
@@ -104,10 +108,18 @@ static int get_all_munits(const struct munit *m)
 		}
 
 		switch (m->mtype) {
-		case CHAN0: case CHAN1: case CHAN2:
+		case CHAN0:
+		case CHAN1:
+		case CHAN2:
 			pci_dev_get(pdev);
 			d->imc[i].chan[m->mtype].cdev = pdev;
 			break;
+		case ERRCHAN0:
+		case ERRCHAN1:
+		case ERRCHAN2:
+			pci_dev_get(pdev);
+			d->imc[i].chan[m->mtype - ERRCHAN0].edev = pdev;
+			break;
 		case SAD_ALL:
 			pci_dev_get(pdev);
 			d->sad_all = pdev;
@@ -212,6 +224,39 @@ static int skx_get_dimm_config(struct mem_ctl_info *mci)
 #define SKX_ILV_REMOTE(tgt)	(((tgt) & 8) == 0)
 #define SKX_ILV_TARGET(tgt)	((tgt) & 7)
 
+static void skx_show_retry_rd_err_log(struct decoded_addr *res,
+				      char *msg, int len)
+{
+	u32 log0, log1, log2, log3, log4;
+	u32 corr0, corr1, corr2, corr3;
+	struct pci_dev *edev;
+	int n;
+
+	edev = res->dev->imc[res->imc].chan[res->channel].edev;
+
+	pci_read_config_dword(edev, 0x154, &log0);
+	pci_read_config_dword(edev, 0x148, &log1);
+	pci_read_config_dword(edev, 0x150, &log2);
+	pci_read_config_dword(edev, 0x15c, &log3);
+	pci_read_config_dword(edev, 0x114, &log4);
+
+	n = snprintf(msg, len, " retry_rd_err_log[%.8x %.8x %.8x %.8x %.8x]",
+		     log0, log1, log2, log3, log4);
+
+	pci_read_config_dword(edev, 0x104, &corr0);
+	pci_read_config_dword(edev, 0x108, &corr1);
+	pci_read_config_dword(edev, 0x10c, &corr2);
+	pci_read_config_dword(edev, 0x110, &corr3);
+
+	if (len - n > 0)
+		snprintf(msg + n, len - n,
+			 " correrrcnt[%.4x %.4x %.4x %.4x %.4x %.4x %.4x %.4x]",
+			 corr0 & 0xffff, corr0 >> 16,
+			 corr1 & 0xffff, corr1 >> 16,
+			 corr2 & 0xffff, corr2 >> 16,
+			 corr3 & 0xffff, corr3 >> 16);
+}
+
 static bool skx_sad_decode(struct decoded_addr *res)
 {
 	struct skx_dev *d = list_first_entry(skx_edac_list, typeof(*d), list);
@@ -658,7 +703,7 @@ static int __init skx_init(void)
 		}
 	}
 
-	skx_set_decode(skx_decode);
+	skx_set_decode(skx_decode, skx_show_retry_rd_err_log);
 
 	if (nvdimm_count && skx_adxl_get() == -ENODEV)
 		skx_printk(KERN_NOTICE, "Only decoding DDR4 address!\n");
diff --git a/drivers/edac/skx_common.c b/drivers/edac/skx_common.c
index e6647c26bd1bb..dfeefacc90d6d 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -37,6 +37,7 @@ static char *adxl_msg;
 
 static char skx_msg[MSG_SIZE];
 static skx_decode_f skx_decode;
+static skx_show_retry_log_f skx_show_retry_rd_err_log;
 static u64 skx_tolm, skx_tohm;
 static LIST_HEAD(dev_edac_list);
 
@@ -150,9 +151,10 @@ static bool skx_adxl_decode(struct decoded_addr *res)
 	return true;
 }
 
-void skx_set_decode(skx_decode_f decode)
+void skx_set_decode(skx_decode_f decode, skx_show_retry_log_f show_retry_log)
 {
 	skx_decode = decode;
+	skx_show_retry_rd_err_log = show_retry_log;
 }
 
 int skx_get_src_id(struct skx_dev *d, int off, u8 *id)
@@ -481,6 +483,7 @@ static void skx_mce_output_error(struct mem_ctl_info *mci,
 	bool overflow = GET_BITFIELD(m->status, 62, 62);
 	bool uncorrected_error = GET_BITFIELD(m->status, 61, 61);
 	bool recoverable;
+	int len;
 	u32 core_err_cnt = GET_BITFIELD(m->status, 38, 52);
 	u32 mscod = GET_BITFIELD(m->status, 16, 31);
 	u32 errcode = GET_BITFIELD(m->status, 0, 15);
@@ -537,12 +540,12 @@ static void skx_mce_output_error(struct mem_ctl_info *mci,
 		}
 	}
 	if (adxl_component_count) {
-		snprintf(skx_msg, MSG_SIZE, "%s%s err_code:0x%04x:0x%04x %s",
+		len = snprintf(skx_msg, MSG_SIZE, "%s%s err_code:0x%04x:0x%04x %s",
 			 overflow ? " OVERFLOW" : "",
 			 (uncorrected_error && recoverable) ? " recoverable" : "",
 			 mscod, errcode, adxl_msg);
 	} else {
-		snprintf(skx_msg, MSG_SIZE,
+		len = snprintf(skx_msg, MSG_SIZE,
 			 "%s%s err_code:0x%04x:0x%04x socket:%d imc:%d rank:%d bg:%d ba:%d row:0x%x col:0x%x",
 			 overflow ? " OVERFLOW" : "",
 			 (uncorrected_error && recoverable) ? " recoverable" : "",
@@ -551,6 +554,9 @@ static void skx_mce_output_error(struct mem_ctl_info *mci,
 			 res->bank_group, res->bank_address, res->row, res->column);
 	}
 
+	if (skx_show_retry_rd_err_log)
+		skx_show_retry_rd_err_log(res, skx_msg + len, MSG_SIZE - len);
+
 	edac_dbg(0, "%s\n", skx_msg);
 
 	/* Call the helper to output message */
diff --git a/drivers/edac/skx_common.h b/drivers/edac/skx_common.h
index fed337c12954b..319f9b2f1f893 100644
--- a/drivers/edac/skx_common.h
+++ b/drivers/edac/skx_common.h
@@ -64,6 +64,7 @@ struct skx_dev {
 		u8 src_id, node_id;
 		struct skx_channel {
 			struct pci_dev	*cdev;
+			struct pci_dev	*edev;
 			struct skx_dimm {
 				u8 close_pg;
 				u8 bank_xor_enable;
@@ -113,10 +114,11 @@ struct decoded_addr {
 
 typedef int (*get_dimm_config_f)(struct mem_ctl_info *mci);
 typedef bool (*skx_decode_f)(struct decoded_addr *res);
+typedef void (*skx_show_retry_log_f)(struct decoded_addr *res, char *msg, int len);
 
 int __init skx_adxl_get(void);
 void __exit skx_adxl_put(void);
-void skx_set_decode(skx_decode_f decode);
+void skx_set_decode(skx_decode_f decode, skx_show_retry_log_f show_retry_log);
 
 int skx_get_src_id(struct skx_dev *d, int off, u8 *id);
 int skx_get_node_id(struct skx_dev *d, u8 *id);
-- 
2.43.0



