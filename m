Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FA515A483;
	Mon, 29 Jan 2024 17:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548258; cv=none; b=RMOePy88MquzLe1v8jcjAmxh0MnkvXohe6g9wkMDKe+v/ZQMBLQ3vuqn4i2UJ3pLZrRuzNc51R3TnQdhLQeW6KacJfrIoJwzyhTbQdWFHd2Ov4uV5WZrWiZwvzYGpjAEFwQORF3OBNUbUjV5UdKOlIf78+oq8ewf1ERlOflHDQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548258; c=relaxed/simple;
	bh=NiqQCDuVxY7wK1+qZi6RtKcEjN9Y6YwA5L4Z8pz+QF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+RyPF4tvtywgv+DQHqVa0aYYAvnZFkO0hBajyXAmhjePS+1OJrYKxNsy5cNZ+fbH0psku0bL3paY+12hOdbtsY6DDoQwOIexx5drM0rof1uXXnSuR9+G1wlpVuNu3bJDIWa45M3N+QsKKEMrlbVmNK/sxy6eHBpf4QuOPFpJD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9EP9Ky4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9EP9Ky4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B161CC433C7;
	Mon, 29 Jan 2024 17:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548257;
	bh=NiqQCDuVxY7wK1+qZi6RtKcEjN9Y6YwA5L4Z8pz+QF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q9EP9Ky4wMVuAKmGysoEktc5lNfeGgG1Eu8x2j5besh8PGOkDzOcx+qOTXhjY+jtV
	 Za3kdXNSCwNFPHme78HmH0nxu20IKSPlhOSnojTiCteuu3aNErTsx1D4FAhiN32dFO
	 xBfbCsrSHNpk12LXyD2KFVt10yMiq6RLjCr+x6uU=
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
Subject: [PATCH 6.1 033/185] scsi: ufs: core: Remove the ufshcd_hba_exit() call from ufshcd_async_scan()
Date: Mon, 29 Jan 2024 09:03:53 -0800
Message-ID: <20240129165959.662373614@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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
index 474e94a69b18..9fd4e9ed93b8 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8333,12 +8333,9 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 
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
 
 static const struct attribute_group *ufshcd_driver_groups[] = {
-- 
2.43.0



