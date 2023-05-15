Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF8C101C0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039B6C433EF;
	Mon, 15 May 2023 17:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173321;
	bh=6eqivIqvpxUu+r7ZqA75Z123J5fIEiGHt3lkV2+eWjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0/QFQU1mVqbfH6odO3cGY1h3sTj7sTeLlAZ5Wpj2HSx4uUV7j7AD448m/TzYD04H
	 hupdnPurcZnmXhi3oMPAcGG76plhJpFgug7nAsFlGQIGGMJjR2q1uYSIBQ8ycASkav
	 aX10P177namUnYOxdJa5RO/lXWiB0oexG1FlKaqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/282] media: saa7134: fix use after free bug in saa7134_finidev due to race condition
Date: Mon, 15 May 2023 18:27:15 +0200
Message-Id: <20230515161723.957109748@linuxfoundation.org>
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

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit 30cf57da176cca80f11df0d9b7f71581fe601389 ]

In saa7134_initdev, it will call saa7134_hwinit1. There are three
function invoking here: saa7134_video_init1, saa7134_ts_init1
and saa7134_vbi_init1.

All of them will init a timer with same function. Take
saa7134_video_init1 as an example. It'll bound &dev->video_q.timeout
with saa7134_buffer_timeout.

In buffer_activate, the timer funtcion is started.

If we remove the module or device which will call saa7134_finidev
to make cleanup, there may be a unfinished work. The
possible sequence is as follows, which will cause a
typical UAF bug.

Fix it by canceling the timer works accordingly before cleanup in
saa7134_finidev.

CPU0                  CPU1

                    |saa7134_buffer_timeout
saa7134_finidev     |
  kfree(dev);       |
                    |
                    | saa7134_buffer_next
                    | //use dev

Fixes: 1e7126b4a86a ("media: saa7134: Convert timers to use timer_setup()")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/saa7134/saa7134-ts.c    | 1 +
 drivers/media/pci/saa7134/saa7134-vbi.c   | 1 +
 drivers/media/pci/saa7134/saa7134-video.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index 6a5053126237f..437dbe5e75e29 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -300,6 +300,7 @@ int saa7134_ts_start(struct saa7134_dev *dev)
 
 int saa7134_ts_fini(struct saa7134_dev *dev)
 {
+	del_timer_sync(&dev->ts_q.timeout);
 	saa7134_pgtable_free(dev->pci, &dev->ts_q.pt);
 	return 0;
 }
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index 3f0b0933eed69..3e773690468bd 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -185,6 +185,7 @@ int saa7134_vbi_init1(struct saa7134_dev *dev)
 int saa7134_vbi_fini(struct saa7134_dev *dev)
 {
 	/* nothing */
+	del_timer_sync(&dev->vbi_q.timeout);
 	return 0;
 }
 
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index e454a288229b8..ea26c8c57494f 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2154,6 +2154,7 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 
 void saa7134_video_fini(struct saa7134_dev *dev)
 {
+	del_timer_sync(&dev->video_q.timeout);
 	/* free stuff */
 	vb2_queue_release(&dev->video_vbq);
 	saa7134_pgtable_free(dev->pci, &dev->video_q.pt);
-- 
2.39.2



