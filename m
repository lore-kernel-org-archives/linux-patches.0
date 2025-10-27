Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A539231AF37;
	Mon, 27 Oct 2025 18:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590482; cv=none; b=k231H9hTE1ATSpv2olv6XQVgfJHzyVePXp1nYZyRZ2R1Ypi+47VtTyuBl+ogd0fq+uUJosE7X5Cn9zsVbqETy2hTjqYJfo9QJxyUWvDFLu9Ohl4UV6n2BRctWMb1tqhGeNTxiU2P1PTs1ICInGVIt8dhDl7i8QYDdgNWFAc22Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590482; c=relaxed/simple;
	bh=oYGzH02XzAyC5UwBpAxY18rBDBrEOeg0zYOlO5qWJOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZloy5PQT5DouzkN2hXlIgEoeljIwwyraqBSIEcA0D80Cr1Jtlqtnus/Fg3WokRMUSxFp0aFldVl9E1ldj3kY4F3dBylVANgSpIfYWBM3vIOcI0dVYkDika2e+yOjqqG3ahqtFzfE1JGQ+HKVxAAInxpVydp3iOd6cDo/y0+IbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQpOv6Sy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQpOv6Sy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70D8C4CEF1;
	Mon, 27 Oct 2025 18:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590482;
	bh=oYGzH02XzAyC5UwBpAxY18rBDBrEOeg0zYOlO5qWJOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQpOv6SyeAE94SkHDd9nZIQRDAgVoqsRQ+4yYTeiel5e9F11/eEx/LwngVlMxDJCS
	 JTtrdofx9TWc9d/dzOOCMHdaH2KHDNgkmsAt670ksuEPg9Q+PrCZnQGTiZ9+zngCDR
	 KHDBMoq0FmY+lsopR60n2kOxIHH5DM6HFWdLu6i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/224] remoteproc: qcom: q6v5: Avoid disabling handover IRQ twice
Date: Mon, 27 Oct 2025 19:33:27 +0100
Message-ID: <20251027183510.636047820@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

[ Upstream commit 110be46f5afe27b66caa2d12473a84cd397b1925 ]

enable_irq() and disable_irq() are reference counted, so we must make sure
that each enable_irq() is always paired with a single disable_irq(). If we
call disable_irq() twice followed by just a single enable_irq(), the IRQ
will remain disabled forever.

For the error handling path in qcom_q6v5_wait_for_start(), disable_irq()
will end up being called twice, because disable_irq() also happens in
qcom_q6v5_unprepare() when rolling back the call to qcom_q6v5_prepare().

Fix this by dropping disable_irq() in qcom_q6v5_wait_for_start(). Since
qcom_q6v5_prepare() is the function that calls enable_irq(), it makes more
sense to have the rollback handled always by qcom_q6v5_unprepare().

Fixes: 3b415c8fb263 ("remoteproc: q6v5: Extract common resource handling")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Link: https://lore.kernel.org/r/20250820-rproc-qcom-q6v5-fixes-v2-1-910b1a3aff71@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/remoteproc/qcom_q6v5.c b/drivers/remoteproc/qcom_q6v5.c
index eaeb6aee6da5c..9c9beeb3bcd74 100644
--- a/drivers/remoteproc/qcom_q6v5.c
+++ b/drivers/remoteproc/qcom_q6v5.c
@@ -113,9 +113,6 @@ int qcom_q6v5_wait_for_start(struct qcom_q6v5 *q6v5, int timeout)
 	int ret;
 
 	ret = wait_for_completion_timeout(&q6v5->start_done, timeout);
-	if (!ret)
-		disable_irq(q6v5->handover_irq);
-
 	return !ret ? -ETIMEDOUT : 0;
 }
 EXPORT_SYMBOL_GPL(qcom_q6v5_wait_for_start);
-- 
2.51.0



