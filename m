Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2441E4D9EA;
	Wed, 19 Jun 2024 13:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803436; cv=none; b=LGpMiX02C72td6QbCodZr8tTXmMp/do2fRTZ/pq5z8ylQ5UaJaw6wMIf0p3LeZ6bL+43X82GNqm4WYfr8TiOicwT0yJhnVkqGKZ1PXwzaXWlMSeHtDymTAc26nOro3RKwmMxbgGFLZLAl3ME7l3D2r8yR1BcoJB6YX7TotTS5bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803436; c=relaxed/simple;
	bh=fYp3isFc5VrPRKWXadX8KKB/E03EcD1jNDi/68aldxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atMq1mQd/8dY4DMS8wRuo+Mtl+uoVGELKgyzt8ta4hau4W4wSbgzzE3mdLmuquOzwnaT2Q5Tvo26lyi+epiJfg3grd3OOSMjabnPfBOMkH33mwhv7t2JXDBi6/CFdUTfg5MNn8UH/6mE3YSFnz68SMOw10L+M+FEEc4rvOErOqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ezbyvQ9i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ezbyvQ9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C222C2BBFC;
	Wed, 19 Jun 2024 13:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803436;
	bh=fYp3isFc5VrPRKWXadX8KKB/E03EcD1jNDi/68aldxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ezbyvQ9ikNHwwMlxVuwUZ4VRATFQZyXidLjYAcDgvubYySBy2dZfyIekBrGcGU25n
	 mwcjKeGwuH7/vWj/EdXbunJ9j1IHN5P6lCEiw0iroYXZ6KU+bYBDzQn5hbXhKYB0SA
	 fk/m4xfTNPwQukK1qJFz78rZqXm7Df/oaNuhA1nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.9 266/281] pmdomain: ti-sci: Fix duplicate PD referrals
Date: Wed, 19 Jun 2024 14:57:05 +0200
Message-ID: <20240619125620.212759373@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
 				if (!pd) {


