Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CB23446C0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301647; cv=none; b=cHCSyyoEPDzn6IPRaKj6FXr6Im62MkKD3lbPyzh27jESh3m4s6uNH8dw1m2Dyljy7GfWEtG1A8U+SQVERbt68Q8JJqGUOf0tNGTFDCBiAXlZ51Go0GQNiVEqxjhMBKZTC3AfbBuLJmJMSll2V9eXSibvrrv9GD4C6qHI+7bRuLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301647; c=relaxed/simple;
	bh=AeoVkPDVr9ojEbJABSTgaMQWuunrU5pwDM5AhJ+Aqs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqhTlxSU9u6RtPev8x/1eugmD6+WdR+tIXV7bv5oxA73vZE9eF29ZlQG/rwnCUmGrtkz3RSZOUWxwHkRa1/F2awnZQkwkybxnGgHB1tvhfWByMu4EZEG3F9k0h7Wot8Rll1yzcemo2FkhD5xneYOV6ACVZWIikrlR19x6WYBX18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mjEN7PyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mjEN7PyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84329C19424;
	Sat, 28 Feb 2026 18:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301647;
	bh=AeoVkPDVr9ojEbJABSTgaMQWuunrU5pwDM5AhJ+Aqs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjEN7PyZCAv8HYBeBAjm9THvaBwilCTIkSkXaKnsgJ0fZF/PZk2tuxQd1bAKIa0QF
	 /lZHR66kwfLmkZPz5X758pjB0BEZZr8eZFD7y8bcZLZ2OExeUUQt3Npv1Xxj7fvPiv
	 2jRPjYp8fInL3hjs2TyCgwlKfVAGE4/dL1qypPxCytj+5cWcESFUQW6nfL4yngkE8W
	 wrQrlhTwlGnvJ9+LR7/CSUKxX2zUTL0eaG+juuJzuupXaGwAyIOhrVO7A9f0erlfy5
	 IfcB1xtDCTuK/dX5FIHryyjzIGQYD2r3OYHTBUG57S70vIYaa+li83e5l0+ODnbssP
	 MNZ8z54VFArjQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zilin Guan <zilin@seu.edu.cn>,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/385] md/raid1: fix memory leak in raid1_run()
Date: Sat, 28 Feb 2026 12:54:24 -0500
Message-ID: <20260228180011.1568201-42-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 6abc7d5dcf0ee0f85e16e41c87fbd06231f28753 ]

raid1_run() calls setup_conf() which registers a thread via
md_register_thread(). If raid1_set_limits() fails, the previously
registered thread is not unregistered, resulting in a memory leak
of the md_thread structure and the thread resource itself.

Add md_unregister_thread() to the error path to properly cleanup
the thread, which aligns with the error handling logic of other paths
in this function.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Link: https://lore.kernel.org/linux-raid/20260126071533.606263-1-zilin@seu.edu.cn
Fixes: 97894f7d3c29 ("md/raid1: use the atomic queue limit update APIs")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Li Nan <linan122@huawei.com>
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f9c18ade06f15..093b04e6be675 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3247,6 +3247,7 @@ static int raid1_run(struct mddev *mddev)
 	if (!mddev_is_dm(mddev)) {
 		ret = raid1_set_limits(mddev);
 		if (ret) {
+			md_unregister_thread(mddev, &conf->thread);
 			if (!mddev->private)
 				raid1_free(mddev, conf);
 			return ret;
-- 
2.51.0

