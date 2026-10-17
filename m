Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A99387373;
	Sat, 17 Oct 2026 16:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255997; cv=none; b=JI+xe5vpoIN6xgdhQDHBr2pkZHmlK3mAPQgEkEL8+vkTfMAZWuNJQikpQRiXO2Rt6M9Ahhv5/pXmpSqJh2hOVBZ4YFLqQXLCShqN8V0XL3hcIWlCVoTaZ0LW7IgDXXLJc2AMnKHWaVKcguqK7Zw2wEekZzshwjF8ks4/0RYeqto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255997; c=relaxed/simple;
	bh=9/J4NSyhEX0IbtSdUFf9MQqi+JDpXtYIRkgZo2jg6rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZejc9NBMy9TQJv+kXDF33quCmp5zg104cQ9+Ys8SQClBrwdifkEtk73a5lSZ3GGqLKiMa1vDzf7xEdYyAl+jxXcskEGysfyfWCHBUbNUIMq+/X31mBIxD9S/JQpXIP81Ed4Oz0/SYK6qC9KJsJ/xiIjDQK9A82q4JLniGwhZWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YF9yFPqG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YF9yFPqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689D81F000C4;
	Sat, 17 Oct 2026 16:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255996;
	bh=q1nac6gxX4/76+XBQJ7y1KePibMlK+UJwPXkj6w42kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YF9yFPqGG5YqO7sWdbCH6Clie1DJxh1zDmo0V5dluEphOluEpCR7eghCuPkH4rjzM
	 TVBjkEXeiCphVUbjd6XIEUmI6emxW65bdiz4eN1sUbkOcJBBnRHhBGHXLRFk0+aSj/
	 H0XJdwUCHKcpFjAbbdPxNuOssMxERx207tgk1ZZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moudy Ho <moudy.ho@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0090/1674] media: platform: mtk-mdp3: fix NULL deref on failed SCP lookup
Date: Sat, 17 Oct 2026 17:39:22 +0200
Message-ID: <20261017160433.449358141@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 90368323fb244da0504e3da37a182f8e89bcc3b9 ]

Add the missing sanity check after looking up the SCP to avoid
dereferencing a NULL-pointer in case its driver has not yet been bound.

Fixes: 61890ccaefaf ("media: platform: mtk-mdp3: add MediaTek MDP3 driver")
Cc: stable@vger.kernel.org	# 6.1
Cc: Moudy Ho <moudy.ho@mediatek.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ Adapted NULL-check placement to the older direct platform_get_drvdata() lookup. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c
index cc44be10fdb77..50d1458339343 100644
--- a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c
+++ b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c
@@ -215,6 +215,11 @@ static int mdp_probe(struct platform_device *pdev)
 		goto err_destroy_clock_wq;
 	}
 	mdp->scp = platform_get_drvdata(mm_pdev);
+	if (!mdp->scp) {
+		ret = -EPROBE_DEFER;
+		goto err_destroy_clock_wq;
+	}
+
 	mdp->rproc_handle = scp_get_rproc(mdp->scp);
 	dev_dbg(&pdev->dev, "MDP rproc_handle: %pK", mdp->rproc_handle);
 
-- 
2.53.0



