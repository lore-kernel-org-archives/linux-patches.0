Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238B125C6EE;
	Thu, 20 Aug 2026 16:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244641; cv=none; b=lxmhZheJpmuWG/YBLCHElT7+Jd40K67Tdeq6ngKiWx95fBbr/VRpqkK4eS80ltc6nv2mXB6hEewD/mxojXZcDGCYqkktgUS59fA276PDSsJReDtWlxr7HyBXsw51A2a+hPufFK6y1EIE3QQjgF6R+vgy70fRWewi9UWNrGa5eK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244641; c=relaxed/simple;
	bh=Un7RPIUhJoLvUm1SwKzwkzQBlKqdqEwcKGEFok+6ogY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHa40lzo12Ley06D7qbUoFIP4oqeyJjSmRIQG6zvvFBp4O5G6yyjJXh1turED3+YlJoJp5IbRB7cJMtQt82o8oYWBlnWAteZwBoDcKpVGELO/c9YgKeuk83e5Z87rwoOuD8J9dEC+b17gxfTRFjeqoi8cGtFDeVjiVRdiggOzFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NCY0iUQk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NCY0iUQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0A01F000E9;
	Thu, 20 Aug 2026 16:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244640;
	bh=n12izqi2z0z8vUs0jQUxEciea3OaA3WuQwxUWd2hiGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NCY0iUQkSAp58MKvXrlzcJF1jwJ1KTFZZKbqYwUs1j5+4gqlj5LONuZ5XWPrykUFe
	 U4ogT1AjlOrFoR7PbyTQK+UJL0/R0yZXgg3jzydfcZ1yDUIw5JEA2yM+aSSgNvrwUZ
	 zSyvLTk5s7nqPsdOdef3j1SW26TIZa8gDGbCGwzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grygorii Strashko <grygorii.strashko@ti.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 225/235] net: ethernet: ti: am65-cpsw: move ale selection in pdata
Date: Thu, 20 Aug 2026 16:57:41 +0200
Message-ID: <20260820145223.437909942@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 7747d4b72f7702b2f19b9f91cc783eb38a2028bf ]

In preparation of adding more multi-port K3 CPSW versions move ALE
selection in am65_cpsw_pdata, so it can be selected basing on DT
compatibility property.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 36a05d282007 ("net: ethernet: ti: am65-cpsw-nuss: Fix port_id extraction from SRC TAG")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 4 +++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 2dc3e5be1d717..d1bf457acba04 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1988,10 +1988,12 @@ static const struct soc_device_attribute am65_cpsw_socinfo[] = {
 
 static const struct am65_cpsw_pdata am65x_sr1_0 = {
 	.quirks = AM65_CPSW_QUIRK_I2027_NO_TX_CSUM,
+	.ale_dev_id = "am65x-cpsw2g",
 };
 
 static const struct am65_cpsw_pdata j721e_pdata = {
 	.quirks = 0,
+	.ale_dev_id = "am65x-cpsw2g",
 };
 
 static const struct of_device_id am65_cpsw_nuss_of_mtable[] = {
@@ -2123,7 +2125,7 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	ale_params.ale_ageout = AM65_CPSW_ALE_AGEOUT_DEFAULT;
 	ale_params.ale_ports = common->port_num + 1;
 	ale_params.ale_regs = common->cpsw_base + AM65_CPSW_NU_ALE_BASE;
-	ale_params.dev_id = "am65x-cpsw2g";
+	ale_params.dev_id = common->pdata.ale_dev_id;
 	ale_params.bus_freq = common->bus_freq;
 
 	common->ale = cpsw_ale_create(&ale_params);
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index 993e1d4d3222f..9c2186b8eae90 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -77,6 +77,7 @@ struct am65_cpsw_rx_chn {
 
 struct am65_cpsw_pdata {
 	u32	quirks;
+	const char	*ale_dev_id;
 };
 
 struct am65_cpsw_common {
-- 
2.53.0



