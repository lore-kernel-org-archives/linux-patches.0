Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F8113A26B;
	Wed,  7 Aug 2024 15:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043059; cv=none; b=bZX4e1fuqY72VsLMltsiPqprpwBtRsAKETdREDV4FSZ2J9JrquIREa7M7ogMslmbs2goqjwR7Rhgxm0cSSYqUspHbwOoVYcfFWsDQnzbFwRQfjEgJVWuhycaF8EWaDf2BUl9oCApvnl0apC07JCE1piHvVjRwAuaBNP4Bev+HzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043059; c=relaxed/simple;
	bh=qLJsCgBtmBAseG5Bcg/NkgCS6rPMj3ANaZZUpqV4XI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u54y2HxEmdrq4WlZdrfVbUs6hkbjq0OyzwzW4Twr+iIs0tidQPNm5eSUaU7X1BOdhUIrmbeq3fXoYv4yregsQ3ZeddsgGiUPt2/4wCG7WPVVWp6YDu3fe7vNMXHTx+PwFPr7qGBtpFgR7PIxjCtZvRO1LMT28pstWC3353ls1m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hzjQXXVe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hzjQXXVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306C7C4AF0B;
	Wed,  7 Aug 2024 15:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043059;
	bh=qLJsCgBtmBAseG5Bcg/NkgCS6rPMj3ANaZZUpqV4XI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hzjQXXVehphkLj6Tr9EvJh7YrqNGlx1G2QmLd4Dnl+7bxMPmbPaWqVrmSHbrM0Ku0
	 May7RRn24z1kNUQShjdttmHHjBZVasZEeEUd2O5vhWDCl9dY9quFu/0ioJapFoLwdf
	 iW+ocfDu7FPGw0/chhn18mW1Z/eEQJjIg7lH8yds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Venky Shankar <vshankar@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.10 076/123] ceph: force sending a cap update msg back to MDS for revoke op
Date: Wed,  7 Aug 2024 16:59:55 +0200
Message-ID: <20240807150023.264684986@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiubo Li <xiubli@redhat.com>

commit 31634d7597d8c57894b6c98eeefc9e58cf842993 upstream.

If a client sends out a cap update dropping caps with the prior 'seq'
just before an incoming cap revoke request, then the client may drop
the revoke because it believes it's already released the requested
capabilities.

This causes the MDS to wait indefinitely for the client to respond
to the revoke. It's therefore always a good idea to ack the cap
revoke request with the bumped up 'seq'.

Currently if the cap->issued equals to the newcaps the check_caps()
will do nothing, we should force flush the caps.

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/61782
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Venky Shankar <vshankar@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/caps.c  |   35 ++++++++++++++++++++++++-----------
 fs/ceph/super.h |    7 ++++---
 2 files changed, 28 insertions(+), 14 deletions(-)

--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2016,6 +2016,8 @@ bool __ceph_should_report_size(struct ce
  *  CHECK_CAPS_AUTHONLY - we should only check the auth cap
  *  CHECK_CAPS_FLUSH - we should flush any dirty caps immediately, without
  *    further delay.
+ *  CHECK_CAPS_FLUSH_FORCE - we should flush any caps immediately, without
+ *    further delay.
  */
 void ceph_check_caps(struct ceph_inode_info *ci, int flags)
 {
@@ -2097,7 +2099,7 @@ retry:
 	}
 
 	doutc(cl, "%p %llx.%llx file_want %s used %s dirty %s "
-	      "flushing %s issued %s revoking %s retain %s %s%s%s\n",
+	      "flushing %s issued %s revoking %s retain %s %s%s%s%s\n",
 	     inode, ceph_vinop(inode), ceph_cap_string(file_wanted),
 	     ceph_cap_string(used), ceph_cap_string(ci->i_dirty_caps),
 	     ceph_cap_string(ci->i_flushing_caps),
@@ -2105,7 +2107,8 @@ retry:
 	     ceph_cap_string(retain),
 	     (flags & CHECK_CAPS_AUTHONLY) ? " AUTHONLY" : "",
 	     (flags & CHECK_CAPS_FLUSH) ? " FLUSH" : "",
-	     (flags & CHECK_CAPS_NOINVAL) ? " NOINVAL" : "");
+	     (flags & CHECK_CAPS_NOINVAL) ? " NOINVAL" : "",
+	     (flags & CHECK_CAPS_FLUSH_FORCE) ? " FLUSH_FORCE" : "");
 
 	/*
 	 * If we no longer need to hold onto old our caps, and we may
@@ -2180,6 +2183,11 @@ retry:
 				queue_writeback = true;
 		}
 
+		if (flags & CHECK_CAPS_FLUSH_FORCE) {
+			doutc(cl, "force to flush caps\n");
+			goto ack;
+		}
+
 		if (cap == ci->i_auth_cap &&
 		    (cap->issued & CEPH_CAP_FILE_WR)) {
 			/* request larger max_size from MDS? */
@@ -3504,6 +3512,8 @@ static void handle_cap_grant(struct inod
 	bool queue_invalidate = false;
 	bool deleted_inode = false;
 	bool fill_inline = false;
+	bool revoke_wait = false;
+	int flags = 0;
 
 	/*
 	 * If there is at least one crypto block then we'll trust
@@ -3699,16 +3709,18 @@ static void handle_cap_grant(struct inod
 		      ceph_cap_string(cap->issued), ceph_cap_string(newcaps),
 		      ceph_cap_string(revoking));
 		if (S_ISREG(inode->i_mode) &&
-		    (revoking & used & CEPH_CAP_FILE_BUFFER))
+		    (revoking & used & CEPH_CAP_FILE_BUFFER)) {
 			writeback = true;  /* initiate writeback; will delay ack */
-		else if (queue_invalidate &&
+			revoke_wait = true;
+		} else if (queue_invalidate &&
 			 revoking == CEPH_CAP_FILE_CACHE &&
-			 (newcaps & CEPH_CAP_FILE_LAZYIO) == 0)
-			; /* do nothing yet, invalidation will be queued */
-		else if (cap == ci->i_auth_cap)
+			 (newcaps & CEPH_CAP_FILE_LAZYIO) == 0) {
+			revoke_wait = true; /* do nothing yet, invalidation will be queued */
+		} else if (cap == ci->i_auth_cap) {
 			check_caps = 1; /* check auth cap only */
-		else
+		} else {
 			check_caps = 2; /* check all caps */
+		}
 		/* If there is new caps, try to wake up the waiters */
 		if (~cap->issued & newcaps)
 			wake = true;
@@ -3735,8 +3747,9 @@ static void handle_cap_grant(struct inod
 	BUG_ON(cap->issued & ~cap->implemented);
 
 	/* don't let check_caps skip sending a response to MDS for revoke msgs */
-	if (le32_to_cpu(grant->op) == CEPH_CAP_OP_REVOKE) {
+	if (!revoke_wait && le32_to_cpu(grant->op) == CEPH_CAP_OP_REVOKE) {
 		cap->mds_wanted = 0;
+		flags |= CHECK_CAPS_FLUSH_FORCE;
 		if (cap == ci->i_auth_cap)
 			check_caps = 1; /* check auth cap only */
 		else
@@ -3792,9 +3805,9 @@ static void handle_cap_grant(struct inod
 
 	mutex_unlock(&session->s_mutex);
 	if (check_caps == 1)
-		ceph_check_caps(ci, CHECK_CAPS_AUTHONLY | CHECK_CAPS_NOINVAL);
+		ceph_check_caps(ci, flags | CHECK_CAPS_AUTHONLY | CHECK_CAPS_NOINVAL);
 	else if (check_caps == 2)
-		ceph_check_caps(ci, CHECK_CAPS_NOINVAL);
+		ceph_check_caps(ci, flags | CHECK_CAPS_NOINVAL);
 }
 
 /*
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -200,9 +200,10 @@ struct ceph_cap {
 	struct list_head caps_item;
 };
 
-#define CHECK_CAPS_AUTHONLY   1  /* only check auth cap */
-#define CHECK_CAPS_FLUSH      2  /* flush any dirty caps */
-#define CHECK_CAPS_NOINVAL    4  /* don't invalidate pagecache */
+#define CHECK_CAPS_AUTHONLY     1  /* only check auth cap */
+#define CHECK_CAPS_FLUSH        2  /* flush any dirty caps */
+#define CHECK_CAPS_NOINVAL      4  /* don't invalidate pagecache */
+#define CHECK_CAPS_FLUSH_FORCE  8  /* force flush any caps */
 
 struct ceph_cap_flush {
 	u64 tid;


