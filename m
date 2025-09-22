Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025FF1547CC;
	Mon, 22 Sep 2025 19:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570435; cv=none; b=aK60En9gZVXV6SPSlOXRd//AgrhOWdYrNPRxvTjHIPF3dwrU7faUXiYPHrPK0P1EapiJYJBfP3SJLmL3BQO4vySQ+oQ9e+gbMXYebbk6q9GUJdbJ84DbOZFQ9NgFCJg+kfHt7ftwhvNavcLc8NjtC5QO31++DqA3VoubcA6qpSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570435; c=relaxed/simple;
	bh=a+EHCMLX2ccCchkTvYZe3GtYnhGYAcUHR44qosIzjPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YM8TJy5H3zVNpOlpeQorWeC2Q/QBZOJ+tSBVMhT9qHEMmXwIItCxjwMFkhNHXydsGrHvMuist/OadpeaveJo9+UgJ4vEb51+4nHurehqPNTWz278WwpRPc91QTcAzRk3evcsOo2STzZKnQmHfcvasjOf5Fu76N4pQoME8ut8nuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C50HOCH9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C50HOCH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917CCC4CEF5;
	Mon, 22 Sep 2025 19:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570434;
	bh=a+EHCMLX2ccCchkTvYZe3GtYnhGYAcUHR44qosIzjPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C50HOCH93hSuVT7fiU4ueSU7kQS1Q33uwfcgw/c9qgaLgUIjQh2ulFoQQmwfYxHT4
	 dUn5Ufp3uUcAWedrn/oh/Z6O1RHPZbPfO1Ycq4AThaII8bZafQ93dLYBY7h961MTUw
	 aRGsSrizb5iUatV0HDj2gUdDFIteCXPaW/m6ZjnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH 6.16 148/149] clk: sunxi-ng: mp: Fix dual-divider clock rate readback
Date: Mon, 22 Sep 2025 21:30:48 +0200
Message-ID: <20250922192416.600829456@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wens@csie.org>

commit 25fbbaf515acd13399589bd5ee6de5f35740cef2 upstream.

When dual-divider clock support was introduced, the P divider offset was
left out of the .recalc_rate readback function. This causes the clock
rate to become bogus or even zero (possibly due to the P divider being
1, leading to a divide-by-zero).

Fix this by incorporating the P divider offset into the calculation.

Fixes: 45717804b75e ("clk: sunxi-ng: mp: introduce dual-divider clock")
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Link: https://patch.msgid.link/20250830170901.1996227-4-wens@kernel.org
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/sunxi-ng/ccu_mp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi-ng/ccu_mp.c b/drivers/clk/sunxi-ng/ccu_mp.c
index 354c981943b6..4221b1888b38 100644
--- a/drivers/clk/sunxi-ng/ccu_mp.c
+++ b/drivers/clk/sunxi-ng/ccu_mp.c
@@ -185,7 +185,7 @@ static unsigned long ccu_mp_recalc_rate(struct clk_hw *hw,
 	p &= (1 << cmp->p.width) - 1;
 
 	if (cmp->common.features & CCU_FEATURE_DUAL_DIV)
-		rate = (parent_rate / p) / m;
+		rate = (parent_rate / (p + cmp->p.offset)) / m;
 	else
 		rate = (parent_rate >> p) / m;
 
-- 
2.51.0



