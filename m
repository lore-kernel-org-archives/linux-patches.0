Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9489320A
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8ACC433D2;
	Mon,  8 May 2023 11:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544148;
	bh=zg/FSjekkU4algjXcqm//2iYeTCGAsgTynUgScWizjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=moDjr3W2tSG1imxOlYzd4NPj6Wymefc3v94vZA8EYrNtNaxJWJ2zqQTkikev2b7ms
	 Y+zAVc4BSUZsTZZYVZlxKVW40uoov82YImrNkw0jdnzzDXtueffnZyF5k5tZ5ZxLMu
	 Bf+8g0cajupo/zFembpXfelqoenvaEegAHwPG1fQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 285/694] media: cedrus: fix use after free bug in cedrus_remove due to race condition
Date: Mon,  8 May 2023 11:42:00 +0200
Message-Id: <20230508094441.539591894@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit 50d0a7aea4809cef87979d4669911276aa23b71f ]

In cedrus_probe, dev->watchdog_work is bound with cedrus_watchdog function.
In cedrus_device_run, it will started by schedule_delayed_work. If there is
an unfinished work in cedrus_remove, there may be a race condition and
trigger UAF bug.

CPU0                  CPU1

                    |cedrus_watchdog
cedrus_remove       |
  v4l2_m2m_release  |
  kfree(m2m_dev)    |
                    |
                    | v4l2_m2m_get_curr_priv
                    |   m2m_dev //use

Fix it by canceling the worker in cedrus_remove.

Fixes: 7c38a551bda1 ("media: cedrus: Add watchdog for job completion")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
index a43d5ff667163..a50a4d0a8f715 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -547,6 +547,7 @@ static int cedrus_remove(struct platform_device *pdev)
 {
 	struct cedrus_dev *dev = platform_get_drvdata(pdev);
 
+	cancel_delayed_work_sync(&dev->watchdog_work);
 	if (media_devnode_is_registered(dev->mdev.devnode)) {
 		media_device_unregister(&dev->mdev);
 		v4l2_m2m_unregister_media_controller(dev->m2m_dev);
-- 
2.39.2



