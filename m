Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE87330B30;
	Fri, 17 Oct 2025 15:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715336; cv=none; b=rzsuTxPGNyLR2M/S1utJngc4BkmGycQ7eU1gvAFkDjclJess0V3a6mwyxV0NzIbOqTVyvlNYXGnIdN08IwK3Aq+Uh1ObDWwFIBSF8dYNzOuoO3289rO3oNYoyuAdeWgWrjSFSoEo4ObnrLTL8xMhXST17N6SYW+jCTGdoAVv0lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715336; c=relaxed/simple;
	bh=qtFX8ApmiVNANi9jjjgn5f6j66Y5s8Ea+xcGuSBrLpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soS3EmiP7UmT9+NN4CubJ1+IDe5RjmoyNui69LPwwySxgvsR32xAkDmjFMNNaG+jPIY58zmdPkIBkm6CCnUZuniaVd3bBOUH1rLcpHGwvvoFMuQI0A9XyZCqzBj3BeR+xNZ0y/8aCJwoowXkMuZKsEBNCaRGBVAQMCrXiJvAmBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KdFd3iki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KdFd3iki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67252C4CEE7;
	Fri, 17 Oct 2025 15:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715335;
	bh=qtFX8ApmiVNANi9jjjgn5f6j66Y5s8Ea+xcGuSBrLpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KdFd3iki7nHfOdvGLjvOOUk6HdW+RxWsd5POClWMMmqd+6jykFxsprzjasHc6Uj3V
	 S6dHEZFjf8h5AECPVFFO51RdRFi1wPqneiUQ52lkKuoPFqn3i8cdfQFaXUMoLcOxNv
	 3LZ9v02t+GagC+Xb8c1G0I0saYRp1wtV66XIt+qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Renjiang Han <quic_renjiang@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.17 180/371] media: venus: pm_helpers: add fallback for the opp-table
Date: Fri, 17 Oct 2025 16:52:35 +0200
Message-ID: <20251017145208.439307745@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Renjiang Han <quic_renjiang@quicinc.com>

commit afb100a5ea7a13d7e6937dcd3b36b19dc6cc9328 upstream.

Since the device trees for both HFI_VERSION_1XX and HFI_VERSION_3XX
do not include an opp-table and have not configured opp-pmdomain, they
still need to use the frequencies defined in the driver's freq_tbl.

Both core_power_v1 and core_power_v4 functions require core_clks_enable
function during POWER_ON. Therefore, in the core_clks_enable function,
if calling dev_pm_opp_find_freq_ceil to obtain the frequency fails,
it needs to fall back to the freq_tbl to retrieve the frequency.

Fixes: b179234b5e59 ("media: venus: pm_helpers: use opp-table for the frequency")
Cc: stable@vger.kernel.org
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Closes: https://lore.kernel.org/linux-media/CA+G9fYu5=3n84VY+vTbCAcfFKOq7Us5vgBZgpypY4MveM=eVwg@mail.gmail.com
Signed-off-by: Renjiang Han <quic_renjiang@quicinc.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/pm_helpers.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/qcom/venus/pm_helpers.c
+++ b/drivers/media/platform/qcom/venus/pm_helpers.c
@@ -40,6 +40,8 @@ static int core_clks_get(struct venus_co
 
 static int core_clks_enable(struct venus_core *core)
 {
+	const struct freq_tbl *freq_tbl = core->res->freq_tbl;
+	unsigned int freq_tbl_size = core->res->freq_tbl_size;
 	const struct venus_resources *res = core->res;
 	struct device *dev = core->dev;
 	unsigned long freq = 0;
@@ -48,8 +50,13 @@ static int core_clks_enable(struct venus
 	int ret;
 
 	opp = dev_pm_opp_find_freq_ceil(dev, &freq);
-	if (!IS_ERR(opp))
+	if (IS_ERR(opp)) {
+		if (!freq_tbl)
+			return -ENODEV;
+		freq = freq_tbl[freq_tbl_size - 1].freq;
+	} else {
 		dev_pm_opp_put(opp);
+	}
 
 	for (i = 0; i < res->clks_num; i++) {
 		if (IS_V6(core)) {


