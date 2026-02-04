Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DEF42AA9;
	Wed,  4 Feb 2026 15:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218279; cv=none; b=b4scdVw2r8Z/Bcv41kIdU+BJVaNS1PRuJnOaOkNzkNJSYwlbNnrrxMfVGsLmjTGmVBpzbvQvpojkiG93I7xKaeHA46PabqN8dYbSp3Z4EVAo5CRQ+RwoY/MPMLhCnfoh1dBs3VR4kyTGmrDMda9wJzGKNuG+p8MT14tv1enKw1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218279; c=relaxed/simple;
	bh=z1+1I4XIhMJ/NUmpc9KADisJBNtECYGV7lF5TT/saX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1uT3uFusaKu/4U+8P1/JHrekw7JuN4dfqNKWXngvyJ4HWQTGMThOJLG1GWL91YV3cQoXhtx6tYtD5tz4CJzC+k/DabYaTjOhrH0Y5a5A7Xm2JeA1bQpqBJUzECfUjaZ+K1PNx0cQieHRBwkE0JIPH4H0Mv1qiXUuT4ZS3CXCfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8I+bAUg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8I+bAUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D77C4CEF7;
	Wed,  4 Feb 2026 15:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218279;
	bh=z1+1I4XIhMJ/NUmpc9KADisJBNtECYGV7lF5TT/saX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8I+bAUgh1+WqEPF+RGqxCPzN0eBDfwXp64OvPSkgNAEgxJFtL2rMNRqGcXNriznU
	 moM4OLPpvp5OFyX2wyZ1NKM03C7zMMN0xHTcx2G11xATvOTjsbtnrlS1U/oQfZKBl0
	 xPyg6CyAFKzP4RmJOdhU679Qd5l/WUo6MP9M/M4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Rahul Sharma <black.hawk@163.com>
Subject: [PATCH 6.1 263/280] gfs2: Fix NULL pointer dereference in gfs2_log_flush
Date: Wed,  4 Feb 2026 15:40:37 +0100
Message-ID: <20260204143919.163617421@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ The context change is due to the commit 4d927b03a688
("gfs2: Rename gfs2_withdrawn to gfs2_withdrawing_or_withdrawn") in v6.8
which is irrelevant to the logic of this patch. ]
Signed-off-by: Rahul Sharma <black.hawk@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/log.c   |    3 ++-
 fs/gfs2/super.c |    4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -1102,7 +1102,8 @@ repeat:
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


