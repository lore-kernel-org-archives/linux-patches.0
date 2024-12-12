Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1CF235C40;
	Thu, 12 Dec 2024 16:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019744; cv=none; b=Zm1R6y1nJWQtyr6t2pLBjpYYBbhcD/Cu0J73ekSU5EHQ+aV0GOLWMzb0Eflmlg12OvDKE7zEha7NSjNRwGZHxamBdhSO3ccBM+mJ8ar88Nb2bXZ5FWLKZNOWY77UFHQNHufoFT7tJE66/0GK2Osgi6S/OjSnsV1DrnYxaiWuuZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019744; c=relaxed/simple;
	bh=Ryo1sy9lLLE7zwWVSCfGCak3d/NC75N4h49/hRLV6hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEy3YbHfHnvVMUMyTX5iNYPAhJKxso17x766/mTIqWokVtwrvg68hRr4YaiPv/8PFf70htQcqpWlrEyNEEhhFw8JWsxGmUQRnp7lYn5qGgCDhOMK76ZawHGRT5X40Yn1C/pnx7YSeRUe0ZYXMnJtfzDwMW3AEVXBqwcOYLErmBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rutedWl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rutedWl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB06C4CECE;
	Thu, 12 Dec 2024 16:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019744;
	bh=Ryo1sy9lLLE7zwWVSCfGCak3d/NC75N4h49/hRLV6hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rutedWl8nCKVsAzDctapA8CyhtuvKp22h/qJQxfTSXfUD5hwADZsfGnq98dt7ILQW
	 kTtofCAhpq0YuhGe7crtDgD+JrWVPCXb6XgrZGRky8IklDAXDCeBs9xBeJaWI3n+R+
	 wI5D5lNZkj6gUByo0m3lhnT0cx3xJdqRzZ9uvitE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 285/772] remoteproc: qcom: q6v5: Use _clk_get_optional for aggre2_clk
Date: Thu, 12 Dec 2024 15:53:50 +0100
Message-ID: <20241212144401.683581669@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit 6d967a5a49e8d08d8e4430aadba8d3c903b794a5 ]

Only msm8996 and msm8998 SLPIs need the RPM_SMD_AGGR2_NOC_CLK
(as aggre2 clock). None of the other platforms do. Back when the support
for the mentioned platforms was added to the q6v5 pass driver, the
devm_clk_get_optional was not available, so the has_aggre2_clk was
necessary in order to differentiate between plaforms that need this
clock and those which do not. Now that devm_clk_get_optional is available,
we can drop the has_aggre2_clk. This makes the adsp_data more cleaner
and removes the check within adsp_init_clocks.

Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220718121514.2451590-1-abel.vesa@linaro.org
Stable-dep-of: e8983156d54f ("remoteproc: qcom: pas: add minidump_id to SM8350 resources")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c | 42 +++++-------------------------
 1 file changed, 7 insertions(+), 35 deletions(-)

diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index dc6f07ca83410..533cee25b18e5 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -37,7 +37,6 @@ struct adsp_data {
 	const char *firmware_name;
 	int pas_id;
 	unsigned int minidump_id;
-	bool has_aggre2_clk;
 	bool auto_boot;
 	bool decrypt_shutdown;
 
@@ -68,7 +67,6 @@ struct qcom_adsp {
 	int pas_id;
 	unsigned int minidump_id;
 	int crash_reason_smem;
-	bool has_aggre2_clk;
 	bool decrypt_shutdown;
 	const char *info_name;
 
@@ -345,15 +343,13 @@ static int adsp_init_clock(struct qcom_adsp *adsp)
 		return ret;
 	}
 
-	if (adsp->has_aggre2_clk) {
-		adsp->aggre2_clk = devm_clk_get(adsp->dev, "aggre2");
-		if (IS_ERR(adsp->aggre2_clk)) {
-			ret = PTR_ERR(adsp->aggre2_clk);
-			if (ret != -EPROBE_DEFER)
-				dev_err(adsp->dev,
-					"failed to get aggre2 clock");
-			return ret;
-		}
+	adsp->aggre2_clk = devm_clk_get_optional(adsp->dev, "aggre2");
+	if (IS_ERR(adsp->aggre2_clk)) {
+		ret = PTR_ERR(adsp->aggre2_clk);
+		if (ret != -EPROBE_DEFER)
+			dev_err(adsp->dev,
+				"failed to get aggre2 clock");
+		return ret;
 	}
 
 	return 0;
@@ -505,7 +501,6 @@ static int adsp_probe(struct platform_device *pdev)
 	adsp->rproc = rproc;
 	adsp->minidump_id = desc->minidump_id;
 	adsp->pas_id = desc->pas_id;
-	adsp->has_aggre2_clk = desc->has_aggre2_clk;
 	adsp->info_name = desc->sysmon_name;
 	adsp->decrypt_shutdown = desc->decrypt_shutdown;
 	platform_set_drvdata(pdev, adsp);
@@ -585,7 +580,6 @@ static const struct adsp_data adsp_resource_init = {
 		.crash_reason_smem = 423,
 		.firmware_name = "adsp.mdt",
 		.pas_id = 1,
-		.has_aggre2_clk = false,
 		.auto_boot = true,
 		.ssr_name = "lpass",
 		.sysmon_name = "adsp",
@@ -596,7 +590,6 @@ static const struct adsp_data sdm845_adsp_resource_init = {
 		.crash_reason_smem = 423,
 		.firmware_name = "adsp.mdt",
 		.pas_id = 1,
-		.has_aggre2_clk = false,
 		.auto_boot = true,
 		.load_state = "adsp",
 		.ssr_name = "lpass",
@@ -608,7 +601,6 @@ static const struct adsp_data sm6350_adsp_resource = {
 	.crash_reason_smem = 423,
 	.firmware_name = "adsp.mdt",
 	.pas_id = 1,
-	.has_aggre2_clk = false,
 	.auto_boot = true,
 	.proxy_pd_names = (char*[]){
 		"lcx",
@@ -625,7 +617,6 @@ static const struct adsp_data sm8150_adsp_resource = {
 		.crash_reason_smem = 423,
 		.firmware_name = "adsp.mdt",
 		.pas_id = 1,
-		.has_aggre2_clk = false,
 		.auto_boot = true,
 		.proxy_pd_names = (char*[]){
 			"cx",
@@ -641,7 +632,6 @@ static const struct adsp_data sm8250_adsp_resource = {
 	.crash_reason_smem = 423,
 	.firmware_name = "adsp.mdt",
 	.pas_id = 1,
-	.has_aggre2_clk = false,
 	.auto_boot = true,
 	.proxy_pd_names = (char*[]){
 		"lcx",
@@ -658,7 +648,6 @@ static const struct adsp_data sm8350_adsp_resource = {
 	.crash_reason_smem = 423,
 	.firmware_name = "adsp.mdt",
 	.pas_id = 1,
-	.has_aggre2_clk = false,
 	.auto_boot = true,
 	.proxy_pd_names = (char*[]){
 		"lcx",
@@ -675,7 +664,6 @@ static const struct adsp_data msm8996_adsp_resource = {
 		.crash_reason_smem = 423,
 		.firmware_name = "adsp.mdt",
 		.pas_id = 1,
-		.has_aggre2_clk = false,
 		.auto_boot = true,
 		.proxy_pd_names = (char*[]){
 			"cx",
@@ -690,7 +678,6 @@ static const struct adsp_data cdsp_resource_init = {
 	.crash_reason_smem = 601,
 	.firmware_name = "cdsp.mdt",
 	.pas_id = 18,
-	.has_aggre2_clk = false,
 	.auto_boot = true,
 	.ssr_name = "cdsp",
 	.sysmon_name = "cdsp",
@@ -701,7 +688,6 @@ static const struct adsp_data sdm845_cdsp_resource_init = {
 	.crash_reason_smem = 601,
 	.firmware_name = "cdsp.mdt",
 	.pas_id = 18,
-	.has_aggre2_clk = false,
 	.auto_boot = true,
 	.load_state = "cdsp",
 	.ssr_name = "cdsp",
@@ -713,7 +699,6 @@ static const struct adsp_data sm6350_cdsp_resource = {
 	.crash_reason_smem = 601,
 	.firmware_name = "cdsp.mdt",
 	.pas_id = 18,
-	.has_aggre2_clk = false,
 	.auto_boot = true,
 	.proxy_pd_names = (char*[]){
 		"cx",
@@ -730,7 +715,6 @@ static const struct adsp_data sm8150_cdsp_resource = {
 	.crash_reason_smem = 601,
 	.firmware_name = "cdsp.mdt",
 	.pas_id = 18,
-	.has_aggre2_clk = false,
 	.auto_boot = true,
 	.proxy_pd_names = (char*[]){
 		"cx",
@@ -746,7 +730,6 @@ static const struct adsp_data sm8250_cdsp_resource = {
 	.crash_reason_smem = 601,
 	.firmware_name = "cdsp.mdt",
 	.pas_id = 18,
-	.has_aggre2_clk = false,
 	.auto_boot = true,
 	.proxy_pd_names = (char*[]){
 		"cx",
@@ -762,7 +745,6 @@ static const struct adsp_data sc8280xp_nsp0_resource = {
 	.crash_reason_smem = 601,
 	.firmware_name = "cdsp.mdt",
 	.pas_id = 18,
-	.has_aggre2_clk = false,
 	.auto_boot = true,
 	.proxy_pd_names = (char*[]){
 		"nsp",
@@ -777,7 +759,6 @@ static const struct adsp_data sc8280xp_nsp1_resource = {
 	.crash_reason_smem = 633,
 	.firmware_name = "cdsp.mdt",
 	.pas_id = 30,
-	.has_aggre2_clk = false,
 	.auto_boot = true,
 	.proxy_pd_names = (char*[]){
 		"nsp",
@@ -792,7 +773,6 @@ static const struct adsp_data sm8350_cdsp_resource = {
 	.crash_reason_smem = 601,
 	.firmware_name = "cdsp.mdt",
 	.pas_id = 18,
-	.has_aggre2_clk = false,
 	.auto_boot = true,
 	.proxy_pd_names = (char*[]){
 		"cx",
@@ -810,7 +790,6 @@ static const struct adsp_data mpss_resource_init = {
 	.firmware_name = "modem.mdt",
 	.pas_id = 4,
 	.minidump_id = 3,
-	.has_aggre2_clk = false,
 	.auto_boot = false,
 	.proxy_pd_names = (char*[]){
 		"cx",
@@ -827,7 +806,6 @@ static const struct adsp_data sc8180x_mpss_resource = {
 	.crash_reason_smem = 421,
 	.firmware_name = "modem.mdt",
 	.pas_id = 4,
-	.has_aggre2_clk = false,
 	.auto_boot = false,
 	.proxy_pd_names = (char*[]){
 		"cx",
@@ -843,7 +821,6 @@ static const struct adsp_data slpi_resource_init = {
 		.crash_reason_smem = 424,
 		.firmware_name = "slpi.mdt",
 		.pas_id = 12,
-		.has_aggre2_clk = true,
 		.auto_boot = true,
 		.proxy_pd_names = (char*[]){
 			"ssc_cx",
@@ -858,7 +835,6 @@ static const struct adsp_data sm8150_slpi_resource = {
 		.crash_reason_smem = 424,
 		.firmware_name = "slpi.mdt",
 		.pas_id = 12,
-		.has_aggre2_clk = false,
 		.auto_boot = true,
 		.proxy_pd_names = (char*[]){
 			"lcx",
@@ -875,7 +851,6 @@ static const struct adsp_data sm8250_slpi_resource = {
 	.crash_reason_smem = 424,
 	.firmware_name = "slpi.mdt",
 	.pas_id = 12,
-	.has_aggre2_clk = false,
 	.auto_boot = true,
 	.proxy_pd_names = (char*[]){
 		"lcx",
@@ -892,7 +867,6 @@ static const struct adsp_data sm8350_slpi_resource = {
 	.crash_reason_smem = 424,
 	.firmware_name = "slpi.mdt",
 	.pas_id = 12,
-	.has_aggre2_clk = false,
 	.auto_boot = true,
 	.proxy_pd_names = (char*[]){
 		"lcx",
@@ -919,7 +893,6 @@ static const struct adsp_data sdx55_mpss_resource = {
 	.crash_reason_smem = 421,
 	.firmware_name = "modem.mdt",
 	.pas_id = 4,
-	.has_aggre2_clk = false,
 	.auto_boot = true,
 	.proxy_pd_names = (char*[]){
 		"cx",
@@ -936,7 +909,6 @@ static const struct adsp_data sm8450_mpss_resource = {
 	.firmware_name = "modem.mdt",
 	.pas_id = 4,
 	.minidump_id = 3,
-	.has_aggre2_clk = false,
 	.auto_boot = false,
 	.decrypt_shutdown = true,
 	.proxy_pd_names = (char*[]){
-- 
2.43.0



