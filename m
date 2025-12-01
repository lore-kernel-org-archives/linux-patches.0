Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CAF2E54BB;
	Mon,  1 Dec 2025 11:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588575; cv=none; b=gBnljzPrk73POAEbthYDCDTufKKSMF+9lunzMKhiUm8SJGEXJ19mGS40txKHIePlZEtSYAlHNx9Di1ufrVcYPsLmRHVlWOhz37fE8Sgp+vJkqIxqhWrJ1S9yUNimG9THROAaxJTIWxehYPDjVDaiM41cEHcEjmz4PEmxdz4Srn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588575; c=relaxed/simple;
	bh=kRUDjBFO9EjlJzYonkU37OpZyuJL1sWOadfnTo3RWgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYC7e0Jxe9n81aErQSk6T1fXiLe5t7ZMusQQJBTnJ6ewf4VsXI2cHamoYsRdSIxiv6iPeJe/vBa0AKakNLzX8XawSaK0ssm4WrufqBvf/lNtTz5y5m0AytSEPOOopFJtxmtwiFrSPUrXzcLjPd5pqB+OsXTJ9BPXio1vJP71QC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GXDT/z37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GXDT/z37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF522C4CEF1;
	Mon,  1 Dec 2025 11:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588575;
	bh=kRUDjBFO9EjlJzYonkU37OpZyuJL1sWOadfnTo3RWgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GXDT/z37N1Jy3yT9CRMyw7sgLvSQFvW4OwMoyl1xMpiPO/3rvaEGu88oJxiaVS0zq
	 1qGKnEXc/T5jAyT6oHGU3Hd3zPuyBBJyGm3FgzoI/M126mBT3e1u+B0NrWqAh/RRF2
	 zsJguJSyQGkAlN3lW2eXSPiaNSos/uDfK9mQC/r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/187] remoteproc: qcom: q6v5: Avoid handling handover twice
Date: Mon,  1 Dec 2025 12:23:25 +0100
Message-ID: <20251201112244.744668903@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

[ Upstream commit 54898664e1eb6b5b3e6cdd9343c6eb15da776153 ]

A remoteproc could theoretically signal handover twice. This is unexpected
and would break the reference counting for the handover resources (power
domains, clocks, regulators, etc), so add a check to prevent that from
happening.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Link: https://lore.kernel.org/r/20250820-rproc-qcom-q6v5-fixes-v2-2-910b1a3aff71@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/remoteproc/qcom_q6v5.c b/drivers/remoteproc/qcom_q6v5.c
index 9c9beeb3bcd74..a6ddb58330eb5 100644
--- a/drivers/remoteproc/qcom_q6v5.c
+++ b/drivers/remoteproc/qcom_q6v5.c
@@ -121,6 +121,11 @@ static irqreturn_t q6v5_handover_interrupt(int irq, void *data)
 {
 	struct qcom_q6v5 *q6v5 = data;
 
+	if (q6v5->handover_issued) {
+		dev_err(q6v5->dev, "Handover signaled, but it already happened\n");
+		return IRQ_HANDLED;
+	}
+
 	if (q6v5->handover)
 		q6v5->handover(q6v5);
 
-- 
2.51.0



