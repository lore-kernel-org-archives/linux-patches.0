Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620D5314A91;
	Wed,  3 Dec 2025 15:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776296; cv=none; b=HZGtoxp+GS6lWaAgY0ZhQPRPoLnWliyG5TsPQ/tr3wXHgUUvfoHSXpOSNoLif5FCJxSwu/yw1sXQEtMlE33LRBWQvoAx89DI3eQ/m8kmqfgMF5gu2KmykHwJkMXrPl+uCIltxa3hIhUJTM8NhZ9PGe406ny8jBd2rzCjO5h6DmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776296; c=relaxed/simple;
	bh=4uzDUzjEh7zA6Murk2AKauqhGg6B4h/Yt42eTseKZz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0qpdTa2V7brwEVVyv1qzajM5LN+2X4csB9mxGIkWHFx6+tl7WcZ8UJGNOKpLUExKgTjHctPh9J5A7xu9Xh9IvVGrtVdTAeTjq6KfN6plI5IyJZH1DRmYgzwBpvmbZ4G1mZnKgNqwzrYydxFflCOTyTIGVr9a6cyq1vcPfijzGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UioCEa5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UioCEa5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2FBC4CEF5;
	Wed,  3 Dec 2025 15:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776296;
	bh=4uzDUzjEh7zA6Murk2AKauqhGg6B4h/Yt42eTseKZz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UioCEa5m1hRCBhqefIeV3lXx3sJPPni6GSe8YDYEuV0nfT/8ozZ8Zs9Uu/ZbkQhQv
	 c3t+oWq8TD/71UHYQoGk6OfuZqdjAyNqTckFhpqj2rrKG3l4bcqpjaCbJ4NLvEpezH
	 VIM9qYxQOxB9TyVUIikDVkvs3LUQsTkJaiintZgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 133/300] remoteproc: qcom: q6v5: Avoid handling handover twice
Date: Wed,  3 Dec 2025 16:25:37 +0100
Message-ID: <20251203152405.542097042@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f2080738ca05e..82e28eb4d477d 100644
--- a/drivers/remoteproc/qcom_q6v5.c
+++ b/drivers/remoteproc/qcom_q6v5.c
@@ -123,6 +123,11 @@ static irqreturn_t q6v5_handover_interrupt(int irq, void *data)
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



