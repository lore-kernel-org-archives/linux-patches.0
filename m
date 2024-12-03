Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8872646;
	Tue,  3 Dec 2024 15:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238989; cv=none; b=JI2WApE8/cBGffwdaql2iLql0qATaM1Por/HJAdMlLO4PlHgSTjgXqgsR7+msGYw6zkS253f1ILmF/I63djaXCnhnSdBE2+F/2P1X4nuGs4vCWbHagPMB9nbSFd/h5nSk+4GYKEf8j7smYU9+s5R0Oi4qc0whB/wM67tQ/aUFkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238989; c=relaxed/simple;
	bh=o2o21CRA9CW5olGw9Tx//Vbiy1AGJ507NHZZICEJ7Ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ip9s/mkHXAk1MdYCeBHKLEjgwS83o2Y4ZMP1BzGR3R9YqKiPyQlZGGPCL8IeesPZ1XvWcSOcX+FVavhYJWRu3EzPqjkoqiOyhG27FxvS81+D0Hjmn9jfmGxDPZ3xKrZR9YoWaQyuHD2ip1efYZcwhg7hxu4Th3Rh+jokd/bogpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6jE4zsc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6jE4zsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BCAC4CECF;
	Tue,  3 Dec 2024 15:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238989;
	bh=o2o21CRA9CW5olGw9Tx//Vbiy1AGJ507NHZZICEJ7Ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p6jE4zscknhYr4nFVxdscrD6V4siPLSn6fS91ZH/syLqwaJXt0tCltoRtgxT0fFkR
	 +5/m2JWfaknlJJl44ne0ulVYi6mBoIR+qQzxeU4cqpyT/W/Zh9XiDEeaUOS3yiwAm7
	 XfJJpMZob3tCXBuotQp+BCpdvBIDUzt7GQesMcaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 466/817] clk: ralink: mtmips: fix clock plan for Ralink SoC RT3883
Date: Tue,  3 Dec 2024 15:40:38 +0100
Message-ID: <20241203144014.063817967@linuxfoundation.org>
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

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

[ Upstream commit 33239152305567b3e9bf052f71fd4baecd626341 ]

Clock plan for Ralink SoC RT3883 needs an extra 'periph' clock to properly
set some peripherals that has this clock as their parent. When this driver
was mainlined we could not find any active users of this SoC so we cannot
perform any real tests for it. Now, one user of a Belkin f9k1109 version 1
device which uses this SoC appear and reported some issues in openWRT:
- https://github.com/openwrt/openwrt/issues/16054
The peripherals that are wrong are 'uart', 'i2c', 'i2s' and 'uartlite' which
has a not defined 'periph' clock as parent. Hence, introduce it to have a
properly working clock plan for this SoC.

Fixes: 6f3b15586eef ("clk: ralink: add clock and reset driver for MTMIPS SoCs")
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://lore.kernel.org/r/20240910044024.120009-2-sergio.paracuellos@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ralink/clk-mtmips.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/ralink/clk-mtmips.c b/drivers/clk/ralink/clk-mtmips.c
index 50a443bf79ecd..62f9801ecd3a4 100644
--- a/drivers/clk/ralink/clk-mtmips.c
+++ b/drivers/clk/ralink/clk-mtmips.c
@@ -267,6 +267,11 @@ static struct mtmips_clk_fixed rt305x_fixed_clocks[] = {
 	CLK_FIXED("xtal", NULL, 40000000)
 };
 
+static struct mtmips_clk_fixed rt3883_fixed_clocks[] = {
+	CLK_FIXED("xtal", NULL, 40000000),
+	CLK_FIXED("periph", "xtal", 40000000)
+};
+
 static struct mtmips_clk_fixed rt3352_fixed_clocks[] = {
 	CLK_FIXED("periph", "xtal", 40000000)
 };
@@ -779,8 +784,8 @@ static const struct mtmips_clk_data rt3352_clk_data = {
 static const struct mtmips_clk_data rt3883_clk_data = {
 	.clk_base = rt3883_clks_base,
 	.num_clk_base = ARRAY_SIZE(rt3883_clks_base),
-	.clk_fixed = rt305x_fixed_clocks,
-	.num_clk_fixed = ARRAY_SIZE(rt305x_fixed_clocks),
+	.clk_fixed = rt3883_fixed_clocks,
+	.num_clk_fixed = ARRAY_SIZE(rt3883_fixed_clocks),
 	.clk_factor = NULL,
 	.num_clk_factor = 0,
 	.clk_periph = rt5350_pherip_clks,
-- 
2.43.0



