Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA7536C9EB
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302377; cv=none; b=V3VbBuxD34R7BsP7/MNJVK/TpSG57WaJiZuRXwJx7/lAB1KygkvwwN9GmvzCbEf+i3XcndiaKRd9HigQEz1YSuBpqTSOlQBPHUKSujIw5p0vASD0FTkfU5S7CohVlxzJmfWTAZiCtNB4tbI/jJsx866MArRh6/1Lyxtl5sjsAAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302377; c=relaxed/simple;
	bh=1RYyVlF1ePFbtHVtDLk2wp9y9r6xeScqaa9gDEC500k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJ3vCkd0IjPitbJJyajV8vMe9T4FoqFURdy2LUxgiB8qtRLtVTTP10GM8UB3ezBAYpqV6SaNrRP76QUSsk6nfVw0wdzUz+2qtHsOypCDtWKPmttmp1Gw4xyBlCHj5n2dEqrMq5YQxbUJaT/ZJAbOIopTvfMppBkFTdSo1Kw6Fpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R2ER2XUE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R2ER2XUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26AC5C19423;
	Sat, 28 Feb 2026 18:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302376;
	bh=1RYyVlF1ePFbtHVtDLk2wp9y9r6xeScqaa9gDEC500k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R2ER2XUEXnu8lDyfvd6oEcHzCBNZ9SIKjgcl4OAYiRnaD2uJBZzB9CsIshoHraci/
	 DCbU8/7M4HPSVIGmzGLrHUnN++rgrYU086kzf6K+cN0EfV9d6OSY5YJN/nImGDrqZj
	 E0QoqBkFONKUAgb9hcnLj5LBmuuvBZAX/kQZGM/gLl55PIO7F+km6zIAK2dYyn16Tw
	 WnmROdR25bTg1X5ZBY8ZtBrySkxuSApSrwb9tk9XJO+UwtPtjcDUwhOXmSDxbm859n
	 POQ4CXXO2tVBHlFWdp1IEyaydsuZkxoK5POrMoP47H2O5pgZi+qWwZzEFkhygU17fl
	 bDaL1UNfzp2/g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/232] dm: use bio_clone_blkg_association
Date: Sat, 28 Feb 2026 13:09:17 -0500
Message-ID: <20260228181127.1592657-104-sashal@kernel.org>
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
index f745b9cf462aa..13225b7f11491 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1351,6 +1351,8 @@ void dm_submit_bio_remap(struct bio *clone, struct bio *tgt_clone)
 	if (!tgt_clone)
 		tgt_clone = clone;
 
+	bio_clone_blkg_association(tgt_clone, io->orig_bio);
+
 	/*
 	 * Account io->origin_bio to DM dev on behalf of target
 	 * that took ownership of IO with DM_MAPIO_SUBMITTED.
-- 
2.51.0

