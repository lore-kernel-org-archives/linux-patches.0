Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDEE3AEF5C;
	Mon, 23 Mar 2026 14:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274630; cv=none; b=Y3enebYKQDFe5myjUMRajUM+57h5FuKAhSBtlZ4+wECvScgOhs4HmROLDi2m1YA3kWjw3xvyvxa6EKB+jCtDX52HS156OKhU3kM2eASyn7qXcTxvT/wy4CasaSLWQGDWNpqtgnN8Dr/jizaYBKo1xVDmkQr/RtcsHR2jEs5R0Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274630; c=relaxed/simple;
	bh=sA6stgT5XinxbngCPZ33Zv3jBLyp2KyhPMmT6iJUjfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKJFpX6RWOcmjryHBwR9G4TkeTCSIuQd+DctXN8t1DcdjsYjehk7R2kL7YyCNmFF57hxrA5zy5pbAF20fR7Npu7gZ9B5DzePIUl2IjwdEPM00Ieu6BetZYDPQ8UN3j+pvwkHrCjyQ4I3gqyEPvEO8WfWvfkMwJ9ocQF0PJp9de4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUgOcgym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUgOcgym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D7AC4CEF7;
	Mon, 23 Mar 2026 14:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274630;
	bh=sA6stgT5XinxbngCPZ33Zv3jBLyp2KyhPMmT6iJUjfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUgOcgymxN+QxLwkl/aBw9icaDn0DhRHUcjPt02iPvo3uys4m/wBlaND99NxDu+vo
	 2BV99j6aoJVni8L45qN1vYpJ1FOen9PDaq23T/Nhgk7BhtDB3JBaLPxqI6q8+RgLrt
	 +eQ29Uw4+xxgY64GNOy44QQBBtCCxlFdt+m/0RmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Sobrie <olivier@sobrie.be>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.18 058/212] mtd: rawnand: pl353: make sure optimal timings are applied
Date: Mon, 23 Mar 2026 14:44:39 +0100
Message-ID: <20260323134505.606810808@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


