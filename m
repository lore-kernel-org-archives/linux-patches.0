Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D311C31E0F8;
	Mon, 18 Aug 2025 13:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524162; cv=none; b=YrH+ifRmhSOG5/ekR2c7Qkeo/Y7vQaLk2JuEhIUP/PcY6gwC45iWCi/X6qC2xtYtjDJgn7H3atsG4gifVWuG8iFzfD5kFK0tHawRKtwJC+4BdIYRfD82L57Y3ZsLD0n0/nbfYfh6DjHg4gxIMIVvGVHw/x1YsDB+x24boQ3oSlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524162; c=relaxed/simple;
	bh=JR6t6XPvi/8GXahGzuFgGSxAJtlV0viAxSQUBeeVBKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rke6X+rye409b2AEvQ5p1nfLK+3OVTBL38ZDJMtfPYlFGNY7+yJZjr4mzNNeE1FL1LpUcREkqR3D3cexlSS4NtsA909WU4kPJInKVh66ObGjEV0u4FQBDlZ7KuZwB2gssH0MN+UIaXgjtrIreGZWtUGiQLWPFFzS/td12FaLyYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQJmlOiU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQJmlOiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B276AC4CEF1;
	Mon, 18 Aug 2025 13:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524162;
	bh=JR6t6XPvi/8GXahGzuFgGSxAJtlV0viAxSQUBeeVBKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQJmlOiUSxQpwZwPOSiCgJ3qS11579/2DrbkMYOLFiqqAwXKPoOXhvlN39g1kFEzi
	 hn9/ZKMwoRQXU891XH1GhxJBS/nc/abhWjaHJ0v+Pxm3aPBa2SqLbZcBU3EtqZNDIi
	 MUcnY2K1DssmWUXJVDF3CZIwegg01td4xDmrt2ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 386/515] clk: renesas: rzg2l: Postpone updating priv->clks[]
Date: Mon, 18 Aug 2025 14:46:12 +0200
Message-ID: <20250818124513.275196881@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index b91dfbfb01e3..0dd10c3e2919 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -1388,10 +1388,6 @@ rzg2l_cpg_register_mod_clk(const struct rzg2l_mod_clk *mod,
 		goto fail;
 	}
 
-	clk = clock->hw.clk;
-	dev_dbg(dev, "Module clock %pC at %lu Hz\n", clk, clk_get_rate(clk));
-	priv->clks[id] = clk;
-
 	if (mod->is_coupled) {
 		struct mstp_clock *sibling;
 
@@ -1403,6 +1399,10 @@ rzg2l_cpg_register_mod_clk(const struct rzg2l_mod_clk *mod,
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



