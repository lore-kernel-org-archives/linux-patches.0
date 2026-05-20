Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288733FBECB;
	Wed, 20 May 2026 18:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302497; cv=none; b=hhadhZbf003kPqc/tEcqWItqnICf/7Xu2V7Bsq9B7YtWScR4moT6tLBBzYVEG7JDO3LmLZqTruGzbumwg1YUJ3wLtinRG9R9SMOH04O8YM6nFmp1D76nzOoq0q+rPRMzVODN4n3C3claVN4+AwyOz81mCPFsC/Kd0rGGNgYpcgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302497; c=relaxed/simple;
	bh=GUTNi6JF9sJ39VvHIUc1qX6TmPqw/3JLeeYcLUc1SAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLntSy+Or6hIJY342lIpY5Apz4XFAIhr7N3IE9WBen6U+M0fnSme6X6jeGYdU7+GV/sYsXN6Vs0ZN7Z82LAZPhGjiwrDwqfRDt4aLite+i9oQV0f9uMh8KIiUu4lgwG4eGPyLKCwZWpLDDcP3Uz092b4/EGmcTZGFKDDjfxMeU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WuX6iT93; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WuX6iT93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE7C1F000E9;
	Wed, 20 May 2026 18:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302496;
	bh=IS7wkfqvlFe1Ga5A+PfG2IHlF/+hSCeXS+cFeEid9xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WuX6iT93PdeMkU1Eo1ysRQxAE4EQwEm4C9ijkB2CppBgVBQsHKKnWZFqGT2nC5dv4
	 PLyBCKAEDST75CXm/esP77Zy+Up+15y7BzWRmC/41jeIKU6DLQDAQBudDG+Azyrds9
	 5IHR5SQzhFhvOzdqzIjEydEwm2KtR47pATMIIHEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Brian Masney <bmasney@redhat.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 288/508] clk: xgene: Fix mapping leak in xgene_pllclk_init()
Date: Wed, 20 May 2026 18:21:51 +0200
Message-ID: <20260520162104.883224315@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0c3d0cee98c83..a542b78d9c731 100644
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



