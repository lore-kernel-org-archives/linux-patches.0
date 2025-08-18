Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C89230F7F8;
	Mon, 18 Aug 2025 13:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522465; cv=none; b=B9Lo/xU1Fq/nfxZpScNa352O2uQtnguKSGpATYDGxBmbum711BYPKJ9t8M/gDLMGtJgEAU2RVmTxmX2S/R7Zgy6+o+MaxqavN21RuUJidctByBIgev+i9qUfbO9a3zofCv3BBmYwc7WfQXplhBdAgxk6XKNGPVPto9T+yCQE1Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522465; c=relaxed/simple;
	bh=nHBwcNBVapzO8julUXAccmFGLec5NBdHAODHnMyuI8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exIF1OSgCIKKQ7Hab2clJ473VbIYSAioBKQO3a31+YYAcQDUMRrwbO9Ap+dalAn2XCeIQlL3ig4JzMdarhkLmjibjXgZ7j3Yn8N5vKSIIdpCAWtHXnFFoeEv5+sROEKBmZ715A+8+Hl35YJiS8fAK1/3jKDfs91Mww7XH/CLDIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLf3jKze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLf3jKze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B502C4CEF1;
	Mon, 18 Aug 2025 13:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522465;
	bh=nHBwcNBVapzO8julUXAccmFGLec5NBdHAODHnMyuI8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLf3jKze1cYZxAmU/2I+HeN1ku6V5+cTVoxO6ejJb/+p8HoF/mlOf+6jqbbLPE3Sa
	 S3iXyVN/+K4cbC6Lk/oJC4eKsM9bxU/Uaw7oZI3QB1LMpV7c3gfCuugaaqyr1tW9Qz
	 vktLp6LHazFuP462h6RUEiDQWoUXU61SnvGCAkiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 323/444] clk: renesas: rzg2l: Postpone updating priv->clks[]
Date: Mon, 18 Aug 2025 14:45:49 +0200
Message-ID: <20250818124501.052398089@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 2f96afdffad4ef74e3c511207058c41c54a2d014 ]

Since the sibling data is filled after the priv->clks[] array entry is
populated, the first clock that is probed and has a sibling will
temporarily behave as its own sibling until its actual sibling is
populated. To avoid any issues, postpone updating priv->clks[] until after
the sibling is populated.

Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20250514090415.4098534-2-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rzg2l-cpg.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/renesas/rzg2l-cpg.c b/drivers/clk/renesas/rzg2l-cpg.c
index 97d42328fa81..e2ecc9d36e05 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -1398,10 +1398,6 @@ rzg2l_cpg_register_mod_clk(const struct rzg2l_mod_clk *mod,
 		goto fail;
 	}
 
-	clk = clock->hw.clk;
-	dev_dbg(dev, "Module clock %pC at %lu Hz\n", clk, clk_get_rate(clk));
-	priv->clks[id] = clk;
-
 	if (mod->is_coupled) {
 		struct mstp_clock *sibling;
 
@@ -1413,6 +1409,10 @@ rzg2l_cpg_register_mod_clk(const struct rzg2l_mod_clk *mod,
 		}
 	}
 
+	clk = clock->hw.clk;
+	dev_dbg(dev, "Module clock %pC at %lu Hz\n", clk, clk_get_rate(clk));
+	priv->clks[id] = clk;
+
 	return;
 
 fail:
-- 
2.39.5



