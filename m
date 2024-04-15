Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F42B74E11;
	Mon, 15 Apr 2024 14:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191133; cv=none; b=JtsuQ0RrCwSEqGuRbsqXjOJ5s+84BBchWOpfyoI30OsbkZ1FSPBZal2eSIHpNxYu7fdhbaBSGljNQp8K9h2iRW0d4oxvFUklRo/MLCOMZM08Rpa6lN1GaAZPOtiTR6JG5pJmfpqXX4ekwGKJSBGvNf4rP6RCIX65zSCt5y89PTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191133; c=relaxed/simple;
	bh=GjJjbb6G16tOl8pwyscr4gDjyoBCMkoX/nj8fkdU8BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAVJYxG/I2QnEQlYgodlXk5me6wQ9WQsg38jz6zGN4qIhcivifJg9Zx3CYP0c9Ck/O1wxVQ6O9AhZ+QOIVw4CZsuFnNCkmgd/FjLrD3yus+G5SfrfbnhPOjGZLrPqV7hmvPIx/jyKF7EVJ502GEgZWHPsffDEBV5nPXmwM/4J7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jz9z3Zq8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jz9z3Zq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC270C113CC;
	Mon, 15 Apr 2024 14:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191133;
	bh=GjJjbb6G16tOl8pwyscr4gDjyoBCMkoX/nj8fkdU8BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jz9z3Zq8WZwAPxgPnHe39Rm4xP+h/FjcPLQPpGvVf7x6X37ncuc3Ndl2mx38EDI7Q
	 KQQDymMTo0xuvx+3mN06D8sxzTiuK21ROdh/OU+vOn+91LttCIate37E5o1SuqBAFY
	 rH8l3C7IEpkby52p/fXnDsfMpNA+AnDvAHVBUop4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 042/172] scsi: qla2xxx: Fix off by one in qla_edif_app_getstats()
Date: Mon, 15 Apr 2024 16:19:01 +0200
Message-ID: <20240415142001.701213208@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



