Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E583191D0;
	Sat, 30 May 2026 18:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164196; cv=none; b=d99N4INg9+OMy4YydK1KkHTPoNbEJ0N7kT4D0UHD8ug6wfeiMJboYFAt/hOb1GCZXaFwYMSXlaDuoWHXTW6zMzYr5JF+n2KEN71rMZDVswgDJHojsA93Xz2cuCQ45ODJJTbeIR7QJcF9kRXpKWBwjfElno9z2HA0WuyMePgulNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164196; c=relaxed/simple;
	bh=JRNkXOpzfBTjlzrIwjFzE4OIp8PFqJu+ex5ho5uaVcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k72Ollqjbwhz4iH6OM06Y2x6P6dhltf08vOHiJkHnQWor6AY4MAE+zG44SDHSBRgaxs/TmOufOOEFbsJbU4aNXsFLcRkAU74cRH39Bq//B0dco3GIzqc2CTA/bYwBmJHTPR3HQKdQ70Pe4sao8YPMuyI5g2u1cbYp0450s2sOoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RbXkneii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RbXkneii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5548A1F00893;
	Sat, 30 May 2026 18:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164195;
	bh=JiW7A84lReCIGIrXB3DBx8sz0Z0QGAHjEDH5eVVLEz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RbXkneiiDrjCRU99rENDruIq4KXT4MQUloyODb4Vq2YK1FVrqOX9NDIOEjJOhOfNg
	 JOlEJJvnb9qai8fj42pn2RrJEp7JGU2p371UtpczaxsZ+QabUIg5sGpVKRV1wPP4W9
	 J/oci7MnnWrOkUw5tVSi30ZcpJFp9UTtMQdmry58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 482/776] gfs2: add some missing log locking
Date: Sat, 30 May 2026 18:03:16 +0200
Message-ID: <20260530160252.795579227@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit fe2c8d051150b90b3ccb85f89e3b1d636cb88ec8 ]

Function gfs2_logd() calls the log flushing functions gfs2_ail1_start(),
gfs2_ail1_wait(), and gfs2_ail1_empty() without holding sdp->sd_log_flush_lock,
but these functions require exclusion against concurrent transactions.

To fix that, add a non-locking __gfs2_log_flush() function.  Then, in
gfs2_logd(), take sdp->sd_log_flush_lock before calling the above mentioned log
flushing functions and __gfs2_log_flush().

Fixes: 5e4c7632aae1c ("gfs2: Issue revokes more intelligently")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/log.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index e7867b0f6c62c..e19b09620a0b7 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -1017,14 +1017,15 @@ static void trans_drain(struct gfs2_trans *tr)
 }
 
 /**
- * gfs2_log_flush - flush incore transaction(s)
+ * __gfs2_log_flush - flush incore transaction(s)
  * @sdp: The filesystem
  * @gl: The glock structure to flush.  If NULL, flush the whole incore log
  * @flags: The log header flags: GFS2_LOG_HEAD_FLUSH_* and debug flags
  *
  */
 
-void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl, u32 flags)
+static void __gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl,
+			     u32 flags)
 {
 	struct gfs2_trans *tr = NULL;
 	unsigned int reserved_blocks = 0, used_blocks = 0;
@@ -1032,7 +1033,6 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl, u32 flags)
 	unsigned int first_log_head;
 	unsigned int reserved_revokes = 0;
 
-	down_write(&sdp->sd_log_flush_lock);
 	trace_gfs2_log_flush(sdp, 1, flags);
 
 repeat:
@@ -1145,7 +1145,6 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl, u32 flags)
 		gfs2_assert_withdraw_delayed(sdp, used_blocks < reserved_blocks);
 		gfs2_log_release(sdp, reserved_blocks - used_blocks);
 	}
-	up_write(&sdp->sd_log_flush_lock);
 	gfs2_trans_free(sdp, tr);
 	if (gfs2_withdrawing(sdp))
 		gfs2_withdraw(sdp);
@@ -1168,6 +1167,13 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl, u32 flags)
 	goto out_end;
 }
 
+void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl, u32 flags)
+{
+	down_write(&sdp->sd_log_flush_lock);
+	__gfs2_log_flush(sdp, gl, flags);
+	up_write(&sdp->sd_log_flush_lock);
+}
+
 /**
  * gfs2_merge_trans - Merge a new transaction into a cached transaction
  * @sdp: the filesystem
@@ -1313,19 +1319,25 @@ int gfs2_logd(void *data)
 		}
 
 		if (gfs2_jrnl_flush_reqd(sdp) || t == 0) {
+			down_write(&sdp->sd_log_flush_lock);
 			gfs2_ail1_empty(sdp, 0);
-			gfs2_log_flush(sdp, NULL, GFS2_LOG_HEAD_FLUSH_NORMAL |
-						  GFS2_LFC_LOGD_JFLUSH_REQD);
+			__gfs2_log_flush(sdp, NULL,
+					 GFS2_LOG_HEAD_FLUSH_NORMAL |
+					 GFS2_LFC_LOGD_JFLUSH_REQD);
+			up_write(&sdp->sd_log_flush_lock);
 		}
 
 		if (test_bit(SDF_FORCE_AIL_FLUSH, &sdp->sd_flags) ||
 		    gfs2_ail_flush_reqd(sdp)) {
 			clear_bit(SDF_FORCE_AIL_FLUSH, &sdp->sd_flags);
+			down_write(&sdp->sd_log_flush_lock);
 			gfs2_ail1_start(sdp);
 			gfs2_ail1_wait(sdp);
 			gfs2_ail1_empty(sdp, 0);
-			gfs2_log_flush(sdp, NULL, GFS2_LOG_HEAD_FLUSH_NORMAL |
-						  GFS2_LFC_LOGD_AIL_FLUSH_REQD);
+			__gfs2_log_flush(sdp, NULL,
+					 GFS2_LOG_HEAD_FLUSH_NORMAL |
+					 GFS2_LFC_LOGD_AIL_FLUSH_REQD);
+			up_write(&sdp->sd_log_flush_lock);
 		}
 
 		t = gfs2_tune_get(sdp, gt_logd_secs) * HZ;
-- 
2.53.0



