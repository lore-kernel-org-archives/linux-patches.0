Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C411C7B6F;
	Tue, 27 Aug 2024 15:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771639; cv=none; b=NCTM1d2Qrk2HO8yL+Xhdg3JJ1c5mV8/oPmQjQuHj05N4hj1wHh3U8uPFb8sIqKh55/S6yd7FPDqr9EGMS843dzXmrjosiGny8rNpEz0MeSqZoSPaap50poA4fJRuGN5eIyZzE4n6Wl8u5i24K36OeMrBqv6wYuYj+uhXP7GW2SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771639; c=relaxed/simple;
	bh=kIQLU48wIob8v19HAyulWIZHUkAHEgghiJ++ldkOFrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BV5x6I1Kmh1qort5jUbusZqjWEyF/dP+bJrrAfa8Ah1rh/UrGZlzjdB6TjCRiPw/G9Md30vkn34l/vREJSz6i/GUEV6/O59FkVMDI0BvNAVMkMWXjo+Jkjerd7Che9p825OQV2X3BI4UovmQrs3d3hS7UJuw0iMzBsG8l0Z6g0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7rkfZ4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7rkfZ4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C2DC6106B;
	Tue, 27 Aug 2024 15:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771639;
	bh=kIQLU48wIob8v19HAyulWIZHUkAHEgghiJ++ldkOFrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S7rkfZ4uikGaCBsl68TLxsGJ27GlS90r68f0Y6mfDd9HRzJwjXu8MIhvlUyeqdT39
	 ZMGgseb22iu1rJN7OTr4T0yWSbuy8itUJRV1erNa08E4TH9AlEtYiWVT5JarqyI6MD
	 NrY6rke9s7mzrhW/kZHtamDb3Ss2uM6DAwAEvDeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Bai <ping.bai@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.10 250/273] pmdomain: imx: wait SSAR when i.MX93 power domain on
Date: Tue, 27 Aug 2024 16:39:34 +0200
Message-ID: <20240827143842.916354136@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


