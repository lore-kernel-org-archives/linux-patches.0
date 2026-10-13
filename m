Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAB74F5E06;
	Tue, 13 Oct 2026 12:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894250; cv=none; b=ejCv0fyQGkrH5Fxd7KLCMjXzTV/CQ26DH+TE6+a+Oqbp8GGOWM2nf708+cdXUlo1Mv/cP57HuFVtLUAFCIdsqdn/INmcHAN/pqQvHa0DGz/ye3r3mhGpRQCGaKM49yJem9bx7cTedBEyEX6FStjg3Dar0CP+mSLlVOgeXw5Nkj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894250; c=relaxed/simple;
	bh=B++Cc6NHraGvlUs9toncVbh0aL04Ct70yPXm1sr66Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCo1UuP1RvX1QWutvrn0BIxjc0kGNUUBOCBRkupD9nOOY7ayuGUucufFpxoxBxIuxTrjEy4dxiN9RvTFvUrq506gg2jCWUERfUw0sVqHvP+ya8UEYgOYhr6uEQzevJnV8PcOZpw/3OFeP3xQnnnm5Rcb+4av7tczsXFuyut3RwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUsV76vp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUsV76vp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595151F00893;
	Tue, 13 Oct 2026 12:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894248;
	bh=jvL3KOhOfTDEuyeN4AVi0UX3x+IFqV7cB4PZ8MXL/+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pUsV76vpt3XmHBO1E+0dL3P1ExocfQ4GAZxC07kG0lu8E39DvogfRADVgdfaMmEMG
	 pclb9qTmacvgHdt4o54mszGlnBInZVqGYeeUvPcF4LueoogLV/N25HdQmYj19djRDz
	 MUYPFPn0Obo067uiOYxYodNFX/3mowMfUdr0cqYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 498/621] remoteproc: qcom_wcnss: Fix handling the lack of PD regulators in v3
Date: Tue, 13 Oct 2026 13:38:13 +0200
Message-ID: <20261013112932.646577676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Val Packett <val@packett.cool>

[ Upstream commit 3dbc90b9c22ea96e37bf55f6011e63b5123ec668 ]

The changes introduced to handle single power domain platforms have
swapped the info pointer increment from num_pd_vregs to num_pds, which
would shift the info pointer past the end of the array for pronto-v3,
which does not list power domain regulators in vregs.

This showed up as a difference between GCC- and LLVM-compiled kernels
on SDM632 devices, where only with LLVM one would get the
"regulator request with no identifier" error, because the out-of-bounds
memory ended up being zeroed. Fix by skipping the increment when there
are more power domains than regulators.

Signed-off-by: Val Packett <val@packett.cool>
Fixes: 65991ea8a6d1 ("remoteproc: qcom_wcnss: Handle platforms with only single power domain")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Fixes: 65991ea8a6d1 ("remoteproc: qcom_wcnss: Handle platforms with only  single power domain")
Link: https://lore.kernel.org/r/20260201210230.911220-1-val@packett.cool
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_wcnss.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/remoteproc/qcom_wcnss.c b/drivers/remoteproc/qcom_wcnss.c
index 2c7e519a2254b..0a0eb1d7da829 100644
--- a/drivers/remoteproc/qcom_wcnss.c
+++ b/drivers/remoteproc/qcom_wcnss.c
@@ -441,25 +441,31 @@ static void wcnss_release_pds(struct qcom_wcnss *wcnss)
 }
 
 static int wcnss_init_regulators(struct qcom_wcnss *wcnss,
-				 const struct wcnss_vreg_info *info,
-				 int num_vregs, int num_pd_vregs)
+				 const struct wcnss_data *data)
 {
+	const struct wcnss_vreg_info *info = data->vregs;
 	struct regulator_bulk_data *bulk;
+	size_t i, possible_pds = 0, num_vregs = data->num_vregs;
 	int ret;
-	int i;
+
+	for (i = 0; i < WCNSS_MAX_PDS; i++)
+		if (data->pd_names[i])
+			possible_pds++;
 
 	/*
 	 * If attaching the power domains suceeded we can skip requesting
 	 * the regulators for the power domains. For old device trees we need to
 	 * reserve extra space to manage them through the regulator interface.
 	 */
-	if (wcnss->num_pds) {
+	if (possible_pds >= num_vregs) {
+		/* Do nothing if vregs do not include PD regulators (pronto-v3) */
+	} else if (wcnss->num_pds) {
 		info += wcnss->num_pds;
 		/* Handle single power domain case */
-		if (wcnss->num_pds < num_pd_vregs)
-			num_vregs += num_pd_vregs - wcnss->num_pds;
+		if (wcnss->num_pds < data->num_pd_vregs)
+			num_vregs += data->num_pd_vregs - wcnss->num_pds;
 	} else {
-		num_vregs += num_pd_vregs;
+		num_vregs += data->num_pd_vregs;
 	}
 
 	bulk = devm_kcalloc(wcnss->dev,
@@ -612,8 +618,7 @@ static int wcnss_probe(struct platform_device *pdev)
 	if (ret && (ret != -ENODATA || !data->num_pd_vregs))
 		return ret;
 
-	ret = wcnss_init_regulators(wcnss, data->vregs, data->num_vregs,
-				    data->num_pd_vregs);
+	ret = wcnss_init_regulators(wcnss, data);
 	if (ret)
 		goto detach_pds;
 
-- 
2.53.0



