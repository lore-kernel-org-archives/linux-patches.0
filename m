Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE31EEC9;
	Tue, 10 Sep 2024 09:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962223; cv=none; b=NkzX5eaEMVvu2cM4iDq+87tVilFasJpGpb/nycF8QOsPwcvlj9oBB4NsLXtbw8qKElqho4n7PPqtNVdSDXShYV6tB//yaGJgKMK9C132gQBOrlAjJyQ7zJ27SZsFEr73EFEW9VdP5YIFnmaJqZ54kZalhGYwma5gB3beNE0HGuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962223; c=relaxed/simple;
	bh=nTHfO+Zk6Of+NGJHwDtkPlYhO06Vot0y0g8+7r3M1Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWcww/McGqlglqvJxTCokQ4jaUEb2H4gcdha6IB9VPZOpyozmR6LnOfEQdxHL3m7juF6r0sF7jy+FQcj6Mm5IZqGBrumnMgiiqQP2M6XjZMKsbEyJ/f3A+jS6uHpyL7tR9BsL+ZhpOLjlX9sGyQQKzsT9hejUJzH0cJmRYOltos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JM27ekyd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JM27ekyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FCBC4CEC3;
	Tue, 10 Sep 2024 09:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962222;
	bh=nTHfO+Zk6Of+NGJHwDtkPlYhO06Vot0y0g8+7r3M1Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JM27ekydcX4qMiN7pNuaf4sqHCRaG5mNvPwCcrYJYOYCdvly3YGgON1fxVU45DqyF
	 rL4ZbuqEsvAqqAQ/L+VpUwU3nwzz7l/9XoDG0+//UmAWStshZvk72tlIuW47DBTqY7
	 d6KDgVceJx0hJglI5tfG+lcMiJh+iSr77OhJDQ/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 336/375] clk: qcom: gcc-x1e80100: Fix USB 0 and 1 PHY GDSC pwrsts flags
Date: Tue, 10 Sep 2024 11:32:13 +0200
Message-ID: <20240910092633.868832545@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit f4c16a7cdbd2edecdb854f2ce0ef07c6263c5379 ]

Allowing these GDSCs to collapse makes the QMP combo PHYs lose their
configuration on machine suspend. Currently, the QMP combo PHY driver
doesn't reinitialise the HW on resume. Under such conditions, the USB
SuperSpeed support is broken. To avoid this, mark the pwrsts flags with
RET_ON. This is in line with USB 2 PHY GDSC config.

Fixes: 161b7c401f4b ("clk: qcom: Add Global Clock controller (GCC) driver for X1E80100")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20240801-x1e80100-clk-gcc-fix-usb-phy-gdscs-pwrsts-v1-1-8df016768a0f@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-x1e80100.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-x1e80100.c b/drivers/clk/qcom/gcc-x1e80100.c
index a263f0c412f5..24f84c6705e5 100644
--- a/drivers/clk/qcom/gcc-x1e80100.c
+++ b/drivers/clk/qcom/gcc-x1e80100.c
@@ -6203,7 +6203,7 @@ static struct gdsc gcc_usb_0_phy_gdsc = {
 	.pd = {
 		.name = "gcc_usb_0_phy_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
@@ -6215,7 +6215,7 @@ static struct gdsc gcc_usb_1_phy_gdsc = {
 	.pd = {
 		.name = "gcc_usb_1_phy_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
-- 
2.43.0



