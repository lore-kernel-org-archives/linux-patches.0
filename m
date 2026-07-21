Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF73C3ED3B2;
	Tue, 21 Jul 2026 15:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649390; cv=none; b=bKejt18ddE3Fa5aI6m5A2E+cotUc07dK1UzcB8JdtTkMKxgTcfwIDmGNvPQ2gvg3XkaW/XT3xmRWiTIVXjOLRnvKZZCGDH0Qg97C547GAJ4ci2e8Q87etf0ICPGNCfA5PJGtgf46eymTQdV2lpT2tGbpRrJc2HX2ss5z/IwHIKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649390; c=relaxed/simple;
	bh=mY+2nIbnQ/iZe/qBYCaY27xtriuBJgeGBz0UdCApjsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJRbc/r3uz+kAokZVKrlc7BkB1Gznc99pnptGfesP5rYljyxGnqTmwLNa2s3wmhVGi7sM2mz9ZgrRSArwwGg31qi8jkp35+qVZHR+14fAoc1DLvmFdFYRYf5vcgeIFJnc1oBUzT4fM9KTZ+nh0KYaKhD0MMATdunrcLSLUdul/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V11pU/HF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V11pU/HF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C031F000E9;
	Tue, 21 Jul 2026 15:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649389;
	bh=uybwoMA79/JvzOutASlUjemmotgRKf8HDZeqhYU80qA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V11pU/HFMZZx5ZX3bAT7BJ/ZqerwrsQ4laC1zzHhvcoTdKAL52V643FuKRz75J7+o
	 ZvlkviFkzCnA9n0vy1ruUorjSlvE6hLrvx0I/NYBDnaNwe28bKKnC/Q6iBtawnqd0y
	 MLOPZM4882uiZTm9N31si3atfMWiZZmSDSqOaxmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sneh Mankad <sneh.mankad@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0561/2077] pinctrl: qcom: Fix resolving register base address from device node
Date: Tue, 21 Jul 2026 17:03:54 +0200
Message-ID: <20260721152606.043790400@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sneh Mankad <sneh.mankad@oss.qualcomm.com>

[ Upstream commit 4e31ab47997540d0ff4c9de801741bed03c1ab3f ]

Commit 56ffb63749f4 ("pinctrl: qcom: add multi TLMM region option parameter")
added reg-names property based register reading. However multiple platforms
are not using the reg-names as they have only single TLMM register region.

Commit tried to handle this using the default_region module parameter,
however this condition is unreachable as the error return precedes it by
just checking if reg-names property exists or not, making it impossible
to use tlmm-test for the SoCs (x1e80100) which don't have reg-names
property in TLMM device.

Fix this by moving the default_region check at the start of the
tlmm_reg_base().

Fixes: 56ffb63749f4 ("pinctrl: qcom: add multi TLMM region option parameter")
Signed-off-by: Sneh Mankad <sneh.mankad@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/tlmm-test.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/qcom/tlmm-test.c b/drivers/pinctrl/qcom/tlmm-test.c
index 7d7fff538755a2..4ac96538a417fc 100644
--- a/drivers/pinctrl/qcom/tlmm-test.c
+++ b/drivers/pinctrl/qcom/tlmm-test.c
@@ -581,6 +581,9 @@ static int tlmm_reg_base(struct device_node *tlmm, struct resource *res)
 	int ret;
 	int i;
 
+	if (!strcmp(tlmm_reg_name, "default_region"))
+		return of_address_to_resource(tlmm, 0, res);
+
 	count = of_property_count_strings(tlmm, "reg-names");
 	if (count <= 0) {
 		pr_err("failed to find tlmm reg name\n");
@@ -597,18 +600,14 @@ static int tlmm_reg_base(struct device_node *tlmm, struct resource *res)
 		return -EINVAL;
 	}
 
-	if (!strcmp(tlmm_reg_name, "default_region")) {
-		ret = of_address_to_resource(tlmm, 0, res);
-	} else {
-		for (i = 0; i < count; i++) {
-			if (!strcmp(reg_names[i], tlmm_reg_name)) {
-				ret = of_address_to_resource(tlmm, i, res);
-				break;
-			}
+	for (i = 0; i < count; i++) {
+		if (!strcmp(reg_names[i], tlmm_reg_name)) {
+			ret = of_address_to_resource(tlmm, i, res);
+			break;
 		}
-		if (i == count)
-			ret = -EINVAL;
 	}
+	if (i == count)
+		ret = -EINVAL;
 
 	kfree(reg_names);
 
-- 
2.53.0



