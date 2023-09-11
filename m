Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911C91170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1656C433C8;
	Mon, 11 Sep 2023 14:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441363;
	bh=nSIoG3DkiDr42CUvMRLriwZ0s+VDvEb53F1dFWHqsjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1FYKWwsa8P5X/BQ0FvDNtPHncoNYuPvbZAWLo6zeRMOYIdZvQXij2wvrduNsjH8gj
	 gnEuxB7qcaUmNnE1bAKF3G3vV5kf2VbV5R0N+ZD10NStg4QVno9Rv6M6uIM69UivhG
	 A2tcTpo/9oWhZ32daAbVbl6bgAJjajUYfRoeKLpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Koba Ko <koba.ko@canonical.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 387/739] EDAC/i10nm: Skip the absent memory controllers
Date: Mon, 11 Sep 2023 15:43:06 +0200
Message-ID: <20230911134702.002458482@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit c545f5e412250555bd4e717d062b117f20bab418 ]

Some Sapphire Rapids workstations' absent memory controllers
still appear as PCIe devices that fool the i10nm_edac driver
and result in "shift exponent -66 is negative" call traces
from skx_get_dimm_info().

Skip the absent memory controllers to avoid the call traces.

Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Closes: https://lore.kernel.org/linux-edac/CAAd53p41Ku1m1rapeqb1xtD+kKuk+BaUW=dumuoF0ZO3GhFjFA@mail.gmail.com/T/#m5de16dce60a8c836ec235868c7c16e3fefad0cc2
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reported-by: Koba Ko <koba.ko@canonical.com>
Closes: https://lore.kernel.org/linux-edac/SA1PR11MB71305B71CCCC3D9305835202892AA@SA1PR11MB7130.namprd11.prod.outlook.com/T/#t
Tested-by: Koba Ko <koba.ko@canonical.com>
Fixes: d4dc89d069aa ("EDAC, i10nm: Add a driver for Intel 10nm server processors")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20230710013232.59712-1-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i10nm_base.c | 54 +++++++++++++++++++++++++++++++++++----
 1 file changed, 49 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/i10nm_base.c b/drivers/edac/i10nm_base.c
index a897b6aff3686..349ff6cfb3796 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -658,13 +658,49 @@ static struct pci_dev *get_ddr_munit(struct skx_dev *d, int i, u32 *offset, unsi
 	return mdev;
 }
 
+/**
+ * i10nm_imc_absent() - Check whether the memory controller @imc is absent
+ *
+ * @imc    : The pointer to the structure of memory controller EDAC device.
+ *
+ * RETURNS : true if the memory controller EDAC device is absent, false otherwise.
+ */
+static bool i10nm_imc_absent(struct skx_imc *imc)
+{
+	u32 mcmtr;
+	int i;
+
+	switch (res_cfg->type) {
+	case SPR:
+		for (i = 0; i < res_cfg->ddr_chan_num; i++) {
+			mcmtr = I10NM_GET_MCMTR(imc, i);
+			edac_dbg(1, "ch%d mcmtr reg %x\n", i, mcmtr);
+			if (mcmtr != ~0)
+				return false;
+		}
+
+		/*
+		 * Some workstations' absent memory controllers still
+		 * appear as PCIe devices, misleading the EDAC driver.
+		 * By observing that the MMIO registers of these absent
+		 * memory controllers consistently hold the value of ~0.
+		 *
+		 * We identify a memory controller as absent by checking
+		 * if its MMIO register "mcmtr" == ~0 in all its channels.
+		 */
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int i10nm_get_ddr_munits(void)
 {
 	struct pci_dev *mdev;
 	void __iomem *mbase;
 	unsigned long size;
 	struct skx_dev *d;
-	int i, j = 0;
+	int i, lmc, j = 0;
 	u32 reg, off;
 	u64 base;
 
@@ -690,7 +726,7 @@ static int i10nm_get_ddr_munits(void)
 		edac_dbg(2, "socket%d mmio base 0x%llx (reg 0x%x)\n",
 			 j++, base, reg);
 
-		for (i = 0; i < res_cfg->ddr_imc_num; i++) {
+		for (lmc = 0, i = 0; i < res_cfg->ddr_imc_num; i++) {
 			mdev = get_ddr_munit(d, i, &off, &size);
 
 			if (i == 0 && !mdev) {
@@ -700,8 +736,6 @@ static int i10nm_get_ddr_munits(void)
 			if (!mdev)
 				continue;
 
-			d->imc[i].mdev = mdev;
-
 			edac_dbg(2, "mc%d mmio base 0x%llx size 0x%lx (reg 0x%x)\n",
 				 i, base + off, size, reg);
 
@@ -712,7 +746,17 @@ static int i10nm_get_ddr_munits(void)
 				return -ENODEV;
 			}
 
-			d->imc[i].mbase = mbase;
+			d->imc[lmc].mbase = mbase;
+			if (i10nm_imc_absent(&d->imc[lmc])) {
+				pci_dev_put(mdev);
+				iounmap(mbase);
+				d->imc[lmc].mbase = NULL;
+				edac_dbg(2, "Skip absent mc%d\n", i);
+				continue;
+			} else {
+				d->imc[lmc].mdev = mdev;
+				lmc++;
+			}
 		}
 	}
 
-- 
2.40.1



