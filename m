Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5846345CAE;
	Tue, 16 Dec 2025 11:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885048; cv=none; b=lxmrAY1WIOgGCW/IOZMdwoidSCJimFgtlghhM+iSixCdLgp6g+AkQzSoaUj+zT8ndDI+cr/LsSL1p9nwZMOFIaqKZX1/kZ5V/k3DFf+k8NGMagP0C1HCzNJXVQqMeyMqytkHO98VLgJTa/3CU80W756unIsxSk+1fSsKJKynYXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885048; c=relaxed/simple;
	bh=tlMj65MGmBGLe5Ik614YawK9yHS+P7Vt+9RLlQuWMnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axVrkw0fCnOaYiBOqrAFI9bJD0GT+38652itsgPgVhbzodwiLKCSlumXyKI/VztmDfIbjX12lzbX7gYjHC2pWHQKY6iBEKsgGWRuq1YLiX0iLUXhWRNLSbt1xshAUg76Wg+dSLgZxBtQGwUJHfnTsqf7pnmf9Y39nXdTknQMl5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eh823s2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eh823s2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66297C4CEF1;
	Tue, 16 Dec 2025 11:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885047;
	bh=tlMj65MGmBGLe5Ik614YawK9yHS+P7Vt+9RLlQuWMnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eh823s2QEWjuczN4o0GbKYNL5Ku2UjKDI+naMtPbMcWBB4/KkGCwoyVPPwa8Zs2SE
	 np2wzuvWQqH2+WkZQCnoEaqAkAbM0RHv7J76cvb/DLsAT62p2vvit4ACxC5aMqlvLy
	 c3zfq8kcCAQfmdybFpx53NzxXUXINUpi+C5K8/co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 022/507] pinctrl: renesas: rzg2l: Fix PMC restore
Date: Tue, 16 Dec 2025 12:07:43 +0100
Message-ID: <20251216111346.340181611@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit cea950101108b7bfffe26ec4007b8e263a4b56a8 ]

PMC restore needs unlocking the register using the PWPR register.

Fixes: ede014cd1ea6422d ("pinctrl: renesas: rzg2l: Add function pointer for PMC register write")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20250921111557.103069-2-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index 289917a0e8725..9330d1bcf6b24 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -3008,7 +3008,11 @@ static void rzg2l_pinctrl_pm_setup_regs(struct rzg2l_pinctrl *pctrl, bool suspen
 		 * Now cache the registers or set them in the order suggested by
 		 * HW manual (section "Operation for GPIO Function").
 		 */
-		RZG2L_PCTRL_REG_ACCESS8(suspend, pctrl->base + PMC(off), cache->pmc[port]);
+		if (suspend)
+			RZG2L_PCTRL_REG_ACCESS8(suspend, pctrl->base + PMC(off), cache->pmc[port]);
+		else
+			pctrl->data->pmc_writeb(pctrl, cache->pmc[port], PMC(off));
+
 		if (has_iolh) {
 			RZG2L_PCTRL_REG_ACCESS32(suspend, pctrl->base + IOLH(off),
 						 cache->iolh[0][port]);
-- 
2.51.0



