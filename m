Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319E338F629
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302133; cv=none; b=FBz/IhigzPMzlOKo0W14/Fr5tzdCulcJxz3zoazmRhLdx4qVvrNaKZlnZyrO2cCSc08L2orwKsOyO/upXQfdvskLhDsU3qUhchtGEzM5c51uLRpYGc6PeOXWcr0V31Tj+4kcYLZLnbl/RhZq63svRelAvR2hPKTzsJHhg1LPHPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302133; c=relaxed/simple;
	bh=FMvcOBzM6GVPkIBzfsmJlbbz4/gYc1gXPbsBpSae/TI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+RVNALU6fjvqQf+5fPJ1rTpSHjrqUoInvwrlzhE3cBWP45UlCTXWiA88AdoW5k4nOwh6gykWaG9EAGib8EoeMNSIY4bXyQDDaJc3wsCjv9QZoW5+9O73+mwIGELmhY+wYLPu4IRsSezHaRZwA8Mst5/myi5BiVs2npEZd9Y5vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dk9L5e3L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dk9L5e3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9839FC19423;
	Sat, 28 Feb 2026 18:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302133;
	bh=FMvcOBzM6GVPkIBzfsmJlbbz4/gYc1gXPbsBpSae/TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dk9L5e3LI36/6dUgs55LGKPWyEtHK7UxE9cjZMn86PQDOXTPRFljTcZAzG7F45PEc
	 ZkrhRelLeZhBMP8QcLr3ZOGxuFGNiSI2+5RXwRDywWO54f3xvPT9JK+AIyE1e2/qRw
	 v8hfGC+rqUBn/wrKnMdV1dBE4sjRF7yM1qIQ6Ocj+n5dtNsugWUU0+Sk729VLClJzf
	 qtgyVJXqbsC5JTFecg6a5vhlQmhKJiLTwG780RSJ912HFWBjR/qM6B2FlXnRehHlDZ
	 c888YQ5KFoo/grbl0YnDS98yG1l9bF4sMLKUWOxYrE9RYRVQnqB1Cv9+8iX31MzgAL
	 rGYkRWNj7lnCg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/283] dm: use bio_clone_blkg_association
Date: Sat, 28 Feb 2026 13:04:26 -0500
Message-ID: <20260228180709.1583486-124-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 2df8b310bcfe76827fd71092f58a2493ee6590b0 ]

The origin bio carries blk-cgroup information which could be set from
foreground(task_css(css) - wbc->wb->blkcg_css), so the blkcg won't
control buffer io since commit ca522482e3eaf ("dm: pass NULL bdev to
bio_alloc_clone"). The synchronous io is still under control by blkcg,
because 'bio->bi_blkg' is set by io submitting task which has been added
into 'cgroup.procs'.

Fix it by using bio_clone_blkg_association when submitting a cloned bio.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220985
Fixes: ca522482e3eaf ("dm: pass NULL bdev to bio_alloc_clone")
Reported-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Tested-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f0c4c3553c016..1d03536fded00 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1363,6 +1363,8 @@ void dm_submit_bio_remap(struct bio *clone, struct bio *tgt_clone)
 	if (!tgt_clone)
 		tgt_clone = clone;
 
+	bio_clone_blkg_association(tgt_clone, io->orig_bio);
+
 	/*
 	 * Account io->origin_bio to DM dev on behalf of target
 	 * that took ownership of IO with DM_MAPIO_SUBMITTED.
-- 
2.51.0

