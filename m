Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0169D359701;
	Fri,  9 Jan 2026 12:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961922; cv=none; b=ZjmpMSDeVcSp71O9h1sdJ8QsaAbp+7GrQhS58UWn7WYfx5wouShWQuJZ+4KaUzplJzLuZSOkMMG9ix92PIjeg1z6ywFjObrx7xLU1fl2s9Z/Yda2kp/9hw0DqkExjWS1j4jQZl15fKSKHeOzHn67QRXZFr+5/PODDISDwGM1hhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961922; c=relaxed/simple;
	bh=qVXigCfdcTBk5BLaEl9LlH0SxMl9O77EJXoapZorBr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKyc76siMBKqGv3XKXkSwnmVWVe0QItnMd+ZxJHbGgHaWn6/i/l63lKXygOuY0xMjNN/QN9bcN9oFAtrdkO0mE+fmvZI7rkmrAe9IfrhsJKJInggs3WZx9kMi0rWwI6HsjXEjy+qe11AEF4CDns2OCVWgSsw4XzNMi1F4DAmyis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TiIG29Ss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TiIG29Ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852A9C4CEF1;
	Fri,  9 Jan 2026 12:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961921;
	bh=qVXigCfdcTBk5BLaEl9LlH0SxMl9O77EJXoapZorBr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TiIG29SsIwgnj7wx1YdmIr5L+/velKPawSr/JMctajBFmavQbgU/5grL1fvhhZHpd
	 dD8cTZ9001E0A+kZ7newSdbz5BdpOY0+z73rSO/jojoTrMfV3br7LU2Cf2ru3vC8Fd
	 6LFE1Ma8R8qPAVwbs0quri3uL413iN1IXDQ28mrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthijs Kooijman <matthijs@stdin.nl>,
	Haojian Zhuang <haojian.zhuang@linaro.org>,
	Tony Lindgren <tony@atomide.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 184/634] pinctrl: single: Fix PIN_CONFIG_BIAS_DISABLE handling
Date: Fri,  9 Jan 2026 12:37:42 +0100
Message-ID: <20260109112124.364376980@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



