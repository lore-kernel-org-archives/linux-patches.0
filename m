Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5862054648;
	Tue, 27 Aug 2024 15:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772745; cv=none; b=llkVGnP/zZ5pasNCCJRCgbIjN5v7rNtqWo5mnvmxxiDEPvduRIeMnPeb0JL2VStzCv7mKuB2mxvNjTJk5YKZrVglAdbcjIwMMPQktD4yevn4Ir+2HOQEpOTfp39tKA/1ZE+lFSEsknoGDcxwiu82DCE3zj1dkNTz+u9WTTbmPCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772745; c=relaxed/simple;
	bh=Eo6uCYLw400DjkWQNLNJZFw4MJu/ABGgftC6a2OlMj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GN4SsIl51+rJm7bjHPgGmgEcZseYQUquJWGdvEwYDwhsKfaxKtXVpGTgDqKutjBROmQxMvaa32ZcgE2et5bhHa0rdNf/XLkO/+pFH5K/blQqndZdRDuWhyyPZVYA3PKFT4oRX4FXntr/N93ZsDmo4f+TE+GcCqw6rjX6sdrr1Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mDssdvqi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mDssdvqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAECAC61041;
	Tue, 27 Aug 2024 15:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772745;
	bh=Eo6uCYLw400DjkWQNLNJZFw4MJu/ABGgftC6a2OlMj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mDssdvqiGxlWenHNJ/WwWEO0RAOh+4lji8e/mhnaOQVqSMacVO82kVtewwTDL6PRR
	 FtDa2f1gAsnROhsxL3K/+yl1C2dJhAZmPuy8GETLPmuXUV1r5Jwe7wobAqZynikxuC
	 qfPMk8wKTQCXy+jHLQIfArJiKyzsvf8QcZ5F56NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Bai <ping.bai@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 275/321] pmdomain: imx: wait SSAR when i.MX93 power domain on
Date: Tue, 27 Aug 2024 16:39:43 +0200
Message-ID: <20240827143848.720547229@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/soc/imx/imx93-pd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/soc/imx/imx93-pd.c
+++ b/drivers/soc/imx/imx93-pd.c
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


