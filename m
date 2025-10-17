Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3DF219A7A;
	Fri, 17 Oct 2025 15:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714914; cv=none; b=iAAn50jDK4FbKdCAbZpY7FHqe7SDnrPQoAV/I6knKGiXWH4Wmhr4X87LZQzw0qkhVKveKiSkAxanBOJ0hcDdGd8rghLru6XJ6r9f1kNOnV4wC8VuxkXoAwDOjsMYzpaW39fqk3t5A8JkxpgXJG1ZFC9GG5JF3VT7cpVbAPzFbr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714914; c=relaxed/simple;
	bh=rQh/7a7fAzpzYn0z8TS2ZiDA28KIJuCf2cfn1ce6e4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+9RrpMLu+Nfp1/S7l++UVUyuVflFLSKmqpIqaGEkyzmCUhnXVeSG64agTCnEniohBPg/0aQkbmnjkRiqv0fSw6PXzLLS9u2hL8FJvonEWhD4wEr2+3scK7I+gVEWylRfe6d5JEgRGi7b8CI15kI/7UcFVWywzVlkGJyGn4VGAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8dICTMY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8dICTMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F3DC4CEE7;
	Fri, 17 Oct 2025 15:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714914;
	bh=rQh/7a7fAzpzYn0z8TS2ZiDA28KIJuCf2cfn1ce6e4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8dICTMYX13KAWH8I4XFaf3Fc49XnZunlEaawnHVD1TWki0Sy6vCEb4B9yRZE0lL8
	 s15gjMRM02329qpYrLOTxRdQf8tJWveZaMUTA/8XeKa24PUtjEYjuNCnc+MsHEHIRu
	 ku5A3rS/9FsotEzgoNkl6Nx5YLoHtsrlnPs+3Usw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan CHen <chenyuan@kylinos.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 033/371] clk: renesas: cpg-mssr: Fix memory leak in cpg_mssr_reserved_init()
Date: Fri, 17 Oct 2025 16:50:08 +0200
Message-ID: <20251017145202.998357623@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

From: Yuan CHen <chenyuan@kylinos.cn>

[ Upstream commit cc55fc58fc1b7f405003fd2ecf79e74653461f0b ]

In case of krealloc_array() failure, the current error handling just
returns from the function without freeing the original array.
Fix this memory leak by freeing the original array.

Fixes: 6aa1754764901668 ("clk: renesas: cpg-mssr: Ignore all clocks assigned to non-Linux system")
Signed-off-by: Yuan CHen <chenyuan@kylinos.cn>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20250908012810.4767-1-chenyuan_fl@163.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/renesas-cpg-mssr.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/renesas/renesas-cpg-mssr.c b/drivers/clk/renesas/renesas-cpg-mssr.c
index 5ff6ee1f7d4b7..de1cf7ba45b78 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -1082,6 +1082,7 @@ static int __init cpg_mssr_reserved_init(struct cpg_mssr_priv *priv,
 
 		of_for_each_phandle(&it, rc, node, "clocks", "#clock-cells", -1) {
 			int idx;
+			unsigned int *new_ids;
 
 			if (it.node != priv->np)
 				continue;
@@ -1092,11 +1093,13 @@ static int __init cpg_mssr_reserved_init(struct cpg_mssr_priv *priv,
 			if (args[0] != CPG_MOD)
 				continue;
 
-			ids = krealloc_array(ids, (num + 1), sizeof(*ids), GFP_KERNEL);
-			if (!ids) {
+			new_ids = krealloc_array(ids, (num + 1), sizeof(*ids), GFP_KERNEL);
+			if (!new_ids) {
 				of_node_put(it.node);
+				kfree(ids);
 				return -ENOMEM;
 			}
+			ids = new_ids;
 
 			if (priv->reg_layout == CLK_REG_LAYOUT_RZ_A)
 				idx = MOD_CLK_PACK_10(args[1]);	/* for DEF_MOD_STB() */
-- 
2.51.0



