Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DDAE556
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:59:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806FDC433EF;
	Mon, 15 May 2023 17:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173559;
	bh=ArgVO4AARk7EI8t4T8olVXhukXhYiLt/ouggLhzTVHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJe5/j7nl2ZJW2f5o+a1qsAkoqaDCJRGgNoq1pFXrOoNQ2k//23ceE8eE0vn9DCsA
	 JdyUiKBzTAuyRMDYQiQRKO8g8R35or+EZnI6FG8rToUI36pa1Gi8U3kqSjeLn3FxfY
	 ygluTdfs67Wf8ubRoxPBhTbIZFXlZx+o1lK71W6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 105/282] md/raid10: fix memleak of md thread
Date: Mon, 15 May 2023 18:28:03 +0200
Message-Id: <20230515161725.398883056@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit f0ddb83da3cbbf8a1f9087a642c448ff52ee9abd ]

In raid10_run(), if setup_conf() succeed and raid10_run() failed before
setting 'mddev->thread', then in the error path 'conf->thread' is not
freed.

Fix the problem by setting 'mddev->thread' right after setup_conf().

Fixes: 43a521238aca ("md-cluster: choose correct label when clustered layout is not supported")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230310073855.1337560-7-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b37e3cd4e3673..c792683a0dea2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3769,6 +3769,9 @@ static int raid10_run(struct mddev *mddev)
 	if (!conf)
 		goto out;
 
+	mddev->thread = conf->thread;
+	conf->thread = NULL;
+
 	if (mddev_is_clustered(conf->mddev)) {
 		int fc, fo;
 
@@ -3781,9 +3784,6 @@ static int raid10_run(struct mddev *mddev)
 		}
 	}
 
-	mddev->thread = conf->thread;
-	conf->thread = NULL;
-
 	if (mddev->queue) {
 		blk_queue_max_discard_sectors(mddev->queue,
 					      mddev->chunk_sectors);
-- 
2.39.2



