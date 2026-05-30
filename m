Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97E62773DE;
	Sat, 30 May 2026 18:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166684; cv=none; b=LLXF9uTPlZoi0N/bjrq2/MsHV2rJ8XdKxnMRUa/LzaZ2JG8t7PwjTZ6j1zZlmPmLynIP+8bQDykrvm7QVS5cj29W3uJMRlovHpAJsyE7jrnAuPoAdKJLc3S4eY3vtcChub8Qhi9YKVuwuhzV+phawW2KVoa3JnrQYQqDzvZDyGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166684; c=relaxed/simple;
	bh=Dz4dX71lT/nSS2nOQ+ymXEujZkMD9Hvgdwb7rHiirHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1oVZgXfyNkkL7GSy5avGrLYIE/xdCs54Yf78xUVnApFvEL+FDYLaRDPl3aAij0uqB2GFCzD1ya9cMgkdNbNeeYNpZyJuql/1XWa0uA0dAVOHZlobbKCjrkq3VnpMKdzI6GzYAlTQLGP+dtXpVeCfAfUvP69LMIlr+2h3M7op8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MaZInvqz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MaZInvqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE64E1F00893;
	Sat, 30 May 2026 18:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166683;
	bh=9dmufkLK/wvnVowsZr2ahjvD9tKp38CEjrAnZT5qkDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MaZInvqzFza96U1uHszFgMSFdypmSgTGcTBo8rUQOsLuHiASW8cHGluJ+scXyjT49
	 UVhaMambciREw3UeOi5FbF3N0bMmZ8gv9srqjSrb23SNgc45AVP7LdoyTKxXjS/Wq7
	 2Sn9VJKl6gtODSltYVSD0st+VtoyTxl4sf5vmx9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Brian Masney <bmasney@redhat.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 405/589] clk: xgene: Fix mapping leak in xgene_pllclk_init()
Date: Sat, 30 May 2026 18:04:46 +0200
Message-ID: <20260530160235.408980171@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit f520a492e07bc6718e26cfb7543ab4cadd8bb0e2 ]

If xgene_register_clk_pll() fails, the mapped register block is never
unmapped.

Fixes: 308964caeebc45eb ("clk: Add APM X-Gene SoC clock driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-xgene.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/clk-xgene.c b/drivers/clk/clk-xgene.c
index 3fd53057c01fe..fca5ce22611ca 100644
--- a/drivers/clk/clk-xgene.c
+++ b/drivers/clk/clk-xgene.c
@@ -187,6 +187,8 @@ static void xgene_pllclk_init(struct device_node *np, enum xgene_pll_type pll_ty
 		of_clk_add_provider(np, of_clk_src_simple_get, clk);
 		clk_register_clkdev(clk, clk_name, NULL);
 		pr_debug("Add %s clock PLL\n", clk_name);
+	} else {
+		iounmap(reg);
 	}
 }
 
-- 
2.53.0



