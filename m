Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC817155725;
	Wed,  5 Feb 2025 14:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765380; cv=none; b=umpFWB04r2d60IUmx2K1c8IpjntL/cfolDwV6mXGG/JzydEFDB0mWoCJrA+cXzTW7776NxrDP6Cmv7nUPYpRZXj5OzefeDfr4e2gKOxsLQzBnG5ro1w3BIE1c5zBparKQk9XFEfWC47J+dF0vqk2B2kDPQxtaqj/79+gq+QSS4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765380; c=relaxed/simple;
	bh=PKr0qlaBTkeWSfvikZFSJTd2oW+B39A0ML0yHOgfN10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtmlAn9HXTGBF8IjH7U49847mKNDptcoRJtqen1Sb1i5qTLmvKXSgKT9puOvL7SU3sCfVhxlU48ww/COduaA7dmF+YNUPmRiDvfuqb1wBo6fGrY2kBs8bW9V7rLfaw5FPM/njlRx4UH0J1OJ6bKo4bW8Eb/qllPT9wZd1VoA15E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKO1fNG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKO1fNG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1998AC4CED1;
	Wed,  5 Feb 2025 14:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765380;
	bh=PKr0qlaBTkeWSfvikZFSJTd2oW+B39A0ML0yHOgfN10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wKO1fNG2O5bjSz84c1+aCBJ22iY6ilKPPhy26Jn5OMa9WDHXKLorYQiRZJhLH07od
	 wEZd8xJdn6Ruw4zmD0x77jkBwPvGPuVbVHazVPCANydHTkS32/WEkDqUtcvH+IWtZ0
	 ROVIZvtYkAA32bjCchMFEGmoaAdf1wIHVLPW1Jec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Drew Fustini <dfustini@tenstorrent.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 173/623] clk: thead: Fix clk gate registration to pass flags
Date: Wed,  5 Feb 2025 14:38:35 +0100
Message-ID: <20250205134502.854035588@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Drew Fustini <dfustini@tenstorrent.com>

[ Upstream commit a826e53fd78c7f07b8ff83446c44b227b2181920 ]

Modify the call to devm_clk_hw_register_gate_parent_data() to actually
pass the clk flags from hw.init instead of just 0. This is necessary to
allow individual clk gates to specify their own clk flags.

Fixes: ae81b69fd2b1 ("clk: thead: Add support for T-Head TH1520 AP_SUBSYS clocks")
Signed-off-by: Drew Fustini <dfustini@tenstorrent.com>
Link: https://lore.kernel.org/r/20250113-th1520-clk_ignore_unused-v1-1-0b08fb813438@tenstorrent.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/thead/clk-th1520-ap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/thead/clk-th1520-ap.c b/drivers/clk/thead/clk-th1520-ap.c
index 1015fab952515..c95b6e26ca531 100644
--- a/drivers/clk/thead/clk-th1520-ap.c
+++ b/drivers/clk/thead/clk-th1520-ap.c
@@ -1048,7 +1048,8 @@ static int th1520_clk_probe(struct platform_device *pdev)
 		hw = devm_clk_hw_register_gate_parent_data(dev,
 							   cg->common.hw.init->name,
 							   cg->common.hw.init->parent_data,
-							   0, base + cg->common.cfg0,
+							   cg->common.hw.init->flags,
+							   base + cg->common.cfg0,
 							   ffs(cg->enable) - 1, 0, NULL);
 		if (IS_ERR(hw))
 			return PTR_ERR(hw);
-- 
2.39.5



