Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E07387588;
	Tue, 21 Jul 2026 21:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667691; cv=none; b=lmkLM/A5ZEH7odWEQUnccB/cj96JBLRFGCMaMEnWptV6YpGB2FJuu8bXOj/fVTQV8VPw9FyxK65QcUp+1gP86KYWQ29NdNxXGFf2eCWdxlr49NQx1T0DxZlQMLw4R0xVBRiCxWqAeQYcW2wzLnC1LBnq04N2HfiznWIRQ2kLfbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667691; c=relaxed/simple;
	bh=N1hFgdnj25Ew3DuKCwQ2tPy9aSodsNHlcuweJ49fV4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNskU5ZhGrlx839eJXbtwARPxs+oWA2p4DbdK/cwSBo0NoQRoQolESaf8YsjHDmvZn2yde9BBZyigtNIF9UBqrNqXqOXtTh/qsXP4xZv9HDLYmLrJ1GLEBJSyjIpgVyCxc5hPVc2V2VUvj0gikef5TQUNu85jYmXwzrOTTrU3TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11q/2sNJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11q/2sNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F781F000E9;
	Tue, 21 Jul 2026 21:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667689;
	bh=2GH2nZ4icxGkT1B65vquwGUexvMpOpGAT0aRzUkPb1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=11q/2sNJv2DLJKgLAOroOZ/S58FN+wAVDWf9/e5LvymW7PNO5da+FyUF2NTGqpn9Y
	 vEeNv2I4we80Iw2gXzXNpSYBBuEVb9QQiyq/pJ5c80lMDv7rbRkVRM/mrFQz6DCeGl
	 PFNaMQmMdvuTuh/u6YILY71xbv2ulIqKM+RvUryA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 1103/1266] net: liquidio: fix BAR resource leak on PF number failure
Date: Tue, 21 Jul 2026 17:25:40 +0200
Message-ID: <20260721152506.485437941@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1332,18 +1332,14 @@ int setup_cn23xx_octeon_pf_device(struct
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
 
@@ -1374,6 +1370,12 @@ int setup_cn23xx_octeon_pf_device(struct
 	oct->coproc_clock_rate = 1000000ULL * cn23xx_coprocessor_clock(oct);
 
 	return 0;
+
+err_unmap_bar1:
+	octeon_unmap_pci_barx(oct, 1);
+err_unmap_bar0:
+	octeon_unmap_pci_barx(oct, 0);
+	return 1;
 }
 EXPORT_SYMBOL_GPL(setup_cn23xx_octeon_pf_device);
 


