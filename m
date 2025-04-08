Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D8522257E;
	Tue,  8 Apr 2025 11:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113308; cv=none; b=gJ8JygbLiWOUEvzEkn0Iuw4bfji2/EM7RfWQoHD/np5GM1rEfnWQlN3J/62TGTIrPzy6klF6Rn7iQy/vaAvI+lHUN1JIx3d1YnwJjws+o6kt6w7B+0NqoW3sqR77rcVSBW1kRDkd2Y9/nyiffB1xd6UU7mxnvMe6SD+ub4x15F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113308; c=relaxed/simple;
	bh=2kmcn7k6s1tmuV3byD2x26tssrGQI/BbQvVyOK81QN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jorrhzvNeZAGwhxmmtIe7DEc676GUQovm69pXps++ndQceNpX4ZBsi/oKyzpESpBWT/Vh8HxlbBe2Ey4seg759XEt4u5TjhbXN3+Dz4XSlOklOFXSSYVkPxZHDdBwypyn9FAYW8f0uT1CxMRubkkgCrw63sMDglStzp5MoHdUzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7GV3x+m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7GV3x+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E703CC4CEE5;
	Tue,  8 Apr 2025 11:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113308;
	bh=2kmcn7k6s1tmuV3byD2x26tssrGQI/BbQvVyOK81QN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x7GV3x+msnALh9Qc7qQ2P5utC1jzdrSE4BE3+pwGNH67GIu2oWUVYHvU6S8SFt5JP
	 scalnQdrckdOZ+R8XmsDqhZH9si+JM5HZJe+qFIHBNHxjGtJVl9VG7Xk8wTwRFS0AG
	 myTqa9+lPOZvgZDPsGsByc28o8V2RhyRIV4VqoSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Lypak <vladimir.lypak@gmail.com>,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/268] clk: qcom: gcc-msm8953: fix stuck venus0_core0 clock
Date: Tue,  8 Apr 2025 12:48:03 +0200
Message-ID: <20250408104830.439517747@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Lypak <vladimir.lypak@gmail.com>

[ Upstream commit cdc59600bccf2cb4c483645438a97d4ec55f326b ]

This clock can't be enable with VENUS_CORE0 GDSC turned off. But that
GDSC is under HW control so it can be turned off at any moment.
Instead of checking the dependent clock we can just vote for it to
enable later when GDSC gets turned on.

Fixes: 9bb6cfc3c77e6 ("clk: qcom: Add Global Clock Controller driver for MSM8953")
Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Link: https://lore.kernel.org/r/20250315-clock-fix-v1-2-2efdc4920dda@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-msm8953.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-msm8953.c b/drivers/clk/qcom/gcc-msm8953.c
index 3e5a8cb14d4df..e6e2ab1380f20 100644
--- a/drivers/clk/qcom/gcc-msm8953.c
+++ b/drivers/clk/qcom/gcc-msm8953.c
@@ -3770,7 +3770,7 @@ static struct clk_branch gcc_venus0_axi_clk = {
 
 static struct clk_branch gcc_venus0_core0_vcodec0_clk = {
 	.halt_reg = 0x4c02c,
-	.halt_check = BRANCH_HALT,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x4c02c,
 		.enable_mask = BIT(0),
-- 
2.39.5



