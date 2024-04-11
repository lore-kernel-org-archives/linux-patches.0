Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0659213DDDD;
	Thu, 11 Apr 2024 09:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829537; cv=none; b=mIfTVZfJIWvy1k11DKgUbtz7HB8HT7Hh5fYRD4hDN+j1RoZDDUo9BgSQJT4KV8wKGljVkJcBcG/Dm90rjCkV70N7EJksFZNzGzakmdw1L/pPtnuQhtMpDXiKppiwzZnpr4XQ2MaTS9slLeZqChzqXx6oDoKXAczQX1DdVar79WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829537; c=relaxed/simple;
	bh=lIR3CI1pUYh6QVZG9tcgqrNEVvzDbh3w/2o/8LGwB/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVTgvT5O2DIEdx6V8FadfgXP304XTG73FvMM6kjI9p6r8SCia/ZzRxNrhMzv6LFSK4X8mbsA4kZ3JcD9lLd3BYKyl8DniVw1JNw7HZZc+lCAC1sfy8YlqrWDzE0AEYQPwgf2grhA/JPkQHWd2PNWvvMTFWuyVRXKUFbr8Nkn+rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YoKjjU6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YoKjjU6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D04C433C7;
	Thu, 11 Apr 2024 09:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829536;
	bh=lIR3CI1pUYh6QVZG9tcgqrNEVvzDbh3w/2o/8LGwB/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YoKjjU6zXXtNhn48meQpmWB8oCUs+7xGHBP/SQOgH48kat3Scq0vzsN7BXwHb51gr
	 5nTuMYUWZNUIp49FSUKKb30z30HiXddr2xEXeEKsrvScJfC1qCBBerSJpMnIsHeD5e
	 Jl6xH3B/ywSdJiiie32QdkyksUhtssxvfwCSpo+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damian Muszynski <damian.muszynski@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 020/175] crypto: qat - resolve race condition during AER recovery
Date: Thu, 11 Apr 2024 11:54:03 +0200
Message-ID: <20240411095420.158709092@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damian Muszynski <damian.muszynski@intel.com>

[ Upstream commit 7d42e097607c4d246d99225bf2b195b6167a210c ]

During the PCI AER system's error recovery process, the kernel driver
may encounter a race condition with freeing the reset_data structure's
memory. If the device restart will take more than 10 seconds the function
scheduling that restart will exit due to a timeout, and the reset_data
structure will be freed. However, this data structure is used for
completion notification after the restart is completed, which leads
to a UAF bug.

This results in a KFENCE bug notice.

  BUG: KFENCE: use-after-free read in adf_device_reset_worker+0x38/0xa0 [intel_qat]
  Use-after-free read at 0x00000000bc56fddf (in kfence-#142):
  adf_device_reset_worker+0x38/0xa0 [intel_qat]
  process_one_work+0x173/0x340

To resolve this race condition, the memory associated to the container
of the work_struct is freed on the worker if the timeout expired,
otherwise on the function that schedules the worker.
The timeout detection can be done by checking if the caller is
still waiting for completion or not by using completion_done() function.

Fixes: d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")
Cc: <stable@vger.kernel.org>
Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_aer.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index 44b91cb73dd19..7242a1ee86de7 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -139,7 +139,8 @@ static void adf_device_reset_worker(struct work_struct *work)
 	if (adf_dev_init(accel_dev) || adf_dev_start(accel_dev)) {
 		/* The device hanged and we can't restart it so stop here */
 		dev_err(&GET_DEV(accel_dev), "Restart device failed\n");
-		if (reset_data->mode == ADF_DEV_RESET_ASYNC)
+		if (reset_data->mode == ADF_DEV_RESET_ASYNC ||
+		    completion_done(&reset_data->compl))
 			kfree(reset_data);
 		WARN(1, "QAT: device restart failed. Device is unusable\n");
 		return;
@@ -147,11 +148,19 @@ static void adf_device_reset_worker(struct work_struct *work)
 	adf_dev_restarted_notify(accel_dev);
 	clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
 
-	/* The dev is back alive. Notify the caller if in sync mode */
-	if (reset_data->mode == ADF_DEV_RESET_SYNC)
-		complete(&reset_data->compl);
-	else
+	/*
+	 * The dev is back alive. Notify the caller if in sync mode
+	 *
+	 * If device restart will take a more time than expected,
+	 * the schedule_reset() function can timeout and exit. This can be
+	 * detected by calling the completion_done() function. In this case
+	 * the reset_data structure needs to be freed here.
+	 */
+	if (reset_data->mode == ADF_DEV_RESET_ASYNC ||
+	    completion_done(&reset_data->compl))
 		kfree(reset_data);
+	else
+		complete(&reset_data->compl);
 }
 
 static int adf_dev_aer_schedule_reset(struct adf_accel_dev *accel_dev,
@@ -184,8 +193,9 @@ static int adf_dev_aer_schedule_reset(struct adf_accel_dev *accel_dev,
 			dev_err(&GET_DEV(accel_dev),
 				"Reset device timeout expired\n");
 			ret = -EFAULT;
+		} else {
+			kfree(reset_data);
 		}
-		kfree(reset_data);
 		return ret;
 	}
 	return 0;
-- 
2.43.0



