Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB9E430CD5;
	Thu, 16 Jul 2026 14:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212493; cv=none; b=ZFmuXAZi2k/GdJqI8KeSJlObLChn6CqVCgNxC3Y433d9xztrcKwCF3j9q4+gL+Y1apOIbB/ki6GAZcoZrFcrmhRSvx7Krshyl05Kp1GglLadgOCX8akhxjwKBNpCwx7n6dG+ahtWvqlsKLDikPOClI7uI6b6lHNtFyTJ4FxzSoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212493; c=relaxed/simple;
	bh=XmTK78UA6Amsk+qC+DRZb9LsS/w7JQD1vP7H0S729Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=moQm2svuTwHvRARJMmzB0IoNLqOmH+BMyJHtC65lwBIxqXOpxgNOxk5U5bOvrGrdjDrPA/yiK5t1sYd3rOyK0ey3Whm3yf2jKC16jFRLAfdx5nlAO0dXK40KNrJiJY+1h5vqjGe02Z7v2lY53EVzlQaPyqNYJZ9iTwn8ToMjd84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vh/A18M0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vh/A18M0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744461F000E9;
	Thu, 16 Jul 2026 14:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212492;
	bh=2IoshdUB5NlvqvtTl7KNiyZkEwPbNEGK26YE16pXYfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vh/A18M0RhIlmFstA/9Gq4nYJUuzULkpK0QfPXH2QcdBRVdsn0GdZeeMzurt2Ngkx
	 mNJsbB/b/AtYfGwSl30g2kkFMOs3yNQ/6MJAxkXDqO4NaIwXCmpDBgqQniRy6v/OKJ
	 DIwE2S3FGhGC93QdyA/fcMrKpi8JI96ynjO1C+S8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.12 348/349] fuse: clear intr_entry in fuse_resend and fuse_remove_pending_req
Date: Thu, 16 Jul 2026 15:34:42 +0200
Message-ID: <20260716133041.089724104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ji'an Zhou <eilaimemedsnaimel@gmail.com>

commit f8fce75fedf73ac72aa09163deb8f4291fdcaad2 upstream.

When fuse_resend() moves a request from fpq->processing back to
fiq->pending, it sets FR_PENDING and clears FR_SENT but does not
remove the requests intr_entry from fiq->interrupts.  If the
request had FR_INTERRUPTED set from a prior signal, intr_entry
remains dangling on fiq->interrupts.  When the requesting task
then receives a fatal signal, fuse_remove_pending_req() sees
FR_PENDING=1, removes the request from fiq->pending and frees it
via the refcount path, also without cleaning intr_entry.  The
stale intr_entry causes use-after-free when fuse_read_interrupt()
iterates fiq->interrupts:
  - list_del_init(&req->intr_entry) -> UAF write on freed slab
  - req->in.h.unique -> UAF read, data leaked to userspace

Remove intr_entry from fiq->interrupts in fuse_resend() for
interrupted requests before they are placed back on fiq->pending.

Add a WARN_ON if the intr_entry is not empty on request destruction.

Fixes: 760eac73f9f6 ("fuse: Introduce a new notification type for resend pending requests")
Cc: stable@vger.kernel.org # 6.9
Signed-off-by: Ji'an Zhou <eilaimemedsnaimel@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -66,6 +66,7 @@ static struct fuse_req *fuse_request_all
 
 static void fuse_request_free(struct fuse_req *req)
 {
+	WARN_ON(!list_empty(&req->intr_entry));
 	kmem_cache_free(fuse_req_cachep, req);
 }
 
@@ -1881,6 +1882,14 @@ static void fuse_resend(struct fuse_conn
 		end_requests(&to_queue);
 		return;
 	}
+	/*
+	 * Remove interrupt entries for resent requests to prevent stale
+	 * intr_entry on fiq->interrupts after the request is re-queued.
+	 */
+	list_for_each_entry(req, &to_queue, list) {
+		if (test_bit(FR_INTERRUPTED, &req->flags))
+			list_del_init(&req->intr_entry);
+	}
 	/* iq and pq requests are both oldest to newest */
 	list_splice(&to_queue, &fiq->pending);
 	fuse_dev_wake_and_unlock(fiq);


