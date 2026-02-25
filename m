Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8311E2834;
	Wed, 25 Feb 2026 01:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984023; cv=none; b=m0YmksdyWDevz6Od8l+CeJQ4CvhOvlw4672hqayClOUyCMeV9W/QrZQYwufQ33Mq5sWSHQYQRoDHkgQtXbyeB3nWjpWVcMdjKsjFcix8mO4LA6uwuVeRIrbc2+E7KQtlEABLEJsoyVcb+d/GDGZF5XtARvK/Im8BwWXtYnEWT94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984023; c=relaxed/simple;
	bh=xibSOYnMlT/zJ9hlsZn66bYUYd+sBDtitoneK7Orlbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUrcLZz3+1BxgrME36Vz0Kkgbj579bReYl02vqwoOKMLSOphdn4QbSkqCz96lHytmlbylmWjv6ftZU5vXfXWZaBZG2bl562peLmRzxLxNi1AUKNaJR8YJ9hZ2In0XBCU52K+rHGraDDOIQG/2bP3OdgCafA0Bk7idoe1kVYVHQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FL5DzNcX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FL5DzNcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C5FC116D0;
	Wed, 25 Feb 2026 01:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984023;
	bh=xibSOYnMlT/zJ9hlsZn66bYUYd+sBDtitoneK7Orlbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FL5DzNcX1jXpZ+bttbWt3O6vRVTAJJpakqixy+ChfH5DfDIPJQzpjprqcaZabHI1+
	 kUPe6sNtDYlf7OM+z9Js3jc7jot9BAIqmjENhLvfGN4UBc7HOG7jgafKKlYLVN90IF
	 wlb1tymGp51FjFFyEgZK+DJFGVNceGXw3liEiG24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 269/641] dm: use bio_clone_blkg_association
Date: Tue, 24 Feb 2026 17:19:55 -0800
Message-ID: <20260225012355.320346499@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 6c83ab940af75..52f01c44e73a6 100644
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



