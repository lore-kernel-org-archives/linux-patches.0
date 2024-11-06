Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626371EE002;
	Wed,  6 Nov 2024 13:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898591; cv=none; b=qJvgQcy0t/vejnlLsDW4RsU2FejmEBCPAGWZH+ovY+eRWVUXIVpyJOrT3bWOw5k5P5EcCCo/qhIK/rsaGz0aravps9iOozLzVAaB4jx5nxFVMwgEYlrxMigUFtScMUk83a5WmPqOKXwkpcxxUertyWQsUAMl7vvzAc0xxTf7btM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898591; c=relaxed/simple;
	bh=srMOq0jApBo5+7ResZP/ZH/lmvvTUtRZO6A5eAqoSHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klWINz7orYaruTn4Ej9fYmYXoXEa0e7suRh4QWWFfHp2xmaN/bHiZmh07+A30an86qF8IGPEOku4bM2KQvuMh5I6MY+6kPmso/7E2+B0n/nS+vlknH7s/kOcLLSwnzKWjAzGpedR1Mi9DcTeWgT6JFO+uK1Rhnj5MH7BrUUiVxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9EqlzHk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9EqlzHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0927C4CECD;
	Wed,  6 Nov 2024 13:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898591;
	bh=srMOq0jApBo5+7ResZP/ZH/lmvvTUtRZO6A5eAqoSHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I9EqlzHktEFu8FMSL1TyQy0jYwO1ilqswkF1T6WVVC5X3fWWy/6pRNy4K1wXz4O1D
	 eYtTsXCUrIuzrxzhOuvvAfC4mw/aEEYZlcHJLAt0zNvTzcvgV5ks5Hcm3M9yP8yjDW
	 AS1kCKnH5ZBenL/N5uyLu5gnYpF8cWUtd3Fy9RsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Taniya Das <tdas@codeaurora.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 289/462] clk: qcom: rpmh: Simplify clk_rpmh_bcm_send_cmd()
Date: Wed,  6 Nov 2024 13:03:02 +0100
Message-ID: <20241106120338.663635516@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@kernel.org>

[ Upstream commit 2cf7a4cbcb4e108aae666dc6a81cedf69e1cba37 ]

This function has some duplication in unlocking a mutex and returns in a
few different places. Let's use some if statements to consolidate code
and make this a bit easier to read.

Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
CC: Taniya Das <tdas@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lkml.kernel.org/r/20200309221232.145630-2-sboyd@kernel.org
Stable-dep-of: a4e5af27e6f6 ("clk: qcom: clk-rpmh: Fix overflow in BCM vote")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rpmh.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/clk/qcom/clk-rpmh.c b/drivers/clk/qcom/clk-rpmh.c
index d7586e26acd8d..21f4248ba7ddb 100644
--- a/drivers/clk/qcom/clk-rpmh.c
+++ b/drivers/clk/qcom/clk-rpmh.c
@@ -259,38 +259,33 @@ static int clk_rpmh_bcm_send_cmd(struct clk_rpmh *c, bool enable)
 {
 	struct tcs_cmd cmd = { 0 };
 	u32 cmd_state;
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&rpmh_clk_lock);
-
-	cmd_state = 0;
 	if (enable) {
 		cmd_state = 1;
 		if (c->aggr_state)
 			cmd_state = c->aggr_state;
+	} else {
+		cmd_state = 0;
 	}
 
-	if (c->last_sent_aggr_state == cmd_state) {
-		mutex_unlock(&rpmh_clk_lock);
-		return 0;
-	}
-
-	cmd.addr = c->res_addr;
-	cmd.data = BCM_TCS_CMD(1, enable, 0, cmd_state);
+	if (c->last_sent_aggr_state != cmd_state) {
+		cmd.addr = c->res_addr;
+		cmd.data = BCM_TCS_CMD(1, enable, 0, cmd_state);
 
-	ret = clk_rpmh_send(c, RPMH_ACTIVE_ONLY_STATE, &cmd, enable);
-	if (ret) {
-		dev_err(c->dev, "set active state of %s failed: (%d)\n",
-			c->res_name, ret);
-		mutex_unlock(&rpmh_clk_lock);
-		return ret;
+		ret = clk_rpmh_send(c, RPMH_ACTIVE_ONLY_STATE, &cmd, enable);
+		if (ret) {
+			dev_err(c->dev, "set active state of %s failed: (%d)\n",
+				c->res_name, ret);
+		} else {
+			c->last_sent_aggr_state = cmd_state;
+		}
 	}
 
-	c->last_sent_aggr_state = cmd_state;
-
 	mutex_unlock(&rpmh_clk_lock);
 
-	return 0;
+	return ret;
 }
 
 static int clk_rpmh_bcm_prepare(struct clk_hw *hw)
-- 
2.43.0



