Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E348151988;
	Wed,  5 Feb 2025 14:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765911; cv=none; b=Mcz5daw3ggMse/lbXjvx7w46baWLoH+T+gepwO9W8LaQbd8qZdxYvshdJVC/X5KCh319XJZH6oYXldhP2IFCAd3EY/kM6OjMd5lcySfB54ZcFyjXy8jr+VnIoJpN88DOfq9CluUqrMvQ82wRelDocEUc6kKT92TDoWBYtHCEYbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765911; c=relaxed/simple;
	bh=6qzP5bvLXef/GMP3jaAdsCkALrznFw7AE/a2W45asQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GopgECyDboL2psAZHDOQk0HBXBL5PsbMWhGIaDEpN3P6g4ME0jor/KqOewoQgALku0qBxeR0ra9JPM2VnWHiPJUQOnZWN2cFIORZ30wfkQPVo4QG2mIXu8IpWxX8Kn2uPdFzcP5QvU7DvxzwIbWv9P+Vwv1rxNguPPTp5bh8Wig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=081rPtr4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="081rPtr4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C98C4CEE2;
	Wed,  5 Feb 2025 14:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765911;
	bh=6qzP5bvLXef/GMP3jaAdsCkALrznFw7AE/a2W45asQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=081rPtr4K5doajLNbRy+zDEFf18ObWhwXx+iwqpuvDmL5dMx07MIqCGG9LfrRtpN4
	 DfAiyXfjWPtTaarOtkxVt++KCDINDrwzI9y9pO+Nk/+/wPzePKLbRl1o/cPe1yPOse
	 /paSQzrtpY3lBDdDYuq83PCvO0qMFotwcW41LNDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo Gan <ganboing@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 225/623] clk: analogbits: Fix incorrect calculation of vco rate delta
Date: Wed,  5 Feb 2025 14:39:27 +0100
Message-ID: <20250205134504.833180212@linuxfoundation.org>
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

From: Bo Gan <ganboing@gmail.com>

[ Upstream commit d7f12857f095ef38523399d47e68787b357232f6 ]

In wrpll_configure_for_rate() we try to determine the best PLL
configuration for a target rate. However, in the loop where we try
values of R, we should compare the derived `vco` with `target_vco_rate`.
However, we were in fact comparing it with `target_rate`, which is
actually after Q shift. This is incorrect, and sometimes can result in
suboptimal clock rates. Fix it.

Fixes: 7b9487a9a5c4 ("clk: analogbits: add Wide-Range PLL library")
Signed-off-by: Bo Gan <ganboing@gmail.com>
Link: https://lore.kernel.org/r/20240830061639.2316-1-ganboing@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/analogbits/wrpll-cln28hpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/analogbits/wrpll-cln28hpc.c b/drivers/clk/analogbits/wrpll-cln28hpc.c
index 65d422a588e1f..9d178afc73bdd 100644
--- a/drivers/clk/analogbits/wrpll-cln28hpc.c
+++ b/drivers/clk/analogbits/wrpll-cln28hpc.c
@@ -292,7 +292,7 @@ int wrpll_configure_for_rate(struct wrpll_cfg *c, u32 target_rate,
 			vco = vco_pre * f;
 		}
 
-		delta = abs(target_rate - vco);
+		delta = abs(target_vco_rate - vco);
 		if (delta < best_delta) {
 			best_delta = delta;
 			best_r = r;
-- 
2.39.5



