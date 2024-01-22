Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7766A66B52;
	Tue, 23 Jan 2024 01:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971687; cv=none; b=Vk08IGPc+pSweDSDD7w4vOBUnCdSkKMx8iYqcORSAWr9td6mScw6Gs773yBYiPyoy7O5LHV4n0ygKme21ICDZ4APSfG16Hxs0Ln80SN638cX6fnxfWFDhNGhJYg9zddgrrk5BZCSiJeW2Y+swoEuMnckFrWZQ1HzCSjCwvYgWyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971687; c=relaxed/simple;
	bh=cnTtTnV5nNdfkh8lwe8BfsZCgFjisAXu6hTjUdsVmsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igxqZOwllx70bL+1+lhduietzuIYXBZ43RifTda84XHdUS3Ko7qozxg8iQm9wh/gdhlELVJX1DzIyTEdi4L5PsOEhUnh1T/YuC76tWiCFN30u4o8poxSTpwN/4OHUj8qDvwqLAjodwzGKttvI7S+OAqt+IM5Ymztu9vqHLo+9XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a5Q6wxh+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a5Q6wxh+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEEDEC433C7;
	Tue, 23 Jan 2024 01:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971687;
	bh=cnTtTnV5nNdfkh8lwe8BfsZCgFjisAXu6hTjUdsVmsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a5Q6wxh+8B0LqO2myq8Z55jNw/aus/Ox+RKyPFsdMgIo1DVFcyreC9CbFmy20yzcu
	 1LQSQF8Y8GCNjuZ4UqsGo2fK6z9EbIaRVn0q96RYZG5a/5gR7S7GYgogUgDqOa/M/D
	 3GKdha/LBVJfkHj8M7Acj874KlsE5443KoSnolp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Can Guo <quic_cang@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 289/417] scsi: ufs: core: Simplify power management during async scan
Date: Mon, 22 Jan 2024 15:57:37 -0800
Message-ID: <20240122235801.844884547@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

commit daf7795406bf307997366f694888bd317ae5b5fa upstream.

ufshcd_init() calls pm_runtime_get_sync() before it calls
async_schedule(). ufshcd_async_scan() calls pm_runtime_put_sync() directly
or indirectly from ufshcd_add_lus(). Simplify ufshcd_async_scan() by always
calling pm_runtime_put_sync() from ufshcd_async_scan().

Cc: <stable@vger.kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20231218225229.2542156-2-bvanassche@acm.org
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8204,7 +8204,6 @@ static int ufshcd_add_lus(struct ufs_hba
 	ufs_bsg_probe(hba);
 	ufshpb_init(hba);
 	scsi_scan_host(hba->host);
-	pm_runtime_put_sync(hba->dev);
 
 out:
 	return ret;
@@ -8331,15 +8330,15 @@ static void ufshcd_async_scan(void *data
 
 	/* Probe and add UFS logical units  */
 	ret = ufshcd_add_lus(hba);
+
 out:
+	pm_runtime_put_sync(hba->dev);
 	/*
 	 * If we failed to initialize the device or the device is not
 	 * present, turn off the power/clocks etc.
 	 */
-	if (ret) {
-		pm_runtime_put_sync(hba->dev);
+	if (ret)
 		ufshcd_hba_exit(hba);
-	}
 }
 
 static const struct attribute_group *ufshcd_driver_groups[] = {


