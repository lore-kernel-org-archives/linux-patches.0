Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBBD1641B4;
	Mon, 29 Jan 2024 17:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548418; cv=none; b=PeOlD6bseHDG+/oDalUGJf2iKmE4KhSqAK3pSPSEaZKme6IaeRsYIoK1NFwaKk11qZlr+iTglV/XdM3Vw9BFo4BmKd8opubsIWjQb3yKjJvv5Ro0jY5XehSYJO4sp3HsHbSNVDacyage1LxtJ7X6QEQwtPr6V1CffH0XnEDxZPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548418; c=relaxed/simple;
	bh=8Y8oBXhvBn0oVxqmY0SCKqrZlzNBmr03xttRQvGr7rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrjiSI9S3Ra4dGG8j+zH/d4LBgwdTmMKir5Ep+qDZ5Ju4oMlmTcsX9JmTbfMOH2AVwM5kf3auZyVKlbaYrLPiAAXGjbx1qXixebYkAIGQcZdX0CEcbUWRfW0tMVXby/lkQr+alvZzhCWjmQdnwBwD7e6pfKy3bcHzPjy6Jxyd/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7jWYGE+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7jWYGE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E41C43399;
	Mon, 29 Jan 2024 17:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548418;
	bh=8Y8oBXhvBn0oVxqmY0SCKqrZlzNBmr03xttRQvGr7rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s7jWYGE+vM1NYj461aD84CFdRvKQFubfdJOk9OC6fz/omqjbT9EWQ3VgHWpZ7Bh42
	 ZKHvNzrOOVp/gV9eIwFNJ1m9cCE4ra485eaPM9jtbFVBePRximcwKlCatjwrDRnEPw
	 yK3hLIycPqAisV7Piq6L9RZ1sKTQ1dopbPbp8T64=
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
Subject: [PATCH 6.6 016/331] scsi: ufs: core: Remove the ufshcd_hba_exit() call from ufshcd_async_scan()
Date: Mon, 29 Jan 2024 09:01:20 -0800
Message-ID: <20240129170015.438143676@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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
index 0971ae37f2a7..44e0437bd19d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8810,12 +8810,9 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 
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



