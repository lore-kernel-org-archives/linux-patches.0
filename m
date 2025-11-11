Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0E31F09B3;
	Tue, 11 Nov 2025 01:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824206; cv=none; b=ZRNrzLqok/vNEVH2ZiaRjQxBEgzBPbpZjlY/SHoLdw9gNChZDsA2H6nlZYA2Zk0r8myrYX21Lgnm5IKaYLKNuEWrGPVld+MdGHcXMETyYZVBsh75GUN8NlOwQfDBeE/OE5aBYoM1c5L0by8i+jg7k9HjlY2LMA3W4skB55SQMbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824206; c=relaxed/simple;
	bh=IbGpFvFNLbc8DSJ2q5XVtj0fstkZQZRVjRolkzKzWKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKsWnogg+EqDTyeny3YzmRlUC2A4gpOc3qzAqjttxZ8a+jABO7AG+np1utighBFGXa4lfPzzHFokVMcAtVs94CFufh0cZXRKl49V9zx+rj88o7Ee/srcPkBdSKqMa1GHuh2nPZPg1ddIWNQy8FPsFSpxzzgkN60sQZpuRnZLKA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=feOynr5X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="feOynr5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A41C4CEF5;
	Tue, 11 Nov 2025 01:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824205;
	bh=IbGpFvFNLbc8DSJ2q5XVtj0fstkZQZRVjRolkzKzWKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=feOynr5XdKrCkAYekt1SFhqnp2xWQxeUHK9i+AogaQuQe7UNXbJ4XI7bvevuvKFzT
	 ezjLhyJLJPQupUgw+ZN6usziF1+MwJnrTdhyeCygkLrgug617rnS7F0U9Ivy3sGTlb
	 Z4+//Dja36qaD6VQTpDmzmdHpuiil1YeGZtlz7C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 410/565] remoteproc: qcom: q6v5: Avoid handling handover twice
Date: Tue, 11 Nov 2025 09:44:26 +0900
Message-ID: <20251111004536.091847220@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



