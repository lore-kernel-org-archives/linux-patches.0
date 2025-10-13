Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE8E30C612;
	Mon, 13 Oct 2025 14:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367260; cv=none; b=eGP7HYEXj4jTnNIzXXYaE5OMtekldZp3PunKH5MrllrmHi3SurqgRg6CnGsozYvjS81OQxyKZAbChPaNDrEWoYZdj/tMp6NyZYsyrG+ZsDyszJLAa0+z91/QJrgrjsfXuIsP0cmUGHA/63L95zLDQkxfLp7XRXCMHSFsOdEVXF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367260; c=relaxed/simple;
	bh=L1IK29+S10OOcHhDWZwQJ5w9ICY2lZ8/DogndxN6PfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eA1a3d2QIv44sXkkKQATwf3VZhMqpguaMiCIeyLbg8YDbbYGv0oQFKerJ/Ajr5FlWbF4E968cXk3LxXGi/NYIXDBNEQY3vmu33cZ2PvyZgWbHaQoI0Rkjx30QU0rXsrzCnqUljU7PdryJs5Ek+znn2tLjhLKsYKJ97LLB+2qF8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NTzyzsRN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NTzyzsRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4491DC113D0;
	Mon, 13 Oct 2025 14:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367260;
	bh=L1IK29+S10OOcHhDWZwQJ5w9ICY2lZ8/DogndxN6PfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NTzyzsRNvVUNMelZiTrRiYvHqxCZL6gevgO+S+bUQulh0GriPCWkRdFMY2Yk9W+jR
	 tri5LqO30GLnw3QipFIKjHSxh+75j+PFDwzXuUpVkLlKeFQ3EV9juNQ0FjYZ5S3NE2
	 ZzBKSrSAxJdwWvpNnckHBKpxVmR1EkoM3KJoZARM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 147/196] remoteproc: qcom: q6v5: Avoid disabling handover IRQ twice
Date: Mon, 13 Oct 2025 16:45:20 +0200
Message-ID: <20251013144320.015880621@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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
index 497acfb33f8f8..6cce6dd9fd232 100644
--- a/drivers/remoteproc/qcom_q6v5.c
+++ b/drivers/remoteproc/qcom_q6v5.c
@@ -162,9 +162,6 @@ int qcom_q6v5_wait_for_start(struct qcom_q6v5 *q6v5, int timeout)
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



