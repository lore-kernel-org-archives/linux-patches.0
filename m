Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DCF73178;
	Tue, 23 Jan 2024 02:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975435; cv=none; b=a7BYjPBnVeYpyfnuYpSXP9suYwLC9A6AnfCmWnQ9HEJzbO8cO5BZ6Q0mGiBZvXiVtobDbcJ1bVLhw4JMznkD4ekLFhsFJZFrTCUA+qe6IAd/Mj8HkfC8D7J/xc4khNOusytlCeXJtaYruOzTpSMG88l8/LQSZmnQy78hR+1dp4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975435; c=relaxed/simple;
	bh=T1Z3+xV/EE1jcFg3JpBlLmarNY59urRjiN8D0uzRH0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkoryl+xyGRE/I1UqDVFJjRb4QUNSgvRYY8+SrlpvmfUwg+IJmQGPiFhAwW+Rl84HLk0Z48E8LL7naoJcxEQsQ19FdwPh5NJF2t6rum3oO/kDLQW/p1Dqeb8Fll9fHCr4shKyXXOPr52E/P6Rz2dUFUdK6A+4pT7Whp579nrk1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=soAgqMPH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="soAgqMPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F15C43399;
	Tue, 23 Jan 2024 02:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975435;
	bh=T1Z3+xV/EE1jcFg3JpBlLmarNY59urRjiN8D0uzRH0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=soAgqMPHUth/qM3eTyIKJQgKK5gNTewoWr7ckl8MQHf7pZIzxegNNzKEdseFKYEX2
	 Uzzx7gmhuNlpGJ+aZuZOTUcIKhqYmc8fvXBRt4YI3BGSuY+9UnPbmVQ3A5m6gQI7aT
	 1MBQOMerVFsojpLSP2zvQRoLexl/iqEuZVTgJGcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Can Guo <quic_cang@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 394/583] scsi: ufs: core: Simplify power management during async scan
Date: Mon, 22 Jan 2024 15:57:25 -0800
Message-ID: <20240122235824.041593810@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -8540,7 +8540,6 @@ static int ufshcd_add_lus(struct ufs_hba
 
 	ufs_bsg_probe(hba);
 	scsi_scan_host(hba->host);
-	pm_runtime_put_sync(hba->dev);
 
 out:
 	return ret;
@@ -8808,15 +8807,15 @@ static void ufshcd_async_scan(void *data
 
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


