Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C847D3BC4EB;
	Thu, 15 Jan 2026 17:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499129; cv=none; b=aEL/UcBvc6NTF75IO3+ovfhX1x/7tNxrsrXQ7S2eVgBYYF+QY5NMO2BgD3wxx5e0NTNKqG9o7XczjUP7kkAfSggBbd3tD8U+RwN1Dq61fDf5SXstK9zmhjs/cjOZSzpC2aRtOPMd8/JxhVmLQENmCgTXoEjzQm9/DDqgOYm71FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499129; c=relaxed/simple;
	bh=/wgC/dPSr/0v2oowFXVzv4fcGGpeNtI2VxTCRD3/c20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMlxUOj5nlqmTl09Mx+ZETTo6lNWQeQsz1n0owqUF5MuUq9vbY3X+6aOyVixXdCWZcgFeVHRNk+ujnhAVslUxOJjZ6sg1rY4dLzLMRsjBeuwH/S0JH4p+s5JTdusE/1XhcBnaKCkpaoSofxmK7uPaVfjn6EVQKfzV+DJnP0nkdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=So59+67w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="So59+67w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C0FC116D0;
	Thu, 15 Jan 2026 17:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499129;
	bh=/wgC/dPSr/0v2oowFXVzv4fcGGpeNtI2VxTCRD3/c20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=So59+67wDF4xuLcuGfx2wM7xrwvZ+5xFcCfJm+S71Sj8lHkk2rqLwCPjeyCNB6r5+
	 8h6oGahpTMlWTNqvxFm5FmknTkaCQVQzXP+M912xuimGYIkoWxkpbclQzBXo6DsLM5
	 PG8uX1LBYOeucZvAHDrCyq4Lh9qhe6l2TtS7IsRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthijs Kooijman <matthijs@stdin.nl>,
	Haojian Zhuang <haojian.zhuang@linaro.org>,
	Tony Lindgren <tony@atomide.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/451] pinctrl: single: Fix PIN_CONFIG_BIAS_DISABLE handling
Date: Thu, 15 Jan 2026 17:45:18 +0100
Message-ID: <20260115164235.155904351@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9485737638b3c..bdcb5ede9b631 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -556,21 +556,30 @@ static int pcs_pinconf_set(struct pinctrl_dev *pctldev,
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
@@ -581,9 +590,6 @@ static int pcs_pinconf_set(struct pinctrl_dev *pctldev,
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



