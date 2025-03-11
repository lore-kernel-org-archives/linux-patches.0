Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E181525F986;
	Tue, 11 Mar 2025 15:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706442; cv=none; b=Nw4FkmQa/kYherOhZTdFgNVoXX0VA4pVBHJaHo6e8kd971NFclFrSGQsZ/ToCYQSIkYBfJL3F00pVQJ5VZV6ZbyEQ9zw/wMvydVFd4IfadIEFSF0xWstDrOhvsjbAUQKhpYaRsd9b7x0IO83y1RFHOZ/k0oVkXVymieRDQuYo/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706442; c=relaxed/simple;
	bh=mHqgdP8iamB5aVs0UFHsocuzpUO0VwBzEO3sr0xsWoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKgUs84GZynFQd8gykBm9A5ANyC1/l3ZBbDVa7d2DAowBbeJnTYfKHSt9DiegJbw+oBKqSaClkSFCoseQqpKJ0B7rox6IyQArcDRsHnAp8fLJecGQCOR0pFHLKCEQT4IAAKxznsDUcbZ0fYj02L9TvcdgWbyZE+syG1eD4OXf1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uMMykdLL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uMMykdLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C42C4CEEA;
	Tue, 11 Mar 2025 15:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706441;
	bh=mHqgdP8iamB5aVs0UFHsocuzpUO0VwBzEO3sr0xsWoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uMMykdLLM7d9xGpxIs3ve3dxyN3DhCCOOF/9XyvhtxUZkdRTrQHcnrIjyJ+EeGsFP
	 a0kJrH9fP8sYMJyVmGaTogE396+FYmWP7JGI/NwOgF5h0TpE+Eu+CgO4kRM62NGJBX
	 cUHNxDSg9rdZeb2cEKyvnErvFxTEwE0ziGwIEM6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo Gan <ganboing@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/462] clk: analogbits: Fix incorrect calculation of vco rate delta
Date: Tue, 11 Mar 2025 15:55:08 +0100
Message-ID: <20250311145800.013336216@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



