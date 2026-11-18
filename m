Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057872;
	b=3AJeCvvcww+JgLp0EXU64zgXE2n7m+OExPY1A48y1Ahg1goe88bVUqWEXdjqGBovVPLN
	 +sbNCj81CYt9HagX7GY7d8y+S4b48NgSKVdVadEWPpIiPIEaRpWf+C6UzsoYGZovD/2Ap
	 gKji0kTasG5oAwz0iM2dQDHmIOo/pg3nMvrDa0J/WXoLMgX2Uk+bCV3TWOunXe88rZcZA
	 ZaofedfaXzDspvHsVR/vnXcCK8sl7DvC9k5y3SpQwP7RjZBUF6/mn6eWjIvLsO+HdY14r
	 4+LYY+9yTI6BeeBcEM9fJISASokX5eLQA/y3KMqjDrCzw4j2mss1eA9W+BuISBjYXAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kAcwj+Uec+aTxmtZfNp1qnSgl2vDvshj4s+arDs7rDA=;
	b=2hcpvTZZ6jitjex80Zkg5yjfoefMtSqpRPfrKwOz1J7GUWw65ipdmTBUxcvIDE2O4OYX
	 ChxQvB+ldqgjgnUByR+hyX3JzndSPPi8w6l6B6ePL+Ye018YWAdDf4kUgd9EiZklDD/Qe
	 EAAHKhiwTkXy6gDTlUTBMTJdH9ZrUjXC+Lo4DkGswZDxEbPfiU/ty3+u2zCCjJ4QZcwo7
	 eel6xrfMuaFhvYjg+bRv1e1F64iKEV30NviQeusRYYmqggNCqgEMptMHbYr58ejSQis5t
	 0U1A8DEFZ3bcIZeKu27ut7h+Nw/CtHlQOpaGck3WiJQfZvz7nzWSYIZ28LqdDCUEUvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M43O6YAG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF0C606A31C;
	Thu, 19 Nov 2026 03:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M43O6YAG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B232B1F000C4;
	Thu, 19 Nov 2026 03:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057872;
	bh=kAcwj+Uec+aTxmtZfNp1qnSgl2vDvshj4s+arDs7rDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M43O6YAGeYm2A2p1i7LvznC+Ia7Xn5+5+mlrlNDOscYgQUv/+S+4unHsj9M5opWvo
	 OddH+ajOgXVnTMVwxFYGM2h2c8bbAbjvi9awScr7JWv7t6Gj2lZJ9YQzyZ2bkOdGZB
	 Zj0d7h80WrJ9D+0+tk0bjpJc8I1XIqwDi0dwz+SM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.10 0284/1848] pnfs/blocklayout: Complete a device upcall when the pipe is closed
Date: Wed, 18 Nov 2026 15:38:42 +0100
Message-ID: <20261118145924.065880117@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


