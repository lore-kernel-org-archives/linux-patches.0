Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E24A522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49DEC43391;
	Sun,  9 Jul 2023 11:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902389;
	bh=XOwjxrd/453tnUTyjxgadHB7N0YiP/oXN1Lng5j8btY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CjK4gkVnTJrSasumemvovx7njl4fRfbXi8XykWHlq5aVkzpV5owKvD0Wz2c+x9/PD
	 qhSfZDDdfXmq4r26HLQiVdryXR8+AosUsa528ulPqXCMW8IYnFs2wG5BdgKWzSxkaX
	 wFnWgEvyur0521cXL6ZHrrXghWOkdJ7YgZAC9pgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Stanley Chu <stanley.chu@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 358/431] scsi: ufs: core: Increase the START STOP UNIT timeout from one to ten seconds
Date: Sun,  9 Jul 2023 13:15:06 +0200
Message-ID: <20230709111459.558062060@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit fe8637f7708c16765ecf4035813efbfdd2c9be10 ]

One UFS vendor asked to increase the UFS timeout from 1 s to 3 s.  Another
UFS vendor asked to increase the UFS timeout from 1 s to 10 s.  Hence this
patch that increases the UFS timeout to 10 s. This patch can cause the
total timeout to exceed 20 s, the Android shutdown timeout.  This is fine
since the loop around ufshcd_execute_start_stop() exists to deal with unit
attentions and because unit attentions are reported quickly.

Fixes: dcd5b7637c6d ("scsi: ufs: Reduce the START STOP UNIT timeout")
Fixes: 8f2c96420c6e ("scsi: ufs: core: Reduce the power mode change timeout")
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20230524203659.1394307-2-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index aec74987cb4e0..8bf39a83ecd7f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9153,7 +9153,8 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
 	};
 
 	return scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, /*buffer=*/NULL,
-			/*bufflen=*/0, /*timeout=*/HZ, /*retries=*/0, &args);
+			/*bufflen=*/0, /*timeout=*/10 * HZ, /*retries=*/0,
+			&args);
 }
 
 /**
-- 
2.39.2



