Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E722FC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:41:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E308C433EF;
	Mon, 15 May 2023 17:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172503;
	bh=TKlScOMpG9D9dm91T3m0t+4SlTlHyF+P2q4/sHpXZRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PllIanSrQVJaH0WFGHNJ68O3nPedNhef4QaRCq8bQ5RPhT1XpHMnqvP9k44sUHmS4
	 8FjEFP8CvfI7LKFptmEHPhkFQwOf5vrfIzauoLLqetREthFsvoPJO87Jv5ezOAcq6a
	 wQXkcKmf5jkZ1uEkwBChUULBH8CCiKmqBRnRZyqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/381] md/raid10: fix memleak of md thread
Date: Mon, 15 May 2023 18:27:06 +0200
Message-Id: <20230515161744.716873758@linuxfoundation.org>
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
index 51f122db9668e..c6a196a10f894 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3752,6 +3752,9 @@ static int raid10_run(struct mddev *mddev)
 	if (!conf)
 		goto out;
 
+	mddev->thread = conf->thread;
+	conf->thread = NULL;
+
 	if (mddev_is_clustered(conf->mddev)) {
 		int fc, fo;
 
@@ -3764,9 +3767,6 @@ static int raid10_run(struct mddev *mddev)
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



