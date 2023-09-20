Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893CA2AB21
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE3CC433C7;
	Wed, 20 Sep 2023 11:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210985;
	bh=Ebgu6/tj3XwNY0+DFxoQSMKhM/+O5u1r2vPlYq91mTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1GEOBQ84eiPlDABLBHqPq0qrL/X5uN99DckBhtgASe8uCfs7ve2i2HvMQog2DR+o
	 i50FW1zfRemZQKEuFWXejrtkui3h5Tqnm3bU+iMzYfb1BKPHtns4LvGO+RM/12bRc8
	 KKlUj5PZhHXOKrOkmwLbKSmMgg0v8TkqfznK31RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Hongfei <luhongfei@vivo.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/139] media: mdp3: Fix resource leaks in of_find_device_by_node
Date: Wed, 20 Sep 2023 13:29:59 +0200
Message-ID: <20230920112838.127943147@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Hongfei <luhongfei@vivo.com>

[ Upstream commit 35ca8ce495366909b4c2e701d1356570dd40c4e2 ]

Use put_device to release the object get through of_find_device_by_node,
avoiding resource leaks.

Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/mdp3/mtk-mdp3-comp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-comp.c b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-comp.c
index 7bc05f42a23c1..9a3f46c1f6ba3 100644
--- a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-comp.c
+++ b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-comp.c
@@ -775,11 +775,13 @@ static int mdp_get_subsys_id(struct device *dev, struct device_node *node,
 	ret = cmdq_dev_get_client_reg(&comp_pdev->dev, &cmdq_reg, index);
 	if (ret != 0) {
 		dev_err(&comp_pdev->dev, "cmdq_dev_get_subsys fail!\n");
+		put_device(&comp_pdev->dev);
 		return -EINVAL;
 	}
 
 	comp->subsys_id = cmdq_reg.subsys;
 	dev_dbg(&comp_pdev->dev, "subsys id=%d\n", cmdq_reg.subsys);
+	put_device(&comp_pdev->dev);
 
 	return 0;
 }
-- 
2.40.1



