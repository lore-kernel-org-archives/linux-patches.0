Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEA1237FC7;
	Thu, 12 Dec 2024 16:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021977; cv=none; b=uL5jQRV63Ac7u0HZeD5WCpN6wreaG9XpddorxNq4Cr8rC+glQx60I+QS/2KYTnXzKNNgWpOMhLJkMl8O1uz2eK7blKrSxSOeEVTcfRS0EJDIOyL3HMV4F1kQYU++ejl086xdbF+ogNe1Dvlh+BGHkw6tnm9HhZlnfQAzRXLCsUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021977; c=relaxed/simple;
	bh=C7WKbigQYJR6LtMHei8ktX5heNaQOEswEZ1FNs7RJsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aV0Oa6Xm66GN+lWqj0xfVRa5bxPHQjK4lbW9SdR6PbWYRBWeXk7damE/SUZtXaHgi6cXnY6jfRFhR9TtXXKjtpgxq1oTVZABwlT/4D5RbiOjSIPpb8H9wXKNFI8BQvT8IzutGJa5lRayEE3TEXuH5FhOQklCIaDvI16NSknpUI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=esx52c9n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="esx52c9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348B8C4CED0;
	Thu, 12 Dec 2024 16:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021976;
	bh=C7WKbigQYJR6LtMHei8ktX5heNaQOEswEZ1FNs7RJsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=esx52c9nHpWlHdp7w+82fNgPPHCVJ3e+rQBvEKVWKWR9BVuQ7nHLQTwvjV0XQrR2b
	 swuOe4Ar2y04EAqmrOS066RCDMfM2LPUfCjlcFiGRymAi1j6fV1XbevDHVCWPAWewU
	 u0+CJNJpfjdnr3DwIwk9JBj3OYYsNLW3UP4R3CtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/565] soc: qcom: geni-se: fix array underflow in geni_se_clk_tbl_get()
Date: Thu, 12 Dec 2024 15:55:08 +0100
Message-ID: <20241212144315.949300788@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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
index 7d649d2cf31e0..751992ed6c57f 100644
--- a/drivers/soc/qcom/qcom-geni-se.c
+++ b/drivers/soc/qcom/qcom-geni-se.c
@@ -594,7 +594,8 @@ int geni_se_clk_tbl_get(struct geni_se *se, unsigned long **tbl)
 
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



