Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FFE225405;
	Thu, 12 Dec 2024 16:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019782; cv=none; b=sPlSNV+SMWlfMrm7X1QvRP1suED7CQW8jCLdzPwYpBvc2/dbq8vqtuHvTa2XPjeDjtNvFLWRSVb5RJ1IGqfCyN61AG2xat/6fnpTabkw6Y7eccDbEQGiwfUJlfZQ7usyWGTR8LAZEuslryhxvuq1EkydzI49CrDNTQwqCN4BAZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019782; c=relaxed/simple;
	bh=Hkx31Qoa7cPJFLZx7q50S0myZYrHhVnj1lNVD9PhdfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b89F4FH895AwGzWjQlG8XLOG/cxTlZPL+ieYE98xazp168aU17nPjgtx48id+x3ER3xvQc+I4gJ7s/iEgLHjxLAPdQEkA8//woOqMUWJCe1Qo6+TutpGKUmUAeC2rWEfg6RngvkzA9K3/ktEj83Wi2Btu6vhKqyouVUtjOyXmVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yPsdmd9c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yPsdmd9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D70C4CECE;
	Thu, 12 Dec 2024 16:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019781;
	bh=Hkx31Qoa7cPJFLZx7q50S0myZYrHhVnj1lNVD9PhdfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yPsdmd9cSEUt3Zs4gUGGTlpd3juxdOs+WTNIsXESMYX7sETaroLRhDxFmAAgaGWAG
	 LYxfcYCYzFWcMrgxY7/Q55xHL7IOsT0pwayPoJ4hUIIKINzc9/pveDs1Ww7/rTqb+7
	 Ml37hRdRufj52FJAspS8W/sN+AU/0n3Z+2glJCKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 289/772] remoteproc: qcom_q6v5_mss: Re-order writes to the IMEM region
Date: Thu, 12 Dec 2024 15:53:54 +0100
Message-ID: <20241212144401.846510027@linuxfoundation.org>
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

From: Sibi Sankar <quic_sibis@quicinc.com>

[ Upstream commit 7b22b7719fc17d5979a991c918c868ab041be5c8 ]

Any write access to the IMEM region when the Q6 is setting up XPU
protection on it will result in a XPU violation. Fix this by ensuring
IMEM writes related to the MBA post-mortem logs happen before the Q6
is brought out of reset.

Fixes: 318130cc9362 ("remoteproc: qcom_q6v5_mss: Add MBA log extraction support")
Signed-off-by: Sibi Sankar <quic_sibis@quicinc.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20240819073020.3291287-1-quic_sibis@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_mss.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index 7dbab5fcbe1e7..e4ef8e6ed8aaa 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -1118,6 +1118,9 @@ static int q6v5_mba_load(struct q6v5 *qproc)
 		goto disable_active_clks;
 	}
 
+	if (qproc->has_mba_logs)
+		qcom_pil_info_store("mba", qproc->mba_phys, MBA_LOG_SIZE);
+
 	writel(qproc->mba_phys, qproc->rmb_base + RMB_MBA_IMAGE_REG);
 	if (qproc->dp_size) {
 		writel(qproc->mba_phys + SZ_1M, qproc->rmb_base + RMB_PMI_CODE_START_REG);
@@ -1128,9 +1131,6 @@ static int q6v5_mba_load(struct q6v5 *qproc)
 	if (ret)
 		goto reclaim_mba;
 
-	if (qproc->has_mba_logs)
-		qcom_pil_info_store("mba", qproc->mba_phys, MBA_LOG_SIZE);
-
 	ret = q6v5_rmb_mba_wait(qproc, 0, 5000);
 	if (ret == -ETIMEDOUT) {
 		dev_err(qproc->dev, "MBA boot timed out\n");
-- 
2.43.0



