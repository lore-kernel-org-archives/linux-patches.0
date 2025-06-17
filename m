Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0672F2346;
	Tue, 17 Jun 2025 16:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176334; cv=none; b=c8zqXityDNTmnzvtYxgNQ5gHYdnKr4OwgUqcGGRTOKHpu0OQ0tIdDmHsN5WO2SfxPqjXcP0tXmlkcrmjm7nISGi7+V/d9IsqOrKDAe7Ff74NwJXyaBLS792v+m8srgRM938fhNIj8RMfg/JsZb+IGfBJZanUmFZwU61aDOE3gP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176334; c=relaxed/simple;
	bh=cXHIzIrzF3uOMmEReQ5HgSgFjvPZeWg92DualDz8YPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQIBKdv4WOc4FJgwjyU1XMWAhJZBLiK7HQq/UWPFiuA3gpWcJp6hZ5hCMqh2ntnAgaUh27v/4QtctFlo0oDZ1o5FRXcpoYLl5LZsVyLkcv27xkDfvgrVWYABmlfihmz5cLFzqbYzER/3bxJWqQJvxUGRe7HFyCVQyQMuNxgzZ8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PRXOmA/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PRXOmA/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF801C4CEE3;
	Tue, 17 Jun 2025 16:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176334;
	bh=cXHIzIrzF3uOMmEReQ5HgSgFjvPZeWg92DualDz8YPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PRXOmA/VAOj5ofTdvMnwRyrdk0W2hwGFWF72PCBwImONV6UtnUiK9SNkq5Gzj4MQ0
	 LOMWJRCbudZNa1uHJUsdkXIVG/abWUgbld9sHkaQtUE45UKD3P55L681qEoZ3gh1VY
	 xF802f+fK5tBDcBSnqahvDDXfHlMPxGAtuRzTQ0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 179/780] wifi: ath12k: Fix buffer overflow in debugfs
Date: Tue, 17 Jun 2025 17:18:07 +0200
Message-ID: <20250617152458.762527565@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1c0d5fa39a8dc..aeaf970339d4d 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
@@ -5377,6 +5377,9 @@ static ssize_t ath12k_write_htt_stats_type(struct file *file,
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



