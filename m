Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4866D2FDC34;
	Tue, 12 Aug 2025 18:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024594; cv=none; b=rBlCUIsmkNSkHBvif5EmBaAgyrf6zMpZf1yN5S4EPXkdAvNtfl5Ue4klJuIRhFXgKZo0TfqMr1tI/urvt44uE0iIuFxZu4KfnCwRtv2zNgYk1AGTE+uDE6MBhT2aZMEAPwYb5idjSJBx0SRG6vPHJT8QH11gUoZdnQrTUZzXraY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024594; c=relaxed/simple;
	bh=VOaW97fjrR+phf5AO+NKFHWend1euJemQstccQ+avFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/nKm+n+xBB6cwdOIKkUKtC6cX1HthRY0K9LMS+cHU3taGWr5dUHSnhg6AAwpnoNhxiO4R7GeoQM8QgJaWwYV1vVOb2Mts0AcSLIRi3RQPNZgsRd8AkqCOHrRnnZh/EvO3cUUn+qSvxzDxhKtqUZwuMobT7C8xbywVVvrVq0VAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lXweBLcR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lXweBLcR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC994C4CEF9;
	Tue, 12 Aug 2025 18:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024594;
	bh=VOaW97fjrR+phf5AO+NKFHWend1euJemQstccQ+avFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXweBLcRdD3YUNzvm8Ps77OLnik9m3q2AfYD+GOcuU8barNBphmBBFNwHjh2QLxG5
	 XGhM/Gjozvos5k1lWyACfNYx1G+XhSrHdVA4Iw4D9gmAf12Cfipj9ggpNYoeO1fvRf
	 jIHaWYTH1KdCUdkguahgUVE4eCCYXM93DEgCxGjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Drew Fustini <fustini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 386/627] clk: thead: th1520-ap: Correctly refer the parent of osc_12m
Date: Tue, 12 Aug 2025 19:31:21 +0200
Message-ID: <20250812173433.981166706@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

From: Yao Zi <ziyao@disroot.org>

[ Upstream commit d274c77ffa202b70ad01d579f33b73b4de123375 ]

The "osc_12m" fixed factor clock refers the external oscillator by
setting clk_parent_data.fw_name to osc_24m, which is obviously wrong
since no clock-names property is allowed for compatible
thead,th1520-clk-ap.

Refer the oscillator as parent by index instead.

Fixes: ae81b69fd2b1 ("clk: thead: Add support for T-Head TH1520 AP_SUBSYS clocks")
Signed-off-by: Yao Zi <ziyao@disroot.org>
Reviewed-by: Drew Fustini <fustini@kernel.org>
Signed-off-by: Drew Fustini <fustini@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/thead/clk-th1520-ap.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/thead/clk-th1520-ap.c b/drivers/clk/thead/clk-th1520-ap.c
index ebfb1d59401d..42feb4bb6329 100644
--- a/drivers/clk/thead/clk-th1520-ap.c
+++ b/drivers/clk/thead/clk-th1520-ap.c
@@ -582,7 +582,14 @@ static const struct clk_parent_data peri2sys_apb_pclk_pd[] = {
 	{ .hw = &peri2sys_apb_pclk.common.hw }
 };
 
-static CLK_FIXED_FACTOR_FW_NAME(osc12m_clk, "osc_12m", "osc_24m", 2, 1, 0);
+static struct clk_fixed_factor osc12m_clk = {
+	.div		= 2,
+	.mult		= 1,
+	.hw.init	= CLK_HW_INIT_PARENTS_DATA("osc_12m",
+						   osc_24m_clk,
+						   &clk_fixed_factor_ops,
+						   0),
+};
 
 static const char * const out_parents[] = { "osc_24m", "osc_12m" };
 
-- 
2.39.5



