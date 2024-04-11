Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496011448EF;
	Thu, 11 Apr 2024 10:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830487; cv=none; b=gZRKEdVntFHgUb4DfEGJZNzTlAvqI/wILgR2+20vr20KvLqg9ECBtCes5VafuWuGOkACXoiEEmiU2Q8F3013KWVzg/VxM91h+KB8C0L3f04CW5uk7ePQCvhFoFwSGSwIGDlBPKaGXg0mlAKOwC/p1MOA7mkQQNFnLBeqVgwlq1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830487; c=relaxed/simple;
	bh=9IA2xD6wBSFyciFBvfsMiSelFXkxHAAEyhztMJtLz9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FI1GLyXWBwHZZphaEDF17zNHCXn+lk9CsmyYRatIYm5WojqDXPU04mfUKUuf7BLzqsO6KattamEq6eh3bx7B3zaNQJ0q4LOTjQoGwNz2hIip29PWWPmRiTWtev9zl+YtgLX5h7af+0kreNQ2tfrx77VEOM4rU1VHo9OOakS0bpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1EuQE6ew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1EuQE6ew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C3FC43390;
	Thu, 11 Apr 2024 10:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830487;
	bh=9IA2xD6wBSFyciFBvfsMiSelFXkxHAAEyhztMJtLz9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1EuQE6ewARm7/xGoRDbKy2FI1WadCyoSu0lN3dI9NN9cdcpxSsmp9ReOF4wVDY2d/
	 YedhbpOhX+vWld1bs3iMaGGoEayQgxj1/y9RgeZNksX3HuKRQo11wCj4vvgIReAeF3
	 rxPhK5+KmEGXDZD4IDWrHRahfh4EX6laMO3FcApA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 019/215] crypto: qat - fix double free during reset
Date: Thu, 11 Apr 2024 11:53:48 +0200
Message-ID: <20240411095425.461361253@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>

[ Upstream commit 01aed663e6c421aeafc9c330bda630976b50a764 ]

There is no need to free the reset_data structure if the recovery is
unsuccessful and the reset is synchronous. The function
adf_dev_aer_schedule_reset() handles the cleanup properly. Only
asynchronous resets require such structure to be freed inside the reset
worker.

Fixes: d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")
Signed-off-by: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 7d42e097607c ("crypto: qat - resolve race condition during AER recovery")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_aer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index f5e960d23a7a7..20f983b830065 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -139,7 +139,8 @@ static void adf_device_reset_worker(struct work_struct *work)
 	if (adf_dev_init(accel_dev) || adf_dev_start(accel_dev)) {
 		/* The device hanged and we can't restart it so stop here */
 		dev_err(&GET_DEV(accel_dev), "Restart device failed\n");
-		kfree(reset_data);
+		if (reset_data->mode == ADF_DEV_RESET_ASYNC)
+			kfree(reset_data);
 		WARN(1, "QAT: device restart failed. Device is unusable\n");
 		return;
 	}
-- 
2.43.0



