Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AE33DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQUtrSNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40C8C433C8;
	Wed, 15 Nov 2023 20:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078661;
	bh=mwikMlXo00sfhF/gNiq/Rf5WrR2vMQOjUIwC2UumrOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQUtrSNOpb+4gUlaEMy8VwWrDn6Ac43WxpxcrHhYhIDu7fsndmuVuE3Nu/d3fPRmd
	 WN8jLvQbteZIEm3IceF1FlnyNN+L+3XmWUOqrS88tW3UlmdpS+s+RbGYQGh2vtFKA+
	 nzESU6Pj+CwpgfJxPyJfNhHzKXhREDq6mMiWX0iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devi Priya <quic_devipriy@quicinc.com>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 08/45] clk: qcom: clk-rcg2: Fix clock rate overflow for high parent frequencies
Date: Wed, 15 Nov 2023 14:32:45 -0500
Message-ID: <20231115191420.167845376@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191419.641552204@linuxfoundation.org>
References: <20231115191419.641552204@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devi Priya <quic_devipriy@quicinc.com>

[ Upstream commit f7b7d30158cff246667273bd2a62fc93ee0725d2 ]

If the parent clock rate is greater than unsigned long max/2 then
integer overflow happens when calculating the clock rate on 32-bit systems.
As RCG2 uses half integer dividers, the clock rate is first being
multiplied by 2 which will overflow the unsigned long max value.
Hence, replace the common pattern of doing 64-bit multiplication
and then a do_div() call with simpler mult_frac call.

Fixes: bcd61c0f535a ("clk: qcom: Add support for root clock generators (RCGs)")
Signed-off-by: Devi Priya <quic_devipriy@quicinc.com>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Link: https://lore.kernel.org/r/20230901073640.4973-1-quic_devipriy@quicinc.com
[bjorn: Also drop unnecessary {} around single statements]
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rcg2.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index 9743af6ae84f9..7c7c140bba4c3 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -139,17 +139,11 @@ static int clk_rcg2_set_parent(struct clk_hw *hw, u8 index)
 static unsigned long
 calc_rate(unsigned long rate, u32 m, u32 n, u32 mode, u32 hid_div)
 {
-	if (hid_div) {
-		rate *= 2;
-		rate /= hid_div + 1;
-	}
+	if (hid_div)
+		rate = mult_frac(rate, 2, hid_div + 1);
 
-	if (mode) {
-		u64 tmp = rate;
-		tmp *= m;
-		do_div(tmp, n);
-		rate = tmp;
-	}
+	if (mode)
+		rate = mult_frac(rate, m, n);
 
 	return rate;
 }
-- 
2.42.0



