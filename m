Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8BB222D70;
	Thu, 12 Dec 2024 17:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025166; cv=none; b=rlLWhX1hd/S+g7snT9Dpw2R6xgNepZlffHHyAlB7wIfWbZD9iBPzQJE33J44/o3gQvnT8yZfntEk5t2SNrD5yTmtpylctfB7l1QPDhvT9/bh73mpJeBoW3FinZqNUPP2idHHg6F6D4I9ZEEOVvokP9a5/RZAQE7N25f8n65JseY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025166; c=relaxed/simple;
	bh=3OWXeudM+IKSYK21ANPsmCWvTW+AaK25eM3JoZywYXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5iUEDvwXkVr5SksunAyJpUGbGGf65qkK3aZw4h0zn+b1J81xOXGHyqLZgmVcws5Nyo8F54ltModN1DdIDLSYmL/TBODLDxJwHriXoR7ftcmEF3pd+sxexZSnIVT+03Qzs+LpFn8vZ8iVpHVaJ1bCsHgalM8bMoM0H7GmZWzgPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwqIfB8u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwqIfB8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD9AC4CECE;
	Thu, 12 Dec 2024 17:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025166;
	bh=3OWXeudM+IKSYK21ANPsmCWvTW+AaK25eM3JoZywYXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GwqIfB8uvkfOMBzdUT2Ro6vUDsFnX4/COf/RQOg1v5awKSw8SDKwUZKpq10i8YzNh
	 YVvGAdT+m++bTrstln6lYZe6bB4rpPA67eutdptc+XQLLeqhwGF3bHVSXeL3psxY/v
	 wHXvR3M42mexWKF6G4Bvst2qbxkkRDfaW08NlQGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 048/321] soc: qcom: geni-se: fix array underflow in geni_se_clk_tbl_get()
Date: Thu, 12 Dec 2024 15:59:26 +0100
Message-ID: <20241212144231.893445315@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 78261cb08f06c93d362cab5c5034bf5899bc7552 ]

This loop is supposed to break if the frequency returned from
clk_round_rate() is the same as on the previous iteration.  However,
that check doesn't make sense on the first iteration through the loop.
It leads to reading before the start of these->clk_perf_tbl[] array.

Fixes: eddac5af0654 ("soc: qcom: Add GENI based QUP Wrapper driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/8cd12678-f44a-4b16-a579-c8f11175ee8c@stanley.mountain
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/qcom-geni-se.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/qcom-geni-se.c b/drivers/soc/qcom/qcom-geni-se.c
index 2e66098e82975..d6115e3ce65fa 100644
--- a/drivers/soc/qcom/qcom-geni-se.c
+++ b/drivers/soc/qcom/qcom-geni-se.c
@@ -550,7 +550,8 @@ int geni_se_clk_tbl_get(struct geni_se *se, unsigned long **tbl)
 
 	for (i = 0; i < MAX_CLK_PERF_LEVEL; i++) {
 		freq = clk_round_rate(se->clk, freq + 1);
-		if (freq <= 0 || freq == se->clk_perf_tbl[i - 1])
+		if (freq <= 0 ||
+		    (i > 0 && freq == se->clk_perf_tbl[i - 1]))
 			break;
 		se->clk_perf_tbl[i] = freq;
 	}
-- 
2.43.0



