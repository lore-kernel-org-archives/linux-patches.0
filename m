Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E0B268FDE;
	Tue,  8 Apr 2025 12:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115659; cv=none; b=jke6O6fp2op7cR4HETkIva9xkruGbsvMFxjcgDBYJ73Ci53mDXJNwxQ2H2dKuJfeQAv4rkZ4q5SGuHLVySBozhziWskRy4bRm3POMBhIbi+Em7XORPk2TUIy3df+oSlx7YQGWBZiFgWCWN5Q8Bh/gpIjkqLQYs1webaxwAPYYME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115659; c=relaxed/simple;
	bh=yjsdxJfHSncDmLPqb8vyj6JAeNWi8S079BwSrM0r2Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VHocSiKDC+yURbtwvgcsovBofCWBQVnnz/vP4BPLroaOkBWuH1Fzgnj/AXi7m/ewLY/mXEL+d+lp06a96qB49TxFL0hJEwBlw8/g4drA1jibVxzHEOjMJpEI93AAqdCWTNeCiP6Fj7JnS32O8JDPu2jwb7rXEYuMoEFsLCfrX34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=19Q5c5UN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="19Q5c5UN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97EFC4CEE5;
	Tue,  8 Apr 2025 12:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115659;
	bh=yjsdxJfHSncDmLPqb8vyj6JAeNWi8S079BwSrM0r2Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=19Q5c5UNbSJi2iecAf1xRLgrfWbrS4TNlBPwhq5JKKagyXf1WeriHkceLTzHc6oDs
	 JMZkuqFReTZCxg/tAKThK2arMqFTkKaRjsHXbrFAYxMSEYhnuBZ9tWm0qC6MFQgJE1
	 VNQWokmnfj4m92McTz4kkfhDdN0qVhjnBpd6N0QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Luca Weiss <luca@lucaweiss.eu>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/204] remoteproc: qcom_q6v5_pas: Make single-PD handling more robust
Date: Tue,  8 Apr 2025 12:49:46 +0200
Message-ID: <20250408104821.990306185@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 631c90afb5bc5..679e89db85a05 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -389,16 +389,16 @@ static int adsp_pds_attach(struct device *dev, struct device **devs,
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
@@ -423,7 +423,7 @@ static void adsp_pds_detach(struct qcom_adsp *adsp, struct device **pds,
 	int i;
 
 	/* Handle single power domain */
-	if (dev->pm_domain && pd_count) {
+	if (pd_count == 1 && dev->pm_domain) {
 		pm_runtime_disable(dev);
 		return;
 	}
-- 
2.39.5



