Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7DE2DE20D;
	Tue, 17 Jun 2025 16:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176002; cv=none; b=T2GVAbQdn5KBXhhz3yRPoQV5v3wM52sWXBF/vKJzMVOa8f4q5KzCLQMKN7yPmBDw3qaQ7H/efYg7TGKdQ7VbV1GvMRNMlKhpM0RMuCfxig6sEqY/eR/AlhvDS3C4C8naZaAJ0ieKfBgRoGPxp968tYAwgK61AaUjQ2ZMZeZkVK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176002; c=relaxed/simple;
	bh=vyKUQYeXYSezeuO0IuawjRVFTav7XZSAzHZJhkZsTyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKyFBn3kWVuvrLa+9HWkOZx0vBarsb/gI4myQW1zGa0A2RmenjnVhwr85TqlRkv15rG08XXmNvamY7MQvMXEg56GC1zGq4PHbxfqeJm90PWwX5hDWd+j6LV7b1+WBk89ZOQIfabFL4u0OwU6SBRfxqOLof2tGDHxOuBPUNlHvwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hvrSbQdG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hvrSbQdG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18044C4CEE7;
	Tue, 17 Jun 2025 16:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176002;
	bh=vyKUQYeXYSezeuO0IuawjRVFTav7XZSAzHZJhkZsTyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hvrSbQdGVmb/P8PwMTv+25+iwxQl3GN26eVsf+DQsP0nOmac4ZAYoKyFASUy52bhZ
	 jYnYcSooHHBTp8kSBTVzvCAOhKQayFHmO8ZF+nxwbRhSTIh6cDLsNBimVqoAvl+TSa
	 7FNeYrqnEKxbs7yfBeyyi+pTuV0kMHVig5ttadEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Winchenbach <swinchenbach@arka.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 234/356] iio: filter: admv8818: fix integer overflow
Date: Tue, 17 Jun 2025 17:25:49 +0200
Message-ID: <20250617152347.614202449@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

From: Sam Winchenbach <swinchenbach@arka.org>

[ Upstream commit fb6009a28d77edec4eb548b5875dae8c79b88467 ]

HZ_PER_MHZ is only unsigned long. This math overflows, leading to
incorrect results.

Fixes: f34fe888ad05 ("iio:filter:admv8818: add support for ADMV8818")
Signed-off-by: Sam Winchenbach <swinchenbach@arka.org>
Link: https://patch.msgid.link/20250328174831.227202-4-sam.winchenbach@framepointer.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/filter/admv8818.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/filter/admv8818.c b/drivers/iio/filter/admv8818.c
index 3d8740caa1455..cd3aff9a2f7bf 100644
--- a/drivers/iio/filter/admv8818.c
+++ b/drivers/iio/filter/admv8818.c
@@ -154,7 +154,7 @@ static int __admv8818_hpf_select(struct admv8818_state *st, u64 freq)
 	}
 
 	/* Close HPF frequency gap between 12 and 12.5 GHz */
-	if (freq >= 12000 * HZ_PER_MHZ && freq <= 12500 * HZ_PER_MHZ) {
+	if (freq >= 12000ULL * HZ_PER_MHZ && freq < 12500ULL * HZ_PER_MHZ) {
 		hpf_band = 3;
 		hpf_step = 15;
 	}
-- 
2.39.5



