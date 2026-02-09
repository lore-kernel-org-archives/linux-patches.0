Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337F33033D2;
	Mon,  9 Feb 2026 14:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770649001; cv=none; b=OjvURBjmzc2PFgkR5uXdUa+9ZJMm1bVciA8VGYv3iPuKS2FKPIrD8JgS3EOkbvgX6wi6JrfvcfT3SE/4bQxy7FlgTiRJy45OYQvJSsN3LD/GZCbee+rKCt2t6B6HdewM7NQ5wTnT+KI0WxQr6xaB3bTzGLwj1IshtzichWvuZLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770649001; c=relaxed/simple;
	bh=sfKRSO8J1wCziJ9H7KWcsSyAROjOvWpYTLAAcyGhy/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8GA8xs8Cixt9XfKt4GsOhkFGNzgK+4o1Qh1scHfBu5kWeEf7tt5ynnsitiYfLoC88CvYH7dwllFRHj4Bu9wTHiySmZVKqAzbAoKD+YqKnGUPzffME4PxMM5u6wynszSxXcSESP1rpuGAyGYTwgGVdwcFx3nu/5z7fCjLV5fpgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n4R4Ii4j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n4R4Ii4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94297C116C6;
	Mon,  9 Feb 2026 14:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770649001;
	bh=sfKRSO8J1wCziJ9H7KWcsSyAROjOvWpYTLAAcyGhy/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n4R4Ii4jG1gZfdee/b2JZZa5kFuHefyG+6pwvsFSnLW7xU4HdmDsIAtbGqb2p0vlf
	 zEexy5raEimvfNm+ruYeywixMdnNrFhsr/Wl/4VkdY29wIPCstN1GYs6wkQYSGJOqb
	 /El0wCBeCH02jEb2LmAeP509l3277HAgXOmoyCAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Rahul Sharma <black.hawk@163.com>
Subject: [PATCH 5.15 63/75] gfs2: Fix NULL pointer dereference in gfs2_log_flush
Date: Mon,  9 Feb 2026 15:25:00 +0100
Message-ID: <20260209142304.112564659@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
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

commit 35264909e9d1973ab9aaa2a1b07cda70f12bb828 upstream.

In gfs2_jindex_free(), set sdp->sd_jdesc to NULL under the log flush
lock to provide exclusion against gfs2_log_flush().

In gfs2_log_flush(), check if sdp->sd_jdesc is non-NULL before
dereferencing it.  Otherwise, we could run into a NULL pointer
dereference when outstanding glock work races with an unmount
(glock_work_func -> run_queue -> do_xmote -> inode_go_sync ->
gfs2_log_flush).

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ The context change is due to the commit 4d927b03a688
  ("gfs2: Rename gfs2_withdrawn to gfs2_withdrawing_or_withdrawn") in v6.8
  which is irrelevant to the logic of this patch. ]
Signed-off-by: Rahul Sharma <black.hawk@163.com>
---
---
 fs/gfs2/log.c   |    3 ++-
 fs/gfs2/super.c |    4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -1094,7 +1094,8 @@ repeat:
 	lops_before_commit(sdp, tr);
 	if (gfs2_withdrawn(sdp))
 		goto out_withdraw;
-	gfs2_log_submit_bio(&sdp->sd_jdesc->jd_log_bio, REQ_OP_WRITE);
+	if (sdp->sd_jdesc)
+		gfs2_log_submit_bio(&sdp->sd_jdesc->jd_log_bio, REQ_OP_WRITE);
 	if (gfs2_withdrawn(sdp))
 		goto out_withdraw;
 
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -67,9 +67,13 @@ void gfs2_jindex_free(struct gfs2_sbd *s
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


