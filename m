Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270B1FBF6
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E516C433D2;
	Mon, 15 May 2023 17:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173337;
	bh=oK1WbgPkpTjEzoAgn0awBJHzstd2h2OygAwWHv8wsIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrGbIvCycvlUQ2vNR+b/f86nMigHIgT/VOr/ksAzO/AkKcydozs6QFuJhgHDMIUnP
	 0k77bhl+Tey2xpJWyH1qzPOluf1QvvAbi9BAOIr7xcUprq+yB1q3XTXwbKpntTWymR
	 g7iHzs2sCQolnhxRYNNKTjjSW1ZjZ/knFjlgWaIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tang Bin <tangbin@cmss.chinamobile.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/282] media: rcar_fdp1: Fix the correct variable assignments
Date: Mon, 15 May 2023 18:27:19 +0200
Message-Id: <20230515161724.072806020@linuxfoundation.org>
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

From: Tang Bin <tangbin@cmss.chinamobile.com>

[ Upstream commit af88c2adbb72a09ab1bb5c37ba388c98fecca69b ]

In the function fdp1_probe(), when get irq failed, the
function platform_get_irq() log an error message, so
remove redundant message here. And the variable type
of "ret" is int, the "fdp1->irq" is unsigned int, when
irq failed, this place maybe wrong, thus fix it.

Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: c766c90faf93 ("media: rcar_fdp1: Fix refcount leak in probe and remove function")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar_fdp1.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
index 90575a58ad880..0967b10a459b1 100644
--- a/drivers/media/platform/rcar_fdp1.c
+++ b/drivers/media/platform/rcar_fdp1.c
@@ -2291,11 +2291,10 @@ static int fdp1_probe(struct platform_device *pdev)
 		return PTR_ERR(fdp1->regs);
 
 	/* Interrupt service routine registration */
-	fdp1->irq = ret = platform_get_irq(pdev, 0);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "cannot find IRQ\n");
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
 		return ret;
-	}
+	fdp1->irq = ret;
 
 	ret = devm_request_irq(&pdev->dev, fdp1->irq, fdp1_irq_handler, 0,
 			       dev_name(&pdev->dev), fdp1);
-- 
2.39.2



