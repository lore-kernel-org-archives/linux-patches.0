Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB8420E023;
	Tue, 12 Aug 2025 19:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026249; cv=none; b=sO9gFklogqnBZ0EWmFEhlpz8iv2bklbCY8y8nsggYRSEuKM40SZFDb9CV5iIKTPeT/y5GI/yW6bB8hUWDUYBUKuCZDTqMdP1+eimzzPJ8WBaXojYocaBfe9c7VBKKyXGBk9FnUn9XXppc8nJm4IVJY+ax7ualLcv4niS86plg2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026249; c=relaxed/simple;
	bh=M1X5pjENQRygM1GTAguCJuBzHKo09Nis+lKOdD5083Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fgpa54txPZdfqIYlRc2c/EaggDqZscFBdlCcrBEFqLSTYMa/6sAmjyqw+Ethb8PHbzW3zFu9JWvapZqxP/7g1gy5HLc38qoMR+XGEUZIGwaxRjIfDD5FnM1cpAGYO0qoHJf6J+tR/iYzM330zBWw4F9ltbrF/osxYEHpN5v11gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1v137e9R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1v137e9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D997C4CEF0;
	Tue, 12 Aug 2025 19:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026248;
	bh=M1X5pjENQRygM1GTAguCJuBzHKo09Nis+lKOdD5083Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1v137e9RZoNiNmfdwWIMmKN7h2a+KU9d9F5UTBcP435dfhvprT55uqAnyL2A79xN/
	 8Shpc4Sv2HwUzQsiFzhSJ23aiqlpCDJo+QoeXfJGS+dCofz6xNv8NVG1Kfp1hYfvaw
	 xy4m0bf/al/wluFoH1ly6bRF9WNWcbnbCM5Ce4wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Drew Fustini <fustini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 281/480] clk: thead: th1520-ap: Correctly refer the parent of osc_12m
Date: Tue, 12 Aug 2025 19:48:09 +0200
Message-ID: <20250812174409.022734895@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4c9555fc6184..6ab89245af12 100644
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



