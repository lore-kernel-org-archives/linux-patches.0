Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057125102A;
	Mon, 11 Dec 2023 18:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cI/PgUUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80553C433C7;
	Mon, 11 Dec 2023 18:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320370;
	bh=byrQwR36zx/IXLVqAL9TpA//f6ngbtaJK5aceqni7ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cI/PgUUfWLUZtu1MRst36UQi8WAYNllif8bpF8OyW73sVtZmg1VSR+Lua3ZmoWfKU
	 7Ckz9pbh6JgAgomSkNzt8I1nL1Mk7rcymRqZOmLxp9kQaC2Hyi+5MuFRvXMcegWxIj
	 xQVGgzWPqekpT59D3aoy7AqKcc90Ssz0H4bl6pLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Geethasowjanya Akula <gakula@marvell.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/194] octeontx2-af: fix a use-after-free in rvu_npa_register_reporters
Date: Mon, 11 Dec 2023 19:20:26 +0100
Message-ID: <20231211182038.183484922@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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
index dc7bd2ce78f7d..d609512998992 100644
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



