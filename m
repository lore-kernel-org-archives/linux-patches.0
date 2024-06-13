Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA362CA6;
	Thu, 13 Jun 2024 12:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282987; cv=none; b=c9xSx8F5vWzn1Jf6uHvuEAEYIjKK39EOjGtmQbEXlWDEGtfbseWo5bWL0IvxgMV/DI4yATmRSnsy+zWNWMGd3yX0AAQa9YUmC0Y3/m8YD37UnEi2X9Yg1IJpTmZXZIG2VuTxYqW1sAADXIk8g71hYWu9IBcqG8QbrhSflqyDW3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282987; c=relaxed/simple;
	bh=JSrGIHHi3qj9s9j2wIYW8Axe+/XM3h3uGT+af6EbNeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PENUyfeUyKw7rRdTXPdc9Am9Aelk8ObobU+ZkmavxkiqQZYzlmFKCx1aMemWj2I2B4fFOOQq0+K7ioMOBeov0xWc9+Pg+EdBOMtE/R4p1PrrQuNuuatt6u8Rkb2xqS4ZB/y8uey6FYzUmNd4aZhGV86afVMKEq1x7RmRAAWm8j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q6BHeANL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q6BHeANL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A5EC2BBFC;
	Thu, 13 Jun 2024 12:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282987;
	bh=JSrGIHHi3qj9s9j2wIYW8Axe+/XM3h3uGT+af6EbNeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q6BHeANLcJCP8VzFJDEimIVTGXgKxzOcQoNNMYu39ZqeQrLPf5FvjM17WCw5OBHqv
	 buJB0z4GLjfDk+xUJI6K11L+p6aU0i/ys0qjgn8RRXkxbwVuoEmyFIbjOPprZMFAJa
	 OM9rZ/N+XYKfBT+/Np2xQjF0aT0PVOA0qLsjxiJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 6.1 53/85] crypto: qat - Fix ADF_DEV_RESET_SYNC memory leak
Date: Thu, 13 Jun 2024 13:35:51 +0200
Message-ID: <20240613113216.184256473@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

From: Herbert Xu <herbert@gondor.apana.org.au>

commit d3b17c6d9dddc2db3670bc9be628b122416a3d26 upstream.

Using completion_done to determine whether the caller has gone
away only works after a complete call.  Furthermore it's still
possible that the caller has not yet called wait_for_completion,
resulting in another potential UAF.

Fix this by making the caller use cancel_work_sync and then freeing
the memory safely.

Fixes: 7d42e097607c ("crypto: qat - resolve race condition during AER recovery")
Cc: <stable@vger.kernel.org> #6.8+
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qat/qat_common/adf_aer.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -95,8 +95,7 @@ static void adf_device_reset_worker(stru
 	if (adf_dev_init(accel_dev) || adf_dev_start(accel_dev)) {
 		/* The device hanged and we can't restart it so stop here */
 		dev_err(&GET_DEV(accel_dev), "Restart device failed\n");
-		if (reset_data->mode == ADF_DEV_RESET_ASYNC ||
-		    completion_done(&reset_data->compl))
+		if (reset_data->mode == ADF_DEV_RESET_ASYNC)
 			kfree(reset_data);
 		WARN(1, "QAT: device restart failed. Device is unusable\n");
 		return;
@@ -104,16 +103,8 @@ static void adf_device_reset_worker(stru
 	adf_dev_restarted_notify(accel_dev);
 	clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
 
-	/*
-	 * The dev is back alive. Notify the caller if in sync mode
-	 *
-	 * If device restart will take a more time than expected,
-	 * the schedule_reset() function can timeout and exit. This can be
-	 * detected by calling the completion_done() function. In this case
-	 * the reset_data structure needs to be freed here.
-	 */
-	if (reset_data->mode == ADF_DEV_RESET_ASYNC ||
-	    completion_done(&reset_data->compl))
+	/* The dev is back alive. Notify the caller if in sync mode */
+	if (reset_data->mode == ADF_DEV_RESET_ASYNC)
 		kfree(reset_data);
 	else
 		complete(&reset_data->compl);
@@ -148,10 +139,10 @@ static int adf_dev_aer_schedule_reset(st
 		if (!timeout) {
 			dev_err(&GET_DEV(accel_dev),
 				"Reset device timeout expired\n");
+			cancel_work_sync(&reset_data->reset_work);
 			ret = -EFAULT;
-		} else {
-			kfree(reset_data);
 		}
+		kfree(reset_data);
 		return ret;
 	}
 	return 0;


