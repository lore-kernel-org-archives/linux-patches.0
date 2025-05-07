Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DD51E22E9;
	Wed,  7 May 2025 19:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644883; cv=none; b=C2w1Qi6KqNtNa9FRd2lM+hlpmGgNhS8XQXeCDZicW4vBJz5oEyngDLgR7KDNbml7TSNodw1e6aohIwn5WmnuZ6oKRnXUMEZ5fDxnRhVbw1uloSfWtUyEzg3FgbggOCyTTuMszr/lXN39LAMjTskGlap4yytVb1pZShkthtyn4uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644883; c=relaxed/simple;
	bh=thmm6/QF9I13lb1LkvUD0nIdprsuPTWhM9GkFzEuaf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6eGdlZjThoedFz1Qm5clYFB3S46WQOJzHoU+DiS8PGamiEnQgP581lVDJ8aGjY7Sv8JPdz1aAw30dOi/Ao/ojXeLYhUueq25K1BmKYqcFItu5sSrFrDshTYb+35ezAO9ojDb89FozU3CR16dgNJdWJovh49a4CyPd7J592KCT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JxQ4l0PA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JxQ4l0PA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44CCC4CEE2;
	Wed,  7 May 2025 19:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644883;
	bh=thmm6/QF9I13lb1LkvUD0nIdprsuPTWhM9GkFzEuaf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JxQ4l0PAcdFBGidrn2PLjJ+WaDkBWcHLnhraZwepYUnrSLD2HQeJFf8ClTD39d5MR
	 dmh9NtJTmZqtYTQkgX6aQOX/ePQXwCowAPCbTgPLOMGGSEYe92/w/bnciO6R512gvh
	 PE42MW2+eVJWtfGPwFO45OHvBWb66UcXeAfmjauU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumar.l.rabara@altera.com>,
	Matthew Gerlach <matthew.gerlach@altera.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.6 008/129] EDAC/altera: Set DDR and SDMMC interrupt mask before registration
Date: Wed,  7 May 2025 20:39:04 +0200
Message-ID: <20250507183813.872745214@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Niravkumar L Rabara <niravkumar.l.rabara@altera.com>

commit 6dbe3c5418c4368e824bff6ae4889257dd544892 upstream.

Mask DDR and SDMMC in probe function to avoid spurious interrupts before
registration.  Removed invalid register write to system manager.

Fixes: 1166fde93d5b ("EDAC, altera: Add Arria10 ECC memory init functions")
Signed-off-by: Niravkumar L Rabara <niravkumar.l.rabara@altera.com>
Signed-off-by: Matthew Gerlach <matthew.gerlach@altera.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Cc: stable@kernel.org
Link: https://lore.kernel.org/20250425142640.33125-3-matthew.gerlach@altera.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/altera_edac.c |    7 ++++---
 drivers/edac/altera_edac.h |    2 ++
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -1015,9 +1015,6 @@ altr_init_a10_ecc_block(struct device_no
 		}
 	}
 
-	/* Interrupt mode set to every SBERR */
-	regmap_write(ecc_mgr_map, ALTR_A10_ECC_INTMODE_OFST,
-		     ALTR_A10_ECC_INTMODE);
 	/* Enable ECC */
 	ecc_set_bits(ecc_ctrl_en_mask, (ecc_block_base +
 					ALTR_A10_ECC_CTRL_OFST));
@@ -2138,6 +2135,10 @@ static int altr_edac_a10_probe(struct pl
 		return PTR_ERR(edac->ecc_mgr_map);
 	}
 
+	/* Set irq mask for DDR SBE to avoid any pending irq before registration */
+	regmap_write(edac->ecc_mgr_map, A10_SYSMGR_ECC_INTMASK_SET_OFST,
+		     (A10_SYSMGR_ECC_INTMASK_SDMMCB | A10_SYSMGR_ECC_INTMASK_DDR0));
+
 	edac->irq_chip.name = pdev->dev.of_node->name;
 	edac->irq_chip.irq_mask = a10_eccmgr_irq_mask;
 	edac->irq_chip.irq_unmask = a10_eccmgr_irq_unmask;
--- a/drivers/edac/altera_edac.h
+++ b/drivers/edac/altera_edac.h
@@ -249,6 +249,8 @@ struct altr_sdram_mc_data {
 #define A10_SYSMGR_ECC_INTMASK_SET_OFST   0x94
 #define A10_SYSMGR_ECC_INTMASK_CLR_OFST   0x98
 #define A10_SYSMGR_ECC_INTMASK_OCRAM      BIT(1)
+#define A10_SYSMGR_ECC_INTMASK_SDMMCB     BIT(16)
+#define A10_SYSMGR_ECC_INTMASK_DDR0       BIT(17)
 
 #define A10_SYSMGR_ECC_INTSTAT_SERR_OFST  0x9C
 #define A10_SYSMGR_ECC_INTSTAT_DERR_OFST  0xA0


