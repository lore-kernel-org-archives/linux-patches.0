Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF4D4653C;
	Mon,  1 Apr 2024 16:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990675; cv=none; b=RZ79BQE2tljNczDAAKGntxBwDhMcnzjJ5sIZnJk3w24nMFiBDebmuXw5vzs+x9VnI/bvYGlw2PDzf2VMkUiq3MnrC793/DA3ydWZufq00Sz+qZke7gFLsUBuVzTcHzYgQa9hwhOGouBizeBs9XAF2EFbnnWXvqHb2DEvjBlHY4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990675; c=relaxed/simple;
	bh=UjYFVl2T8pJJbjOC4FY5BVw9crsiNrJCfOfMUQBgkgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ii4kzhCfWahYJIwC5OrfbdjKCuzSzMPq0/9cuklkijnputsgIgYD+Ow6seqFanNzlENJQLEWrRfIAB5zd/594lrWKpwpPOP/43XFUi4D/xgL9KJfMd6JKC3bAqlBJAxl6nOJq0DrBM0FJQMf2mfIFnxks+NruRIuZqDHF3GkDgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQ0xESFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQ0xESFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C295C433C7;
	Mon,  1 Apr 2024 16:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990675;
	bh=UjYFVl2T8pJJbjOC4FY5BVw9crsiNrJCfOfMUQBgkgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQ0xESFObPNWqdVSLqep3KPt4D1NERqUBrDnAZCaJ6zT78nn3HHkSNBM5GCiyeb5M
	 a58bCz5plonzbE7dgBuJByUM8hVOrjiIQQHJ8D4BiwaQ3qrKZMqbGwq/n0aQHa3gkG
	 6EmJxldfcRK5BgBPhEHVt2upFf9RGHfCkrQ84Ulw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/272] crypto: qat - fix double free during reset
Date: Mon,  1 Apr 2024 17:43:42 +0200
Message-ID: <20240401152531.357416390@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fe9bb2f3536a9..fa6b7ecd4c08d 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -95,7 +95,8 @@ static void adf_device_reset_worker(struct work_struct *work)
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



