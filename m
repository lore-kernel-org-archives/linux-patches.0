Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0FE624;
	Thu, 11 Apr 2024 10:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832484; cv=none; b=XgA2/AKj2HmBPyH8QGR5pieL9pMQZva8jb91RXkOcOY62Hvmwn8lsYuxiuvwcGITmjB+hZfE15ni6tVdeGzSBBmHtvGT7iNKEWt1kZXlwu/UmtTvrBmaWNZPGxwrkvuZ1hCDFruf+h4rc6M+7HnaNPaLgwLaOuumMWp7jLJ+Qm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832484; c=relaxed/simple;
	bh=R9C6O6AbP3biOgpAKb4Tz7aKWBUGi76srQoaoJL43zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRL6jbEI/RkApXqONxW6n2OPmhJqdvnB12xddboAeC2Jdrt/cZ3z5EPp0rrFrttkcnD01NNAySGnbn1f0NJSzLezSpFvBGD0eRtKFG4tG7Tz7g3F8m0CmfFYc8k8wyV+9iJWaO55w0tQKQrwbzilxkYZ9XIWkCmnMByIiwJdmio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nE/5AEWD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nE/5AEWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C21C433C7;
	Thu, 11 Apr 2024 10:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832484;
	bh=R9C6O6AbP3biOgpAKb4Tz7aKWBUGi76srQoaoJL43zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nE/5AEWDrSac2aP6rDdDbvSrLeUeDhhaajakP8fRdyvGQ8mPcjAQ1a3TFwVEsns6w
	 nQmwG6Vok2XsMU6UT7SRxUm2qcjQra5xikZclKQn4ZYjhqBO4LH0sGyjBQ6WAOSBX4
	 LugGAAw2uaRUbe84wcQRyAoX433i1DSvfsbE/ksI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 63/83] thermal/of: Assume polling-delay(-passive) 0 when absent
Date: Thu, 11 Apr 2024 11:57:35 +0200
Message-ID: <20240411095414.581258893@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 488164006a281986d95abbc4b26e340c19c4c85b ]

Currently, thermal zones associated with providers that have interrupts
for signaling hot/critical trips are required to set a polling-delay
of 0 to indicate no polling. This feels a bit backwards.

Change the code such that "no polling delay" also means "no polling".

Suggested-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20240125-topic-thermal-v1-2-3c9d4dced138@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_of.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
index 4104743dbc17e..202dce0d2e309 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -337,14 +337,18 @@ static int thermal_of_monitor_init(struct device_node *np, int *delay, int *pdel
 	int ret;
 
 	ret = of_property_read_u32(np, "polling-delay-passive", pdelay);
-	if (ret < 0) {
-		pr_err("%pOFn: missing polling-delay-passive property\n", np);
+	if (ret == -EINVAL) {
+		*pdelay = 0;
+	} else if (ret < 0) {
+		pr_err("%pOFn: Couldn't get polling-delay-passive: %d\n", np, ret);
 		return ret;
 	}
 
 	ret = of_property_read_u32(np, "polling-delay", delay);
-	if (ret < 0) {
-		pr_err("%pOFn: missing polling-delay property\n", np);
+	if (ret == -EINVAL) {
+		*delay = 0;
+	} else if (ret < 0) {
+		pr_err("%pOFn: Couldn't get polling-delay: %d\n", np, ret);
 		return ret;
 	}
 
-- 
2.43.0



