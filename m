Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3E9285061;
	Wed, 20 May 2026 16:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295554; cv=none; b=JHZ2DY+rg79Pf0kIp2028P4TR7Xx096t6nqKrdqDLJUO5qPBtux2nPHuhxQ11z+0BjNzi2Xs7nbrL0b8DYFP+igLW3ItQxwjiBSUY92IthLvGPEOO/o88C9ufBxusei3OtKYm9yaqax+d95uPGnqngLiLJLPCg73PagJP08kuQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295554; c=relaxed/simple;
	bh=ljNQMoK15rqBdBQZdlRTvKd8DNMqZROiU6eyrVRIuzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=joag4za3uBunaANeYnu0nxa4jSBI9NZI6+OPxcOIx1RqWKU4rP+y40RKWVk8w9i/GTcumqygOrVECqbt2oGdQ7Y7W0Db8QDl2fD9TBDXOr6loyynkkMpq4Mm8wfL2adAkmI9n9Ry1U6tfxAXp0oZOxlo0fh2pIKc3qzX0WQ/ABU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1RwklLG5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1RwklLG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908221F000E9;
	Wed, 20 May 2026 16:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295553;
	bh=V6IT6l2/k6qG6qW9f9qN+gJwniX9ENj5C9UWsR72OKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1RwklLG5tkLlYsWn1dFtuVhcdSM/nlVA4fSUNb8TW84IlFnDshllNdt5iQsoWRVd0
	 sidZeT3SOj6VmhJ0CbhucSzxBxFnh1JAlfJSkiVo73FdjIwpBEXlo+tQaSXFsGWvcs
	 /fF0CmTKKazLvscm4fi7ld+T8SW9qpR/tAPJKX3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0462/1146] gfs2: add some missing log locking
Date: Wed, 20 May 2026 18:11:52 +0200
Message-ID: <20260520162158.652869674@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 347df29d610e6..41a70fbee82f4 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -1018,14 +1018,15 @@ static void trans_drain(struct gfs2_trans *tr)
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
@@ -1033,7 +1034,6 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl, u32 flags)
 	unsigned int first_log_head;
 	unsigned int reserved_revokes = 0;
 
-	down_write(&sdp->sd_log_flush_lock);
 	trace_gfs2_log_flush(sdp, 1, flags);
 
 repeat:
@@ -1145,7 +1145,6 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl, u32 flags)
 		gfs2_assert_withdraw(sdp, used_blocks < reserved_blocks);
 		gfs2_log_release(sdp, reserved_blocks - used_blocks);
 	}
-	up_write(&sdp->sd_log_flush_lock);
 	gfs2_trans_free(sdp, tr);
 	trace_gfs2_log_flush(sdp, 0, flags);
 	return;
@@ -1166,6 +1165,13 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl, u32 flags)
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
@@ -1297,19 +1303,25 @@ int gfs2_logd(void *data)
 			break;
 
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



