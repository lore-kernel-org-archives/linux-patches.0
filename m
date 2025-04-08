Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FACA276033;
	Tue,  8 Apr 2025 12:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116356; cv=none; b=t9SIkH3xktyHPMursUGsdQ6lwwWFZpOOUUl//fBDbFHM4TzoNg8TnySBeMHLCS2iFE5eOy+jd0VkYIXIQBI8XLDcWbGwlwVRWAv/TzurOVfn2NIMvjnBHyN0am/N1Clv0rVQ7r3fjulCSvzPY84/4ATTD+SJB5FVVvMOpDG2GqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116356; c=relaxed/simple;
	bh=+BJgHJmGRTiK0ZUptKrYGk/AA3Qg4knz/D1Krj9qMuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVpJGhMs0fbrlMDR/0ctgiFkquL1tEicLhLA3QZw//WahNmpB63CWjKkbVAObRZTK+X80bImFlHOyTmUW+aikLEGvLVwHrfTSvI3d82lhnKZPDOAoJtiq2lmlWbjr3w9Bax1n1YR/3KL/TetWJqKy6VssDsW1cN8Xww843AfsZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qCODtaZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qCODtaZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C82C4CEE5;
	Tue,  8 Apr 2025 12:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116356;
	bh=+BJgHJmGRTiK0ZUptKrYGk/AA3Qg4knz/D1Krj9qMuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qCODtaZcdFptQlTlk4qCUD4nS9eGIvYOtzmggLyl/iGCXcGG/B91uX0E8Y8xEqBnx
	 bn0xLFY15MfDK6JAQUQWomed6xg9bvG/j8Pm84Ddv0MxwOTpHsMWymw02lkh82epMx
	 yTI+ENFp4gBdj8x+Shh7p5BpR1WXhDh8sQLIaGLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Luca Weiss <luca@lucaweiss.eu>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 110/423] remoteproc: qcom_q6v5_pas: Make single-PD handling more robust
Date: Tue,  8 Apr 2025 12:47:16 +0200
Message-ID: <20250408104848.294496005@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1a2d08ec9de9e..179a0afd5fe6f 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -509,16 +509,16 @@ static int adsp_pds_attach(struct device *dev, struct device **devs,
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
@@ -543,7 +543,7 @@ static void adsp_pds_detach(struct qcom_adsp *adsp, struct device **pds,
 	int i;
 
 	/* Handle single power domain */
-	if (dev->pm_domain && pd_count) {
+	if (pd_count == 1 && dev->pm_domain) {
 		pm_runtime_disable(dev);
 		return;
 	}
-- 
2.39.5



