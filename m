Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C33B12FB31;
	Wed, 19 Jun 2024 13:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802612; cv=none; b=laGXKZxe1XbML9UFS9VoUJsefxflHwaFydaqXd26uQr64EobHYLM02DnpRA3vD7mO5SGFYOMhZgBMUWtUOVm1ZitG0LVtpQ1vSlfsUvwlFXIA/2PVWzDtln8dOP61SzlJ1mPWP2LSnATov3JlmAdld39U7FHQqCNoEGoVJUpov0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802612; c=relaxed/simple;
	bh=vTBO3SzvxaXXEitez0LLJDFJq8JjNCAe5EeyeQJBZRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PiNk7EQL/84RzBO86IgA5XGtO9ZSEYYUcnx6elcmpeOs5cWTR2lFs7mNZMgTqy6TAdlhawBSsoTJyc3aoYKMjxvmGKAn2KwNxAVEYkfuy8STy735xJ4oFE93DnW2IMGw26ANDELg89HUCNz4qbE+6o7bdaFDwhXe/maWXZOztms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1DAHlshQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1DAHlshQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97077C2BBFC;
	Wed, 19 Jun 2024 13:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802612;
	bh=vTBO3SzvxaXXEitez0LLJDFJq8JjNCAe5EeyeQJBZRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1DAHlshQLIcRqTRfrir/7xXMkNUtYiz8fQPzdKvatijfowEfQySSTtDHYgYQmeDCY
	 2aK2/DdITM0fLqyNdyRm9FgQHsRqcL06IYbd0NCaIFKiKPZylH0xN7jgzzSWJw4fsy
	 j7S5Gp6x48bp7uTtwp7esjJ5ajYg199BOHvL3BzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 224/267] pmdomain: ti-sci: Fix duplicate PD referrals
Date: Wed, 19 Jun 2024 14:56:15 +0200
Message-ID: <20240619125614.923407289@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

commit 670c900f69645db394efb38934b3344d8804171a upstream.

When the dts file has multiple referrers to a single PD (e.g.
simple-framebuffer and dss nodes both point to the DSS power-domain) the
ti-sci driver will create two power domains, both with the same ID, and
that will cause problems as one of the power domains will hide the other
one.

Fix this checking if a PD with the ID has already been created, and only
create a PD for new IDs.

Fixes: efa5c01cd7ee ("soc: ti: ti_sci_pm_domains: switch to use multiple genpds instead of one")
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240415-ti-sci-pd-v1-1-a0e56b8ad897@ideasonboard.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/ti/ti_sci_pm_domains.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/pmdomain/ti/ti_sci_pm_domains.c
+++ b/drivers/pmdomain/ti/ti_sci_pm_domains.c
@@ -114,6 +114,18 @@ static const struct of_device_id ti_sci_
 };
 MODULE_DEVICE_TABLE(of, ti_sci_pm_domain_matches);
 
+static bool ti_sci_pm_idx_exists(struct ti_sci_genpd_provider *pd_provider, u32 idx)
+{
+	struct ti_sci_pm_domain *pd;
+
+	list_for_each_entry(pd, &pd_provider->pd_list, node) {
+		if (pd->idx == idx)
+			return true;
+	}
+
+	return false;
+}
+
 static int ti_sci_pm_domain_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -149,8 +161,14 @@ static int ti_sci_pm_domain_probe(struct
 				break;
 
 			if (args.args_count >= 1 && args.np == dev->of_node) {
-				if (args.args[0] > max_id)
+				if (args.args[0] > max_id) {
 					max_id = args.args[0];
+				} else {
+					if (ti_sci_pm_idx_exists(pd_provider, args.args[0])) {
+						index++;
+						continue;
+					}
+				}
 
 				pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
 				if (!pd)


