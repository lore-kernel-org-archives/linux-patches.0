Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1109C30F818;
	Mon, 13 Oct 2025 15:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367856; cv=none; b=aBC/H4VzLTWXV2M980bpgG0gMXXkk5CHrGKscAV6Cmg8Q8SEU9nmgB5mOwdaU/vQWFRkVWl3gyx8F/K1tGgeRoUMV+v7qdc521i2vL88OdtcgKfiuikoNJEycn48VqyPQXf5aIyaJKoxEfKGropItojyYhNimJH/Vzq7ENdrBNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367856; c=relaxed/simple;
	bh=Oe88VzO31f9E4tv1JWJ+V1S64+5tYjQXEcaiPbxzGvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDVfHIfGpo3nkRyJ3ESshU9DfKAL1lh6IW0q7R/N3V3whSgGqpfCGraMQsTL1tinB8hqYMu7/FmTUzO+y+KmIbNmDzHm5QP7w4BYEtnRt7/gBvBE8KK700VCAOilnvQhDgL0kEN9qbFyT2yzL3Bk8IHc6N8Cjpy6ZhqKw2IqaOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHOs+/Aj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHOs+/Aj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4059AC4CEE7;
	Mon, 13 Oct 2025 15:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367855;
	bh=Oe88VzO31f9E4tv1JWJ+V1S64+5tYjQXEcaiPbxzGvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tHOs+/Aj8WwZIY6MUabr+/irmYm3lThisKgsagpQ98RjcLL1fWVnHhrZ8vzPA2oyX
	 andk+RP8yl0x9ll7zivx9yUqRwE9c896VKyTafjA5S2vrM/YDOpXuDOx0xLsqLZQV7
	 zNfPElJdUCoOzAf9tCH6IMMQHlrMimi38llPG/44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 139/196] remoteproc: qcom: q6v5: Avoid disabling handover IRQ twice
Date: Mon, 13 Oct 2025 16:45:30 +0200
Message-ID: <20251013144320.342921206@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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
index 4ee5e67a9f03f..769c6d6d6a731 100644
--- a/drivers/remoteproc/qcom_q6v5.c
+++ b/drivers/remoteproc/qcom_q6v5.c
@@ -156,9 +156,6 @@ int qcom_q6v5_wait_for_start(struct qcom_q6v5 *q6v5, int timeout)
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



