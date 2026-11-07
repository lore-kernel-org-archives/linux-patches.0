Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061705;
	b=StLVSDmB1XXxDa5cKtzLtnMMn+ug2ayuUmqWBoEY24lW1UcqkN/C0AUGggelcyKDjz9k
	 Ckw7bN+Pkk3QIaMyaDRQoZaeUz1Iw4Ui+d9OGiGM4//S/Kr7rdYeK0a7catgNgDQv93Jr
	 +zpSI/G6u+Q+uIMCWNNn2HyWAO+s+qCMVFJRSHd/ub4WewK6FopHT1ivxdymu/6R0gynj
	 N++vs/GUbDRc9U/o99clif/x0tVwAsd/xypvxtuqwIl1VV0EonhvH6g3IHPTe3AGMiUz1
	 0yKqI3tJuv2NM5WCxh16drfA+7aG9oNxcW8duVd1kB9iU9a+Z2Bqvb+kq5XzwXw+uVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bOl85+eudxKXSckpWng7YaXguL9KObLQ9TdYP4syhMY=;
	b=m3jt+9Uzu1kz2uspRG18A7S8wEqXV0hE6+q7wZkwUY8C/2iH/rdnAW9Sssp/caU/L4wW
	 q+p9O/br4c6QzKJkn3M+1b4GJ+2DNDhECxrQu4li4C3nrOzszgzv6STzo81+kVOQcYrnS
	 iiFbFTG4GajAfbLiaHfW72p7s1FcP97fQfqWMHr17/Y+6jnt5nvlOQX7wchmqDu586rJX
	 ilez77XCuKsdVYXvqfGiVBp9uPqXSYopC7MPNG0dU5eCtooQtRIxNRnVDQZe23RuK9OYD
	 zxjqI7Ky8CilTdNe/os7m9RF903/IdwOcqmESBCzxKbBtM2fev2VTtCl5akt1hDAqzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aQQ/8BFJ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57738606A331;
	Sat,  7 Nov 2026 14:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aQQ/8BFJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041891F0089F;
	Sat,  7 Nov 2026 14:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061705;
	bh=bOl85+eudxKXSckpWng7YaXguL9KObLQ9TdYP4syhMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aQQ/8BFJzMtUIAs1F5CZdqQ4JfVZxQwhaYQtsSB6Np49ChZaDTrWG0EDz93uOW8wl
	 uxDTv8YauThuRw9gBgxkHutkWEb60U4I7w64NbnLijZ+WDDDXtrTTSvPky2ci1I5Wy
	 cEy0wCYYHgZtJ8W/Dj2S21+rjPnEilN5v29G+Vjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0754/1536] pnfs/blocklayout: Complete a device upcall only on its own reply
Date: Sat,  7 Nov 2026 08:46:10 -0500
Message-ID: <20261107135018.711377488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

commit acfbea6c5e27c68d6b6d12849eb2b7f8466ccf06 upstream.

bl_pipe_downcall() wakes bl_resolve_deviceid() on any write of the
right size, without checking that blkmapd has read the upcall being
replied to. A write that arrives first returns the waiter while its
struct rpc_pipe_msg is still queued on the pipe, which then holds a
list_head into a dead stack frame. Reaching the pipe takes root, so
the trigger is a broken or hostile blkmapd.

The wait has two further defects. bl_resolve_deviceid() sets
TASK_UNINTERRUPTIBLE only after rpc_queue_upcall() has made the
message visible, so a reply that lands in between wakes a running
task and the schedule() that follows sleeps forever holding
bl_mutex. And nn->bl_mount_reply is never reset, so when the pipe
purges an unread upcall the waiter takes the previous reply as its
own.

Move the message into struct nfs_net, where bl_mutex already limits
the pipe to one upcall per net namespace. Accept a reply only while
blkmapd has read the whole message and no earlier reply has been
taken, and reject any other write with -EINVAL. Wait for that reply
on a completion so it cannot slip past the sleep, and check
msg->errno before trusting it.

Fixes: fe0a9b740881 ("pnfsblock: add device operations")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260901-alemi-v2-5-e163f94a3a6e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/blocklayout/blocklayout.h |    5 ---
 fs/nfs/blocklayout/rpc_pipefs.c  |   58 ++++++++++++++++++++++++---------------
 fs/nfs/netns.h                   |    5 ++-
 3 files changed, 41 insertions(+), 27 deletions(-)

--- a/fs/nfs/blocklayout/blocklayout.h
+++ b/fs/nfs/blocklayout/blocklayout.h
@@ -161,11 +161,6 @@ BLK_LSEG2EXT(struct pnfs_layout_segment
 	return BLK_LO2EXT(lseg->pls_layout);
 }
 
-struct bl_pipe_msg {
-	struct rpc_pipe_msg msg;
-	wait_queue_head_t *bl_wq;
-};
-
 struct bl_msg_hdr {
 	u8  type;
 	u16 totallen; /* length of entire message, including hdr itself */
--- a/fs/nfs/blocklayout/rpc_pipefs.c
+++ b/fs/nfs/blocklayout/rpc_pipefs.c
@@ -55,17 +55,15 @@ bl_resolve_deviceid(struct nfs_server *s
 	struct net *net = server->nfs_client->cl_net;
 	struct nfs_net *nn = net_generic(net, nfs_net_id);
 	struct bl_dev_msg *reply = &nn->bl_mount_reply;
-	struct bl_pipe_msg bl_pipe_msg;
-	struct rpc_pipe_msg *msg = &bl_pipe_msg.msg;
+	struct rpc_pipe_msg *msg = &nn->bl_pipe_msg;
+	struct rpc_pipe *pipe = nn->bl_device_pipe;
 	struct bl_msg_hdr *bl_msg;
-	DECLARE_WAITQUEUE(wq, current);
 	dev_t dev = 0;
 	int rc;
 
 	dprintk("%s CREATING PIPEFS MESSAGE\n", __func__);
 
 	mutex_lock(&nn->bl_mutex);
-	bl_pipe_msg.bl_wq = &nn->bl_wq;
 
 	b->simple.len += 4;	/* single volume */
 	if (b->simple.len > PAGE_SIZE)
@@ -83,17 +81,15 @@ bl_resolve_deviceid(struct nfs_server *s
 	nfs4_encode_simple(msg->data + sizeof(*bl_msg), b);
 
 	dprintk("%s CALLING USERSPACE DAEMON\n", __func__);
-	add_wait_queue(&nn->bl_wq, &wq);
-	rc = rpc_queue_upcall(nn->bl_device_pipe, msg);
-	if (rc < 0) {
-		remove_wait_queue(&nn->bl_wq, &wq);
+	reinit_completion(&nn->bl_done);
+	rc = rpc_queue_upcall(pipe, msg);
+	if (rc < 0)
 		goto out_free_data;
-	}
 
-	set_current_state(TASK_UNINTERRUPTIBLE);
-	schedule();
-	remove_wait_queue(&nn->bl_wq, &wq);
+	wait_for_completion(&nn->bl_done);
 
+	if (msg->errno < 0)
+		goto out_free_data;
 	if (reply->status != BL_DEVICE_REQUEST_PROC) {
 		printk(KERN_WARNING "%s failed to decode device: %d\n",
 			__func__, reply->status);
@@ -113,26 +109,46 @@ static ssize_t bl_pipe_downcall(struct f
 {
 	struct nfs_net *nn = net_generic(file_inode(filp)->i_sb->s_fs_info,
 					 nfs_net_id);
+	struct rpc_pipe *pipe = nn->bl_device_pipe;
+	struct bl_dev_msg reply;
+	bool accepted;
 
-	if (mlen != sizeof (struct bl_dev_msg))
+	if (mlen != sizeof(reply))
 		return -EINVAL;
-
-	if (copy_from_user(&nn->bl_mount_reply, src, mlen) != 0)
+	if (copy_from_user(&reply, src, mlen) != 0)
 		return -EFAULT;
 
-	wake_up(&nn->bl_wq);
-
+	/*
+	 * Accept a reply only after blkmapd has read the whole upcall.
+	 * Completion retires the message, here and in
+	 * bl_pipe_destroy_msg(), so a later reply finds nothing in
+	 * flight.
+	 */
+	spin_lock(&pipe->lock);
+	accepted = rpc_msg_is_inflight(&nn->bl_pipe_msg);
+	if (accepted) {
+		nn->bl_pipe_msg.copied = 0;
+		nn->bl_mount_reply = reply;
+		complete(&nn->bl_done);
+	}
+	spin_unlock(&pipe->lock);
+	if (!accepted)
+		return -EINVAL;
 	return mlen;
 }
 
 static void bl_pipe_destroy_msg(struct rpc_pipe_msg *msg)
 {
-	struct bl_pipe_msg *bl_pipe_msg =
-		container_of(msg, struct bl_pipe_msg, msg);
+	struct nfs_net *nn = container_of(msg, struct nfs_net, bl_pipe_msg);
+	struct rpc_pipe *pipe = nn->bl_device_pipe;
 
 	if (msg->errno >= 0)
 		return;
-	wake_up(bl_pipe_msg->bl_wq);
+
+	spin_lock(&pipe->lock);
+	msg->copied = 0;
+	spin_unlock(&pipe->lock);
+	complete(&nn->bl_done);
 }
 
 static const struct rpc_pipe_ops bl_upcall_ops = {
@@ -229,7 +245,7 @@ static int nfs4blocklayout_net_init(stru
 	int err;
 
 	mutex_init(&nn->bl_mutex);
-	init_waitqueue_head(&nn->bl_wq);
+	init_completion(&nn->bl_done);
 	nn->bl_device_pipe = rpc_mkpipe_data(&bl_upcall_ops, 0);
 	if (IS_ERR(nn->bl_device_pipe))
 		return PTR_ERR(nn->bl_device_pipe);
--- a/fs/nfs/netns.h
+++ b/fs/nfs/netns.h
@@ -10,6 +10,8 @@
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 #include <linux/sunrpc/stats.h>
+#include <linux/sunrpc/rpc_pipe_fs.h>
+#include <linux/completion.h>
 
 struct bl_dev_msg {
 	int32_t status;
@@ -21,8 +23,9 @@ struct nfs_netns_client;
 struct nfs_net {
 	struct cache_detail *nfs_dns_resolve;
 	struct rpc_pipe *bl_device_pipe;
+	struct rpc_pipe_msg bl_pipe_msg;
 	struct bl_dev_msg bl_mount_reply;
-	wait_queue_head_t bl_wq;
+	struct completion bl_done;
 	struct mutex bl_mutex;
 	struct list_head nfs_client_list;
 	struct list_head nfs_volume_list;


