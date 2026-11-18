Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051822;
	b=tS57AAMwE9r5om8xRQSV8NUgaTbtDjo4UbRyNnyxJG1aF/e891C4yLpnm/gjbaeqJEHD
	 /Z0JO0G+xAZb6pUUKOWMALW9qkpAnT8hy+Bx8CxeoGMPby6fRnpXVHbpji/0YyBuodqKJ
	 QJLDFuCng4ciS+tdteOKdj8Aa6dsiOByCyEW55JidWE5h/kBVCJSCj14kBTwCCoKDYQ4P
	 7CHEZnopym8iyOenzz29jNC7lsI3T7+eEQYmnTlUJO7JW69UBvsGIo3bkfWq9gCdvP/+B
	 wxJrC0eCuCWSeMkZPzYcMkSVTrpW/LKlU8VD2Mns88SCNvrnoH/y6JC1TjoHyD8h05g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jmZ7dVRY7B4r626ypXvTaW0FNy4sLwlqZEzMNUq3ZFM=;
	b=AW+xG9rsUjikj0JTFMNk8BF+11xZbru7pcSPccPOqwYgnQy6rSbia0d0fI0S4H+NibTS
	 0u1vvBZUNAAsYXpAbiTQ/9N9oVd356e6OEpaALBq6ucbS47Cy1ZedcgHPL7gmx6SIl4Lv
	 oGjGrwCWrTPyzYIjuf3fFs8vXjjTX4wBxtUHtSKJrmEnF15X3l86BCtPVm3rcky2KrhRA
	 fvyPeWWg0Kjvwx/c/HpayVgVmdI2PWPe1ydkjdVijK+0v6YoJ9qdwI+sEZFMxXJIM0qDw
	 iLQfdBCxAe5OF3jLiU3phY0Vag841rR9PdMdwsxCaixEpkksdgwiHsqutnO9idl0xfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="E5zyz2Z/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C484D606A32F;
	Thu, 19 Nov 2026 01:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E5zyz2Z/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95BE1F000C4;
	Thu, 19 Nov 2026 01:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051822;
	bh=jmZ7dVRY7B4r626ypXvTaW0FNy4sLwlqZEzMNUq3ZFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E5zyz2Z/p+IO3o/WdX/vHo8t8y7ln3BcQd38Hn35Yhlmdlphlnbb++6W1GZzSB3rN
	 VjNCh2VLD7AEbeFAsIfLVQ67v7zyxmUHnvGKHfkA4WNvoZDvHeY9yZkNFGPe/cUvd4
	 DQEWNnD6bUcZZsIsn0ps0DCRnhDyoRHeIhRe4kmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.15 0344/2214] pnfs/blocklayout: Complete a device upcall when the pipe is closed
Date: Wed, 18 Nov 2026 15:33:40 +0100
Message-ID: <20261118150024.475571363@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

commit 2a25cc8e984610828a526086313b8a7aeefe507d upstream.

Once blkmapd has read a whole upcall, rpc_pipe_read() unlinks the
message from every pipe list, so the purges in rpc_pipe_release()
and rpc_close_pipes() no longer reach it. bl_upcall_ops supplies no
.release_pipe callback, and bl_pipe_destroy_msg() returns without
completing the upcall because a downcall is expected to follow. A
daemon that exits between the read and the write therefore strands
its waiter: bl_resolve_deviceid() sleeps in wait_for_completion()
and never returns, and it holds nn->bl_mutex across that wait, so
every later device resolution in the net namespace blocks behind
it.

Add a .release_pipe that completes an upcall blkmapd has consumed
and left unanswered. Completing an upcall retires it, so a message
the framework has already purged is no longer in flight and is not
completed a second time here.

Fixes: fe0a9b740881 ("pnfsblock: add device operations")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260901-alemi-v2-8-e163f94a3a6e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/blocklayout/rpc_pipefs.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/fs/nfs/blocklayout/rpc_pipefs.c
+++ b/fs/nfs/blocklayout/rpc_pipefs.c
@@ -152,10 +152,31 @@ static void bl_pipe_destroy_msg(struct r
 	complete(&nn->bl_done);
 }
 
+/*
+ * An upcall blkmapd has consumed is off every pipe list, so the
+ * purges in rpc_pipe_release() and rpc_close_pipes() cannot reach it.
+ * No downcall can arrive once the pipe is closed; release its waiter
+ * here.
+ */
+static void bl_release_pipe(struct inode *inode)
+{
+	struct nfs_net *nn = net_generic(inode->i_sb->s_fs_info, nfs_net_id);
+	struct rpc_pipe *pipe = nn->bl_device_pipe;
+
+	spin_lock(&pipe->lock);
+	if (rpc_msg_is_inflight(&nn->bl_pipe_msg)) {
+		nn->bl_pipe_msg.copied = 0;
+		nn->bl_pipe_msg.errno = -EPIPE;
+		complete(&nn->bl_done);
+	}
+	spin_unlock(&pipe->lock);
+}
+
 static const struct rpc_pipe_ops bl_upcall_ops = {
 	.upcall		= rpc_pipe_generic_upcall,
 	.downcall	= bl_pipe_downcall,
 	.destroy_msg	= bl_pipe_destroy_msg,
+	.release_pipe	= bl_release_pipe,
 };
 
 static struct dentry *nfs4blocklayout_register_sb(struct super_block *sb,


