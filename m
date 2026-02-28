Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E6733F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301155; cv=none; b=rpeQcDNqvE7X68FYdU1SlW9a8ZccSJFsV6IS6hVYs0JAVbdHTOzm5+vcRrpJT/rUDD0H+93yTkEUdVCJnPDArv+u/Q8hBP/2oXe8tl2nDIsf1loLeGLGJOcTVRPJqq7dQ/t6fgTEEA3vOdNL2DiT0Ocsfo6CgNPMjyMJ6M7/df8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301155; c=relaxed/simple;
	bh=XRTZj9O6e/ypbjfemxfPAAtPh7yD7YZZLwpmdZQF97s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5ffbsbjFm74loB7xsgzof8Eb4BJP+hRoJeTFn+rWTXmPXsUa4iol8tSp53JLPs50bFNw00J2a1Ixk+ZpX8vjKZiQmQXiuG39XaqEbUNtuMEyWX4JxCJ3lzY9VBr4Rhev+uEtWVU21jXWZj47K3dkv6gXhGHjhP7anmaapQLEX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kwZgxDSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kwZgxDSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07481C116D0;
	Sat, 28 Feb 2026 17:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301155;
	bh=XRTZj9O6e/ypbjfemxfPAAtPh7yD7YZZLwpmdZQF97s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kwZgxDSEK+tNjH67dq6KafSnNQ7GICmZdjptWUC14F1uwowtbC6MQahxJLteEnW1G
	 dQBTYtvW9/d826iLlP7dDLGEFjpSh5AsLoOefyrZUiF7/qqh+G/ZiAO6cMwFRR/KeV
	 Ol912/nEogVkvuK+3nmY0dNmzh5cznAieVeSEMLdFndwVKCX0VeBgVxvWfsVAkV719
	 aH9dui6PbBjNOyecwMyNmTZ0e+v2H2thv/xyK2+9qkKziSIxY8DbdEgt8gRq8JX7Yy
	 yNbESiKvjKfLVCLfnRwBTmoErVF88iyqpUjg6sNoLzp/yyxE4npQAiPcL/ak+DeHnO
	 Y9pIT+07U7IuQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Brian Masney <bmasney@redhat.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 319/752] clk: microchip: core: correct return value on *_get_parent()
Date: Sat, 28 Feb 2026 12:40:30 -0500
Message-ID: <20260228174750.1542406-319-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 5df96d141cccb37f0c3112a22fc1112ea48e9246 ]

roclk_get_parent() and sclk_get_parent() has the possibility of
returning -EINVAL, however the framework expects this call to always
succeed since the return value is unsigned.

If there is no parent map defined, then the current value programmed in
the hardware is used. Let's use that same value in the case where
-EINVAL is currently returned.

This index is only used by clk_core_get_parent_by_index(), and it
validates that it doesn't overflow the number of available parents.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202512050233.R9hAWsJN-lkp@intel.com/
Signed-off-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Link: https://lore.kernel.org/r/20251205-clk-microchip-fixes-v3-2-a02190705e47@redhat.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/microchip/clk-core.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/clk/microchip/clk-core.c b/drivers/clk/microchip/clk-core.c
index a0163441dfe5c..82f62731fc0ed 100644
--- a/drivers/clk/microchip/clk-core.c
+++ b/drivers/clk/microchip/clk-core.c
@@ -283,14 +283,13 @@ static u8 roclk_get_parent(struct clk_hw *hw)
 
 	v = (readl(refo->ctrl_reg) >> REFO_SEL_SHIFT) & REFO_SEL_MASK;
 
-	if (!refo->parent_map)
-		return v;
-
-	for (i = 0; i < clk_hw_get_num_parents(hw); i++)
-		if (refo->parent_map[i] == v)
-			return i;
+	if (refo->parent_map) {
+		for (i = 0; i < clk_hw_get_num_parents(hw); i++)
+			if (refo->parent_map[i] == v)
+				return i;
+	}
 
-	return -EINVAL;
+	return v;
 }
 
 static unsigned long roclk_calc_rate(unsigned long parent_rate,
@@ -817,13 +816,13 @@ static u8 sclk_get_parent(struct clk_hw *hw)
 
 	v = (readl(sclk->mux_reg) >> OSC_CUR_SHIFT) & OSC_CUR_MASK;
 
-	if (!sclk->parent_map)
-		return v;
+	if (sclk->parent_map) {
+		for (i = 0; i < clk_hw_get_num_parents(hw); i++)
+			if (sclk->parent_map[i] == v)
+				return i;
+	}
 
-	for (i = 0; i < clk_hw_get_num_parents(hw); i++)
-		if (sclk->parent_map[i] == v)
-			return i;
-	return -EINVAL;
+	return v;
 }
 
 static int sclk_set_parent(struct clk_hw *hw, u8 index)
-- 
2.51.0

