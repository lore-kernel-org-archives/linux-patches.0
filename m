Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37F331E85C;
	Thu, 16 Jul 2026 13:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210294; cv=none; b=mkNMyalUcurlWJ1G7/CcLmRZDOcWYHyvs1R1gAK8FIUR4jE7Z0xCkWjg5hX+GUnx5V2ymkWpSXeP5B9UkV6b9UuY2EWYZoYwYGh5NsO3GDaZOTOdlvgJgXVF5TbXsBuYoRZEk76Nx96a19Z4fCDriyfXjhU/If5+lRybXacmkpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210294; c=relaxed/simple;
	bh=q/a4fKm13fGfGhlLkV/vsDbKYvAEzXk14pZ+BXuxaI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtfHhhjmMichpS/JN0FONDdhLtJUaMLJlITZBSmviiKWbahMqQ5e+kDxzZbF6+JiayB3IuYVUeZTiG6VUXtAra0evegJHZ0q5EqbkbP7ZxiCjgPa95TlhKd9p5MAI9X5CBZC5e2rh5YfDzmVwsJhzmA58lWIBHWjsCvAxU7gLsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SuigAw1r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SuigAw1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DE41F000E9;
	Thu, 16 Jul 2026 13:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210292;
	bh=eOcdFByqta4PpdvHiWpa/yjv37yHclBmj8/Uo4arG7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SuigAw1rDmlCQuT0+p5idLIPcyAdujfPNtc6GjO9MVk9RR3oDN1mmuz/f+Hf4/ql5
	 dHpAQ6N/pFc5L7ibqeXu/SNT0WmZbV+BN7/2WKr9eDaNYRoTkSdcV0qmMyA7zZIArE
	 LVMmKHq6d8NkXiL9g9lUEnhKGUJvR3VaydgimMC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Chris Mason <clm@meta.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 7.1 511/518] fuse-uring: end fuse_req on io-uring cancel task work
Date: Thu, 16 Jul 2026 15:32:59 +0200
Message-ID: <20260716133059.019668854@linuxfoundation.org>
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
@@ -1225,11 +1225,21 @@ static void fuse_uring_send_in_task(stru
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


