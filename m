Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D9931355B;
	Wed,  3 Dec 2025 16:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777981; cv=none; b=n/RpQpJVhOqKJR7SGhwEIiWx7ogNVRHHJaIFVhXAS+BsvNfy3RkQ1sCazSw9CUdTAgyFQ22vlHf3AgRNjBOqgV4W1gtPj4HjfVipeLa3brrUJBHJ18MY90wJ6blCPFps3jMclh5uO9/pdFX/jzlAMjpoQajTjjvgNT7RQJ2W8N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777981; c=relaxed/simple;
	bh=gf7O8OCwFB5AQ2VmJmTZKCmgaghvGkrpfHHKOADx6UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwwBUTPkU/2lU95sN4ot/QrlK1z2RfrrTYF2sB38uXFc9L14okEZM8EpAS8yOPy3cWAJQRypbA5WJO+39BpHfxvIw3iOEWlryjZmR1jMbr3/JwX0zwTPxh+PnLPCYwK1kTDmdNHtcfNsqGCnhvjkLdM7YaRDDg9HcL6I82ghZzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmiX4kx3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmiX4kx3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B8EC4CEF5;
	Wed,  3 Dec 2025 16:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777981;
	bh=gf7O8OCwFB5AQ2VmJmTZKCmgaghvGkrpfHHKOADx6UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmiX4kx36CK820ACShNoDAxhNntotkeiD8lXfbwddDW38tUWXrcJnjz20DysUzeAn
	 EbNusXc5Zvh5+KUy24An2JCiz1BZpy1iiAfa7nLggIjBeium34wtzEeKpWx/0Buh27
	 etyfdJ5betBN17xE+Ta+S4Q9/eQRWJ6jmEOjuljc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 173/392] remoteproc: qcom: q6v5: Avoid handling handover twice
Date: Wed,  3 Dec 2025 16:25:23 +0100
Message-ID: <20251203152420.444057682@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 515c6d68e47ce..ab011371c53e8 100644
--- a/drivers/remoteproc/qcom_q6v5.c
+++ b/drivers/remoteproc/qcom_q6v5.c
@@ -124,6 +124,11 @@ static irqreturn_t q6v5_handover_interrupt(int irq, void *data)
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



