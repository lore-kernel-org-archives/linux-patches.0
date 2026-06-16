Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410984418DF;
	Tue, 16 Jun 2026 15:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625424; cv=none; b=Ao1SoKSzfE6HTtu/mtqrQQHhQuz0fDchLkQBOJiqO5uTRZ5s08rLK3koSmaf54hM8WDBauSYmi7q1u6BvvxNJN6NG006WQdS5q2kRw16mxPqgO1VMhreBZveg7sxc9Mq5K/ElajFO5qzw1EuEZEdz3Mr2lTNXTYgiWMtcOnz97s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625424; c=relaxed/simple;
	bh=3mxjlQ9rEyCUlOnc/yUD3Mi5OUhEuRobBRfz6I0GPPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/8YqKMuFjYV1qmCWDA8ImYw+Kn6PAxkhA87DRU3q2pL3L07E6RaNqMykXwepTIKDeOZ2DqRmx03Pzds/uInTdtzMI5OOGaLqWk6sLEUkTziHp6ANs+Bt6CaN8/oAgGccTEvI2k1H6rHgNpQYcCftWyPx0YOZNbyJ6WHA4GLR9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUnVK7j9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUnVK7j9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39FE21F000E9;
	Tue, 16 Jun 2026 15:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625423;
	bh=mQIWLX2x/fVpileqFX7eR41vf425x5UUezuxSqJ+HZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PUnVK7j9E9mODeC11UyB/3W4W8/u8DVKbCb9MPByCoEg3SgHxnLCEwEg5XvLgU+c6
	 rDcTYuiJc0aF33iTiiPmzCxyBk0YtQFJA7y47f0+ZmOSbVe6GMxH101qQqpkBOIuIH
	 yKHhg/piFmJX56YdvGE8MpSzApq9hoNNwARyw/YU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 139/325] clk: qcom: x1e80100-dispcc: Stop disp_cc_mdss_mdp_clk_src from getting parked
Date: Tue, 16 Jun 2026 20:28:55 +0530
Message-ID: <20260616145104.655867492@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <johannes.goede@oss.qualcomm.com>

[ Upstream commit bc27dbefae6ed11376d991a2921eff806ffef67c ]

Parking disp_cc_mdss_mdp_clk_src at 19.2MHz causing the EFI GOP framebuffer
to stop functioning. The EFI GOP framebuffer should keep working until
the msm display driver loads, to help with boot debugging and to ensure
display output when the msm module is not in the initramfs.

Switch disp_cc_mdss_mdp_clk_src over to clk_rcg2_shared_no_init_park_ops
to keep the EFI GOP working after binding the x1e80100-dispcc driver.

Suggested-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Fixes: 01a0a6cc8cfd ("clk: qcom: Park shared RCGs upon registration")
Link: https://lore.kernel.org/r/20260425123351.6292-1-johannes.goede@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-x1e80100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/dispcc-x1e80100.c b/drivers/clk/qcom/dispcc-x1e80100.c
index 40069eba41f241..5c00a0f8448931 100644
--- a/drivers/clk/qcom/dispcc-x1e80100.c
+++ b/drivers/clk/qcom/dispcc-x1e80100.c
@@ -580,7 +580,7 @@ static struct clk_rcg2 disp_cc_mdss_mdp_clk_src = {
 		.parent_data = disp_cc_parent_data_6,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_6),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_no_init_park_ops,
 	},
 };
 
-- 
2.53.0



