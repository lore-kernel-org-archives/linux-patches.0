Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5541FBF6
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2180EC4339B;
	Mon, 15 May 2023 17:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172706;
	bh=PsqgKafZcqs7T4IVecJejKrs8cnA6FFjnjY/okz6uSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cy7hB/67gVQDaZlFOPyVhNGrFuKUMV8WIIWq3rDBKN3MP3iOJQ/LKYvqHfSI7QoKs
	 2eufMEVTEhKEi5VGDO3Dp9XexJVt72FAdDhiwHQibJj610V6FyHRlttvyEA9qddIRZ
	 tN0UQVOvxoFOGe67g0UhjLWruqwHsUJVOU3KXrxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 223/381] firmware: stratix10-svc: Fix an NULL vs IS_ERR() bug in probe
Date: Mon, 15 May 2023 18:27:54 +0200
Message-Id: <20230515161746.800339847@linuxfoundation.org>
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
index 7dd0ac1a0cfc7..78a446cb43486 100644
--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -989,8 +989,8 @@ static int stratix10_svc_drv_probe(struct platform_device *pdev)
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



