Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C243E958C;
	Thu, 15 Jan 2026 17:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499422; cv=none; b=KbLjgPsDfuLMVaiKRDcSkERvYjWlz49msHatcPo0+QQxXi1CbqYOgAVjDXnUnuA7g5yOYeOucXlcOaQK+5sgESnUWI8VbFQ/0yUMffVwQLD8uT5SdmHi8S2lk5ndWYjjkZMW52xf5xo+Hd01WjUN/CPNFgcjj9QBmrVBo6SZu9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499422; c=relaxed/simple;
	bh=xUhtYcsWe3NUA3tVJbHAYeOIsCBMEgcSQjxUz5KARWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlJgTVwrLQJ//W1m6HoVZGqEZIjcZARHGAkd9IoShY3KI8Fxi9Khj9WnINvW4DpUb0OGPTI3/+lSBPYTodJ7mwJscGLwIo50aHLGiCKsD4cdLTgL2/fWGsu/0TmzeYkTUnYACj7VakFckhwPrI81Iby9iHCNVxc3fDEljSxFRJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BlGJ/Cax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BlGJ/Cax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CF9C116D0;
	Thu, 15 Jan 2026 17:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499422;
	bh=xUhtYcsWe3NUA3tVJbHAYeOIsCBMEgcSQjxUz5KARWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BlGJ/CaxjZCrQ7WV8GeAMPGKWbyxgybhkalm3jtNHLhKJiTythv5om0+fiIITSg+y
	 d26iC4qahcs8WycpncNoWMtuDSufX8mD1OexXhnsRTzghLOzY6me798mU6yQ26MuAL
	 UcOruEMCgn6XqOwTfioVbJ6MIMFJVJAtwYOncalk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stefanha@redhat.com,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 221/451] vhost/vsock: improve RCU read sections around vhost_vsock_get()
Date: Thu, 15 Jan 2026 17:47:02 +0100
Message-ID: <20260115164238.893810565@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit d8ee3cfdc89b75dc059dc21c27bef2c1440f67eb ]

vhost_vsock_get() uses hash_for_each_possible_rcu() to find the
`vhost_vsock` associated with the `guest_cid`. hash_for_each_possible_rcu()
should only be called within an RCU read section, as mentioned in the
following comment in include/linux/rculist.h:

/**
 * hlist_for_each_entry_rcu - iterate over rcu list of given type
 * @pos:	the type * to use as a loop cursor.
 * @head:	the head for your list.
 * @member:	the name of the hlist_node within the struct.
 * @cond:	optional lockdep expression if called from non-RCU protection.
 *
 * This list-traversal primitive may safely run concurrently with
 * the _rcu list-mutation primitives such as hlist_add_head_rcu()
 * as long as the traversal is guarded by rcu_read_lock().
 */

Currently, all calls to vhost_vsock_get() are between rcu_read_lock()
and rcu_read_unlock() except for calls in vhost_vsock_set_cid() and
vhost_vsock_reset_orphans(). In both cases, the current code is safe,
but we can make improvements to make it more robust.

About vhost_vsock_set_cid(), when building the kernel with
CONFIG_PROVE_RCU_LIST enabled, we get the following RCU warning when the
user space issues `ioctl(dev, VHOST_VSOCK_SET_GUEST_CID, ...)` :

  WARNING: suspicious RCU usage
  6.18.0-rc7 #62 Not tainted
  -----------------------------
  drivers/vhost/vsock.c:74 RCU-list traversed in non-reader section!!

  other info that might help us debug this:

  rcu_scheduler_active = 2, debug_locks = 1
  1 lock held by rpc-libvirtd/3443:
   #0: ffffffffc05032a8 (vhost_vsock_mutex){+.+.}-{4:4}, at: vhost_vsock_dev_ioctl+0x2ff/0x530 [vhost_vsock]

  stack backtrace:
  CPU: 2 UID: 0 PID: 3443 Comm: rpc-libvirtd Not tainted 6.18.0-rc7 #62 PREEMPT(none)
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-7.fc42 06/10/2025
  Call Trace:
   <TASK>
   dump_stack_lvl+0x75/0xb0
   dump_stack+0x14/0x1a
   lockdep_rcu_suspicious.cold+0x4e/0x97
   vhost_vsock_get+0x8f/0xa0 [vhost_vsock]
   vhost_vsock_dev_ioctl+0x307/0x530 [vhost_vsock]
   __x64_sys_ioctl+0x4f2/0xa00
   x64_sys_call+0xed0/0x1da0
   do_syscall_64+0x73/0xfa0
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
   ...
   </TASK>

This is not a real problem, because the vhost_vsock_get() caller, i.e.
vhost_vsock_set_cid(), holds the `vhost_vsock_mutex` used by the hash
table writers. Anyway, to prevent that warning, add lockdep_is_held()
condition to hash_for_each_possible_rcu() to verify that either the
caller is in an RCU read section or `vhost_vsock_mutex` is held when
CONFIG_PROVE_RCU_LIST is enabled; and also clarify the comment for
vhost_vsock_get() to better describe the locking requirements and the
scope of the returned pointer validity.

About vhost_vsock_reset_orphans(), currently this function is only
called via vsock_for_each_connected_socket(), which holds the
`vsock_table_lock` spinlock (which is also an RCU read-side critical
section). However, add an explicit RCU read lock there to make the code
more robust and explicit about the RCU requirements, and to prevent
issues if the calling context changes in the future or if
vhost_vsock_reset_orphans() is called from other contexts.

Fixes: 834e772c8db0 ("vhost/vsock: fix use-after-free in network stack callers")
Cc: stefanha@redhat.com
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-Id: <20251126133826.142496-1-sgarzare@redhat.com>
Message-ID: <20251126210313.GA499503@fedora>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vsock.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -58,14 +58,15 @@ static u32 vhost_transport_get_local_cid
 	return VHOST_VSOCK_DEFAULT_HOST_CID;
 }
 
-/* Callers that dereference the return value must hold vhost_vsock_mutex or the
- * RCU read lock.
+/* Callers must be in an RCU read section or hold the vhost_vsock_mutex.
+ * The return value can only be dereferenced while within the section.
  */
 static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
 {
 	struct vhost_vsock *vsock;
 
-	hash_for_each_possible_rcu(vhost_vsock_hash, vsock, hash, guest_cid) {
+	hash_for_each_possible_rcu(vhost_vsock_hash, vsock, hash, guest_cid,
+				   lockdep_is_held(&vhost_vsock_mutex)) {
 		u32 other_cid = vsock->guest_cid;
 
 		/* Skip instances that have no CID yet */
@@ -666,9 +667,15 @@ static void vhost_vsock_reset_orphans(st
 	 * executing.
 	 */
 
+	rcu_read_lock();
+
 	/* If the peer is still valid, no need to reset connection */
-	if (vhost_vsock_get(vsk->remote_addr.svm_cid))
+	if (vhost_vsock_get(vsk->remote_addr.svm_cid)) {
+		rcu_read_unlock();
 		return;
+	}
+
+	rcu_read_unlock();
 
 	/* If the close timeout is pending, let it expire.  This avoids races
 	 * with the timeout callback.


