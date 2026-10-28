Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210016;
	b=L9L00VoW5c/ZOkWgAnM6FdAksi4/gXDiXDxLGd1ofIIjqo/HOiNO4AunXtiJ+v0LBsiP
	 IpcdYRO6958FJJcPaJTw5aJvA6nJW+d1H5d5i02rZCZSSCqLzGTmJgQI4oyGvdnncX5Bd
	 skVX0Tai18bN7Od5eMX45FfWT/c00SeEEvtsJtxepDtaNgLjiamTp55a5GzHKEg4QVc6e
	 hHFuXCPdfsapiKfvjTl2wWWI3BHCC6DVYDa40WQyGNEXZ+WEDXG1R1K62IZipM49Wy93Z
	 LefYgymFiTTq4aP9Xhc+zsGA54gCpjak/xZrQ1wz7dgezX4nVKnxbijsLtbpP7XnJ9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JG4XMFPJaFzWyqiiMw3H0XhIHBnCDJIgzNy8RJglFGY=;
	b=hWwGAWSCq08BBLohV8+vi846J2z8BmW0MhDy8xgzGyjcnrzbkdgwkBVz0gU7wLw50Gyf
	 KBRt+boeIXmyAgU8beYz8+rmURjFGj3FSDR2eJ5DH9ov8e8Xqb+aTE+Fp/8rD6Q3+2yG5
	 lg2A4VNMxF+Cu+cnjRnC2Roeb5YiHnAPeLpSoxH23QyJjfTvaIyCfIJ7vphD1NpYrttI3
	 g11YNK3fVEsjkipq/OnOWcfPm3Z1BUMFPKwLcv1KPwFM4UXwiGzI2lY9J2OC+9fqiOAKE
	 oB7HgZaKWfVExtyyg0LyPnSDTZxFtP98v1RZ8Jul99aaXLx9YLetnMOqOK2hul0EL4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vpoyseb+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F40C606A325;
	Wed, 28 Oct 2026 17:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vpoyseb+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7EB1F031E2;
	Wed, 28 Oct 2026 17:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210016;
	bh=JG4XMFPJaFzWyqiiMw3H0XhIHBnCDJIgzNy8RJglFGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vpoyseb+I/IVli887FZC6KunogX5WTSRu70xKB160LTSQCUqu9ol36IKstDIMzU2G
	 38R05QNWvLrXfaOOqofI07qbpA1rX8+Wz1ILxVv6VJ2TpHsFVnwi9zJR4bTDL1HCwe
	 3ydL2KsI3sNGb0e7FpnuUZx93payf+D2kBbKkLsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 045/168] eventfs: Free the eventfs_inode after an rcu grace period too
Date: Wed, 28 Oct 2026 17:59:41 +0100
Message-ID: <20261028165944.155815060@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 2cd88c498ecff8e22bf4c397b8eb226db70ac343 upstream.

tracefs_d_revalidate() reads ->is_freed of the eventfs_inode that
dentry->d_fsdata points to, and ->d_revalidate() is called in rcu
pathwalk mode with nothing but rcu_read_lock() held. The dentry itself
stays around for such a walker, but tracefs_d_release() drops its
reference to the eventfs_inode when the dentry is killed, and
release_ei() then frees it after a grace period of eventfs_srcu. An
SRCU grace period doesn't wait for rcu_read_lock() sections, so the
walker can read an eventfs_inode that is already gone.

With a pathwalk held up in tracefs_d_revalidate() while the dentry goes
away:

  BUG: KASAN: slab-use-after-free in tracefs_d_revalidate+0x76/0x90
  Read of size 1 at addr ff1100010152d8d0 by task walker/97
  Call Trace:
   <TASK>
   tracefs_d_revalidate+0x76/0x90
   lookup_fast+0x320/0x640
   path_lookupat+0x160/0xb00
   filename_lookup+0x1f1/0x5b0
   vfs_statx+0xd7/0x3b0
   vfs_fstatat+0x4d/0x90
   __do_sys_newfstatat+0xa0/0x100
   do_syscall_64+0x10e/0x5e0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  [...]
  Allocated by task 1:
   __kmalloc_cache_noprof+0x249/0x560
   eventfs_create_dir+0x7a/0x590
   event_create_dir+0x2fb/0xcf0
   trace_add_event_call+0xbf/0x150
  [...]
  Freed by task 11:
   kfree+0x1db/0x5b0
   srcu_invoke_callbacks+0x3a3/0x620
   process_one_work+0x937/0x1810
   worker_thread+0x4f1/0xd60

Before commit 8e556432477e ("eventfs: Use SRCU for freeing
eventfs_inodes") release_ei() used call_rcu(), which covered the walker,
while eventfs_iterate() needs the SRCU grace period. Wait for both and
chain call_rcu() from the SRCU callback.

Cc: stable@vger.kernel.org
Fixes: 8e556432477e ("eventfs: Use SRCU for freeing eventfs_inodes")
Link: https://patch.msgid.link/20261009-work-fixes-rcu-v1-4-7446d2d335e6@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -92,6 +92,14 @@ static void free_ei_rcu(struct rcu_head
 	}
 }
 
+/* read under eventfs_srcu and, by tracefs_d_revalidate(), in rcu pathwalk */
+static void free_ei_srcu(struct rcu_head *rcu)
+{
+	struct eventfs_inode *ei = container_of(rcu, struct eventfs_inode, rcu);
+
+	call_rcu(&ei->rcu, free_ei_rcu);
+}
+
 /*
  * eventfs_inode reference count management.
  *
@@ -113,7 +121,7 @@ static void release_ei(struct kref *ref)
 			entry->release(entry->name, ei->data);
 	}
 
-	call_srcu(&eventfs_srcu, &ei->rcu, free_ei_rcu);
+	call_srcu(&eventfs_srcu, &ei->rcu, free_ei_srcu);
 }
 
 static inline void put_ei(struct eventfs_inode *ei)


