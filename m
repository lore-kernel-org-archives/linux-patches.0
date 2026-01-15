Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA76F3A0E98;
	Thu, 15 Jan 2026 17:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497685; cv=none; b=ZQBho9iji50qrxGKv6JXTL8i8DLUL1XJW5x2yKP+E3qHHurNyHZ4hEGiFmimZb5pJzGK7M4MdnCZBHWgSYOkPX6a4dnKdEaeoUYZKBO/IOKjXEAmuMCXAb52iE+5x74GkB+T1mHQf4pmXSKO26Vn249/2QsOQIB8mfkVGEIkueg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497685; c=relaxed/simple;
	bh=Yj0poCItF8kZTX0dsKPiYnq3mL25ORCAW/xk1yTgses=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWTzfmzD1ByWR1QLlaX8X25Koi2rO+jZwXcu1VR34NM6Q/ypvGaQg5GUhJmVzL8G5bzzX89BvABOS/BfSp9mFeiBuD617YXgSgwqeqF3iyMIhjHKjvn/jFEfVMFELWzOeLjMKIOu5WHOQiLaAFGZje5SOaW5dgj+b4ctrpfPgMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9cabBAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9cabBAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAC7C116D0;
	Thu, 15 Jan 2026 17:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497684;
	bh=Yj0poCItF8kZTX0dsKPiYnq3mL25ORCAW/xk1yTgses=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9cabBAs0BYHxbaVxVqTrXpC2D47gNbfqGfAFSnhOCsJzQ06YPUZ2vTWGnYYczxOD
	 pyIsol3/msISH//Y59a6Dot6NcyrD3PWek6gDaSc5zPwCHkNEl1/jN1qq8FNBkc4jk
	 FA01lpvxBkCbGqjTWC3TPmoIlpP/pZpMciMqBzqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthijs Kooijman <matthijs@stdin.nl>,
	Haojian Zhuang <haojian.zhuang@linaro.org>,
	Tony Lindgren <tony@atomide.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 166/554] pinctrl: single: Fix PIN_CONFIG_BIAS_DISABLE handling
Date: Thu, 15 Jan 2026 17:43:52 +0100
Message-ID: <20260115164252.276662488@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthijs Kooijman <matthijs@stdin.nl>

[ Upstream commit b5fe46efc147516a908d2d31bf40eb858ab76d51 ]

The pinctrl-single driver handles pin_config_set by looking up the
requested setting in a DT-defined lookup table, which defines what bits
correspond to each setting. There is no way to add
PIN_CONFIG_BIAS_DISABLE entries to the table, since there is instead
code to disable the bias by applying the disable values of both the
pullup and pulldown entries in the table.

However, this code is inside the table-lookup loop, so it would only
execute if there is an entry for PIN_CONFIG_BIAS_DISABLE in the table,
which can never exist, so this code never runs.

This commit lifts the offending code out of the loop, so it just
executes directly whenever PIN_CONFIG_BIAS_DISABLE is requested,
skippipng the table lookup loop.

This also introduces a new `param` variable to make the code slightly
more readable.

This bug seems to have existed when this code was first merged in commit
9dddb4df90d13 ("pinctrl: single: support generic pinconf"). Earlier
versions of this patch did have an entry for PIN_CONFIG_BIAS_DISABLE in
the lookup table, but that was removed, which is probably how this bug
was introduced.

Signed-off-by: Matthijs Kooijman <matthijs@stdin.nl>
Reviewed-by: Haojian Zhuang <haojian.zhuang@linaro.org>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Message-ID: <20240319110633.230329-1-matthijs@stdin.nl>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: 61d1bb53547d ("pinctrl: single: Fix incorrect type for error return variable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-single.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index a72911e8ea82d..b81297084f097 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -557,21 +557,30 @@ static int pcs_pinconf_set(struct pinctrl_dev *pctldev,
 	unsigned offset = 0, shift = 0, i, data, ret;
 	u32 arg;
 	int j;
+	enum pin_config_param param;
 
 	ret = pcs_get_function(pctldev, pin, &func);
 	if (ret)
 		return ret;
 
 	for (j = 0; j < num_configs; j++) {
+		param = pinconf_to_config_param(configs[j]);
+
+		/* BIAS_DISABLE has no entry in the func->conf table */
+		if (param == PIN_CONFIG_BIAS_DISABLE) {
+			/* This just disables all bias entries */
+			pcs_pinconf_clear_bias(pctldev, pin);
+			continue;
+		}
+
 		for (i = 0; i < func->nconfs; i++) {
-			if (pinconf_to_config_param(configs[j])
-				!= func->conf[i].param)
+			if (param != func->conf[i].param)
 				continue;
 
 			offset = pin * (pcs->width / BITS_PER_BYTE);
 			data = pcs->read(pcs->base + offset);
 			arg = pinconf_to_config_argument(configs[j]);
-			switch (func->conf[i].param) {
+			switch (param) {
 			/* 2 parameters */
 			case PIN_CONFIG_INPUT_SCHMITT:
 			case PIN_CONFIG_DRIVE_STRENGTH:
@@ -583,9 +592,6 @@ static int pcs_pinconf_set(struct pinctrl_dev *pctldev,
 				data |= (arg << shift) & func->conf[i].mask;
 				break;
 			/* 4 parameters */
-			case PIN_CONFIG_BIAS_DISABLE:
-				pcs_pinconf_clear_bias(pctldev, pin);
-				break;
 			case PIN_CONFIG_BIAS_PULL_DOWN:
 			case PIN_CONFIG_BIAS_PULL_UP:
 				if (arg) {
-- 
2.51.0



