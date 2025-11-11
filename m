Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145BC30BF77;
	Tue, 11 Nov 2025 01:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825234; cv=none; b=XUUQX7JWYDXxkTSNaYFTuxG+9tkAWHFLW4zN4AjSc8dMCMqT5a6VdHTUlqCpUqaTVqsJ0ImQuB3b98WpsCSSmJsE8bbKY5gZNVef8cAp9ijp0GEgN5eIm/4WeuoK1UeKhg5uXcSl8IonHza9CvHkITm85YRkdYK4jIslImATZgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825234; c=relaxed/simple;
	bh=esYQLy4cpAQ7VuisV/W6VkOT27yHqCySDJokHNLEdfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgKPjgkwj3TBExPkaMC4pvVn0LfpBYxV2R24kHjmShnNploWa3638z+wSVXCDykAfQLXBmHp589b7CG/aPzsLgP1RWZRMsJ5CY/rQb7EE7ZR9/oxVIqLSehc595GoUei0SHr2MuFN3/qMBHKmTCFZv1Bze/55mnwVzziqCGyU3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMSA/lJS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMSA/lJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A372FC113D0;
	Tue, 11 Nov 2025 01:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825233;
	bh=esYQLy4cpAQ7VuisV/W6VkOT27yHqCySDJokHNLEdfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMSA/lJSjF5/y5sOayEhftHC9QbJbrSOWPiY+dFA0Zwf+FGak1BojYR6nF+xmkjC7
	 0XccBMklTmcNyzkm1UiB9fAMnqs9O00M73TEvzP3PW4sMkjC2JROfQ+LRpAkowNtvo
	 HgqyzSW5Vqs+2K0vvP2JEf2fbQNEJfXZv+ORAeJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Bai <ping.bai@nxp.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 710/849] clk: scmi: Add duty cycle ops only when duty cycle is supported
Date: Tue, 11 Nov 2025 09:44:40 +0900
Message-ID: <20251111004553.603232273@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacky Bai <ping.bai@nxp.com>

[ Upstream commit 18db1ff2dea0f97dedaeadd18b0cb0a0d76154df ]

For some of the SCMI based platforms, the oem extended config may be
supported, but not for duty cycle purpose. Skip the duty cycle ops if
err return when trying to get duty cycle info.

Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-scmi.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-scmi.c b/drivers/clk/clk-scmi.c
index d2408403283fc..c2f3ef4e58fe3 100644
--- a/drivers/clk/clk-scmi.c
+++ b/drivers/clk/clk-scmi.c
@@ -349,6 +349,8 @@ scmi_clk_ops_select(struct scmi_clk *sclk, bool atomic_capable,
 		    unsigned int atomic_threshold_us,
 		    const struct clk_ops **clk_ops_db, size_t db_size)
 {
+	int ret;
+	u32 val;
 	const struct scmi_clock_info *ci = sclk->info;
 	unsigned int feats_key = 0;
 	const struct clk_ops *ops;
@@ -370,8 +372,13 @@ scmi_clk_ops_select(struct scmi_clk *sclk, bool atomic_capable,
 	if (!ci->parent_ctrl_forbidden)
 		feats_key |= BIT(SCMI_CLK_PARENT_CTRL_SUPPORTED);
 
-	if (ci->extended_config)
-		feats_key |= BIT(SCMI_CLK_DUTY_CYCLE_SUPPORTED);
+	if (ci->extended_config) {
+		ret = scmi_proto_clk_ops->config_oem_get(sclk->ph, sclk->id,
+						 SCMI_CLOCK_CFG_DUTY_CYCLE,
+						 &val, NULL, false);
+		if (!ret)
+			feats_key |= BIT(SCMI_CLK_DUTY_CYCLE_SUPPORTED);
+	}
 
 	if (WARN_ON(feats_key >= db_size))
 		return NULL;
-- 
2.51.0



