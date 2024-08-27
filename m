Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47311C5792;
	Tue, 27 Aug 2024 14:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770702; cv=none; b=X7CGHqBlvQ9P0iYOoPO0t8TofiqbbgRZwHHgga6aOSxMlZPtAYRMVc26f21DGuhvwNmRRBo0TZq6LW88yIZTc+dPM465DBtlD9LWPeqeiOol7j/6DhlPbTJb9MlJsb7x8VhRHqPKSEPe19xJ/wGfk8WdzlMWIoz3J4UXKAuejTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770702; c=relaxed/simple;
	bh=d2Vojo40pMDVe6GoATSPq1qew5UseykpcG+oVZIvLyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJS86sM4UExIyyuiLpObCQVKcUIotGJdlFnd93A98DAlLcq3ICETsRk6En3Fw2bhtbR3nA3koaB2bhMKQMF47NmBNDUtuv+7oOXJafJKy/x9b6oILhQhtpBumdTeFOXfBgRmIP0EWzk/C8NkIsdLjrphX/RWm1YKmT2Wf3fTeXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xBLXb4oz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBLXb4oz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4178AC61044;
	Tue, 27 Aug 2024 14:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770702;
	bh=d2Vojo40pMDVe6GoATSPq1qew5UseykpcG+oVZIvLyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xBLXb4ozG+4XvquoJeKFM/hI5bDX9FRl2bXhGLaE1GzLfmnOYlbmKsvK8TN6LbDj5
	 EEpHepVRTL7yPTBfdMsPycMNZ8EEb8HeizoEMEubk/QYRAbHZzkOcmRdYNMC7fhSDZ
	 vyKWAbl3KTKZazJee5VA7Mi0J82z6ntOcPBedNXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Bai <ping.bai@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 308/341] pmdomain: imx: wait SSAR when i.MX93 power domain on
Date: Tue, 27 Aug 2024 16:38:59 +0200
Message-ID: <20240827143855.109251859@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

commit 52dd070c62e4ae2b5e7411b920e3f7a64235ecfb upstream.

With "quiet" set in bootargs, there is power domain failure:
"imx93_power_domain 44462400.power-domain: pd_off timeout: name:
 44462400.power-domain, stat: 4"

The current power on opertation takes ISO state as power on finished
flag, but it is wrong. Before powering on operation really finishes,
powering off comes and powering off will never finish because the last
powering on still not finishes, so the following powering off actually
not trigger hardware state machine to run. SSAR is the last step when
powering on a domain, so need to wait SSAR done when powering on.

Since EdgeLock Enclave(ELE) handshake is involved in the flow, enlarge
the waiting time to 10ms for both on and off to avoid timeout.

Cc: stable@vger.kernel.org
Fixes: 0a0f7cc25d4a ("soc: imx: add i.MX93 SRC power domain driver")
Reviewed-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20240814124740.2778952-1-peng.fan@oss.nxp.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/imx93-pd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/pmdomain/imx/imx93-pd.c
+++ b/drivers/pmdomain/imx/imx93-pd.c
@@ -20,6 +20,7 @@
 #define FUNC_STAT_PSW_STAT_MASK		BIT(0)
 #define FUNC_STAT_RST_STAT_MASK		BIT(2)
 #define FUNC_STAT_ISO_STAT_MASK		BIT(4)
+#define FUNC_STAT_SSAR_STAT_MASK	BIT(8)
 
 struct imx93_power_domain {
 	struct generic_pm_domain genpd;
@@ -50,7 +51,7 @@ static int imx93_pd_on(struct generic_pm
 	writel(val, addr + MIX_SLICE_SW_CTRL_OFF);
 
 	ret = readl_poll_timeout(addr + MIX_FUNC_STAT_OFF, val,
-				 !(val & FUNC_STAT_ISO_STAT_MASK), 1, 10000);
+				 !(val & FUNC_STAT_SSAR_STAT_MASK), 1, 10000);
 	if (ret) {
 		dev_err(domain->dev, "pd_on timeout: name: %s, stat: %x\n", genpd->name, val);
 		return ret;
@@ -72,7 +73,7 @@ static int imx93_pd_off(struct generic_p
 	writel(val, addr + MIX_SLICE_SW_CTRL_OFF);
 
 	ret = readl_poll_timeout(addr + MIX_FUNC_STAT_OFF, val,
-				 val & FUNC_STAT_PSW_STAT_MASK, 1, 1000);
+				 val & FUNC_STAT_PSW_STAT_MASK, 1, 10000);
 	if (ret) {
 		dev_err(domain->dev, "pd_off timeout: name: %s, stat: %x\n", genpd->name, val);
 		return ret;


