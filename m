Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15158F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B5EC433C8;
	Sun, 16 Jul 2023 20:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538442;
	bh=yZTXW+VLrG2GWZ39erW2Je/RGyPZY9kNoxWnk5BFaFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rVA0LOFvsyejLOnM2npgFzqgziRtQaRvQ34L8uYqUyu+wnJp3txEK4iQnI6YteqG8
	 4OxUd+9E59EoFDVd30nOqDVB/BksMUif30iPAIYPUeX5N3swvlu3TE6FuitfhjK4GI
	 tT46kckHh+F3HO2g5LiVUx9kJ26sTmRPl/IIacxQ=
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
Subject: [PATCH 6.4 452/800] scsi: ufs: core: Increase the START STOP UNIT timeout from one to ten seconds
Date: Sun, 16 Jul 2023 21:45:05 +0200
Message-ID: <20230716194959.582182356@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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
index e7e79f515e141..c36812401ef05 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9184,7 +9184,8 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
 	};
 
 	return scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, /*buffer=*/NULL,
-			/*bufflen=*/0, /*timeout=*/HZ, /*retries=*/0, &args);
+			/*bufflen=*/0, /*timeout=*/10 * HZ, /*retries=*/0,
+			&args);
 }
 
 /**
-- 
2.39.2



