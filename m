Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868A82690EC;
	Tue,  8 Apr 2025 11:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113236; cv=none; b=QnDj49btZqLwI1v9QFjWwWPf+zMWW6C3wUHW3Dyty4bpeijkn07x5RatY2UPa16XH9IfDkxj7Mw6TRK+NH1s5gSFkHKDTxYyCuMdf0pi7RvJuCufHZwZLXPU4orVXNpcyva00wh3VdXehPjudeou2ThFP2roslKg9rIey4s+suY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113236; c=relaxed/simple;
	bh=Fd4GwDVNtbyk7ajETLKRUPwNd0DXdBWFipVHuxZBtAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkGmQISJZLCTny7+8TOKQqyakb8vPbczpPjZv/pe8H9iIB/fwkVRJazX+BhUheVZT7BW2DIJ1RcgioJtbmcFvsnbrUETIL3BP7J/kQF/UL4eJGYCmrkBkJKugM5X1d84VbZ4zvwVS7X9sSBZz64bOvnhSGmZSHXczAt1pPhi02g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WYsCrvj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WYsCrvj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19189C4CEE5;
	Tue,  8 Apr 2025 11:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113236;
	bh=Fd4GwDVNtbyk7ajETLKRUPwNd0DXdBWFipVHuxZBtAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WYsCrvj39CO2sVqYuRdC2+PjxAgAWlgsOXOGmBBIEp/e0SQcPeXSvXBE60RPJixDX
	 bpuUjxVZyUcATimyxA2YcTAzNou3XNjWpiwR+7ibdZubHb5CriWWQX7YOPMqKLcPTt
	 Gwjfvq0e3vpPfkXllNrYL87su5BP/OQOAY3l8Xg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Luca Weiss <luca@lucaweiss.eu>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/268] remoteproc: qcom_q6v5_pas: Make single-PD handling more robust
Date: Tue,  8 Apr 2025 12:47:58 +0200
Message-ID: <20250408104830.304282311@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Luca Weiss <luca@lucaweiss.eu>

[ Upstream commit e917b73234b02aa4966325e7380d2559bf127ba9 ]

Only go into the if condition for single-PD handling when there's
actually just one power domain specified there. Otherwise it'll be an
issue in the dts and we should fail in the regular code path.

This also mirrors the latest changes in the qcom_q6v5_mss driver.

Suggested-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Fixes: 17ee2fb4e856 ("remoteproc: qcom: pas: Vote for active/proxy power domains")
Signed-off-by: Luca Weiss <luca@lucaweiss.eu>
Reviewed-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Link: https://lore.kernel.org/r/20250128-pas-singlepd-v1-2-85d9ae4b0093@lucaweiss.eu
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index fd6bf9e77afcb..181f05506864e 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -490,16 +490,16 @@ static int adsp_pds_attach(struct device *dev, struct device **devs,
 	if (!pd_names)
 		return 0;
 
+	while (pd_names[num_pds])
+		num_pds++;
+
 	/* Handle single power domain */
-	if (dev->pm_domain) {
+	if (num_pds == 1 && dev->pm_domain) {
 		devs[0] = dev;
 		pm_runtime_enable(dev);
 		return 1;
 	}
 
-	while (pd_names[num_pds])
-		num_pds++;
-
 	for (i = 0; i < num_pds; i++) {
 		devs[i] = dev_pm_domain_attach_by_name(dev, pd_names[i]);
 		if (IS_ERR_OR_NULL(devs[i])) {
@@ -524,7 +524,7 @@ static void adsp_pds_detach(struct qcom_adsp *adsp, struct device **pds,
 	int i;
 
 	/* Handle single power domain */
-	if (dev->pm_domain && pd_count) {
+	if (pd_count == 1 && dev->pm_domain) {
 		pm_runtime_disable(dev);
 		return;
 	}
-- 
2.39.5



