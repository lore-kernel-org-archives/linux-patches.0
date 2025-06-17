Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A7F2F2343;
	Tue, 17 Jun 2025 15:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175345; cv=none; b=SJDmDLm0FhE8N1z+UTEQ6gga7xFlNQmDxYCBsyscmIBWUsRzvKwDsb3bq71K9VfeJBvZXTP2XO+UfGA2v9B2fYt5jlSpi8thMmZEaJcTO/SmwWt6z0crZP56/xqcm1HpHepyHwsPXGf4DfYl2f1Ayjgb9DHbi13fmq9614tLjcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175345; c=relaxed/simple;
	bh=uPoorEqsSN0vLQeF4F0Zwzd+cmvAVUEZNReWjsMofZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SAXdmMvwEaY0EdwRKcFMIGd4g0PvX3/MiHzGfPmq9AlWs1DPWpAu6xWhF4Wnjtqmxp3LyaTS3XGvZ4lNwcjD+VMZaNmw5YZabaJzRBzhCm523I6+pNbkCIMB5zKQqH6+rAK8pA25dg5Da42uEmQxj9S3+I0b6eNcasorbvZI5ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WdEDpFE/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WdEDpFE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7446FC4CEE3;
	Tue, 17 Jun 2025 15:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175344;
	bh=uPoorEqsSN0vLQeF4F0Zwzd+cmvAVUEZNReWjsMofZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WdEDpFE/hVumyZh4XVinEPH5cOuOPRZm/9s3nYoiGpPoe0wDYYkR8bVBUfNadpefQ
	 1Ci+SENjLRnQMXQodysZCFYu9N50Pjt+eflAILZx7ExxLdbu+puAWZ5iMBgVlhPxk6
	 vQnrLiIHDryMOyj0bTcfxnAMgSDFzrob47/AL2VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 117/512] wifi: ath12k: Fix buffer overflow in debugfs
Date: Tue, 17 Jun 2025 17:21:23 +0200
Message-ID: <20250617152424.326578947@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 8c7a5031a6b0d42e640fbd2d5d05f61f74e32dce ]

If the user tries to write more than 32 bytes then it results in memory
corruption.  Fortunately, this is debugfs so it's limited to root users.

Fixes: 3f73c24f28b3 ("wifi: ath12k: Add support to enable debugfs_htt_stats")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/35daefbd-d493-41d9-b192-96177d521b40@stanley.mountain
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c b/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
index f1b7e74aefe42..6f2e7ecc66af7 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
@@ -1646,6 +1646,9 @@ static ssize_t ath12k_write_htt_stats_type(struct file *file,
 	const int size = 32;
 	int num_args;
 
+	if (count > size)
+		return -EINVAL;
+
 	char *buf __free(kfree) = kzalloc(size, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
-- 
2.39.5



