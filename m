Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EAF492E5C;
	Wed, 23 Sep 2026 14:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175211; cv=none; b=iyrfMo4OGkTuxrDS3D/UB89DXoSOTnnk2mfs46JHRmOhwmhZh+EqRf0rbdT58vC0A/RRzvT5mXf18IYm96w5kY4LOTX9sELO8Trzq6QPdbDIXsi5+q7EcfeQjO6qGVhIgUtd4DhaYVS4y92JaYn0YHFadG2QZ59wwXJJdLbnDDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175211; c=relaxed/simple;
	bh=qL5i0fdrlmIeS2J9xZGp/83q+h04F+46z8KGiZAmJyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6V0tU82Gu0aqALvhJtSHZXFKxVRqF/L75RRgpl08dNE5Q+IlfREKdXp3x/KEEMSE3nHfKGvJkhnEoAa+CsyeCSaIsx6//QRfdoqDHMuJ8OrgwEqWIh3C6dqNUGQEjrdq89thmsmZFbuDO13nZ4jVN2jbPVAU28rOxZ7taHyEgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJXLEU0C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJXLEU0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C061F000FF;
	Wed, 23 Sep 2026 14:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175209;
	bh=PtoOqfuVzsc41K4YwTsrCl6Qm1auySlWRsWQJCd0qyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EJXLEU0CpExZwnH/KbmdVFKb7JYFIh+uNonv6nGdGsnVs56M2yeADYebs3mwl7KU9
	 mbSv5zFkiWrFTRojpMv5/4Rl85iKs+MsMV/gGSg8mMo5jAB3PC7x9AzE6w6+s1SesC
	 E+4sGGpzuLRoo83FXpcVMf6SpJfaepfowcgEeUus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 320/398] watchdog: rzv2h: Avoid division by zero
Date: Wed, 23 Sep 2026 16:06:34 +0200
Message-ID: <20260923140651.714434993@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

commit 6274281c41efa8dd1aa5234c59ad904ff89d7af4 upstream.

clk_get_rate() could return 0.  Avoid a division by zero panic.

Fixes: f6febd0a30b6 ("watchdog: Add Watchdog Timer driver for RZ/V2H(P)")
Cc: stable@vger.kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260913064851.8239-4-tzungbi@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/rzv2h_wdt.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/watchdog/rzv2h_wdt.c
+++ b/drivers/watchdog/rzv2h_wdt.c
@@ -280,6 +280,7 @@ static int rzv2h_wdt_probe(struct platfo
 	struct device *dev = &pdev->dev;
 	struct rzv2h_wdt_priv *priv;
 	struct clk *count_clk;
+	unsigned long rate;
 	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -316,8 +317,12 @@ static int rzv2h_wdt_probe(struct platfo
 		return dev_err_probe(dev, -EINVAL, "Invalid count source\n");
 	}
 
+	rate = clk_get_rate(count_clk);
+	if (!rate)
+		return dev_err_probe(dev, -EINVAL, "Invalid clock rate\n");
+
 	priv->wdev.max_hw_heartbeat_ms = (MILLI * priv->of_data->timeout_cycles *
-					  priv->of_data->cks_div) / clk_get_rate(count_clk);
+					  priv->of_data->cks_div) / rate;
 	dev_dbg(dev, "max hw timeout of %dms\n", priv->wdev.max_hw_heartbeat_ms);
 
 	ret = devm_pm_runtime_enable(dev);


