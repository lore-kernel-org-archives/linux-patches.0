Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A34615198D;
	Wed,  5 Feb 2025 14:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764037; cv=none; b=awLDocYBR46Yxo5ueXtZa+kPX22gpemqPmgWesVfn+YAjCorBxeSPZa2seHj3bFPKNrqQUYbusdQ9/v8ZWVcXAtvFvUYzS+tv7MLsdzlKpmiUnbgyf6dd7Xz42L2XEngc04b1NvVDstGv17OYpSWt+zlWPxPaOi8LpGjl4ab+kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764037; c=relaxed/simple;
	bh=RndF5E1XV1yqMjh5IT2m1CpxexcdQpQ2AElaJ+Z4N2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kooaraq0dtrrrHsVBMD3PCy/JNzjEUS69jSBL6X10P55DCII4kkmHu69syz72vzKLrpat9XA9mM/aiqFV3oFFUVqAezO179P2JpuzlQHn2xh3BujblUexT6cTHzKBv/77wZ137pvC2v8S8ScQJb8Olsxxh3R1dIGXAvxZHI9CkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pmTfjXYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pmTfjXYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B073C4CED1;
	Wed,  5 Feb 2025 14:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764037;
	bh=RndF5E1XV1yqMjh5IT2m1CpxexcdQpQ2AElaJ+Z4N2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pmTfjXYk1c3qBFP75r7zxOXZS1hFycxzR8ASyvXfC3bIdhbMWi17zv+/jxNAiemea
	 Z5ZM2ZYBoFuo0GT+jnxNRcJfLlibCiJ5hUw9kxIOuCV53zzu3qbdYgIyHI5lFp59jh
	 tpZoQjAg3nUEcjwe9yRAYj2ckTtEE/OQngFFB6l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/590] clk: renesas: cpg-mssr: Fix soc node handling in cpg_mssr_reserved_init()
Date: Wed,  5 Feb 2025 14:37:18 +0100
Message-ID: <20250205134458.428914075@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit a6ca7e6240f0651412da6a17d0e7a8f66d3455a6 ]

A device_node reference obtained via of_find_node_by_path() requires
explicit calls to of_node_put() after it is no longer required to avoid
leaking the resource.

Instead of adding the missing calls to of_node_put() in all execution
paths, use the cleanup attribute for 'soc' by means of the __free()
macro, which automatically calls of_node_put() when the variable goes
out of scope.

Fixes: 6aa175476490 ("clk: renesas: cpg-mssr: Ignore all clocks assigned to non-Linux system")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20241031-clk-renesas-cpg-mssr-cleanup-v2-1-0010936d1154@gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/renesas-cpg-mssr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/renesas/renesas-cpg-mssr.c b/drivers/clk/renesas/renesas-cpg-mssr.c
index 1b421b8097965..0f27c33192e10 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -981,7 +981,7 @@ static void __init cpg_mssr_reserved_exit(struct cpg_mssr_priv *priv)
 static int __init cpg_mssr_reserved_init(struct cpg_mssr_priv *priv,
 					 const struct cpg_mssr_info *info)
 {
-	struct device_node *soc = of_find_node_by_path("/soc");
+	struct device_node *soc __free(device_node) = of_find_node_by_path("/soc");
 	struct device_node *node;
 	uint32_t args[MAX_PHANDLE_ARGS];
 	unsigned int *ids = NULL;
-- 
2.39.5



