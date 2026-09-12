Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71D03D566E;
	Sat, 12 Sep 2026 14:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225082; cv=none; b=gBYnsOJlj0DhgtX4WYC9fSJbkS+abJm9YpEa5IgGqMd4/VY+Fk8CZVgwxW3YKM6iOfpXQMjLYdTHUrcMDDJeqFiD3Rhig5N95B2LfvBJO6rPuxrcU3MkDZUd0gLegLOa9G1bZpYGrDyaHsj/YkdGDjoUc5eVGsn3T5YkmZ0sYrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225082; c=relaxed/simple;
	bh=zs4N/ewyUhY5C2EbQS3Q+s3iCRSapp9XalvbujLhMeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FflefyBTpiaMKJhH+l0GNwBpHd+bfVSBFk1CgmCBK3gCSqy94oKAbQ9VXCMeJ2FMKt6q5cIJBrpL/2vFicUHs5Ep0Lo7+1I6hpTvV89ydCejqOJp9EraAfdqlptBfd9zi6MiuIBKX+FoXc32HjdIFcTt10Uj7fR55VskDGs6AuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgvbT4q8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgvbT4q8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2E41F000FF;
	Sat, 12 Sep 2026 14:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225080;
	bh=WTiaY8aRlw87StRFaXb0PbuF8oE7eavPf7UxNiHifP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wgvbT4q8FT2OrVRCt9FQTn1JFyo+0FExuMtoFYI55bKg1IafIceVEO48I5tDLTLqB
	 K+EZapu2uffbv2dGTcU3ReueDalkawPFCfFtbnzt8z8VXKCcbxkeDtKtYQYgrV66s+
	 FDj7pZzN5biCqu2d44OhaCys7nWkau3jR6sW3CX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1124/1424] scsi: sd: Fix sd_done() sense handling condition
Date: Sat, 12 Sep 2026 08:59:16 +0200
Message-ID: <20260912065632.471484150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

[ Upstream commit a640d4546b11be5709a82bdc63d7dafd8ddc6c9e ]

Only enter the sense_key switch when the command returned CHECK
CONDITION with valid, non-deferred sense. The old condition let deferred
or invalid sense fall through and mis-handle the I/O.

Fixes: 03aba2f79594 ("[SCSI] sd/scsi_lib simplify sd_rw_intr and scsi_io_completion")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260707030333.22245-4-yangxiuwei@kylinos.cn
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8cb10cb78b1d8..a6c8d786125ef 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2167,8 +2167,8 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	}
 	sdkp->medium_access_timed_out = 0;
 
-	if (!scsi_status_is_check_condition(result) &&
-	    (!sense_valid || sense_deferred))
+	if (!scsi_status_is_check_condition(result) ||
+	    !sense_valid || sense_deferred)
 		goto out;
 
 	switch (sshdr.sense_key) {
-- 
2.53.0



