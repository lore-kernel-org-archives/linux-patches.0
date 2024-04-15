Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947A63BBE1;
	Mon, 15 Apr 2024 14:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192056; cv=none; b=Pb1jwBSnUPJBr30NS/BmGM87xNo3ewz+LMc8oPKNF3rs5UkmzDPJk3tX8UmdVyLGLYqKd1oFcRuG2vFUdOJRJxKe8SNdBWluG+GB0cKtxkcfbMgT3mh9JCiknV5zOY1PANMVZzn5+bgyzllOXV6he0VGckeYt4qPhtIQo1WkmZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192056; c=relaxed/simple;
	bh=+9IqYnNH+gOpMZECLRIZkXsZ7/FCaDKeADGJIoGrITQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIxFFXMx/4otIojRCEUNDKQRwjrGW5bSD0angd9zYol0lDK847K27YFuH0ewXAskSOSZ1qG9wRzZ4Vve2QO2aDdtHn/m8YSffHsRAGUFrJoFjD/56+YTpvcNWDD4AHgIR6T+QnLM94uvalGtM/VQ+N7PEypc9kmx52+rAY/lbvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qViqT3yQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qViqT3yQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182C0C113CC;
	Mon, 15 Apr 2024 14:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192056;
	bh=+9IqYnNH+gOpMZECLRIZkXsZ7/FCaDKeADGJIoGrITQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qViqT3yQ5IvTCk5EsVz9aCEFuhCuPCtOHRGOtkHN9XRx9O7jqvGZNXvGos4F42blT
	 vfuOfVJtg4dhOVativ4U3eXakxdkr9xokIcHzRTMYw8RmP/3SXUv68R6ENpu1flc1k
	 AUIgYqGrNkRtkuuyvZQZ1mcYL0bsV5Lf318dT66w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 13/69] scsi: qla2xxx: Fix off by one in qla_edif_app_getstats()
Date: Mon, 15 Apr 2024 16:20:44 +0200
Message-ID: <20240415141946.571190629@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 4406e4176f47177f5e51b4cc7e6a7a2ff3dbfbbd ]

The app_reply->elem[] array is allocated earlier in this function and it
has app_req.num_ports elements.  Thus this > comparison needs to be >= to
prevent memory corruption.

Fixes: 7878f22a2e03 ("scsi: qla2xxx: edif: Add getfcinfo and statistic bsgs")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/5c125b2f-92dd-412b-9b6f-fc3a3207bd60@moroto.mountain
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 7aee4d093969a..969008071decd 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -1058,7 +1058,7 @@ qla_edif_app_getstats(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 
 		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
 			if (fcport->edif.enable) {
-				if (pcnt > app_req.num_ports)
+				if (pcnt >= app_req.num_ports)
 					break;
 
 				app_reply->elem[pcnt].rekey_count =
-- 
2.43.0



