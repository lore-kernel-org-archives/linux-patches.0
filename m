Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8127317E90E;
	Mon, 27 May 2024 19:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837040; cv=none; b=W6lkdl/B5heEiAHRFDeZ9+dENY1Nd0/9DFwnwcC6zgZYS/qN1uvCqbRtrzPidXroHUcG2Q4lNU4JTdbyg02uRYIkpRR06czqYvgOUtFDzgdDgW5w5iii0DYpMH4h1GcE4bNbKN6YhhP9vPYcgH5p1kwddrLoPx95uXEcHa87vVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837040; c=relaxed/simple;
	bh=rEToUy8LqG0OmfWuWT6c7jK/aGLcD+AV1HtxETxcyTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aoy0+hdwqLKd8dXP3I1hNYbHPb5cw1ryve0TZirYxz28lzUTdagQ3gSolD496OdP11uUaGOmBIxr94uJ88bDP2hdR2FnbZiYpnWakmPE5WWBbgaccrNjQFEVyFMFRVZuBbLshh0TE09rFTeCTrxSnoq4XJd4IjziTYmt/U5FJDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJLLRuPu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJLLRuPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16835C2BBFC;
	Mon, 27 May 2024 19:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837040;
	bh=rEToUy8LqG0OmfWuWT6c7jK/aGLcD+AV1HtxETxcyTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJLLRuPuaUZUBFM4th2PhRO7muy7YepwSU8/iGAmEG6Vz93LdWyrYWjXzK4E8r/IU
	 4Rcky7rGO9bU4yWCb9vYNAe0LkfElU8FGnmQhl/9csHP8wU5WJZEii7PVy1/r5owqd
	 SgfHbK7S/fKZ6gp2kvWdNKURgUosoENskA75LPwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aapo Vienamo <aapo.vienamo@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Michael Walle <mwalle@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 288/427] mtd: core: Report error if first mtd_otp_size() call fails in mtd_otp_nvmem_add()
Date: Mon, 27 May 2024 20:55:35 +0200
Message-ID: <20240527185629.318730251@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aapo Vienamo <aapo.vienamo@linux.intel.com>

[ Upstream commit d44f0bbbd8d182debcce88bda55b05269f3d33d6 ]

Jump to the error reporting code in mtd_otp_nvmem_add() if the
mtd_otp_size() call fails. Without this fix, the error is not logged.

Signed-off-by: Aapo Vienamo <aapo.vienamo@linux.intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Fixes: 4b361cfa8624 ("mtd: core: add OTP nvmem provider support")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240313173425.1325790-2-aapo.vienamo@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 0de87bc638405..6d5c755411de0 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -956,8 +956,10 @@ static int mtd_otp_nvmem_add(struct mtd_info *mtd)
 
 	if (mtd->_get_user_prot_info && mtd->_read_user_prot_reg) {
 		size = mtd_otp_size(mtd, true);
-		if (size < 0)
-			return size;
+		if (size < 0) {
+			err = size;
+			goto err;
+		}
 
 		if (size > 0) {
 			nvmem = mtd_otp_nvmem_register(mtd, "user-otp", size,
-- 
2.43.0



