Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D32F343D6C;
	Fri, 21 Nov 2025 13:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732854; cv=none; b=m17174rRiLQwkIJUeu6PhXslAral6P15t7EiulYNGAQIWNSmYZsph1K85M6tLhmNEM8thhbbFigBgwlhjQHbRo9md4s23DLY7Csv2Znjry0RrL84q38r3QE2tvCFfuaDVUiej0jhhT9CDBj8UYemEzuQoFZy5LjQ4B2z/4G+vDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732854; c=relaxed/simple;
	bh=uR+IzB2iGKqlr27hELKkktKA0iav1jtDjznEHS+7B7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTORK2IabOSWpsadrH5/qFyy1GNOSN47IVrMyxyjapNjWxNFF3CqtWE8LwVauCxfaDWHBwCI4MAA7cHtz4LEy91DnC9Kopcvw2mpjTQSST7yapMUgsTwmaSAmUBD4pBvj3AFwnKdghfwRqFYf3uadoY54Rem66KV/kTWlbNRfmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f99DIzIc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f99DIzIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5344C4CEF1;
	Fri, 21 Nov 2025 13:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732854;
	bh=uR+IzB2iGKqlr27hELKkktKA0iav1jtDjznEHS+7B7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f99DIzIcIiL1m9fCwFwfX+deUzXYfC0TWZCk0TptfuCr55kc8DrbTBs3NjF3jvupv
	 3Cq4Y7PK1N21PtlhEvKsKqhqeAcS/fgaScIu0OtpFNbi7SqBEvTrc/9yYu4fmRqOHC
	 b9Ax4A/TeqBmcMCFTIlknXBksw6GID1Pn3DQc+XU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 266/529] remoteproc: qcom: q6v5: Avoid handling handover twice
Date: Fri, 21 Nov 2025 14:09:25 +0100
Message-ID: <20251121130240.488355157@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 769c6d6d6a731..58d5b85e58cda 100644
--- a/drivers/remoteproc/qcom_q6v5.c
+++ b/drivers/remoteproc/qcom_q6v5.c
@@ -164,6 +164,11 @@ static irqreturn_t q6v5_handover_interrupt(int irq, void *data)
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



