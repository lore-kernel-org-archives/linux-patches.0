Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D6A2F199C;
	Thu,  3 Jul 2025 15:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555500; cv=none; b=tKRpdQ+YOHLzWFIZgNuZoIDtVFyN0Frh9Bwe4WR+dmedsD8JnN96HKQetqTYX3w3PwHt1FQf1zqOa2pIZxNNMDuUPKoyK9Yodg/dUKqguZ0cKmRVkMz0KHusSBLFHiABvFB1qgDmDWqZigPyYvTqrhFbdvvl0BPbKHeZGCkVLMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555500; c=relaxed/simple;
	bh=6485hifaYaet7WeyrprFwBeuWYnf3JjYJoK/ZarxNGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPC7gEsTQ1wgHPDkk0M1G877lWwjbrhceKjycTlltc+fDDac/m/iJiC0UrhaTjdXSNZxC3KR2IVTyVEl7wrc5GOxRMeRtHKN7TPKcQCarQ092J76kWhkI7i6nzlddEumn5VCNQo94A9sh3I9VO7IDJZx9I2qeHFKdYoODdedBmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSugO5GI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSugO5GI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7C8C4CEF1;
	Thu,  3 Jul 2025 15:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555499;
	bh=6485hifaYaet7WeyrprFwBeuWYnf3JjYJoK/ZarxNGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSugO5GIikB5rxchw2Lu7+UuKP5YDcwPbu5O/TDe9fPGLfjHjbOHyzxd9Rh1AP1FJ
	 57REYrzT8uqqC7WPS3nnBNo1lRnHHflO+gLjTOgvWnmjafL+LLvScg0aH+BGpnZhLv
	 SWEH5oQUsg8Nn3D9LX0tiCLx5/obfhuBTV8Z9B8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Purva Yeshi <purvayeshi550@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/139] iio: adc: ad_sigma_delta: Fix use of uninitialized status_pos
Date: Thu,  3 Jul 2025 16:41:34 +0200
Message-ID: <20250703143942.402631800@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Purva Yeshi <purvayeshi550@gmail.com>

[ Upstream commit e5cdb098a3cb165d52282ffc3a6448642953ea13 ]

Fix Smatch-detected issue:
drivers/iio/adc/ad_sigma_delta.c:604 ad_sd_trigger_handler() error:
uninitialized symbol 'status_pos'.

The variable `status_pos` was only initialized in specific switch cases
(1, 2, 3, 4), which could leave it uninitialized if `reg_size` had an
unexpected value.

Fix by adding a default case to the switch block to catch unexpected
values of `reg_size`. Use `dev_err_ratelimited()` for error logging and
`goto irq_handled` instead of returning early.

Signed-off-by: Purva Yeshi <purvayeshi550@gmail.com>
Link: https://patch.msgid.link/20250410170408.8585-1-purvayeshi550@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad_sigma_delta.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/iio/adc/ad_sigma_delta.c b/drivers/iio/adc/ad_sigma_delta.c
index 7e21928707437..533667eefe419 100644
--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -476,6 +476,10 @@ static irqreturn_t ad_sd_trigger_handler(int irq, void *p)
 		 * byte set to zero. */
 		ad_sd_read_reg_raw(sigma_delta, data_reg, transfer_size, &data[1]);
 		break;
+
+	default:
+		dev_err_ratelimited(&indio_dev->dev, "Unsupported reg_size: %u\n", reg_size);
+		goto irq_handled;
 	}
 
 	/*
-- 
2.39.5



