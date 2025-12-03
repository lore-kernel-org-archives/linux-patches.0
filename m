Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0309D376BD2;
	Wed,  3 Dec 2025 16:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779530; cv=none; b=UXQkivQdPZwQ09K4RlAS00YsSXxx705vqiyIK+zZeCdI6eOKh++Lo6Pvk3XmgvSr0Xn2wbI3ufKnCqbPFFY2z8COj8HaN2snM0uDPJg5x2iKn3fVf7gen1vRNCluwWcu6j35Td80sYsNfg0l5D2YQlPa5OPf+3lWIR1oKctaITc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779530; c=relaxed/simple;
	bh=6S+tOFGHAJnvd5dA8vrAAmGMHmnpJD5oyVUdxJt1Eeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odqpAcpM3/QPP0cjGT8huOq1/pvgmMtk2nSBLGIsiy8BPFZshPynhISDE8BJ0CGVsTiJ7iPVHP9anmCkGm7BgNU9cUF/xh/Up5tmHjP0wNOTUPFKiAKatVCV3zbkfM/OieYRibGJes3URBgTeH4mMO7lzcQ5JCi1q7f+QCHjNJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vF/9u2Os; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vF/9u2Os"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732F9C116B1;
	Wed,  3 Dec 2025 16:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779529;
	bh=6S+tOFGHAJnvd5dA8vrAAmGMHmnpJD5oyVUdxJt1Eeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vF/9u2OsxMjAdqax8Nb3DVcVyNvqnWpAZtXM9DcWJy5KJcDDcxovjxtcC0q/CbpB+
	 3fIRGi+H8Znuo4nTWxLrkQ/MetEzMe8TfXXMSV78FDqPshN1zyfd8i8R3LSIFw9yQq
	 RlB5HN3Mgym3UvNWJIRY7OQuPXIHIVK5jgbOf+54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 252/568] remoteproc: qcom: q6v5: Avoid handling handover twice
Date: Wed,  3 Dec 2025 16:24:14 +0100
Message-ID: <20251203152449.951661598@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6cce6dd9fd232..76bc553da5d62 100644
--- a/drivers/remoteproc/qcom_q6v5.c
+++ b/drivers/remoteproc/qcom_q6v5.c
@@ -170,6 +170,11 @@ static irqreturn_t q6v5_handover_interrupt(int irq, void *data)
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



