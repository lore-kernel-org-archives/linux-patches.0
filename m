Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E817E343893;
	Sat, 12 Sep 2026 09:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206250; cv=none; b=Brre2X8DD2y5BQCcZclWWTP7dNmSj6f+ds8vXY0tl8wFlGXcmTjRx9se3LaF92fh8sqlOgR8eV5RdA9AlDKQ4sUT0ExQTDukfGqKVsjPRXLXtSe1DDRc01+5+lNJesDC+QauHbetWuIleksjQ1D68mxQTbqVQC0VF4fqyT+f+Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206250; c=relaxed/simple;
	bh=ftyaocb+9Go3u9X00z169jXHlAy4/8HOpNXZzmos/hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGSMT3v0pSCsagomLePusXedzffB8RCa+RwrwOTwImUBFWtzUZHhlgKyEyV5dPbxPdRGf4/2XtMoc3AYAwv3CsRF+Xg95iBmwvXu20zJ5gFiciNmIPYCD5sa0M3VqaUzmv98cyefAPO3cgRnWAfVVHq96owSQ/MXOQLiLVfbrBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHf17JE3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHf17JE3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B772E1F000FF;
	Sat, 12 Sep 2026 09:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206248;
	bh=lo5az48UHOlyld7Z3fEjOskot01z2hxdIV5WsvsRA5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rHf17JE3+HM/EdRLSM0qMV3VyZyYS3ky2GvLk3XmljgXVc9GqHXNtA0dT/X+TNL7S
	 iMsdQUzryrOZs+PW57l24oXudSmfBEp4cOQ1kdxpFW6dBIQeu4NvFkYr4e5Jh9WlDp
	 +w+SQWRtdtAAIEeb96mwDRIqPJCl0/wM1YQG2wTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Khare <udaykhare77@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0167/1518] regulator: tps6594: Fix device node reference leaks in multiphase loop
Date: Sat, 12 Sep 2026 08:38:56 +0200
Message-ID: <20260912065627.274864048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Uday Khare <udaykhare77@gmail.com>

[ Upstream commit 7fd28093b3effc4f92566466df364622830ec608 ]

In tps6594_regulator_probe(), the multi-phase configuration loop calls
of_find_node_by_name() to find buck nodes by name, and of_get_parent()
twice to navigate to the PMIC parent node. None of the acquired node
references (np, intermediate parent, np_pmic_parent) are ever released
via of_node_put(), causing a reference leak on every loop iteration.

Additionally, of_find_node_by_name() can return NULL, but the result was
immediately passed to of_node_full_name() and of_get_parent() without a
NULL check, which could lead to a NULL pointer dereference.

Fix this by:
- Adding a NULL check for np after of_find_node_by_name()
- Storing the intermediate parent node in a local variable np_parent
- Calling of_node_put() on np, np_parent and np_pmic_parent at the
  end of each loop iteration

Fixes: f17ccc5deb4d ("regulator: tps6594-regulator: Add driver for TI TPS6594 regulators")
Signed-off-by: Uday Khare <udaykhare77@gmail.com>
Link: https://patch.msgid.link/20260618132327.11529-1-udaykhare77@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/tps6594-regulator.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/tps6594-regulator.c b/drivers/regulator/tps6594-regulator.c
index 645e83462c645..31a5218d55105 100644
--- a/drivers/regulator/tps6594-regulator.c
+++ b/drivers/regulator/tps6594-regulator.c
@@ -669,13 +669,20 @@ static int tps6594_regulator_probe(struct platform_device *pdev)
 	 * buck_configured to avoid creating bucks for every buck in multiphase
 	 */
 	for (multi = 0; multi < desc->num_multi_phase_regs; multi++) {
+		struct device_node *np_parent;
+
 		multi_regs = &desc->multi_phase_regs[multi];
 		np = of_find_node_by_name(tps->dev->of_node, multi_regs->supply_name);
-		npname = of_node_full_name(np);
-		np_pmic_parent = of_get_parent(of_get_parent(np));
-		if (of_node_cmp(of_node_full_name(np_pmic_parent), tps->dev->of_node->full_name))
+		if (!np)
 			continue;
-		if (strcmp(npname, multi_regs->supply_name) == 0) {
+
+		npname = of_node_full_name(np);
+		np_parent = of_get_parent(np);
+		np_pmic_parent = of_get_parent(np_parent);
+
+		if (np_pmic_parent &&
+		    !of_node_cmp(of_node_full_name(np_pmic_parent), tps->dev->of_node->full_name) &&
+		    strcmp(npname, multi_regs->supply_name) == 0) {
 			switch (multi) {
 			case MULTI_BUCK12:
 				buck_multi[0] = true;
@@ -706,6 +713,10 @@ static int tps6594_regulator_probe(struct platform_device *pdev)
 				break;
 			}
 		}
+
+		of_node_put(np_pmic_parent);
+		of_node_put(np_parent);
+		of_node_put(np);
 	}
 
 	reg_irq_nb = desc->num_irq_types * (desc->num_buck_regs + desc->num_ldo_regs);
-- 
2.53.0



