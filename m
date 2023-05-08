Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7AC168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624CEC433D2;
	Mon,  8 May 2023 10:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542714;
	bh=Rk/rBQbw1VEk0om1RQnQ2alpgvZHjuq3vxNerV11n1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=amZO7qR4EJeQXXgL5hmxwmMteZAU5DuJ6WfTtnwd/qkasEQ+iqyJGQx/1oTRHZY/C
	 2D8z33/Q67GyyfGeE+YBMmxVccTgDu/PySndkeGsX4HJKp9B2ssMJOFj7rsoQVO0oA
	 XFoHuwhxFFaa2mJp4miGiiYAdfrDK14WCIrIDln4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 493/663] firmware: stratix10-svc: Fix an NULL vs IS_ERR() bug in probe
Date: Mon,  8 May 2023 11:45:19 +0200
Message-Id: <20230508094444.427485523@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit e1d6ca042e62c2a69513235f8629eb6e62ca79c5 ]

The svc_create_memory_pool() function returns error pointers.  It never
returns NULL.  Fix the check.

Fixes: 7ca5ce896524 ("firmware: add Intel Stratix10 service layer driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/5f9a8cb4-5a4f-460b-9cdc-2fae6c5b7922@kili.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/stratix10-svc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/stratix10-svc.c b/drivers/firmware/stratix10-svc.c
index bde1f543f5298..80f4e2d14e046 100644
--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -1133,8 +1133,8 @@ static int stratix10_svc_drv_probe(struct platform_device *pdev)
 		return ret;
 
 	genpool = svc_create_memory_pool(pdev, sh_memory);
-	if (!genpool)
-		return -ENOMEM;
+	if (IS_ERR(genpool))
+		return PTR_ERR(genpool);
 
 	/* allocate service controller and supporting channel */
 	controller = devm_kzalloc(dev, sizeof(*controller), GFP_KERNEL);
-- 
2.39.2



