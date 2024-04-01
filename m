Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183BF446AC;
	Mon,  1 Apr 2024 16:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988047; cv=none; b=D4ds3yaU4wBOVhCwM78ciyFzf8kQP+mjiDv1UVTyQTu6cd2W9qKMHNkOQfmai6VsYUcXaBcSs+MXqr4k6sR2nCXGyHol9T+7Ttf26Ims6oEI4ZYi69ZjC0thl+QnvrdMHH1mPUHD0DKjQWOqpwfgaTINcdyNETxH1AxLGE0TBHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988047; c=relaxed/simple;
	bh=36SuOskb+khIQjH8wOZ/IGO93607X0G3iDof5ySfMQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujisjC+qNg7tgMRo8BWh2nK/Jczmg3ptP6ZWDzKKXGXLCNzE3FuuhY9Azr5uj+jrg2R7jQJCUnOBavkMaSaG/JO4p4H2HkqChjz0tQNqQ6HOqA+eJaEt1i1UVJFhCsb2OG0oFVg5npiusSGs7oJbdg20cD8oxL+KkmjNv+sexq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SpX0eBFD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpX0eBFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD6AC433F1;
	Mon,  1 Apr 2024 16:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988047;
	bh=36SuOskb+khIQjH8wOZ/IGO93607X0G3iDof5ySfMQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SpX0eBFD14YVlbgP8rSUHfKODan1/x7af51/VChdnF/YfmtcKECrkZewVBd4iATYG
	 hQB6Ze9SoTKuagVoV8X9a9tpBcG48FTxmRYzIAW/qsrEwp+wRKrdl8qsKBwJVa4HXk
	 7w5BC/TEi+yrBD0kTOgIawKpzP4MaBYMAXTLxri8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damian Muszynski <damian.muszynski@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 041/432] crypto: qat - resolve race condition during AER recovery
Date: Mon,  1 Apr 2024 17:40:28 +0200
Message-ID: <20240401152554.355683946@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 22 ++++++++++++++-----
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index a39e70bd4b21b..621d14ea3b81a 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -92,7 +92,8 @@ static void adf_device_reset_worker(struct work_struct *work)
 	if (adf_dev_restart(accel_dev)) {
 		/* The device hanged and we can't restart it so stop here */
 		dev_err(&GET_DEV(accel_dev), "Restart device failed\n");
-		if (reset_data->mode == ADF_DEV_RESET_ASYNC)
+		if (reset_data->mode == ADF_DEV_RESET_ASYNC ||
+		    completion_done(&reset_data->compl))
 			kfree(reset_data);
 		WARN(1, "QAT: device restart failed. Device is unusable\n");
 		return;
@@ -100,11 +101,19 @@ static void adf_device_reset_worker(struct work_struct *work)
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
@@ -137,8 +146,9 @@ static int adf_dev_aer_schedule_reset(struct adf_accel_dev *accel_dev,
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



