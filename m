Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2859925BEE8;
	Thu, 27 Nov 2025 14:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255061; cv=none; b=D6CPIA76brEe8C7tx/SuOGjamJkEPaDm+t3anu/zMczrBih8LetyKS3xHm+6ZyGNSp8FJ8aXYiyBp4ZS4lVEW7oweYwr+D4nT5ACKRHWXyOwYLNY/rZr8/foVvPLE7yKdnps6C0wpJAhPWnipBCLqOLqxYITgMzp9POjIfAH5Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255061; c=relaxed/simple;
	bh=4kLQj+YQ+vReuGHiobHa5p8d7OMbvcVsRv8Obj+nn6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ox/wK63sEbDhefipLSiHiuudEm7JOGvG+5wQ0de0+0OfJ/N01b3yFBAqaAle+uN17aKF0Um34ny35twfOfKzA7VP/J99WboeduDLA3JBe7ilfSgQPiR4+FmBoE9suPxM3zKA3oonwbd330T1xovM1C4BPdr9JvP3kabulPpupRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzO9KG/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzO9KG/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2618C4CEF8;
	Thu, 27 Nov 2025 14:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255061;
	bh=4kLQj+YQ+vReuGHiobHa5p8d7OMbvcVsRv8Obj+nn6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzO9KG/bqRGln+C4wAwJJNQcKf/wisH+m+7u4ywAyySk02c6QQCez4QVdP+IbukJr
	 4h3yT64xDrXoCIgb8HzbQWAWG/OFXK/WsDyzlBwyFnne3q/4Kwa70biam48caIIBRC
	 p/7FbL6ppSNn2sG+1zBZt6DGi+SYWvfLH9FKaNto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 80/86] pmdomain: imx-gpc: Convert to platform remove callback returning void
Date: Thu, 27 Nov 2025 15:46:36 +0100
Message-ID: <20251127144030.756916723@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit da07c5871d18157608a0d0702cb093168d79080a ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

In the error path emit an error message replacing the (less useful)
message by the core. Apart from the improved error message there is no
change in behaviour.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20231124080623.564924-3-u.kleine-koenig@pengutronix.de
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: bbde14682eba ("pmdomain: imx: Fix reference count leak in imx_gpc_remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/gpc.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/drivers/pmdomain/imx/gpc.c
+++ b/drivers/pmdomain/imx/gpc.c
@@ -512,7 +512,7 @@ static int imx_gpc_probe(struct platform
 	return 0;
 }
 
-static int imx_gpc_remove(struct platform_device *pdev)
+static void imx_gpc_remove(struct platform_device *pdev)
 {
 	struct device_node *pgc_node;
 	int ret;
@@ -522,7 +522,7 @@ static int imx_gpc_remove(struct platfor
 	/* bail out if DT too old and doesn't provide the necessary info */
 	if (!of_property_read_bool(pdev->dev.of_node, "#power-domain-cells") &&
 	    !pgc_node)
-		return 0;
+		return;
 
 	/*
 	 * If the old DT binding is used the toplevel driver needs to
@@ -532,16 +532,20 @@ static int imx_gpc_remove(struct platfor
 		of_genpd_del_provider(pdev->dev.of_node);
 
 		ret = pm_genpd_remove(&imx_gpc_domains[GPC_PGC_DOMAIN_PU].base);
-		if (ret)
-			return ret;
+		if (ret) {
+			dev_err(&pdev->dev, "Failed to remove PU power domain (%pe)\n",
+				ERR_PTR(ret));
+			return;
+		}
 		imx_pgc_put_clocks(&imx_gpc_domains[GPC_PGC_DOMAIN_PU]);
 
 		ret = pm_genpd_remove(&imx_gpc_domains[GPC_PGC_DOMAIN_ARM].base);
-		if (ret)
-			return ret;
+		if (ret) {
+			dev_err(&pdev->dev, "Failed to remove ARM power domain (%pe)\n",
+				ERR_PTR(ret));
+			return;
+		}
 	}
-
-	return 0;
 }
 
 static struct platform_driver imx_gpc_driver = {
@@ -550,6 +554,6 @@ static struct platform_driver imx_gpc_dr
 		.of_match_table = imx_gpc_dt_ids,
 	},
 	.probe = imx_gpc_probe,
-	.remove = imx_gpc_remove,
+	.remove_new = imx_gpc_remove,
 };
 builtin_platform_driver(imx_gpc_driver)


