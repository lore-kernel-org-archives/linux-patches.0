Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF131EB5FD;
	Sat, 12 Sep 2026 07:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197624; cv=none; b=erKNzWLsWZ1guDNqeeHhqA0ooZGQsyfgU/H2Vfx6MH8oAFnzgZUNROXZkoDrwJ5eUV3CLVlVMsGX4SlS3IZVaLgDZpXt1Cgwo3K67/cuK7bCQtgdCBuvEiC7ZsM9xtoiuyDI1333sI4kz0YUwARtrhpgtrPApaEgyokrM1H7dxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197624; c=relaxed/simple;
	bh=k28Kt6DC1DDPc8LZSxD1VyBr2lP56yfmMyB5xN8E+Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdglhR5FZ7b7tziGYP0sWzl33w3NgYFRDGXrnIcEYHZ229hRN4Zoxqr70atn5+e9OtDgfbMPq8/PwEPnMAjyi9A/OSebuM7KwoPR4hefyD/6Qmh9NZmvHCyAoS5HBkjTW80vNV8xN+zjKcl6NPtv8SpbM6MrIVSUg5GO3NSCPZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qls20N86; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qls20N86"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EEC1F000FF;
	Sat, 12 Sep 2026 07:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197622;
	bh=FNcmeLIAHc9HksuMpMweXdMmjMbRmGzeR38adbjrxPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qls20N86O7j0WMVKWaTAt6dmW93V4QZJFp+jnQZ+zMtmvAwZbTyrK531png7aUN8y
	 sLbwpqOYDsr0hXZlMvb7loB2noC3e3q6YanOne+Oe230e8rSIUEWKg1LlTMcN75i13
	 pkIEEZtvEauXkaZUvkjCuOKn1DR3CkiuILY0Jsls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Alexander Koskovich <akoskovich@pm.me>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0212/1815] clk: qcom: gxclkctl: Use custom disable callback for gx_gdsc
Date: Sat, 12 Sep 2026 08:32:42 +0200
Message-ID: <20260912065653.971696545@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taniya Das <taniya.das@oss.qualcomm.com>

[ Upstream commit badf361c00c802738c776fb5f4e8b08b4d0bad1c ]

The GX GDSC represents a special GPU power domain that must not be
disabled during normal runtime PM flows. As per the GMU architecture,
GX GDSC should only be force-disabled during GMU/GPU recovery, where the
OS explicitly resets the GX power domain.

However, when managed by the generic GDSC runtime PM path, GX GDSC may be
disabled during GMU runtime suspend, resulting in warnings such as:

  gx_clkctl_gx_gdsc status stuck at 'on'

and failures in gdsc_toggle_logic() during rpm suspend.

Use the newly added custom disable callback for gx_gdsc to ensure the
GDSC is toggled only in recovery scenarios, while preventing unintended
disable attempts during normal GMU runtime PM operations.

Reported-by: Pengyu Luo <mitltlatltl@gmail.com>
Closes: https://lore.kernel.org/all/CAH2e8h4Vp9fJYAUUbOmoHSKB25wakPBvmpwa62BTRqgRQbMWuw@mail.gmail.com/
Reported-by: Alexander Koskovich <akoskovich@pm.me>
Closes: https://lore.kernel.org/all/gwVAH2mJerU4dBInw8pKmOs5aQK55Q7W6q_UQAlLFCsEgX6eyvSgXAWbNNMqAX4WmPlYCKUSMhfkr5Jry4Ps5EqnxYZqEEDd3Whwv7ZXGlc=@pm.me/
Fixes: 5af11acae660 ("clk: qcom: Add a driver for SM8750 GPU clocks")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Taniya Das <taniya.das@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260427-gfx-clk-fixes-v2-2-797e54b3d464@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gxclkctl-kaanapali.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gxclkctl-kaanapali.c b/drivers/clk/qcom/gxclkctl-kaanapali.c
index 10c1a8976c56c..a03da61489b4d 100644
--- a/drivers/clk/qcom/gxclkctl-kaanapali.c
+++ b/drivers/clk/qcom/gxclkctl-kaanapali.c
@@ -25,6 +25,7 @@ static struct gdsc gx_clkctl_gx_gdsc = {
 	.pd = {
 		.name = "gx_clkctl_gx_gdsc",
 		.power_on = gdsc_gx_do_nothing_enable,
+		.power_off = gdsc_gx_disable,
 	},
 	.pwrsts = PWRSTS_OFF_ON,
 	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
-- 
2.53.0



