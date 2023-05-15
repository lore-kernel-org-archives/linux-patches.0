Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55518FC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:38:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA6BC433D2;
	Mon, 15 May 2023 17:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172300;
	bh=bpaJgpUMqXR7Nh37UtEikUg8/XQ6nPBBY4b6eeHzMpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKBjRj6XOXz+dKSh2inI9IvwsCxUrLQaZ1CXhxwOIuYqG6quBe69KW/6DWv06+/SV
	 yH/SqS+26J3aaHHalL2lk7YaQdMRD6Hve7vcrT0w/s5eNNU7g1J9zbeUGVNQWq1FMI
	 CxTHWdMTSj0llojCPqpE1iv3UGZA+8MTG7L+H0b0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/381] media: rcar_fdp1: simplify error check logic at fdp_open()
Date: Mon, 15 May 2023 18:26:00 +0200
Message-Id: <20230515161741.730113785@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit fa9f443f7c962d072d150472e2bb77de39817a9a ]

Avoid some code duplication by moving the common error path
logic at fdp_open().

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: c766c90faf93 ("media: rcar_fdp1: Fix refcount leak in probe and remove function")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar_fdp1.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
index c9448de885b62..ac2e7b2c60829 100644
--- a/drivers/media/platform/rcar_fdp1.c
+++ b/drivers/media/platform/rcar_fdp1.c
@@ -2121,9 +2121,7 @@ static int fdp1_open(struct file *file)
 
 	if (ctx->hdl.error) {
 		ret = ctx->hdl.error;
-		v4l2_ctrl_handler_free(&ctx->hdl);
-		kfree(ctx);
-		goto done;
+		goto error_ctx;
 	}
 
 	ctx->fh.ctrl_handler = &ctx->hdl;
@@ -2137,10 +2135,7 @@ static int fdp1_open(struct file *file)
 
 	if (IS_ERR(ctx->fh.m2m_ctx)) {
 		ret = PTR_ERR(ctx->fh.m2m_ctx);
-
-		v4l2_ctrl_handler_free(&ctx->hdl);
-		kfree(ctx);
-		goto done;
+		goto error_ctx;
 	}
 
 	/* Perform any power management required */
@@ -2151,6 +2146,12 @@ static int fdp1_open(struct file *file)
 	dprintk(fdp1, "Created instance: %p, m2m_ctx: %p\n",
 		ctx, ctx->fh.m2m_ctx);
 
+	mutex_unlock(&fdp1->dev_mutex);
+	return 0;
+
+error_ctx:
+	v4l2_ctrl_handler_free(&ctx->hdl);
+	kfree(ctx);
 done:
 	mutex_unlock(&fdp1->dev_mutex);
 	return ret;
-- 
2.39.2



