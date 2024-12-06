Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7B0206F1A;
	Fri,  6 Dec 2024 15:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497744; cv=none; b=dxeFRaSGElShtl7MiNnbw3om4oxTrGbpOWVFUw1dOuvY2KCNRwqd6sBWLjNwe0ln4avjqSTVGRNfJtULDXx7+fiBpHI6ZStmX7AvWRziBXLULOWdPRoxeR7mPmR9syJfKILyKfCaB2kJuJqitgVrvBbv8DsgVR+RH3Py6jwRtA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497744; c=relaxed/simple;
	bh=BR4rxIRxbJgPC9PhsYgARAVg/F6Wv0AVkDR2GF37Zb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmIRVOfZ5ifKZdK497vVMjEinlJ3TSXXb2D/PbfOvFI6/6LA9cj30UcJmY8BDW87whcYEe3EtlADXKCh61H2ZWEiANQKderIjHkrrMtTKmCMeXQecBbC6md2rQZKDdlWtqvMYIgp4N7WpUaDQwgtRliHvYV+bfz5NyTBY5meZBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GRbGBjrG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GRbGBjrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B58C4CEDC;
	Fri,  6 Dec 2024 15:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497743;
	bh=BR4rxIRxbJgPC9PhsYgARAVg/F6Wv0AVkDR2GF37Zb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GRbGBjrGfalRIrDmzomlYwqivn7sIqirWlMVYzOSJzCyVvWXSaX78P3GoDCX/xlnd
	 tQlkQIlvBLfaj5xvnqwQZL2Ar6i75EaMTGxhmfouSF+fsmzkVKQoP/veY9i6mpwEJy
	 PZ+SLLzyomY1qHrvTjN1Z1Gdwz+TPzAWhyujSiPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 379/676] remoteproc: qcom_q6v5_mss: Re-order writes to the IMEM region
Date: Fri,  6 Dec 2024 15:33:18 +0100
Message-ID: <20241206143708.152202175@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 22fe7b5f5236d..2d717f2ed396c 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -1161,6 +1161,9 @@ static int q6v5_mba_load(struct q6v5 *qproc)
 		goto disable_active_clks;
 	}
 
+	if (qproc->has_mba_logs)
+		qcom_pil_info_store("mba", qproc->mba_phys, MBA_LOG_SIZE);
+
 	writel(qproc->mba_phys, qproc->rmb_base + RMB_MBA_IMAGE_REG);
 	if (qproc->dp_size) {
 		writel(qproc->mba_phys + SZ_1M, qproc->rmb_base + RMB_PMI_CODE_START_REG);
@@ -1171,9 +1174,6 @@ static int q6v5_mba_load(struct q6v5 *qproc)
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



