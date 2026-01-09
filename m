Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE55359FBE;
	Fri,  9 Jan 2026 12:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960109; cv=none; b=i1QJUrN7tCuEXwGqGk617NvXT3BPc+zqJkjFyNfI7Pzy2FVYUXEHJxmenoyywf9fsYxE9ywprnzCi3P5x1ncsPZL0IG7Y9xYqeeeSrKViESwgvAVnLKKdo0DiOF2XlnHTfvPupd+2yEhtQR5ReyMW0mrljjpg76lvlorH/aYUF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960109; c=relaxed/simple;
	bh=lzjvp+qj3KXX1pghHSpPlVz0e7geN+Ut/FYgJKXrWBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unltvBbFrR58G9GJL9o8jKHeLaBZ4gGSp7AAhbW8unIGywf079YPtdzT2q5YkXms6wfWBtvEAAxuLveoN/GIuT4geoGwsqPnP+CPfP9q9Sj9UJ+GeJuEUH23EJBNSm7B8ewhIM2PP9qgVx9iUs5HEX+veDvDmPhZom/jRV35qN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L0fbi6D9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L0fbi6D9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BEDC19421;
	Fri,  9 Jan 2026 12:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960109;
	bh=lzjvp+qj3KXX1pghHSpPlVz0e7geN+Ut/FYgJKXrWBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0fbi6D9Vi9Sps2sFMyYkzDzjfcdviog0reaELdGiu+dYzIrfyrlWK+mj2uBwcGnC
	 PJxprIo1KR92yEV49n3MkJ5W7WDI1zdW5D319klYT7qXwbMpIke0v+i2RqMjtZN/vb
	 CzFLI0CrwXoEaid4GhuKdgOp23iJH7LbGYM5cSgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthijs Kooijman <matthijs@stdin.nl>,
	Haojian Zhuang <haojian.zhuang@linaro.org>,
	Tony Lindgren <tony@atomide.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 255/737] pinctrl: single: Fix PIN_CONFIG_BIAS_DISABLE handling
Date: Fri,  9 Jan 2026 12:36:34 +0100
Message-ID: <20260109112143.583832203@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7684039be10cb..5c6d5add6ecac 100644
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
@@ -582,9 +591,6 @@ static int pcs_pinconf_set(struct pinctrl_dev *pctldev,
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



