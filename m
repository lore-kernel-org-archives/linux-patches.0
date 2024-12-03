Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946BB1E766E;
	Tue,  3 Dec 2024 16:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242069; cv=none; b=m+3GbzJwXMfiidbvC+ETkneZAVZMr+/aOeujoE+HwEGEERCODOdeFd8y0azm1vH/byOcB35RrUzsGDDW2F8dlmpSB0LxKatl+cAsOGZ2/rHSpLxdZSSb3NoyQayetpKphEtZChLpSdKpLdt23YAP5Ul5eQ5eVSc7S8ChaLbMBJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242069; c=relaxed/simple;
	bh=Z6PIrt9cCnmiIBIzVMvw4Y05rOQmzI8BoDkwNIcLUQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJfEhj1l/7x6uzI3NS0HnPD30jzE60+F9obsZAHL3HYPO0i4Q8S11b2xiCeGxD89wX4bGOtYOPjnN9sleF2BrzHstci3o9Rxtt1QkLyE5EnbzFfJigWUntaPXBiIQWqhT/k+FpYOYDO2lNx/AU5qA0dfQHAbUHx4U2M8nocQpZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VK5IHfqX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VK5IHfqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD0FC4CECF;
	Tue,  3 Dec 2024 16:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242069;
	bh=Z6PIrt9cCnmiIBIzVMvw4Y05rOQmzI8BoDkwNIcLUQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VK5IHfqXW4fCMru8ih7EvAqc5pYKTUWIC0KDCIwBua37ixc04IHLiLNMCJB5KF9Yd
	 ngay5ZPPSTLTXXbbUOgTHX+EOo3KC0UYSV96XTfMZTq+erynHT8EwZ14W+aWTudVNW
	 E4lKZnir6EpLw6Fm9x9iVI06Cdzh5YBc2SMgot4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <andersson@kernel.org>,
	Raviteja Laggyshetty <quic_rlaggysh@quicinc.com>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 598/826] interconnect: qcom: icc-rpmh: probe defer incase of missing QoS clock dependency
Date: Tue,  3 Dec 2024 15:45:25 +0100
Message-ID: <20241203144807.082973135@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



