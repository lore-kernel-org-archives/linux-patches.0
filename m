Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC5A25FA29;
	Tue,  8 Apr 2025 11:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111409; cv=none; b=ESyOngLl86PH2BqqoZiXUZlzHjFWFdXJ1Qi9PmLyWvNJglj1i3ILgtMu8uW1GYpl6ksiuAHdy1S6gFWewbUM8I8Z1vAa0htL+srsPHAK4hCnueJdST+RLatGX/bojcUyk+0ZP0iSjMhprxlOeT2epQ5Jg1gLFRyKZ+XgYjjnfnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111409; c=relaxed/simple;
	bh=AZL+4lSSfWXmn2OD5htkP+JHdYVyUNw9WRPdeDXomco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lf+3mlPi9dFsyx8Yj3gJ2ZEkxT0h4nfJYtmRyfi40LQLh1GNF97Cx2RxOv/DJR6cdBZSMXYp3hFhOy4ghMBgLg9habiHE5SHbxNfgZfUluBua45mDrEsCIpEgbhyd4nNjCEk4YLwLzrWxcIx1n74v2SXxlsG2bppNbo+sz+A2y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1O8KspR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1O8KspR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2147C4CEE5;
	Tue,  8 Apr 2025 11:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111409;
	bh=AZL+4lSSfWXmn2OD5htkP+JHdYVyUNw9WRPdeDXomco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V1O8KspRevJM+1YsfliT8Rqu81cE6xpsFFE1YEFkCcwEdoqHDXddXOsLjnVjgdPNt
	 Xd6C6q1wtUEvkQ8gxoZJaB9LkX2Y2JwiUsCcOyCGtxFQmmnJRsz/JxtU/GOdDPmwCp
	 N0TFKSH9w0+VdI8acFi2doapdvocK55Xu0Y92nEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 420/731] clk: qcom: gcc-sm8650: Do not turn off USB GDSCs during gdsc_disable()
Date: Tue,  8 Apr 2025 12:45:17 +0200
Message-ID: <20250408104924.043092711@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 8b75c2973997e66fd897b7e87b5ba2f3d683e94b ]

With PWRSTS_OFF_ON, USB GDSCs are turned off during gdsc_disable(). This
can happen during scenarios such as system suspend and breaks the resume
of USB controller from suspend.

So use PWRSTS_RET_ON to indicate the GDSC driver to not turn off the GDSCs
during gdsc_disable() and allow the hardware to transition the GDSCs to
retention when the parent domain enters low power state during system
suspend.

Fixes: c58225b7e3d7 ("clk: qcom: add the SM8650 Global Clock Controller driver, part 1")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250305-topic-sm8650-upstream-fix-usb-suspend-v1-1-649036ab0557@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm8650.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sm8650.c b/drivers/clk/qcom/gcc-sm8650.c
index 9dd5c48f33bed..fa1672c4e7d81 100644
--- a/drivers/clk/qcom/gcc-sm8650.c
+++ b/drivers/clk/qcom/gcc-sm8650.c
@@ -3497,7 +3497,7 @@ static struct gdsc usb30_prim_gdsc = {
 	.pd = {
 		.name = "usb30_prim_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
@@ -3506,7 +3506,7 @@ static struct gdsc usb3_phy_gdsc = {
 	.pd = {
 		.name = "usb3_phy_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
-- 
2.39.5



