Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297603C73F6;
	Tue, 21 Jul 2026 22:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674547; cv=none; b=DdB5MeIGFJlWKJfQSKRPFAhleLUicKr7B09A/PSGfHRiiaH0Lw4VS896cCwzUbl6MSLquRQQIXa641Q0j3TZV6mAJlNZ3BftIXYAWVRhij5Q0aT6psBvkpMG/pO6PetxRjcF8TX2lVRfKcjV+IyEWMxQivco6Rf/m7Tr2YJD404=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674547; c=relaxed/simple;
	bh=me4oRe6MlN79j/NpU43B88umsCjEPysErRshpw7vN6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UavUx2D/M46gKJRSz6lRIpaiuJirrWl6Bq8vFAfl4EeQMSt3jHJ5rU5Tnz0VvIsDlAd9ReqRctNSN5XKzvUx0qyuk6l6tOJ2G9iMxUhuKsc2vsJLvat92KQBQ6vgw15/QprDjrhSUQZbFtwHcaOxg4rDPvE4Fk3tYeE1J4JdvMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ehBBkAjz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ehBBkAjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F1A1F000E9;
	Tue, 21 Jul 2026 22:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674546;
	bh=okZ9+lQNhKQk0jFLaAQjT80FsETfbDyEAX+k6YKyGSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ehBBkAjzAnANmk3nQoUAR4ZxYo5wGfYxwwrBGNfSP2mYkUsBT62CcOGYrw2QYfQWy
	 OLDn6UGh+QlvPTooFTbaSo9ZTQXGZ5/JvKxNvs/Q9Tc7CqbiqR7QL+v0fk0AgAfKNu
	 vMJMRucePWoJDq1wiuCZZ/ZSt25APApxvIDGVDJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 545/699] net: liquidio: fix BAR resource leak on PF number failure
Date: Tue, 21 Jul 2026 17:25:04 +0200
Message-ID: <20260721152407.996228850@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


