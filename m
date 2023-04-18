Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471322566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:33:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AD4C433EF;
	Tue, 18 Apr 2023 12:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821238;
	bh=vH+5IKCFPbkXD4a0PudxpTwqg30/MXp64t7nVP0SMo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mcglHybCcVahQSJvruzH+2ST4ryzIQHCuhIkOahRoMOfmiKG0Exfuf+1KLDOBHoVP
	 0JrMKhV7dXOsEZT0dktnGDdV0QbTBGzNRv9rwDdf/rQH5pThoj8GfIhlJU2a6VGjmw
	 PcjKPO7zWvoXj6o+CmnT+SVrMtEnmZtwIgyVqyQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>
Subject: [PATCH 5.10 050/124] Revert "media: ti: cal: fix possible memory leak in cal_ctx_create()"
Date: Tue, 18 Apr 2023 14:21:09 +0200
Message-Id: <20230418120311.657225377@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaosheng Cui <cuigaosheng1@huawei.com>

This reverts commit c7a218cbf67fffcd99b76ae3b5e9c2e8bef17c8c.

The memory of ctx is allocated by devm_kzalloc in cal_ctx_create,
it should not be freed by kfree when cal_ctx_v4l2_init() fails,
otherwise kfree() will cause double free, so revert this patch.

The memory of ctx is allocated by kzalloc since commit
9e67f24e4d9 ("media: ti-vpe: cal: fix ctx uninitialization"),
so the fixes tag of patch c7a218cbf67fis not entirely accurate,
mainline should merge this patch, but it should not be merged
into 5.10, so we just revert this patch for this branch.

Fixes: c7a218cbf67f ("media: ti: cal: fix possible memory leak in cal_ctx_create()")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/ti-vpe/cal.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -624,10 +624,8 @@ static struct cal_ctx *cal_ctx_create(st
 	ctx->cport = inst;
 
 	ret = cal_ctx_v4l2_init(ctx);
-	if (ret) {
-		kfree(ctx);
+	if (ret)
 		return NULL;
-	}
 
 	return ctx;
 }


