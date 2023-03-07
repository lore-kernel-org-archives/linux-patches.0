Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8343CBA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E20C433D2;
	Tue,  7 Mar 2023 17:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210579;
	bh=cCqQIGm9fMkHgIyiODid/+uhkH9QJkxMWagOqX5XdTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=14dKHR0CsMDdHUDxhBJ0B87BGjOKnyOn9cKs+8g8bbTs6l3F0MZTjUewCVoZzRv23
	 sHf67hgYFPk3dqp7bxxZdDxVnSvXBk2Pw2apdDl+BDw1Fk47atn7rwUOQJRTMZduaU
	 dfEdRI6l9o3iR6tojW2b5MeRLIA2IBFU9GBwMKXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Rui Miguel Silva <rmfrfs@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0585/1001] media: imx: imx7-media-csi: fix missing clk_disable_unprepare() in imx7_csi_init()
Date: Tue,  7 Mar 2023 17:55:57 +0100
Message-Id: <20230307170046.873332102@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit cea606d9e996a77eed57fc60709e0728341450e3 ]

Add missing clk_disable_unprepare(), if imx7_csi_dma_setup() fails
in imx7_csi_init().

Fixes: ff43ca911978 ("media: imx: imx7-media-csi: Move CSI configuration before source start")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Rui Miguel Silva <rmfrfs@gmail.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/nxp/imx7-media-csi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/nxp/imx7-media-csi.c b/drivers/media/platform/nxp/imx7-media-csi.c
index 886374d3a6ff1..1ef92c8c0098c 100644
--- a/drivers/media/platform/nxp/imx7-media-csi.c
+++ b/drivers/media/platform/nxp/imx7-media-csi.c
@@ -638,8 +638,10 @@ static int imx7_csi_init(struct imx7_csi *csi)
 	imx7_csi_configure(csi);
 
 	ret = imx7_csi_dma_setup(csi);
-	if (ret < 0)
+	if (ret < 0) {
+		clk_disable_unprepare(csi->mclk);
 		return ret;
+	}
 
 	return 0;
 }
-- 
2.39.2



