Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4994418DB;
	Tue, 21 Jul 2026 22:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672622; cv=none; b=LUJ6UT9L7JhR/vDCcuoqqjpAkjJVsBTqcm2RU1JS7UlXomH9C6k63N3bBCMSZjei4XnDeYoqwBdz60HJiObXJHS1g+SaLqHPfAf1mADo2sZsYX8vzv1pMrkUkfoIXhsIIA+c9zoP4AIyclLIe8Ur4f19qAaDf/4DZvieA7/7Omg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672622; c=relaxed/simple;
	bh=YtiuK7Fa9qm2p4Y1L6sXRMFScC3EnWkGpEygi1Va/nU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qA+QPVrYQyWk53mp+Vl9OcKLSeCAq/TgCOsfW2P9s2dMC+u6JQGsCxSIMB9/vwQVZDpe2EL9Uc9hamH6t+fhjZSY4eT4/MWtkF0KfIe+oCjnovEiD5VbOMlRxIXetH7wuWbRzEVmf8z3O50u1AsuuxDtfGtvMOKllF5HauGMM1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMnQX1Po; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMnQX1Po"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58611F000E9;
	Tue, 21 Jul 2026 22:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672621;
	bh=W7qZxrWyXYIhwr85Aq33W0w246KwyQJKX83p9SWRGYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NMnQX1Po6Buy4+v22Ase0duRvN7Flg8RGPh6H5696jd4IhtPTiJxQl5eJdbXi5LPk
	 FngA27z7sS/3/ao5Hh/ed8fjX8DUrRsbHaqggmmotR9EVVuCOf7WfuwLUCtYOknm7D
	 k+S9ybBrHiP5EMvHpmD2JufpR7tQ1DRD/NP6tXw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 695/843] net: liquidio: fix BAR resource leak on PF number failure
Date: Tue, 21 Jul 2026 17:25:30 +0200
Message-ID: <20260721152421.687228810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit c63ee62a3c4ac1a1542f4c1a4b87e2f41df5a496 upstream.

If cn23xx_get_pf_num() fails, the function returns without
unmapping either BAR. Unmap both BARs before returning from
the error path.

Found by manual code review.

Fixes: 0c45d7fe12c7 ("liquidio: fix use of pf in pass-through mode in a virtual machine")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Link: https://patch.msgid.link/20260624064013.2809570-1-haoxiang_li2024@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c |   18 ++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
@@ -1334,18 +1334,14 @@ int setup_cn23xx_octeon_pf_device(struct
 	if (octeon_map_pci_barx(oct, 1, MAX_BAR1_IOREMAP_SIZE)) {
 		dev_err(&oct->pci_dev->dev, "%s CN23XX BAR1 map failed\n",
 			__func__);
-		octeon_unmap_pci_barx(oct, 0);
-		return 1;
+		goto err_unmap_bar0;
 	}
 
 	if (cn23xx_get_pf_num(oct) != 0)
-		return 1;
+		goto err_unmap_bar1;
 
-	if (cn23xx_sriov_config(oct)) {
-		octeon_unmap_pci_barx(oct, 0);
-		octeon_unmap_pci_barx(oct, 1);
-		return 1;
-	}
+	if (cn23xx_sriov_config(oct))
+		goto err_unmap_bar1;
 
 	octeon_write_csr64(oct, CN23XX_SLI_MAC_CREDIT_CNT, 0x3F802080802080ULL);
 
@@ -1376,6 +1372,12 @@ int setup_cn23xx_octeon_pf_device(struct
 	oct->coproc_clock_rate = 1000000ULL * cn23xx_coprocessor_clock(oct);
 
 	return 0;
+
+err_unmap_bar1:
+	octeon_unmap_pci_barx(oct, 1);
+err_unmap_bar0:
+	octeon_unmap_pci_barx(oct, 0);
+	return 1;
 }
 
 int validate_cn23xx_pf_config_info(struct octeon_device *oct,


