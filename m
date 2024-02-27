Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278551420A2;
	Tue, 27 Feb 2024 14:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042768; cv=none; b=QBfDNNqAvdJFC4mXHESV74dEp9t4ThooU9QaX1YCnzg48IRIKu2hnRFqSnUrO84JDBx83psbNxLQA+EfsLI9kjNw/GwEzLpXe+JfgE/kH7zjARHSDhwlTGGBnZeMiiVflx5fO0Eep47RgeT2x+NEJ91MI71MdY1adnW+AEFBLGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042768; c=relaxed/simple;
	bh=rvmiB5JpJ3WMq3G94FAyLGMU4ElTRIgTHZw/f428/Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lp5NUDeRGAtmG05EUIiok9yAraEeSXxvcB5FqIjiNp5k/HRC5eHK8EOpEQhGnLYmDF4AxZfjuUrTyrdbAKPwmdXmIgIR/2ofa1bf3GQIuzRaqWi8zxDi4K+X2lFpuwheLdAHlljJkCulB3MScOEiGgqpVDhAwvDsutzvHoi0Me0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VrOmD+mP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VrOmD+mP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A27C433F1;
	Tue, 27 Feb 2024 14:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042767;
	bh=rvmiB5JpJ3WMq3G94FAyLGMU4ElTRIgTHZw/f428/Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VrOmD+mPB/18aHQ76OuBid3j9kD/wCI/tYShM7Un4Fd6hEi1gOFkH7KZw0p7xlHZD
	 qdsTwV/fi7fXUrZaCeIcgTUoQOOUVuAIQr7Ei5r15sMsimb0Sar6H70aRYqTZKVlj2
	 g9UMNujc5lT+WRX8WfQ3RWr+VNTmV14Qd86+95ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/245] clk: renesas: cpg-mssr: Fix use after free if cpg_mssr_common_init() failed
Date: Tue, 27 Feb 2024 14:25:01 +0100
Message-ID: <20240227131618.900921322@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

[ Upstream commit fbfd614aeaa2853c2c575299dfe2458db8eff67e ]

If cpg_mssr_common_init() fails after assigning priv to global variable
cpg_mssr_priv, it deallocates priv, but cpg_mssr_priv keeps dangling
pointer that potentially can be used later.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 1f7db7bbf031 ("clk: renesas: cpg-mssr: Add early clock support")
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/1671806417-32623-1-git-send-email-khoroshilov@ispras.ru
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/renesas-cpg-mssr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/renesas/renesas-cpg-mssr.c b/drivers/clk/renesas/renesas-cpg-mssr.c
index 21f762aa21313..ed67b90fc1b0c 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -957,7 +957,6 @@ static int __init cpg_mssr_common_init(struct device *dev,
 		goto out_err;
 	}
 
-	cpg_mssr_priv = priv;
 	priv->num_core_clks = info->num_total_core_clks;
 	priv->num_mod_clks = info->num_hw_mod_clks;
 	priv->last_dt_core_clk = info->last_dt_core_clk;
@@ -987,6 +986,8 @@ static int __init cpg_mssr_common_init(struct device *dev,
 	if (error)
 		goto out_err;
 
+	cpg_mssr_priv = priv;
+
 	return 0;
 
 out_err:
-- 
2.43.0



