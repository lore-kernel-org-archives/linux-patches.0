Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7E11EE001;
	Tue,  3 Dec 2024 15:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239416; cv=none; b=Fe01TVz60Emib7OxzD7KOG/aUjOD463Tqhf+QJXtQwMQ3cKLlYen7IM5FXHtJcRD3wrKU9kG41vmrUrkI5vnsTWhEk5KxJaeVeXoY3D5hnh9VjudNVrIa62JdlbjUi0MBnXTdyo8dOObORDbGd5wOeIcYk3fO+aARYQWZBgayeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239416; c=relaxed/simple;
	bh=bKWob6JGuL2nWygMn5WlxClo9dzZX02a2zlVaarSITo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h65/TiKb9PcjQaUMUnmGeqosSGYc8dS0mEvRNxxgUp4sCe8DLCaj+1A45sy4rfvnGMRfOq2H5sNBrj8fAImEqSvJcWewnDCO/ey3aXRv9PI0jaGuBAHMXVrpcawaPT45/V8109oSoSMgCuUkQ9HsFxcARTjsmyjyy2Otj71qoAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GptalkMu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GptalkMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA14C4CECF;
	Tue,  3 Dec 2024 15:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239416;
	bh=bKWob6JGuL2nWygMn5WlxClo9dzZX02a2zlVaarSITo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GptalkMuIdv3fjtowumdO1w9bhdZ7sR3BIL/Wa6H2eEzUaD7vvtiRoSRL/bJRXbsF
	 Z8dlIhTEPTbb6GIb15+uDVfV+sLHXW2w+Gr3FsEU+Tauqc7eGU8wU3X6GivNbWVlpA
	 TuyZguiDx4kcF1fdDFuBhaB3HCAVoFvY0FO7czoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <andersson@kernel.org>,
	Raviteja Laggyshetty <quic_rlaggysh@quicinc.com>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 605/817] interconnect: qcom: icc-rpmh: probe defer incase of missing QoS clock dependency
Date: Tue,  3 Dec 2024 15:42:57 +0100
Message-ID: <20241203144019.542728429@linuxfoundation.org>
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

From: Raviteja Laggyshetty <quic_rlaggysh@quicinc.com>

[ Upstream commit 05123e3299dd6aa02508469b303262338c2a661c ]

Return -EPROBE_DEFER from interconnect provider incase probe defer is
received from devm_clk_bulk_get_all(). This would help in reattempting
the inteconnect driver probe, once the required QoS clocks are
available.

Suggested-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Raviteja Laggyshetty <quic_rlaggysh@quicinc.com>
Reviewed-by: Konrad Dybcio <konradybcio@kernel.org>
Fixes: 0a7be6b35da8 ("interconnect: qcom: icc-rpmh: Add QoS configuration support")
Link: https://lore.kernel.org/r/20240911094516.16901-1-quic_rlaggysh@quicinc.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/icc-rpmh.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/interconnect/qcom/icc-rpmh.c b/drivers/interconnect/qcom/icc-rpmh.c
index f49a8e0cb03c0..adacd6f7d6a8f 100644
--- a/drivers/interconnect/qcom/icc-rpmh.c
+++ b/drivers/interconnect/qcom/icc-rpmh.c
@@ -311,6 +311,9 @@ int qcom_icc_rpmh_probe(struct platform_device *pdev)
 		}
 
 		qp->num_clks = devm_clk_bulk_get_all(qp->dev, &qp->clks);
+		if (qp->num_clks == -EPROBE_DEFER)
+			return dev_err_probe(dev, qp->num_clks, "Failed to get QoS clocks\n");
+
 		if (qp->num_clks < 0 || (!qp->num_clks && desc->qos_clks_required)) {
 			dev_info(dev, "Skipping QoS, failed to get clk: %d\n", qp->num_clks);
 			goto skip_qos_config;
-- 
2.43.0



