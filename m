Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE7830B50F;
	Mon, 13 Apr 2026 16:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097612; cv=none; b=Tw6sUr/OAHRdURgWaxWAP4mfpGlMf3VlCuGGPzR1wuHMCYv/qHdnEGPeRJsEpba8zss8y/rFKiDd9ZH0xK5AeMW63QXZG5q5JBcc8wNdHkDWCtPRHDPlA/RLa41cbNYg4E4GIAYcSSN2SB5glyG3+RPHlwCZmRAfGg7YGU0bLnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097612; c=relaxed/simple;
	bh=AIirs4pV/Szt59K7mCodyy0Wo1C6Qyad9O5bfoFeMKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWnycz2nXnRfH0RDjG0oyMhHcZVVQP4AZUdqoLoTNQXjK8sa9Sh5aQ1plgI1gyaqOACm4a6bRFVvK0CczY765KJxglmp9skvb+mD+3rM17AqdGnfv/HOlw1puQ2DU9x319Qnmz9xCCgeEZB+llhxO3tEhG+p4sR3sbLB2FnSMV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZEvTZMPz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZEvTZMPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448F2C2BCAF;
	Mon, 13 Apr 2026 16:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097612;
	bh=AIirs4pV/Szt59K7mCodyy0Wo1C6Qyad9O5bfoFeMKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZEvTZMPziweV4opMZGZVlOhw0ktqJ6wOWmzrDyIfvJlejUKf+NIYIDm/bkEDfZ3OF
	 Uhau63xtS2zWBx5qHmZatm0XPPZlM02s3evd+3Ixg3L5dfUN3pVTMNYkcCcHjoENqQ
	 Mza2wMBHcbXiZx1cMfWL+4XDePJRZe8aNqGOgZQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Sobrie <olivier@sobrie.be>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 205/570] mtd: rawnand: pl353: make sure optimal timings are applied
Date: Mon, 13 Apr 2026 17:55:36 +0200
Message-ID: <20260413155838.137941868@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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
@@ -864,6 +864,9 @@ static int pl35x_nfc_setup_interface(str
 			  PL35X_SMC_NAND_TAR_CYCLES(tmgs.t_ar) |
 			  PL35X_SMC_NAND_TRR_CYCLES(tmgs.t_rr);
 
+	writel(plnand->timings, nfc->conf_regs + PL35X_SMC_CYCLES);
+	pl35x_smc_update_regs(nfc);
+
 	return 0;
 }
 


