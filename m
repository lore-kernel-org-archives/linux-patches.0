Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00AF3B42FC;
	Thu, 16 Jul 2026 13:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210280; cv=none; b=J1QTeocpbad7G2CKL67xzzk6nkDiab4V3tnA5+gwphse6hzyWUxqAfmih+0u03bs1x4fIyA8lP4vhGal5la2+FrATEdWc1Nj663hwB2cE2RZcft1iHyJVwMSuBTwEsfi3bFfDL+J6dA8PS8+MuWTyj+CDCoapzxVKveWqXPxmh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210280; c=relaxed/simple;
	bh=SMOJpIkrMCG3g0UuI3I0e6KAR5xoe8saGpJODfDT1TU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkPG/q2BFivpUm1jGNK3it3YvbcPajC1UVqFWLb4HNUSeAVE5sASC8DMEyYpK3Pmur1BQ9lTZLs8fp7NUlcdk19ahxoR2VzxS6vikVA8FU8vEgS4rWAI5DN1o3OJMOIl/Uuq3aAUZ1cS4Sr1c9sceY+x1Vwn7Vz6MSyq/8M3n6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+SBOwEZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+SBOwEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4029D1F000E9;
	Thu, 16 Jul 2026 13:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210279;
	bh=MW657jJ48fJ4Icl8qD39P/HeWYeCDr0aBql8qqr1DiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+SBOwEZ3lN3+tFbDWS1zljj4XJ249O4MZajJkFa7sZBroFLNOSoeoQgxupUvtico
	 D+ztOl2uLnJCFm7zU55BB/Vfn2N+4sY/X6xIDt0zc7nKIsLa8kh8/bbDElPk3jWIFh
	 Uz4bU/r/NGXvSqc2mQQwj3YDRsuzqqTC2goHUz6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 7.1 507/518] fuse: clear intr_entry in fuse_resend and fuse_remove_pending_req
Date: Thu, 16 Jul 2026 15:32:55 +0200
Message-ID: <20260716133058.933183638@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -2041,6 +2042,14 @@ static void fuse_resend(struct fuse_conn
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


