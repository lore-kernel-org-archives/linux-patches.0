Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CAC8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2D0C433C8;
	Sun, 16 Jul 2023 20:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538856;
	bh=XZS/KRT6+rroDkcBeQwrKdTOSWOjd6ZTk8AWqLBfZE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0y5fQ/fxaeZoYa72jqOB0bGoXRJBuf6g6lIrzbA0XIa3hfr5+ixVvJkE2X99RVbJ
	 zOrC+WxL46bEQ50GVia5AdqxkxC50KaoPH4jjsq4owL9BsmtI0244ooQlCUqN8NjqX
	 4WmK/zJKC3nUUFKnB5P/68YgoXqOjpD5DyQwPQ3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clark Wang <xiaoning.wang@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 601/800] i3c: master: svc: fix cpu schedule in spin lock
Date: Sun, 16 Jul 2023 21:47:34 +0200
Message-ID: <20230716195003.062437399@linuxfoundation.org>
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

From: Clark Wang <xiaoning.wang@nxp.com>

[ Upstream commit 33beadb3b1ab74e69db2c49d9663f3a93a273943 ]

pm_runtime_resume_and_get() may call sleep(). It cannot be used in
svc_i3c_master_start_xfer_locked(), because it is in a spin lock.

Move the pm runtime operations to svc_i3c_master_enqueue_xfer().

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Fixes: 05be23ef78f7 ("i3c: master: svc: add runtime pm support")
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20230517033030.3068085-2-xiaoning.wang@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index e3f454123805e..79b08942a925d 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -1090,12 +1090,6 @@ static void svc_i3c_master_start_xfer_locked(struct svc_i3c_master *master)
 	if (!xfer)
 		return;
 
-	ret = pm_runtime_resume_and_get(master->dev);
-	if (ret < 0) {
-		dev_err(master->dev, "<%s> Cannot get runtime PM.\n", __func__);
-		return;
-	}
-
 	svc_i3c_master_clear_merrwarn(master);
 	svc_i3c_master_flush_fifo(master);
 
@@ -1110,9 +1104,6 @@ static void svc_i3c_master_start_xfer_locked(struct svc_i3c_master *master)
 			break;
 	}
 
-	pm_runtime_mark_last_busy(master->dev);
-	pm_runtime_put_autosuspend(master->dev);
-
 	xfer->ret = ret;
 	complete(&xfer->comp);
 
@@ -1133,6 +1124,13 @@ static void svc_i3c_master_enqueue_xfer(struct svc_i3c_master *master,
 					struct svc_i3c_xfer *xfer)
 {
 	unsigned long flags;
+	int ret;
+
+	ret = pm_runtime_resume_and_get(master->dev);
+	if (ret < 0) {
+		dev_err(master->dev, "<%s> Cannot get runtime PM.\n", __func__);
+		return;
+	}
 
 	init_completion(&xfer->comp);
 	spin_lock_irqsave(&master->xferqueue.lock, flags);
@@ -1143,6 +1141,9 @@ static void svc_i3c_master_enqueue_xfer(struct svc_i3c_master *master,
 		svc_i3c_master_start_xfer_locked(master);
 	}
 	spin_unlock_irqrestore(&master->xferqueue.lock, flags);
+
+	pm_runtime_mark_last_busy(master->dev);
+	pm_runtime_put_autosuspend(master->dev);
 }
 
 static bool
-- 
2.39.2



