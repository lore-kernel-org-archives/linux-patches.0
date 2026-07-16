Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA136400981;
	Thu, 16 Jul 2026 14:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211583; cv=none; b=oBdkAMd+hg+jDB0HV6bDhxLok0+V8O62+O1BC85FRf4hWmzzy/kRYvMJ3C1PVvE9kzipfRanqcJb5NYVU1Psx4ohxBx0dx8nrOMh9XFjl6sgMkbkvQwsch4S0tjFgsUEPpT8H+Pj9iDtVLHTr+OFU2kvJC72ZB7fkEmFORkyE3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211583; c=relaxed/simple;
	bh=IwtmBWG/72Nk8DAoUW2pVlH0qsQ7sqzXnUjSTzx5XbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hz7jNZ77Ufi32xLpVMCW7V3cpUVAKdscsdWWiuX/qPuRpZgImCL+qpd/Kn9YfjxEgkRNmytMe4AlGG4uIpuMHLMo75BLq8i8OSbjqmzK61vtD9tFluoWKwvNM5lnjltT7oZsR2D5k9T1IEWGZpB4bq7oPMNMBOmnvsqI54jXOls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BjkE+sMf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BjkE+sMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE971F000E9;
	Thu, 16 Jul 2026 14:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211582;
	bh=GzSZ6jklK56Z4xWOy48Gt0NkzNYv2V8NwAhtCCGlw/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BjkE+sMfIj+nsAJKMMWejB3Va4At6D4dLG4qCOPrNXWl1SjiKWRxaTEKRSCJJ7x0b
	 9LLaybfVg+s/c0GdS8+aRKxkuf2+rBjOF8pB1Q1E8FQsN1OJEpO06gLTV9ofRtMqhk
	 vHSp7Klv4W5J0z50UaCk93qIrWOYYXE/5dwbCk+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.18 467/480] fuse: clear intr_entry in fuse_resend and fuse_remove_pending_req
Date: Thu, 16 Jul 2026 15:33:34 +0200
Message-ID: <20260716133054.924710881@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
@@ -148,6 +148,7 @@ static struct fuse_req *fuse_request_all
 
 static void fuse_request_free(struct fuse_req *req)
 {
+	WARN_ON(!list_empty(&req->intr_entry));
 	kmem_cache_free(fuse_req_cachep, req);
 }
 
@@ -2046,6 +2047,14 @@ static void fuse_resend(struct fuse_conn
 		fuse_dev_end_requests(&to_queue);
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


