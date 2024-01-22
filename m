Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9484F15D5C5;
	Tue, 23 Jan 2024 00:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969760; cv=none; b=irpCM17Vz+PW5FE2mKAKmZn83AomFMP9fMofsYWBExodCIeRZMnqXjBW49MWXrHuVE5F1R5HpKPls6xvxN8mYN89g7J3ck9DBrUdHMmphV3JR6VwqYIbJAOeIkebvqMB5vOqZVYRF0egRTXQ/YP2mH0mHjhEJFHzC7CzMRHxXTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969760; c=relaxed/simple;
	bh=rfdLBq3PM0LwH0AoW6dkdFu00U6fN5KuCzI+KIx05l0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S1rjooMelk7VoWseDohgjSmIvfDwp/Hk75pb5EiSMVWlYzyguvzhaWcJxhP5xc98tkqIRXsqx2Pk2InnbTApDjnDmoJqaYFXm0q2L/7TX3BomrRkJl+IT7NWpnJTq7h267RPDTuq9tb4zehlDNs54iQCmmokG5BoIz/J48XAxfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJ0J9xcM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJ0J9xcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54694C43390;
	Tue, 23 Jan 2024 00:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969760;
	bh=rfdLBq3PM0LwH0AoW6dkdFu00U6fN5KuCzI+KIx05l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJ0J9xcM9rYEn/EuvJvx6ilFXwtl//EusqtfyyI3bqW/rrsL6EhwZpk57wqwk8+uL
	 ZBEcZo7t6f19yhWlh2FklebJ1AZJS1lpUh6C5WZsBx8nVMxD/lURiArru3Ef2nKH18
	 pr8RdVyYIdWTNPhnCCCiV4Cq+MgzuOkI/01/maew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Can Guo <quic_cang@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.7 433/641] scsi: ufs: core: Simplify power management during async scan
Date: Mon, 22 Jan 2024 15:55:37 -0800
Message-ID: <20240122235831.542207587@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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
@@ -8646,7 +8646,6 @@ static int ufshcd_add_lus(struct ufs_hba
 
 	ufs_bsg_probe(hba);
 	scsi_scan_host(hba->host);
-	pm_runtime_put_sync(hba->dev);
 
 out:
 	return ret;
@@ -8914,15 +8913,15 @@ static void ufshcd_async_scan(void *data
 
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
 
 static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)


