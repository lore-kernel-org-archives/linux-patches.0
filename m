Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604D821D00A;
	Mon, 23 Mar 2026 13:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273918; cv=none; b=bUtRTyRXpB0qjYHOOfq5e7ARYrLVnM0sYtg+mAT9MMZwxlXtkSbbsNwroIjaqjIXx4Kx2DT+hOzxYHyCxzY5cB22wDR31kHgKEm9TRSFjROJNttxDPWwTMNPMZhfjXlZHxJ+NPybTZYQIvysIsAEIyiU+ABjvcKDMLWxqK5PJcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273918; c=relaxed/simple;
	bh=h9Dnf4q6Lv0pOItWae+wlDsLQMCcEoxO70PIJ1RO7ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eX5qIOWcWkbQPKz49szAcGNLcxRhfZD+ZTlMJchvjtQ4L2ICPgSfwIX97lpm0bIvxdS9b3I+adio8RQ3ajXjUMnBYF9CsDZVzJwMDsxboxqhlbZKdHOcOwsqQz8D9BoFHuE2qch/InlDPAWLI//XQFjO+JIki86g5hmemAtgtAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nC8LfBXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nC8LfBXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D959EC4CEF7;
	Mon, 23 Mar 2026 13:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273918;
	bh=h9Dnf4q6Lv0pOItWae+wlDsLQMCcEoxO70PIJ1RO7ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nC8LfBXW43hVid3pAMe9dCnli7yIfE62B8QHxX950Kwp6Pxmb4YZPn1VTzAnpFNbJ
	 RNNmInivBBsi7pr5lQj/hvGZg4STzSjbam4lqNlCfvkf99tnWtMdcqSIJ7Zz9kldKw
	 dC1ZqE2S87PTBJwZ9aBsyzuCVA4JX8RLFwO4TuJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Sobrie <olivier@sobrie.be>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.19 050/220] mtd: rawnand: pl353: make sure optimal timings are applied
Date: Mon, 23 Mar 2026 14:43:47 +0100
Message-ID: <20260323134506.166627195@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
 


