Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D978C168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE9FC433EF;
	Mon,  8 May 2023 10:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540207;
	bh=Z/QWEeChUg/0tX5Wv/oH0TJy2/Dcj2j0rB7GzzZhVIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BC5i5OwL7pLBy2WVaX5TsEn8obeoH3EobMKoPT42EYghUEFnyl+mOB3g6rTbdfZtq
	 D1dQlgqNS9bCUbMPxpSz8MR3KGvulrtK11H+aeVLxkWDCUA2qOAwiGl/6Jbf8FCH/K
	 MLSTljHOFe7vbbMK/A+bngrk7wbjUq5UmHa6nj8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 245/611] media: rcar_fdp1: Fix refcount leak in probe and remove function
Date: Mon,  8 May 2023 11:41:27 +0200
Message-Id: <20230508094430.380308590@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit c766c90faf93897b77c9c5daa603cffab85ba907 ]

rcar_fcp_get() take reference, which should be balanced with
rcar_fcp_put(). Add missing rcar_fcp_put() in fdp1_remove and
the error paths of fdp1_probe() to fix this.

Fixes: 4710b752e029 ("[media] v4l: Add Renesas R-Car FDP1 Driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
[hverkuil: resolve merge conflict, remove() is now void]
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/renesas/rcar_fdp1.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/renesas/rcar_fdp1.c b/drivers/media/platform/renesas/rcar_fdp1.c
index 37ecf489d112e..dea22e3579052 100644
--- a/drivers/media/platform/renesas/rcar_fdp1.c
+++ b/drivers/media/platform/renesas/rcar_fdp1.c
@@ -2313,8 +2313,10 @@ static int fdp1_probe(struct platform_device *pdev)
 
 	/* Determine our clock rate */
 	clk = clk_get(&pdev->dev, NULL);
-	if (IS_ERR(clk))
-		return PTR_ERR(clk);
+	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
+		goto put_dev;
+	}
 
 	fdp1->clk_rate = clk_get_rate(clk);
 	clk_put(clk);
@@ -2323,7 +2325,7 @@ static int fdp1_probe(struct platform_device *pdev)
 	ret = v4l2_device_register(&pdev->dev, &fdp1->v4l2_dev);
 	if (ret) {
 		v4l2_err(&fdp1->v4l2_dev, "Failed to register video device\n");
-		return ret;
+		goto put_dev;
 	}
 
 	/* M2M registration */
@@ -2393,6 +2395,8 @@ static int fdp1_probe(struct platform_device *pdev)
 unreg_dev:
 	v4l2_device_unregister(&fdp1->v4l2_dev);
 
+put_dev:
+	rcar_fcp_put(fdp1->fcp);
 	return ret;
 }
 
@@ -2404,6 +2408,7 @@ static int fdp1_remove(struct platform_device *pdev)
 	video_unregister_device(&fdp1->vfd);
 	v4l2_device_unregister(&fdp1->v4l2_dev);
 	pm_runtime_disable(&pdev->dev);
+	rcar_fcp_put(fdp1->fcp);
 
 	return 0;
 }
-- 
2.39.2



