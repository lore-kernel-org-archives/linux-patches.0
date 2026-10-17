Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C082D73A6;
	Sat, 17 Oct 2026 17:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257080; cv=none; b=BgQKXq+5T4ZBo+I7ifX1CMc9a9Ci1pai8Qyeupnn5vjxUccA176L5Je2cuE06JSUxv11vNkE/wKxedMm2D6UwKJCu7BKYP+oUwAg2Sn+33FFbjrCto/1ilDjh7kDC1WY7A8VdKk0Hvkl4nwuO5XkwX9LJJepGlM8IkrHiIeE8aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257080; c=relaxed/simple;
	bh=8JyiP4T5BFWJQex0cnZcjf+G/uz370aoCGi6ehGPcts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpkHmdkpX+VEjJaokjTWkNR4151KN6lmekch7cXMcb3XVDBTYz2pvnn4DF6X2RfmyjCKVgUsS3rYsTbWNl+9crsYwzzt9EoSGFTY8I3Q7kBkOjNPgADqypHzP4SydjoMgLRE3xan+qiNHL4Ccs784f17csfB01lV6Q7Jhg6CD8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tAqLH6nM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tAqLH6nM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22A51F000C4;
	Sat, 17 Oct 2026 17:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257079;
	bh=cPtMVhOkbJq/CXwRXrGxv8jFn247b9ekjbrzEFNIjyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tAqLH6nMM55X8iamgLEpwAy1yI9gcKgKH4wowrzRGatZ7axZ6gYIkM0kbWcNYnLTt
	 2tm3Pvh4YwwV+0ZL5ruz+X/FRhj3bwVHW1DyDVp5RTaOrUIAPmnpa7XU0Gzm54XMmm
	 n+s0SP+jO+RmizrqGERHegeT1324b7BTizagC1Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0446/1674] iio: adc: aspeed: propagate reset deassert errors
Date: Sat, 17 Oct 2026 17:45:18 +0200
Message-ID: <20261017160442.568468589@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 95e4eb426b4bd666fa2f37886c0ddf74a0cc6167 ]

aspeed_adc_probe() continues to register ADC resources after deasserting
the shared reset, even if the reset controller reports a failure.

A failed deassertion leaves the hardware unavailable, so stop probing
before installing the cleanup action and enabling the ADC.

Fixes: edf7550a1f93 ("iio: adc: aspeed: Deassert reset in probe")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/aspeed_adc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/aspeed_adc.c b/drivers/iio/adc/aspeed_adc.c
index e6a9d8d77af53..4cb2210cb38d7 100644
--- a/drivers/iio/adc/aspeed_adc.c
+++ b/drivers/iio/adc/aspeed_adc.c
@@ -553,7 +553,9 @@ static int aspeed_adc_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, PTR_ERR(data->rst),
 				     "invalid or missing reset controller device tree entry");
 
-	reset_control_deassert(data->rst);
+	ret = reset_control_deassert(data->rst);
+	if (ret)
+		return ret;
 
 	ret = devm_add_action_or_reset(data->dev, aspeed_adc_reset_assert,
 				       data->rst);
-- 
2.53.0



