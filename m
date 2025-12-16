Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6E3398B78;
	Tue, 16 Dec 2025 12:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888361; cv=none; b=CfVavvBIOQCwl5Uac2Bvgvyf66Vx8rppLM5IyyuC7cEHlg30gEGWzUj5BNwhpsBC+g088jVFP6xsCHYeD7kxqLUtO4izzgxmJuAc4h1N6lHm9hfMIy3c4ygizPtGOxej51wvue2MV/30rnk0CkakqFDmwdMHHm5BSd081vJkBqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888361; c=relaxed/simple;
	bh=X2XPSw0Vv+u9B1dHYI0kfqHo7p9tQ3iVuDgllRrfkd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zi+HytbsArqGZyZDI9IKvvVO3VYoc9Wgb5g0rFg5UWTBmPTK5rWZR+DvLdm3Ctl753zt5LYDPtFjk02CBIZXHVtRJBqWdSOh1trdHJmfjyhLXS8xk+euKOld6hRg7QIExno+swmERbBAwQ8uq6IrSGVUaSt9bHp4GoJNCEgOQC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fyksbhi0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fyksbhi0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71F4C4CEF1;
	Tue, 16 Dec 2025 12:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888361;
	bh=X2XPSw0Vv+u9B1dHYI0kfqHo7p9tQ3iVuDgllRrfkd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fyksbhi0tErJ7lFCv0qBHZZD3CQWmdi2H7MkdQ6EpMX3QMDU2rJIWCu5B0GF+cefx
	 lZIn3bss4vXTaY3NaMeQ+OYU9kJYU3SkLhQIiM1jQvARmGsQHInFzIgZvpIPos6EF+
	 mIPEfCqus1rI9XIvKcMPb45uxvBqNV1SJab46VsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 511/614] net: dsa: b53: provide accessors for accessing ARL_SRCH_CTL
Date: Tue, 16 Dec 2025 12:14:38 +0100
Message-ID: <20251216111419.883280997@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 1716be6db04af53bac9b869f01156a460595cf41 ]

In order to more easily support more formats, move accessing
ARL_SRCH_CTL into helper functions to contain the differences.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20251107080749.26936-5-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8e46aacea426 ("net: dsa: b53: use same ARL search result offset for BCM5325/65")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 37 +++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 4c418e0531f73..38e6fa05042ca 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2017,18 +2017,37 @@ int b53_fdb_del(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL(b53_fdb_del);
 
-static int b53_arl_search_wait(struct b53_device *dev)
+static void b53_read_arl_srch_ctl(struct b53_device *dev, u8 *val)
 {
-	unsigned int timeout = 1000;
-	u8 reg, offset;
+	u8 offset;
+
+	if (is5325(dev) || is5365(dev))
+		offset = B53_ARL_SRCH_CTL_25;
+	else
+		offset = B53_ARL_SRCH_CTL;
+
+	b53_read8(dev, B53_ARLIO_PAGE, offset, val);
+}
+
+static void b53_write_arl_srch_ctl(struct b53_device *dev, u8 val)
+{
+	u8 offset;
 
 	if (is5325(dev) || is5365(dev))
 		offset = B53_ARL_SRCH_CTL_25;
 	else
 		offset = B53_ARL_SRCH_CTL;
 
+	b53_write8(dev, B53_ARLIO_PAGE, offset, val);
+}
+
+static int b53_arl_search_wait(struct b53_device *dev)
+{
+	unsigned int timeout = 1000;
+	u8 reg;
+
 	do {
-		b53_read8(dev, B53_ARLIO_PAGE, offset, &reg);
+		b53_read_arl_srch_ctl(dev, &reg);
 		if (!(reg & ARL_SRCH_STDN))
 			return -ENOENT;
 
@@ -2083,23 +2102,15 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 	unsigned int count = 0, results_per_hit = 1;
 	struct b53_device *priv = ds->priv;
 	struct b53_arl_entry results[2];
-	u8 offset;
 	int ret;
-	u8 reg;
 
 	if (priv->num_arl_bins > 2)
 		results_per_hit = 2;
 
 	mutex_lock(&priv->arl_mutex);
 
-	if (is5325(priv) || is5365(priv))
-		offset = B53_ARL_SRCH_CTL_25;
-	else
-		offset = B53_ARL_SRCH_CTL;
-
 	/* Start search operation */
-	reg = ARL_SRCH_STDN;
-	b53_write8(priv, B53_ARLIO_PAGE, offset, reg);
+	b53_write_arl_srch_ctl(priv, ARL_SRCH_STDN);
 
 	do {
 		ret = b53_arl_search_wait(priv);
-- 
2.51.0



