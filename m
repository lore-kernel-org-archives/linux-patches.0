Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEB129D26E;
	Wed, 20 May 2026 17:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298574; cv=none; b=bc9f90GDyQd97E/ZBfZay5Hw6uw1mI716TpW5GOHYS3fmJ+WO/lIVPN0fLrDj//Cy+KNc11Vm6LKMpdS1NTlSrhPenb2VGjgslA+34CTtetAuqoZAtCD6Svcc+1SYaGBp3bCot7ezmfCpD9+I18N+QXQ0O36c6izka3Ww5SUxm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298574; c=relaxed/simple;
	bh=RQSYTvwee4Ddr3G0l8lb+CR3WKqm/iAunLlcyzG991w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxFO4uQNX+JkmuI7c7jWAvXkVeaDL8doSTIS099Me3tKSqC189rtrtxr1dF5Pt1ZKWXm0fj1Gx9hC3O5jh/bK6z4AjTrgg4wX0qDR3maGscqdT++or4ZpUjoTmXz2MylF+AF8Dx/svDDv/KnzKxxSzHf+bzVZJYFAb1scK60Nvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLdIVFGZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLdIVFGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EC01F000E9;
	Wed, 20 May 2026 17:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298572;
	bh=V88Au5T3UmG9zyxIXOx4U2huLCNmpzKABCfbOZ+I/sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aLdIVFGZpqTaV60mPFBc5IGP439Rf+eyzSr+V8xPmuglR2Qwqg2Ca6WOzKRxdhCTL
	 UWJxAoOlPCHNmwDkeyo4Ryor0Hm6qwBTQJPCXfQNtll3gfqn51hIBFpmc/cMyP/jP+
	 2XXCQwBCmnLmncbE4e8ODsVSjAa8JsOnjO+48HgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 462/957] mtd: physmap_of_gemini: Fix disabled pinctrl state check
Date: Wed, 20 May 2026 18:15:45 +0200
Message-ID: <20260520162144.541931425@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit b7c0982184b0661f5b1b805f3a56f1bd3757b63e ]

The condition for checking the disabled pinctrl state incorrectly checks
gf->enabled_state instead of gf->disabled_state. This causes misleading
error messages and could lead to incorrect behavior when only one of the
pinctrl states is defined.

Fix the condition to properly check gf->disabled_state.

Fixes: 9d3b5086f6d4 ("mtd: physmap_of_gemini: Handle pin control")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/maps/physmap-gemini.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/maps/physmap-gemini.c b/drivers/mtd/maps/physmap-gemini.c
index 9d3b4bf84a1ad..1c34b4ef77ea3 100644
--- a/drivers/mtd/maps/physmap-gemini.c
+++ b/drivers/mtd/maps/physmap-gemini.c
@@ -181,7 +181,7 @@ int of_flash_probe_gemini(struct platform_device *pdev,
 		dev_err(dev, "no enabled pin control state\n");
 
 	gf->disabled_state = pinctrl_lookup_state(gf->p, "disabled");
-	if (IS_ERR(gf->enabled_state)) {
+	if (IS_ERR(gf->disabled_state)) {
 		dev_err(dev, "no disabled pin control state\n");
 	} else {
 		ret = pinctrl_select_state(gf->p, gf->disabled_state);
-- 
2.53.0



