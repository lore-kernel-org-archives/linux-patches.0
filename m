Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9E015218A;
	Tue,  2 Jul 2024 17:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941036; cv=none; b=PuXBHbwVRcdVgUvUcUxadmxwdLVsGPQesQxNwENWl90IRTKDYl6bbFusMgLsqvFOuYShwJ2+nQFOjPr+K0AmG78toWUX2o3zZIzuGA99khaS+qb+KqXKHhHmsqyAZQEY5KcM+lRw4qcJU3OFARZHewf5zY25VqxQyvHTEsckkeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941036; c=relaxed/simple;
	bh=1Rva4NJ0zE8W7WnfxIxScwCE234edJYlbZZB5LwpSPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l34J2z5ssUWHzD9W8DkkJLIp+nQ2Ybj4Nxer/LzMzNccT9KP/WgtC7X/FYXqQVnsgIy8TJQZF3khpC8SnnNnDVhr4tx9vScqR2DtrUN4JDmW9O+JUVXLLsyAWIxzFNs16z+AKoCHScDPJDjL0Cm3t19J6ca5oxDxdb6gw3hJENM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m1nfotlG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m1nfotlG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4806C116B1;
	Tue,  2 Jul 2024 17:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941036;
	bh=1Rva4NJ0zE8W7WnfxIxScwCE234edJYlbZZB5LwpSPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m1nfotlG2qHwfby7AnPR0JlAHsr4Nl9sKGKmh0uPnP4XgHDhvHNKSZF/H59ei4XE6
	 1sbeeIC5G+PAEQ13XfJmyCFSmxpGFlIwlT9pep6UhCtiE2U88KrSrNI10mYW2qFjFR
	 BNe6KziMO1x/ggEhi9XM/ghbtMwpHgzh+ca5OxQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/163] gfs2: Fix NULL pointer dereference in gfs2_log_flush
Date: Tue,  2 Jul 2024 19:03:02 +0200
Message-ID: <20240702170235.639535508@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 35264909e9d1973ab9aaa2a1b07cda70f12bb828 ]

In gfs2_jindex_free(), set sdp->sd_jdesc to NULL under the log flush
lock to provide exclusion against gfs2_log_flush().

In gfs2_log_flush(), check if sdp->sd_jdesc is non-NULL before
dereferencing it.  Otherwise, we could run into a NULL pointer
dereference when outstanding glock work races with an unmount
(glock_work_func -> run_queue -> do_xmote -> inode_go_sync ->
gfs2_log_flush).

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/log.c   | 3 ++-
 fs/gfs2/super.c | 4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 88bc9b1b22650..767549066066c 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -1102,7 +1102,8 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl, u32 flags)
 	lops_before_commit(sdp, tr);
 	if (gfs2_withdrawing_or_withdrawn(sdp))
 		goto out_withdraw;
-	gfs2_log_submit_bio(&sdp->sd_jdesc->jd_log_bio, REQ_OP_WRITE);
+	if (sdp->sd_jdesc)
+		gfs2_log_submit_bio(&sdp->sd_jdesc->jd_log_bio, REQ_OP_WRITE);
 	if (gfs2_withdrawing_or_withdrawn(sdp))
 		goto out_withdraw;
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 2e1d1eca4d14a..8b34c6cf9293f 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -67,9 +67,13 @@ void gfs2_jindex_free(struct gfs2_sbd *sdp)
 	sdp->sd_journals = 0;
 	spin_unlock(&sdp->sd_jindex_spin);
 
+	down_write(&sdp->sd_log_flush_lock);
 	sdp->sd_jdesc = NULL;
+	up_write(&sdp->sd_log_flush_lock);
+
 	while (!list_empty(&list)) {
 		jd = list_first_entry(&list, struct gfs2_jdesc, jd_list);
+		BUG_ON(jd->jd_log_bio);
 		gfs2_free_journal_extents(jd);
 		list_del(&jd->jd_list);
 		iput(jd->jd_inode);
-- 
2.43.0



