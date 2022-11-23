Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB70C1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6F0C433C1;
	Wed, 23 Nov 2022 09:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197432;
	bh=Ggfvxl0ZmSZPa8GC1v6biOunhDsqkf/NLhvT9TFQdQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g8mQpoenpTNjaudmay/6gqqSMtIWuFZUmMeLSFc/pDfPzAsQVKvUNu+RHXNEcyOZd
	 2eGDiWA6jdgJi3gqUWEJLNPejSDiBI//Az5e2W+9DlIq1Au5fiD+YmZ/DaTz5vwjLq
	 U0wDm+d0S2g5xk//FpXUR9otNOYDEZg0xboQfAmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mike Christie <michael.chritie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 292/314] scsi: target: tcm_loop: Fix possible name leak in tcm_loop_setup_hba_bus()
Date: Wed, 23 Nov 2022 09:52:17 +0100
Message-Id: <20221123084638.768295973@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

[ Upstream commit bc68e428d4963af0201e92159629ab96948f0893 ]

If device_register() fails in tcm_loop_setup_hba_bus(), the name allocated
by dev_set_name() need be freed. As comment of device_register() says, it
should use put_device() to give up the reference in the error path. So fix
this by calling put_device(), then the name can be freed in kobject_cleanup().
The 'tl_hba' will be freed in tcm_loop_release_adapter(), so it don't need
goto error label in this case.

Fixes: 3703b2c5d041 ("[SCSI] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric module")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221115015042.3652261-1-yangyingliang@huawei.com
Reviewed-by: Mike Christie <michael.chritie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/loopback/tcm_loop.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 4407b56aa6d1..139031ccb700 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -397,6 +397,7 @@ static int tcm_loop_setup_hba_bus(struct tcm_loop_hba *tl_hba, int tcm_loop_host
 	ret = device_register(&tl_hba->dev);
 	if (ret) {
 		pr_err("device_register() failed for tl_hba->dev: %d\n", ret);
+		put_device(&tl_hba->dev);
 		return -ENODEV;
 	}
 
@@ -1073,7 +1074,7 @@ static struct se_wwn *tcm_loop_make_scsi_hba(
 	 */
 	ret = tcm_loop_setup_hba_bus(tl_hba, tcm_loop_hba_no_cnt);
 	if (ret)
-		goto out;
+		return ERR_PTR(ret);
 
 	sh = tl_hba->sh;
 	tcm_loop_hba_no_cnt++;
-- 
2.35.1



