Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A075101A;
	Mon, 11 Dec 2023 18:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2AkDxgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA34C433C7;
	Mon, 11 Dec 2023 18:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319353;
	bh=GNApzdaPjvHSixD/pyfZzjSe5ByNyJIlLFbP385SVUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2AkDxgxtcKy53uQyX/GDTGy1weLyk74HJHObY2pMtyBIah1RVJ13woH06rW6GQjb
	 /j8a51nwB/6F3CjUOWI5shN4JJB2qkxz2vBxkaJs7F1FKqZjxAdh0ko8xMWGU6i7jw
	 Pa/4p97i2LL6qufM++wDH6VosQzVKz73180KTvwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Geethasowjanya Akula <gakula@marvell.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/244] octeontx2-af: fix a use-after-free in rvu_npa_register_reporters
Date: Mon, 11 Dec 2023 19:18:57 +0100
Message-ID: <20231211182047.797737041@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit 3c91c909f13f0c32b0d54d75c3f798479b1a84f5 ]

The rvu_dl will be freed in rvu_npa_health_reporters_destroy(rvu_dl)
after the create_workqueue fails, and after that free, the rvu_dl will
be translate back through rvu_npa_health_reporters_create,
rvu_health_reporters_create, and rvu_register_dl. Finally it goes to the
err_dl_health label, being freed again in
rvu_health_reporters_destroy(rvu) by rvu_npa_health_reporters_destroy.
In the second calls of rvu_npa_health_reporters_destroy, however,
it uses rvu_dl->rvu_npa_health_reporter, which is already freed at
the end of rvu_npa_health_reporters_destroy in the first call.

So this patch prevents the first destroy by instantly returning -ENONMEN
when create_workqueue fails. In addition, since the failure of
create_workqueue is the only entrence of label err, it has been
integrated into the error-handling path of create_workqueue.

Fixes: f1168d1e207c ("octeontx2-af: Add devlink health reporters for NPA")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Geethasowjanya Akula <gakula@marvell.com>
Link: https://lore.kernel.org/r/20231202095902.3264863-1-alexious@zju.edu.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 41df5ac23f927..058f75dc4c8a5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -1285,7 +1285,7 @@ static int rvu_npa_register_reporters(struct rvu_devlink *rvu_dl)
 
 	rvu_dl->devlink_wq = create_workqueue("rvu_devlink_wq");
 	if (!rvu_dl->devlink_wq)
-		goto err;
+		return -ENOMEM;
 
 	INIT_WORK(&rvu_reporters->intr_work, rvu_npa_intr_work);
 	INIT_WORK(&rvu_reporters->err_work, rvu_npa_err_work);
@@ -1293,9 +1293,6 @@ static int rvu_npa_register_reporters(struct rvu_devlink *rvu_dl)
 	INIT_WORK(&rvu_reporters->ras_work, rvu_npa_ras_work);
 
 	return 0;
-err:
-	rvu_npa_health_reporters_destroy(rvu_dl);
-	return -ENOMEM;
 }
 
 static int rvu_npa_health_reporters_create(struct rvu_devlink *rvu_dl)
-- 
2.42.0



