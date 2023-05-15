Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC14FBF6
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFC4C433D2;
	Mon, 15 May 2023 17:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173327;
	bh=rKN8FchKCnzGab1wEBlR+lkjrdbK84rIZCbqKmfAAZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yqaQXdiWJWdNq1c5fJR58zVil/14EbP+2frbR/MN3yK+Pz8NQ7OJlgoRZYht64rez
	 S/aH2zK5v8U3ZYGNmSjXcrKg7qse7ai873toI1qnDmUAEwvyVa3xVvGD0fGmmPzv7b
	 sy4Ej46ua4RbAwnna43aepUkxho8O4b0IzN6kTcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/282] media: rcar_fdp1: simplify error check logic at fdp_open()
Date: Mon, 15 May 2023 18:27:16 +0200
Message-Id: <20230515161723.986317840@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
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
index 97bed45360f08..d6eee66c8dd49 100644
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



