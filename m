Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E91721C17A;
	Tue, 12 Nov 2024 10:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408500; cv=none; b=Vms0/Ifm+3Z6MblfDgQYi9zJoLLWbi/X22F5pm/g0YCfAB4rc/87eJnm9wUd9vRCYMupRzrE/4vWUDp73gt5C8XlXJ0k4Xpu4fffpK7p4wei0KXIaxPP8J+ZY6qDdpz6fWDG2MG3tR6e0Y1xaYtvRw2sk4pXWGBanLYDwx5Vy1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408500; c=relaxed/simple;
	bh=UU4qgRgAyUIptpNVzlqao+R4kD3KIcZfvrHplap8vAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1IBhjD7Dpddg/XacayPrVypA0L8pqJbNbTiaUtbdQdN20HQ+Q939ZjT7Mpedfd+twycBgaRF0cP8qyionf+WhHvhsEiFdhOQJldUc/rB4KdoLp15XLN9rhuMvY5dACsIYOZmZNl93XeroGNISir1j9vHQ/xNL8c1VerLFVRrH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tWvHKyu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tWvHKyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1B2C4CECD;
	Tue, 12 Nov 2024 10:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408500;
	bh=UU4qgRgAyUIptpNVzlqao+R4kD3KIcZfvrHplap8vAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2tWvHKyuyaGcFMl1bnbsAJ1Tyz9e1Lzlb9KyjawTaDqo1j5Wi/aSiixBNVmK5yiLE
	 MczW7YEaFJGiifakfNN9OoDn1Eh/tRYn57vt+EfLqkS5JqUiYV8d695VlbamoxN2EG
	 2GFG0tpjnNqjDlCYdjeMxxgxFJnyu6DOAiMwUGW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jagadeesh Kona <quic_jkona@quicinc.com>,
	Taniya Das <quic_tdas@quicinc.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Steev Klimaszewski <steev@kali.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.11 164/184] clk: qcom: videocc-sm8350: use HW_CTRL_TRIGGER for vcodec GDSCs
Date: Tue, 12 Nov 2024 11:22:02 +0100
Message-ID: <20241112101907.163241432@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit f903663a8dcd6e1656e52856afbf706cc14cbe6d upstream.

A recent change in the venus driver results in a stuck clock on the
Lenovo ThinkPad X13s, for example, when streaming video in firefox:

	video_cc_mvs0_clk status stuck at 'off'
	WARNING: CPU: 6 PID: 2885 at drivers/clk/qcom/clk-branch.c:87 clk_branch_wait+0x144/0x15c
	...
	Call trace:
	 clk_branch_wait+0x144/0x15c
	 clk_branch2_enable+0x30/0x40
	 clk_core_enable+0xd8/0x29c
	 clk_enable+0x2c/0x4c
	 vcodec_clks_enable.isra.0+0x94/0xd8 [venus_core]
	 coreid_power_v4+0x464/0x628 [venus_core]
	 vdec_start_streaming+0xc4/0x510 [venus_dec]
	 vb2_start_streaming+0x6c/0x180 [videobuf2_common]
	 vb2_core_streamon+0x120/0x1dc [videobuf2_common]
	 vb2_streamon+0x1c/0x6c [videobuf2_v4l2]
	 v4l2_m2m_ioctl_streamon+0x30/0x80 [v4l2_mem2mem]
	 v4l_streamon+0x24/0x30 [videodev]

using the out-of-tree sm8350/sc8280xp venus support. [1]

Update also the sm8350/sc8280xp GDSC definitions so that the hw control
mode can be changed at runtime as the venus driver now requires.

Fixes: ec9a652e5149 ("venus: pm_helpers: Use dev_pm_genpd_set_hwmode to switch GDSC mode on V6")
Link: https://lore.kernel.org/lkml/20230731-topic-8280_venus-v1-0-8c8bbe1983a5@linaro.org/ # [1]
Cc: Jagadeesh Kona <quic_jkona@quicinc.com>
Cc: Taniya Das <quic_tdas@quicinc.com>
Cc: Abel Vesa <abel.vesa@linaro.org>
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Steev Klimaszewski <steev@kali.org>
Link: https://lore.kernel.org/r/20240901093024.18841-1-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/videocc-sm8350.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/videocc-sm8350.c b/drivers/clk/qcom/videocc-sm8350.c
index 5bd6fe3e1298..874d4da95ff8 100644
--- a/drivers/clk/qcom/videocc-sm8350.c
+++ b/drivers/clk/qcom/videocc-sm8350.c
@@ -452,7 +452,7 @@ static struct gdsc mvs0_gdsc = {
 	.pd = {
 		.name = "mvs0_gdsc",
 	},
-	.flags = HW_CTRL | RETAIN_FF_ENABLE,
+	.flags = HW_CTRL_TRIGGER | RETAIN_FF_ENABLE,
 	.pwrsts = PWRSTS_OFF_ON,
 };
 
@@ -461,7 +461,7 @@ static struct gdsc mvs1_gdsc = {
 	.pd = {
 		.name = "mvs1_gdsc",
 	},
-	.flags = HW_CTRL | RETAIN_FF_ENABLE,
+	.flags = HW_CTRL_TRIGGER | RETAIN_FF_ENABLE,
 	.pwrsts = PWRSTS_OFF_ON,
 };
 
-- 
2.47.0



