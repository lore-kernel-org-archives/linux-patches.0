Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1C515198D;
	Wed,  5 Feb 2025 14:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764070; cv=none; b=URKFF5l08/t48PcdN/Ln4RBbiTOxvDKY9gbBk3dxGDOuHPxk+Cr4ZBYZ+cpOFBtydex+GOYgcyMMkjAOPUMfU70cE9w8G2e3giomMQ/Y/J4BIV/c6nJOAw6357xMQsK4x/tCvAPQAOtcBW+RsYjANyCwHnzAW6dFFaiEpDGWGCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764070; c=relaxed/simple;
	bh=kO0j02FKJkEq2uZ8ziqK4b1S1lFtOrK/LwUeFWpfSE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ByH2mEVaLdJyZoy5CmMOSX+VWnDjy1v5dkGFM2+LUkMyHs4eNsfe9B9WXwcG3tuGZO36VgDVP0oL6UtaPczvVH1kTSxEn8CPkOBDi+obhxJ83SWWRBU1m2vGVn7GsT6gphTkJ77CcMTRfVP8VkLZMM31hmYE/0/yXU7fem9LrPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tuCzpWk4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tuCzpWk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F56EC4CED1;
	Wed,  5 Feb 2025 14:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764070;
	bh=kO0j02FKJkEq2uZ8ziqK4b1S1lFtOrK/LwUeFWpfSE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tuCzpWk40yLMn44in2pDiK2FF6fps2R1e4ZxC05fPLt2BNgeU6iS8F8Xz7eYXsIez
	 q1KAlGqpQjqLrWXTjoj6hNJBL0b9/rjxN5GVYcXxQoPig34HZ1Lh1X/1HLnqYk/o46
	 SU3Il/d3WLL8gwGOom18M6lk5e9FUVEiDwhC5ifk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo Gan <ganboing@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 137/393] clk: analogbits: Fix incorrect calculation of vco rate delta
Date: Wed,  5 Feb 2025 14:40:56 +0100
Message-ID: <20250205134425.542286131@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 09ca823563993..d8ae392959969 100644
--- a/drivers/clk/analogbits/wrpll-cln28hpc.c
+++ b/drivers/clk/analogbits/wrpll-cln28hpc.c
@@ -291,7 +291,7 @@ int wrpll_configure_for_rate(struct wrpll_cfg *c, u32 target_rate,
 			vco = vco_pre * f;
 		}
 
-		delta = abs(target_rate - vco);
+		delta = abs(target_vco_rate - vco);
 		if (delta < best_delta) {
 			best_delta = delta;
 			best_r = r;
-- 
2.39.5



