Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DF633FE;
	Tue,  3 Dec 2024 15:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238067; cv=none; b=KofNsUlsLIG36XcEXlN139PJx+m3tzVefNQIScTfFVOEk8Bf2RI+9fYRLnP4XaQB6xTqpfYM4NPF2xr+OOyGhmoSAQDpetAWNH/uVw+bQCRrokD3mH3ocDRXUC1iwNO1HVpkGrKWy8zuH1aqviYS2Lq8/Kv7QW/htG0sSE+ZJd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238067; c=relaxed/simple;
	bh=owJY75CRqf06rHN05ueIbosMqrZuFBNRxJAaznAqx/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uH20CmejYCUkR4DWT1yVA6HphmoLDbBajzrstXYk3DJiq36/F2XzLxl5O/2SkpoMRqShMoojDZGtwNbVLxB5NXz1dXvhcS3fhoecbGkveitMKfeg56zPkQcvHc3iS7/m10J6nG61tw4VoEPyPAinRnTunTJc/9lpHg8gtw9cS6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mDzE9sqJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mDzE9sqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8986C4CECF;
	Tue,  3 Dec 2024 15:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238067;
	bh=owJY75CRqf06rHN05ueIbosMqrZuFBNRxJAaznAqx/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mDzE9sqJnQ+VqutGmqKfmsMAwnmNwBS49hceg6RuOgMw3J0u3aCgG7RQd6QENdWPU
	 duCwIHGBC0mt8DufW0SkGf+KL0SYbk4QQjELJABh8vijU3QIYb7DWfIWTSAUzYUvoO
	 odPVBoDnOoq8bboscMrRal9AVMuv9uFmynlGCQI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 151/817] soc: qcom: geni-se: fix array underflow in geni_se_clk_tbl_get()
Date: Tue,  3 Dec 2024 15:35:23 +0100
Message-ID: <20241203144001.620275524@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 2e8f24d5da80b..4cb959106efa9 100644
--- a/drivers/soc/qcom/qcom-geni-se.c
+++ b/drivers/soc/qcom/qcom-geni-se.c
@@ -585,7 +585,8 @@ int geni_se_clk_tbl_get(struct geni_se *se, unsigned long **tbl)
 
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



