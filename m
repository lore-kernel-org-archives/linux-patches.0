Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF2B13D624;
	Thu, 13 Jun 2024 11:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279175; cv=none; b=rpx1EUIAmQzDMxqIxD7HVe6poAQ4B03hx5ia/2ozqBn3TwitKskdiuBotTTNsVjHnwe4/Nao5ZGhcx/es+qZ7Sdt9+zeOqfaLzh8f0YR2kxTzo0u6G8m/FPz1awCTMq+oBGruB1aP2HN4FzWrm8rLDohNP95wghRglR0khXIFdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279175; c=relaxed/simple;
	bh=/i08v+W+f2AiEWIQ03Uv8IwZ7QqOE7hbZiHMnT64Mp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+H7h8YLMZf68wZwVTnexuaPqWNCA6R2mSKV47hThl7MvLitHWdDAWx6Pjpqr/PBvhcLNLOtiwGhp/idFyTnc1uESd3DJwP563sTHBMxTurR9mgbVM9pWqlo+y6vSmro3VstKXXHC/dCvxTVjsTmoxNV4ucEp3U/CYaw0xgVits=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C3zaobS2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3zaobS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8717EC2BBFC;
	Thu, 13 Jun 2024 11:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279174;
	bh=/i08v+W+f2AiEWIQ03Uv8IwZ7QqOE7hbZiHMnT64Mp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C3zaobS26vE/VZNY2Gg4EJuQhj2EBrO9aYOI4RnLwPd2HgxZh+W6ItTpwRI+4EEgg
	 nZEKKvKXUBn+vS016l72qEangNYbMgjvMWtA2+t1dblgNpO2zv4Hm5Mq5uWBMn3iqL
	 dw+ofGvgMiIMO3k/XNvgxK3/ztvPgA6N3L3b/jgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 4.19 200/213] crypto: qat - Fix ADF_DEV_RESET_SYNC memory leak
Date: Thu, 13 Jun 2024 13:34:08 +0200
Message-ID: <20240613113235.694460209@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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
@@ -139,8 +139,7 @@ static void adf_device_reset_worker(stru
 	if (adf_dev_init(accel_dev) || adf_dev_start(accel_dev)) {
 		/* The device hanged and we can't restart it so stop here */
 		dev_err(&GET_DEV(accel_dev), "Restart device failed\n");
-		if (reset_data->mode == ADF_DEV_RESET_ASYNC ||
-		    completion_done(&reset_data->compl))
+		if (reset_data->mode == ADF_DEV_RESET_ASYNC)
 			kfree(reset_data);
 		WARN(1, "QAT: device restart failed. Device is unusable\n");
 		return;
@@ -148,16 +147,8 @@ static void adf_device_reset_worker(stru
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
@@ -192,10 +183,10 @@ static int adf_dev_aer_schedule_reset(st
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


