Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EA8423EA0;
	Thu, 16 Jul 2026 14:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211594; cv=none; b=AbrrG9jtvNPid7cFyhZu2LTwW9EgvU7ubcmnb38wLqXavjrMyjWVrX3dW5asPo50uLZHQnj6SmajXze0AGH+1S2sdVH+6LyCih4nqInkGfpoCOTgZ53UeRB6LcEv+Unn46rBrGKA4KS0JIQAAU5nVNzDkbbgh0aJvtHaMgLC7es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211594; c=relaxed/simple;
	bh=tJm8UXJqO74HFGJMxLMKFEvfL/+eqz/CzTb8ACE8snI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9+7BLle5Vyi1MrgbG823TWHQ2oeqYRMbXghN6Q2WOlzwucV8h1JU2qBvoNSX7sHZo1VWdwS1gRu6ITp1oDyR/8wHY7ZdBthm/GQ2iiNGTXM32Y2MA55sbGW6sTlIuKpF6p8X0cuvdAyw4nfcDhXZAlzHR2pJYseoZ396iS1RUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNbVq/mQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNbVq/mQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5A11F00A3A;
	Thu, 16 Jul 2026 14:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211593;
	bh=eXxTOb3dUMClLufIXcts7p9ak9IZxPI1rLNGn8IlxKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eNbVq/mQHMHQhcidEZUMwcglUhnoljjTh5cWS/uwiuV2rNaEadmUHPO1rnJIfS7eX
	 P8Qbc3VCrvNBn1UNj0oWBWt3BCF42OyEQvJMpk8HXXgdq90NfyWKvllwFB6mneddv9
	 LZdsE6xivnKFRPkX1wdLZnJMqgsJGJhX3aBDb7tM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Chris Mason <clm@meta.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.18 471/480] fuse-uring: end fuse_req on io-uring cancel task work
Date: Thu, 16 Jul 2026 15:33:38 +0200
Message-ID: <20260716133055.008710328@linuxfoundation.org>
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

From: Chris Mason <clm@meta.com>

commit bea4fe98204b6ce7eb8e29f7bf867dd7619b3ddd upstream.

When io_uring delivers task work with tw.cancel set (PF_EXITING,
PF_KTHREAD fallback, or percpu_ref_is_dying on the ring context),
fuse_uring_send_in_task() takes the cancel branch, assigns
-ECANCELED, and falls through to fuse_uring_send(). That path only
flips the entry to FRRS_USERSPACE and completes the io_uring cmd;
it never discharges the ring entry's owning reference to the
fuse_req that fuse_uring_add_req_to_ring_ent() handed it at
dispatch time.

    fuse_uring_send_in_task()
      tw.cancel == true
        err = -ECANCELED
      fuse_uring_send(ent, cmd, err, issue_flags)
        ent->state = FRRS_USERSPACE
        list_move(&ent->list, &queue->ent_in_userspace)
        ent->cmd = NULL
        io_uring_cmd_done(-ECANCELED)
        /* ent->fuse_req still set, req still hashed */

The fuse_req stays linked on fpq->processing[hash] and
fuse_request_end() is never invoked. The originating syscall
thread blocks in D-state in request_wait_answer() until
fuse_abort_conn() runs, which can be the entire connection
lifetime. For FR_BACKGROUND requests fc->num_background is never
decremented either, so repeated cancels inflate the counter until
max_background is hit and all later background ops stall. tw.cancel does
not imply a connection abort (e.g. a single io_uring worker thread exits
while the fuse connection stays up), so this cannot be left for
fuse_abort_conn() to clean up.

Ending the req but still routing the entry through fuse_uring_send()
is not enough: that leaves a req-less entry on ent_in_userspace, and
ent_list_request_expired() dereferences ent->fuse_req unconditionally
on the head of that list, which would then NULL-deref.

Fix the cancel branch to release the entry directly. Remove it from the
queue, complete the io_uring cmd, end the fuse_req, free the entry, and
drop its queue_refs (waking the teardown waiter if it was the last).

Fixes: c2c9af9a0b13 ("fuse: Allow to queue fg requests through io-uring")
Cc: stable@vger.kernel.org
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Assisted-by: kres (claude-opus-4-7)
Signed-off-by: Chris Mason <clm@meta.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev_uring.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -1226,11 +1226,21 @@ static void fuse_uring_send_in_task(stru
 			fuse_uring_next_fuse_req(ent, queue, issue_flags);
 			return;
 		}
+		fuse_uring_send(ent, cmd, err, issue_flags);
 	} else {
 		err = -ECANCELED;
-	}
 
-	fuse_uring_send(ent, cmd, err, issue_flags);
+		spin_lock(&queue->lock);
+		list_del_init(&ent->list);
+		spin_unlock(&queue->lock);
+
+		io_uring_cmd_done(cmd, err, issue_flags);
+
+		fuse_uring_req_end(ent, ent->fuse_req, err);
+		kfree(ent);
+		if (atomic_dec_and_test(&queue->ring->queue_refs))
+			wake_up_all(&queue->ring->stop_waitq);
+	}
 }
 
 static struct fuse_ring_queue *fuse_uring_task_to_queue(struct fuse_ring *ring)


