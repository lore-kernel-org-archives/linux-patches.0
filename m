Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6E333EAFD;
	Tue, 11 Nov 2025 01:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825005; cv=none; b=PvRPSZrscZ1F5cWr1cDbszqZ21ObwifrAONFChh/aBN3ShBt5gVocAl7FWO6A0NXZC3jvsJHBjihVpX/hM93eEn83A4qEHJKnRj58XrS69HoLJ15ssQHFeulSpfE/xkXgrZFpgnKv3isan0AsSP41akqo5YfdRm75mBOE+Mnf3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825005; c=relaxed/simple;
	bh=mMPH3Vjf9I7SczbaOOz2fE6Nxe8sFdKGdHqIf66hWws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFE1cHaw+z+HE5MBGcbxoQizgqwoSxD1zPSwGcueOleTOJwshVEbrhpqjeIFNAXhXbfgJLtcQSM+KpZRcXtwEn6EUyI18d34heEoxo1ihKkLbTGACxijrmHIxY1IbaAZR9+FYvqmOk12SR8xHWnChntag/0pzfSTPkQM9Mgur5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZ7gVhxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZ7gVhxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCE4C116D0;
	Tue, 11 Nov 2025 01:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825005;
	bh=mMPH3Vjf9I7SczbaOOz2fE6Nxe8sFdKGdHqIf66hWws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZ7gVhxB+AX9sYl7F6ty0HWET0dYnBpB7b/gK9wTsYMr8uq1tZ8C8yxs1J93mpSXa
	 0zIhu+AhR3Euy9GRhN9eFT3Z5pf4hNg3A5u32yByAhtb51HRHGDiyYKCYTdawM2umv
	 wjXMT3hX7ChytMFPMeGMMwBbkmTzLUICtNsXWbN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 615/849] remoteproc: qcom: q6v5: Avoid handling handover twice
Date: Tue, 11 Nov 2025 09:43:05 +0900
Message-ID: <20251111004551.296886452@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



