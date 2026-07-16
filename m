Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762D542BEA3;
	Thu, 16 Jul 2026 14:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212015; cv=none; b=Q6use4o2lBBbHHQuAUTyhqmVtLt4PnZYDUEzzKkaRhHL8M+9cetqLl3mgBJdw+n/Qk30Mh1jmLTiXssLrdbrx8j0uXdXPcKAG5nH1bovcmPayzv9D0swKW+/CyeHMi7JnqWWrVs8surWcrBEQKZk7UTtb+oK2vOB3nk2AGkmYtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212015; c=relaxed/simple;
	bh=h3+qicHujf8/XEJU5+4lxh0AiiFCJPogkI3sNF4nkQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjCXqtwzvMUecA61A4YYmu4fHM/xu/v9ZqveL+YdAvBI/yACKIgGC0vvjbC/FOf9zpVIa4mM6EOR9lgO6u4C0jA29VmdhOT3ToofyNpDC8YSzTZTErGM1Yx4qVkZNzGaqJUTA6JJwjb7iMyOQ5xbMGQVfYlAcuzCaSDVb2kYNU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oyRsOrFa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oyRsOrFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A041F0155B;
	Thu, 16 Jul 2026 14:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212013;
	bh=eb/is9a2XzeOepE3vMqWccpsAVwr+bn8iENVGwJ13do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oyRsOrFaQxcFYuM7OTylizqJ2YLW0oaZGwkJsF/e0S96dPdfHXvQePy6+YhXSYkjV
	 9hI62OfssIidLzM23koTnZwnGvq9unkAw0olnpuTOM0o62b0Ave45NeMaetxNeXvZm
	 rrrJGHO6PH0V6xgsgy8DyNyhytlIksWVdxbRutxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davide Ornaghi <d.ornaghi97@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 166/349] ksmbd: fix UAF of struct file_lock in SMB2_LOCK deferred-lock cancellation
Date: Thu, 16 Jul 2026 15:31:40 +0200
Message-ID: <20260716133037.096196605@linuxfoundation.org>
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

From: Davide Ornaghi <d.ornaghi97@gmail.com>

commit d20d1c8ba5765d1d12eefc0aee6385ab3f240e1e upstream.

When a blocking byte-range lock request is deferred in the
FILE_LOCK_DEFERRED path, ksmbd registers the asynchronous work into
the connection's async_requests list via setup_async_work(). The cancel
callback smb2_remove_blocked_lock() holds a reference to the flock.

If the lock waiter is subsequently woken up but the work state is no
longer KSMBD_WORK_ACTIVE (e.g., due to a concurrent cancellation), the
cleanup path calls locks_free_lock(flock) without dequeuing the work from
the async_requests list. Concurrently, smb2_cancel() walks the list
under conn->request_lock and invokes the cancel callback, which then
dereferences the already freed 'flock'. This leads to a slab-use-after-free
inside __wake_up_common.

Fix this by restructuring the cleanup logic after the worker returns
from ksmbd_vfs_posix_lock_wait(). Move list_del(&smb_lock->llist) and
release_async_work(work) to the top of the cleanup block. This guarantees
that the async work is completely dequeued and serialized under
conn->request_lock before locks_free_lock(flock) is called, rendering
the flock unreachable for any concurrent smb2_cancel().

Cc: stable@vger.kernel.org
Signed-off-by: Davide Ornaghi <d.ornaghi97@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7689,29 +7689,27 @@ skip:
 				list_del(&work->fp_entry);
 				spin_unlock(&fp->f_lock);
 
-				if (work->state != KSMBD_WORK_ACTIVE) {
-					list_del(&smb_lock->llist);
-					locks_free_lock(flock);
+				list_del(&smb_lock->llist);
+				release_async_work(work);
+
+				if (work->state == KSMBD_WORK_ACTIVE)
+					goto retry;
 
-					if (work->state == KSMBD_WORK_CANCELLED) {
-						rsp->hdr.Status =
-							STATUS_CANCELLED;
-						kfree(smb_lock);
-						smb2_send_interim_resp(work,
-								       STATUS_CANCELLED);
-						work->send_no_response = 1;
-						goto out;
-					}
+				locks_free_lock(flock);
 
-					rsp->hdr.Status =
-						STATUS_RANGE_NOT_LOCKED;
+				if (work->state == KSMBD_WORK_CANCELLED) {
+					rsp->hdr.Status = STATUS_CANCELLED;
 					kfree(smb_lock);
-					goto out2;
+					smb2_send_interim_resp(work,
+							STATUS_CANCELLED);
+					work->send_no_response = 1;
+					goto out;
 				}
 
-				list_del(&smb_lock->llist);
-				release_async_work(work);
-				goto retry;
+				rsp->hdr.Status =
+					STATUS_RANGE_NOT_LOCKED;
+				kfree(smb_lock);
+				goto out2;
 			} else if (!rc) {
 				list_add(&smb_lock->llist, &rollback_list);
 				spin_lock(&work->conn->llist_lock);


