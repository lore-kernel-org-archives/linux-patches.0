Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C90F1E4B1;
	Mon, 15 Apr 2024 14:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191619; cv=none; b=EL2SCCFDuMFUsWShPxOru/ciB0KYB7ogj+l4h55Ff63YaNB6xm1RiIrFyZoVEQqPXcMz2Jo+v7UWtbUl6tC1R23h9hoyIEgG8EeUnQQomO9mEWjZHif/tUv3Ux+9PqRC2/JEFlNe77osRzSXKBOLhf2AaMIBC3k8/qX4t0AAnDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191619; c=relaxed/simple;
	bh=wnnavf1Dh4LIRKurvG5rdC/3gRZN/3vKT1SHeogszO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=av4doBvKdJyHcTS+7OxcCuo11P2jK1YVeyl+wpP8M4NlG1efd9rFtO0j8qK678up0yg39SRW3xX1iRcBtnv5x3z+qdTtqNVDk/dHDEtlKQKyAOdDkiBrw18AqsWZrsESQDqJ/a0EWasf3FI59NEI/mWXBxsaHx7YV34afPd1Dno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trrFDeXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trrFDeXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8394C113CC;
	Mon, 15 Apr 2024 14:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191619;
	bh=wnnavf1Dh4LIRKurvG5rdC/3gRZN/3vKT1SHeogszO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trrFDeXgHrF64BJDdULFrsm5bAl5HNM1RYVwIhvLPhAA15BBN1AU1jTkh0Pu+3wad
	 HDfuFyo+2MZM4WSAZ7YXZq4jt8NU9mYfMRIpamWVTlqJihzP3uNMRFJpbpCZDLvELJ
	 d0Iya2kMeDqXuxSefQdadXr337wuO3Mt5ecqYq9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/122] scsi: qla2xxx: Fix off by one in qla_edif_app_getstats()
Date: Mon, 15 Apr 2024 16:19:55 +0200
Message-ID: <20240415141954.275241941@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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
index 26e6b3e3af431..dcde55c8ee5de 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -1100,7 +1100,7 @@ qla_edif_app_getstats(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 
 		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
 			if (fcport->edif.enable) {
-				if (pcnt > app_req.num_ports)
+				if (pcnt >= app_req.num_ports)
 					break;
 
 				app_reply->elem[pcnt].rekey_count =
-- 
2.43.0



