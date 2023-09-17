Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723B26FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7138C433C8;
	Sun, 17 Sep 2023 19:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979977;
	bh=yWzGFwf6mWuAxfOhfBnrzWQdt9V/MFkQeUhc08idT6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4jKx7PASAjks/Jcs77PA1CU6E5fRsZdk4Uf1Sx1VITAh8Tji+jcH70XJ5clpUoQK
	 GKL9JFBfhZFiL37vVHRP/DF7aINGK2jFkZviOHi7UDGLgEyfK9HQgVjLojnTiyNQq/
	 JhK+nKhws73ElIYrkhuVWG/jFITjbYTMii364BmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 061/285] gfs2: low-memory forced flush fixes
Date: Sun, 17 Sep 2023 21:11:01 +0200
Message-ID: <20230917191053.818544204@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit b74cd55aa9a9d0aca760028a51343ec79812e410 ]

First, function gfs2_ail_flush_reqd checks the SDF_FORCE_AIL_FLUSH flag
to determine if an AIL flush should be forced in low-memory situations.
However, it also immediately clears the flag, and when called repeatedly
as in function gfs2_logd, the flag will be lost.  Fix that by pulling
the SDF_FORCE_AIL_FLUSH flag check out of gfs2_ail_flush_reqd.

Second, function gfs2_writepages sets the SDF_FORCE_AIL_FLUSH flag
whether or not enough pages were written.  If enough pages could be
written, flushing the AIL is unnecessary, though.

Third, gfs2_writepages doesn't wake up logd after setting the
SDF_FORCE_AIL_FLUSH flag, so it can take a long time for logd to react.
It would be preferable to wake up logd, but that hurts the performance
of some workloads and we don't quite understand why so far, so don't
wake up logd so far.

Fixes: b066a4eebd4f ("gfs2: forcibly flush ail to relieve memory pressure")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/aops.c | 4 ++--
 fs/gfs2/log.c  | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index ae49256b7c8c6..be2759a974f9e 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -183,13 +183,13 @@ static int gfs2_writepages(struct address_space *mapping,
 	int ret;
 
 	/*
-	 * Even if we didn't write any pages here, we might still be holding
+	 * Even if we didn't write enough pages here, we might still be holding
 	 * dirty pages in the ail. We forcibly flush the ail because we don't
 	 * want balance_dirty_pages() to loop indefinitely trying to write out
 	 * pages held in the ail that it can't find.
 	 */
 	ret = iomap_writepages(mapping, wbc, &wpc, &gfs2_writeback_ops);
-	if (ret == 0)
+	if (ret == 0 && wbc->nr_to_write > 0)
 		set_bit(SDF_FORCE_AIL_FLUSH, &sdp->sd_flags);
 	return ret;
 }
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index d3da259820e30..aaca22f2aa2d1 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -1282,9 +1282,6 @@ static inline int gfs2_ail_flush_reqd(struct gfs2_sbd *sdp)
 {
 	unsigned int used_blocks = sdp->sd_jdesc->jd_blocks - atomic_read(&sdp->sd_log_blks_free);
 
-	if (test_and_clear_bit(SDF_FORCE_AIL_FLUSH, &sdp->sd_flags))
-		return 1;
-
 	return used_blocks + atomic_read(&sdp->sd_log_blks_needed) >=
 		atomic_read(&sdp->sd_log_thresh2);
 }
@@ -1325,7 +1322,9 @@ int gfs2_logd(void *data)
 						  GFS2_LFC_LOGD_JFLUSH_REQD);
 		}
 
-		if (gfs2_ail_flush_reqd(sdp)) {
+		if (test_bit(SDF_FORCE_AIL_FLUSH, &sdp->sd_flags) ||
+		    gfs2_ail_flush_reqd(sdp)) {
+			clear_bit(SDF_FORCE_AIL_FLUSH, &sdp->sd_flags);
 			gfs2_ail1_start(sdp);
 			gfs2_ail1_wait(sdp);
 			gfs2_ail1_empty(sdp, 0);
@@ -1338,6 +1337,7 @@ int gfs2_logd(void *data)
 		try_to_freeze();
 
 		t = wait_event_interruptible_timeout(sdp->sd_logd_waitq,
+				test_bit(SDF_FORCE_AIL_FLUSH, &sdp->sd_flags) ||
 				gfs2_ail_flush_reqd(sdp) ||
 				gfs2_jrnl_flush_reqd(sdp) ||
 				kthread_should_stop(),
-- 
2.40.1



