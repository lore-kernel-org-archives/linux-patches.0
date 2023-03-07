Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97687BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:36:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24C3C433D2;
	Tue,  7 Mar 2023 17:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210570;
	bh=FO9ouAa5rATCJduQ6vm2USYRmIMUEfyeNf+JC8crKXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pep9T9LYfN4k568sDRpKlnYdq3TTDYNY50tlKyaoeY8DA3Q90Jj4xVKWOqiz7euAy
	 ofGDrQImisD4EiCabq/yiKyUW11mB87UTr1nxfgugy/GmGva8u645WUBsiAXl4wMBV
	 6KUCIBp3ETftmsKPUbvz8OnTlIUEoQ0oIjAlzJC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0583/1001] media: ti: cal: fix possible memory leak in cal_ctx_create()
Date: Tue,  7 Mar 2023 17:55:55 +0100
Message-Id: <20230307170046.780671838@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

[ Upstream commit 7acd650a0484d92985a0d6d867d980c6dd019885 ]

The memory of ctx is allocated in cal_ctx_create(), but it will
not be freed when cal_ctx_v4l2_init() fails, so add kfree() when
cal_ctx_v4l2_init() fails to fix it.

Fixes: d68a94e98a89 ("media: ti-vpe: cal: Split video device initialization and registration")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti/cal/cal.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti/cal/cal.c b/drivers/media/platform/ti/cal/cal.c
index 56b61c0583cf8..1236215ec70eb 100644
--- a/drivers/media/platform/ti/cal/cal.c
+++ b/drivers/media/platform/ti/cal/cal.c
@@ -1050,8 +1050,10 @@ static struct cal_ctx *cal_ctx_create(struct cal_dev *cal, int inst)
 	ctx->cport = inst;
 
 	ret = cal_ctx_v4l2_init(ctx);
-	if (ret)
+	if (ret) {
+		kfree(ctx);
 		return NULL;
+	}
 
 	return ctx;
 }
-- 
2.39.2



