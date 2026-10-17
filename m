Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D82355F49;
	Sat, 17 Oct 2026 16:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255276; cv=none; b=E+dBJRP03DvWRoTFurs+qoWDVS04ZOyf/b9GOZkA6bEE2lEpmOF6EGCly0zKJ6x8GE9L1kPdZeqQzDJyQ0AOPWlkEXPL6SXa3cNMTt78gAkiPF0ne3qlDBIBvcz53NfitN9WiKVwuVr/HiJ9HMSat2+fhJUgz/rqXOTID1XRbbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255276; c=relaxed/simple;
	bh=Jd3omAzfdC/TyR3Q3owuLlnF0UQdxqtQy5MJ/0WmtKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PuBImgQMD3qejTDu++W7G8gm/v/dNbcAyrAroO7Qwbq2kzAbe3DMbGzt3u9QILOc1VKuxF6VEe8JtaObV6H3BTw514T6EQLXbM5PVRK1uti3Yw9EVwGXoHA58pwbpC41uPHUGWq3toCX+NKGUkf8kweGAt/4hFUDhpEbRy4s6gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0WzxwV0a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0WzxwV0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998121F000C4;
	Sat, 17 Oct 2026 16:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255275;
	bh=3CX9e6E40d99pMphYScEoxlkcZX27u79y25VigOFvwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0WzxwV0a+xDWXfurUCcQW8RIXfd+Gi2EmLhmmOWuqJg5pPrGzqejeqKssmHqvvcdD
	 0SB2yKkAHMIQoI3/gM35wwfFEFLU8IRyvGUBRx5HAJsjuUZVtuZB99FvpOKZSVg2n2
	 FH6ulh1ijpx9mbx1w5rG6FQNGVO36I8M1DFKtR58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 722/869] remoteproc: qcom_wcnss: Fix handling the lack of PD regulators in v3
Date: Sat, 17 Oct 2026 17:59:23 +0200
Message-ID: <20261017160055.467394109@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



