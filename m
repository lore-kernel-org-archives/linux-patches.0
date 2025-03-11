Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5ED25DD0F;
	Tue, 11 Mar 2025 15:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705420; cv=none; b=TBk4GKofGM0nWjpGXdpRa4DIHLg8iANvsaK2JJS+n82RbK5aGWnRPdNWYyVMRqzBSUA+qdUggTtFyVw5ceVSUD5E1XArp+bUefS6DFH9UNukrLMV1MQgDBeG2V8DyRtF7vhgQ6EGEvi4FjliL8lJejtjG0ljDegkG6N1oi9gd/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705420; c=relaxed/simple;
	bh=Xof3FgNAl+tkuzAsNgvord3SVgHY06+OfMAsVTFVVH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IaVnh3fk7Fo9cL30CAAgDuxF2aTEsi3bjrLh71g2oWZHEVeWNEinBUbCNfJhgE8hR3MP/t0kdXfD6ho0LRvmhRpOdttssDo7iakqkzyjNh6RO54ccxrq+x7C7eE+1fvHheP3gdkELLawjUETRTdF4o/8+hhIh1S1jz8/LN+H10U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJw5K4dG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJw5K4dG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E90C4CEE9;
	Tue, 11 Mar 2025 15:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705419;
	bh=Xof3FgNAl+tkuzAsNgvord3SVgHY06+OfMAsVTFVVH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJw5K4dG7FGI4wQnM6B590rCqy7i3ttGa5CFEv05HFAtr3rLcfQM2N+4sUMlay9e4
	 zHmEpWS7kNXxf687lt/oKCXnO7xWai9ODGnt9YXxc1uUFVKhmNVCybmdxVF7DZ8364
	 kvGR8/xFng5kSO+BdF6WqhQqu2Ajh8CJaneW/vnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo Gan <ganboing@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 029/328] clk: analogbits: Fix incorrect calculation of vco rate delta
Date: Tue, 11 Mar 2025 15:56:39 +0100
Message-ID: <20250311145716.052261940@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 776ead319ae9c..9df572579afb4 100644
--- a/drivers/clk/analogbits/wrpll-cln28hpc.c
+++ b/drivers/clk/analogbits/wrpll-cln28hpc.c
@@ -287,7 +287,7 @@ int wrpll_configure_for_rate(struct wrpll_cfg *c, u32 target_rate,
 			vco = vco_pre * f;
 		}
 
-		delta = abs(target_rate - vco);
+		delta = abs(target_vco_rate - vco);
 		if (delta < best_delta) {
 			best_delta = delta;
 			best_r = r;
-- 
2.39.5



