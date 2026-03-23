Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1371124634F;
	Mon, 23 Mar 2026 15:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278977; cv=none; b=Tt0kGRm0lB/fCPGbhFxZZ+/D5zy9DeMC/WOSNcsIOwcC7hyKyChk2tTfQiV/YMhn36RVp2SBRCRa33drJb8a5eFtoEkkCfxpqoBarRxtNbsGQQPFj+6LlvfzGddgNfS7qw2u04045tyYoLS9NXU++07Qpd5qOTJTMso685Bb8ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278977; c=relaxed/simple;
	bh=GG1SeG9lXH83CdR9/IJCvqes8lK441ds+StW42r/mqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVPDzmi5D191ag/4o/JXxaLc8yPtBkivfzfekHq7DrT5uBKkZwSpTLQLKx1H/ALQKjYULq7sCoDvheYK0MhsJiQD6K5YX1dLRQX5QFPFwbd4UbKUEjgxmjEEZYqsRoo1+2IUQ6RHan0jajxzVoDZwGzH6McJmate15bFzDtCZW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pP2Hssca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pP2Hssca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0ECC4CEF7;
	Mon, 23 Mar 2026 15:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278977;
	bh=GG1SeG9lXH83CdR9/IJCvqes8lK441ds+StW42r/mqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pP2HsscakNuByWp8VKX9xkeJCYeRONjFpv28Zu/4NdgyweHmJwC2tNGxKxBIwqzwr
	 1MuuxC/J5IFHIM/lY/ACjbUx6Rc2q/ubecQn1SI/27L7EXK4DxZH6cbrA9YWoGkbji
	 Z5XmVCg64tNIHc1dCO3CCNhAbcMCadTVmcyk9Xrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Sobrie <olivier@sobrie.be>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 479/567] mtd: rawnand: pl353: make sure optimal timings are applied
Date: Mon, 23 Mar 2026 14:46:39 +0100
Message-ID: <20260323134545.831028099@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Olivier Sobrie <olivier@sobrie.be>

commit b9465b04de4b90228de03db9a1e0d56b00814366 upstream.

Timings of the nand are adjusted by pl35x_nfc_setup_interface() but
actually applied by the pl35x_nand_select_target() function.
If there is only one nand chip, the pl35x_nand_select_target() will only
apply the timings once since the test at its beginning will always be true
after the first call to this function. As a result, the hardware will
keep using the default timings set at boot to detect the nand chip, not
the optimal ones.

With this patch, we program directly the new timings when
pl35x_nfc_setup_interface() is called.

Fixes: 08d8c62164a3 ("mtd: rawnand: pl353: Add support for the ARM PL353 SMC NAND controller")
Signed-off-by: Olivier Sobrie <olivier@sobrie.be>
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/pl35x-nand-controller.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mtd/nand/raw/pl35x-nand-controller.c
+++ b/drivers/mtd/nand/raw/pl35x-nand-controller.c
@@ -862,6 +862,9 @@ static int pl35x_nfc_setup_interface(str
 			  PL35X_SMC_NAND_TAR_CYCLES(tmgs.t_ar) |
 			  PL35X_SMC_NAND_TRR_CYCLES(tmgs.t_rr);
 
+	writel(plnand->timings, nfc->conf_regs + PL35X_SMC_CYCLES);
+	pl35x_smc_update_regs(nfc);
+
 	return 0;
 }
 


