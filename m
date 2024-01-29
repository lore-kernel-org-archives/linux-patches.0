Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31814159572;
	Mon, 29 Jan 2024 17:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548080; cv=none; b=R9EBzElHpb9F/v+FXGramizEaHNUkFxIgiVbPesh60iJnPhcNynjwC6gIuAZfcV2lFshf2ZCcPei5HhSNVyvS3JlN8ZV8ydbNZivQ2E7ktHC8CysRElj1MmOQA2Cna5BQC/ElWid/PlF4KyXKhMWSXjXtmkokoXgFCJBd6iId4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548080; c=relaxed/simple;
	bh=MKjHVy4T1t5WxNC/SpfCFKi8oKZtxSVaENuj+cXCp1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bv/cL2xcilfE6QGBCyEK7flcrtHwdj49k/+5oYTT8buc6cHxknLSBp9F/Tczd6oXRTlNk4DMi5woOxZt183S9j09hqOju3n3xQmHICMO0gj1zxeWVgOXA1xRERNAT03595UJ/n+/kRMW2h03NRQC7R4J0Y7P3LANHnU6vv+IN18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BwYglFpv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BwYglFpv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE802C43390;
	Mon, 29 Jan 2024 17:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548080;
	bh=MKjHVy4T1t5WxNC/SpfCFKi8oKZtxSVaENuj+cXCp1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BwYglFpvsKm0cl785wJdFu0miVdmkTnq8CdjMTkTWP/U2yc9l6g5V24k5P7hH4aY8
	 stmfwvf+/Bo9KDAYDA6cH677GTILz9UfCMXUoY487eUWlFD8V2csPE+L1B8usmNFPo
	 D9AKyo3wmDzalk4QEO5U821FSqeAUQNq+Sk7nSZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Mentz <danielmentz@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Can Guo <quic_cang@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 055/346] scsi: ufs: core: Remove the ufshcd_hba_exit() call from ufshcd_async_scan()
Date: Mon, 29 Jan 2024 09:01:26 -0800
Message-ID: <20240129170018.015958648@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

[ Upstream commit ee36710912b2075c417100a8acc642c9c6496501 ]

Calling ufshcd_hba_exit() from a function that is called asynchronously
from ufshcd_init() is wrong because this triggers multiple race
conditions. Instead of calling ufshcd_hba_exit(), log an error message.

Reported-by: Daniel Mentz <danielmentz@google.com>
Fixes: 1d337ec2f35e ("ufs: improve init sequence")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20231218225229.2542156-3-bvanassche@acm.org
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ce2f76769fb0..1f8d86b9c4fa 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8916,12 +8916,9 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 
 out:
 	pm_runtime_put_sync(hba->dev);
-	/*
-	 * If we failed to initialize the device or the device is not
-	 * present, turn off the power/clocks etc.
-	 */
+
 	if (ret)
-		ufshcd_hba_exit(hba);
+		dev_err(hba->dev, "%s failed: %d\n", __func__, ret);
 }
 
 static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
-- 
2.43.0



