Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1C636C9E0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302306; cv=none; b=TAxjtKXqDEfMHBX3X6M/YIoSH2ymhyj9R9HdQ0y37iI1OAdLinod57ahzDMXUHyfPKue89Vb+OoeEUQhVdccuP2vYp5QKEIxyGO8YHseF7kiUnDFeDSvhQS1CsvMQGxHxjRU6qCVdvaawhzqH38vs74y8avGNzXMAejMqnv4ylc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302306; c=relaxed/simple;
	bh=6VaQvCIVojoYPF7gqTD8uN76+OfmwLGJ8FFNSgx8OKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raPbMzvYkXdjFp8/0/qKpF2RnchrKNAOW8ZpHKMqooV51Lw8E8qeHP/og+j86lHVd1cg1abCGJ+pabSWYQ0kbzCoglIyR2L9zsiM5Ws9Kdm0+NNO9IaXaoWfBPE0jz9to6jbf+jD7jiG55x4vNW2tEsK/qwvMShREYmlGyRq58c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XdoRGKsF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XdoRGKsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3777BC19424;
	Sat, 28 Feb 2026 18:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302306;
	bh=6VaQvCIVojoYPF7gqTD8uN76+OfmwLGJ8FFNSgx8OKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XdoRGKsF8PihCed5BDIzRtFqcYSmcuI0qOrubirPyErE1x0EjeR2p8DCrk2OAmH7A
	 0A8lWX4IUnpUuBiSEGkKubZ7+svQVyCGzpWx3ISjE3v9VUjAegHSyvrjdKqHUrpMNo
	 uSkRqlTJY63lK1Y1IrII8VNAcXTu+E4haIM7ip1u9EMp7eQAyTQXwKV0+vGqmB+z5d
	 OST73d0QOxxczbtqL4rZPFyYM8C/+iXaXtYQLs+qw5+eLrGnfHIGkzXNjLECmUhwYv
	 o61sDDBJuGyZMPOMtRIISAcFVTC3xSay6KAaDJG10d15029hraDqlH0sfUbSRA4lwy
	 +evB7bTbHZNcg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/232] md/raid10: fix any_working flag handling in raid10_sync_request
Date: Sat, 28 Feb 2026 13:07:55 -0500
Message-ID: <20260228181127.1592657-22-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Li Nan <linan122@huawei.com>

[ Upstream commit 99582edb3f62e8ee6c34512021368f53f9b091f2 ]

In raid10_sync_request(), 'any_working' indicates if any IO will
be submitted. When there's only one In_sync disk with badblocks,
'any_working' might be set to 1 but no IO is submitted. Fix it by
setting 'any_working' after badblock checks.

Link: https://lore.kernel.org/linux-raid/20260105110300.1442509-11-linan666@huaweicloud.com
Fixes: e875ecea266a ("md/raid10 record bad blocks as needed during recovery.")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 2ae68b7b79598..99ebcb4475024 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3535,7 +3535,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				    !test_bit(In_sync, &rdev->flags))
 					continue;
 				/* This is where we read from */
-				any_working = 1;
 				sector = r10_bio->devs[j].addr;
 
 				if (is_badblock(rdev, sector, max_sync,
@@ -3550,6 +3549,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 						continue;
 					}
 				}
+				any_working = 1;
 				bio = r10_bio->devs[0].bio;
 				bio->bi_next = biolist;
 				biolist = bio;
-- 
2.51.0

