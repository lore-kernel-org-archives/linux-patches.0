Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2D06FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF4BC433CD;
	Sun, 17 Sep 2023 20:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980964;
	bh=LM8EGF63NkVrYoX1+nV/BTtZd9+/WdQzmXe68CrgLqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DuPAE9GEa8FkAANBrunzicn9ZEHpnYtpx/8OyZwkXJjAKVi2T1kqOtpu4kbl/T33s
	 ddgk5widYBVjVRqi0Ijsidv2K4K7zy5JZhgug20oHj6SI/pLfuRetOmf0cSUrG7B0a
	 WlP0iXpcvQfcy1bwTmO3V10jmc8QhFIchxnyjCqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/219] gfs2: low-memory forced flush fixes
Date: Sun, 17 Sep 2023 21:13:07 +0200
Message-ID: <20230917191043.180404155@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2f04c0ff7470b..1e9fa26f04fe1 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -182,13 +182,13 @@ static int gfs2_writepages(struct address_space *mapping,
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
index 69c3facfcbef4..e021d5f50c231 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -1285,9 +1285,6 @@ static inline int gfs2_ail_flush_reqd(struct gfs2_sbd *sdp)
 {
 	unsigned int used_blocks = sdp->sd_jdesc->jd_blocks - atomic_read(&sdp->sd_log_blks_free);
 
-	if (test_and_clear_bit(SDF_FORCE_AIL_FLUSH, &sdp->sd_flags))
-		return 1;
-
 	return used_blocks + atomic_read(&sdp->sd_log_blks_needed) >=
 		atomic_read(&sdp->sd_log_thresh2);
 }
@@ -1328,7 +1325,9 @@ int gfs2_logd(void *data)
 						  GFS2_LFC_LOGD_JFLUSH_REQD);
 		}
 
-		if (gfs2_ail_flush_reqd(sdp)) {
+		if (test_bit(SDF_FORCE_AIL_FLUSH, &sdp->sd_flags) ||
+		    gfs2_ail_flush_reqd(sdp)) {
+			clear_bit(SDF_FORCE_AIL_FLUSH, &sdp->sd_flags);
 			gfs2_ail1_start(sdp);
 			gfs2_ail1_wait(sdp);
 			gfs2_ail1_empty(sdp, 0);
@@ -1341,6 +1340,7 @@ int gfs2_logd(void *data)
 		try_to_freeze();
 
 		t = wait_event_interruptible_timeout(sdp->sd_logd_waitq,
+				test_bit(SDF_FORCE_AIL_FLUSH, &sdp->sd_flags) ||
 				gfs2_ail_flush_reqd(sdp) ||
 				gfs2_jrnl_flush_reqd(sdp) ||
 				kthread_should_stop(),
-- 
2.40.1



