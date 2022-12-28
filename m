Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03531C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650B4C433D2;
	Wed, 28 Dec 2022 16:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244302;
	bh=OfY6zGByrBbKsvEdV91BP/2dfIMi1sIKjsty/X+0mVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dh3dNbQ49uoSeW3437B6ptf04BCo7xO9tcPuO5fPvsaI2Xt89Ib/BXrkV985yVA/9
	 UutA7gqUCwXYEGFQd1j/joo1D7ezYeTOkAiGAfToVhMwwWpsNXtbF4FlZ2Mwp1uKUS
	 ShMSp52yjU3TDFNX1edqou/J5eq+U2in+OLWTPOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0647/1146] scsi: hpsa: Fix possible memory leak in hpsa_add_sas_device()
Date: Wed, 28 Dec 2022 15:36:26 +0100
Message-Id: <20221228144347.733845190@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit fda34a5d304d0b98cc967e8763b52221b66dc202 ]

If hpsa_sas_port_add_rphy() returns an error, the 'rphy' allocated in
sas_end_device_alloc() needs to be freed. Address this by calling
sas_rphy_free() in the error path.

Fixes: d04e62b9d63a ("hpsa: add in sas transport class")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221111043012.1074466-1-yangyingliang@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hpsa.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6696967c5192..4dbf51e2623a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -9823,10 +9823,12 @@ static int hpsa_add_sas_device(struct hpsa_sas_node *hpsa_sas_node,
 
 	rc = hpsa_sas_port_add_rphy(hpsa_sas_port, rphy);
 	if (rc)
-		goto free_sas_port;
+		goto free_sas_rphy;
 
 	return 0;
 
+free_sas_rphy:
+	sas_rphy_free(rphy);
 free_sas_port:
 	hpsa_free_sas_port(hpsa_sas_port);
 	device->sas_port = NULL;
-- 
2.35.1



