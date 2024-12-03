Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD9C1F757E;
	Tue,  3 Dec 2024 15:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239217; cv=none; b=W5VY0FEFyUesnDC8Yd/EPhEHnO4Tj8Y5Ky1kOS/Exvn8CEAWqz4aIuZCEuiGEJVqfWWN7+6GV7QB4SBGXioLqXpfdUPvCXxPqCWZ82+P9Sx613XjVopotTwqRwtH/9vZtx7FYFjIAC2tSMRPkh4jce/tTF5te16gi4dueexhkrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239217; c=relaxed/simple;
	bh=ueeSfx+oqPOB9zDTYjcGDhtjm3Z3W+HisNoiTBorL+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQP7V+1c7DP4hJG1wQQqghNVdgRIYCeK97qK+tIyeLExeC4CL+0zMeJ4ieSxYwqx5M+tRcsQihTicBFXBvKHtGMxeCJClbVThR7IlBP0wtc5+pzinCV8E0xLKSG303lviWOTK15KLmmyny3LF1gD3N2vCzETNkxhF8hPZa/XKds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xx5UBhgD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xx5UBhgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA8AC4CECF;
	Tue,  3 Dec 2024 15:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239217;
	bh=ueeSfx+oqPOB9zDTYjcGDhtjm3Z3W+HisNoiTBorL+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xx5UBhgDFzIBFb1U99NcZ8W7dFrmUjimmCT6zwPcAAa019jkbWQEGMNGtNYXGx4aM
	 2VHGoM5dTrmjj05lEsatqBKW3+hjbL9VlXm5ljdvIfNdylE2RBMGzud7sFdOssRQRf
	 7GVrQkrLDBDLT4c3dPSM6o3YYnNhwABoMEzCZATU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 538/817] remoteproc: qcom_q6v5_mss: Re-order writes to the IMEM region
Date: Tue,  3 Dec 2024 15:41:50 +0100
Message-ID: <20241203144016.903523296@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 2a42215ce8e07..32c3531b20c70 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -1162,6 +1162,9 @@ static int q6v5_mba_load(struct q6v5 *qproc)
 		goto disable_active_clks;
 	}
 
+	if (qproc->has_mba_logs)
+		qcom_pil_info_store("mba", qproc->mba_phys, MBA_LOG_SIZE);
+
 	writel(qproc->mba_phys, qproc->rmb_base + RMB_MBA_IMAGE_REG);
 	if (qproc->dp_size) {
 		writel(qproc->mba_phys + SZ_1M, qproc->rmb_base + RMB_PMI_CODE_START_REG);
@@ -1172,9 +1175,6 @@ static int q6v5_mba_load(struct q6v5 *qproc)
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



