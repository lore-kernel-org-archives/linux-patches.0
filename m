Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044532;
	b=o0q0QLwf1d0IxqFEVsd2zC7yybkVXivtdDe0/J91/bsFEfP/sYgztqsjGTdhiEmaVNxs
	 u4H9j7WpAvQigHskIG1H1j2LMNVnvRivPI8mofExH2uNXdKcoPG8RGqvTxYK3w1EVz3vT
	 dmqbj0auyQshdBpOyTk+hjjmy0yZVvUF2kVdOGKVdXMc4zu/9jlEEgQfDkZO4/V2T+rZK
	 s41s+BAGC1l1bjjqDVwpXIOW2eO3OkYUuuR9wlUDJIvJe9W+5R+cKF8XUutg8Equ8nBAB
	 XsjjbEH89NnjGaTt88VmwZvaF6uFd4Tmc3r+MELs6J8NbdBaNVhF5E3oQND4rE1jjQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=89m5NhTZP9KL6yksIls713TNeiJSS041zo7zABORCJQ=;
	b=psqdelKh6hjujzoP8jrElKDAhWO7p6YvTXlO3FN1Ie4wC2TQWVhSb2fdOGQZSleoYpUT
	 x0v7OXULtif/ijUR0gK6VnRGL5Pl8y7a1qN9wlTJkDgxz0ql0ovIXdU7X2h9OO1tWD32/
	 A6z0uJzzeRjGXNJej3QLm6PCpwS9OspVKd1MiUIvYTt+tXZ4k2Uf+yCTQV9CBYOST6OvD
	 h8cI/mxtijFhJ+RtZCOp68+/CPCtaTntNDFIbDsv3hl2B/C/oriKC560t8+02M3Sdo5Bz
	 6oyKJvsqL/JY5nqFBS6SptoSaillD98qrTj7gUZVUNgGehUnAmmonXgcTW3pCTcMt6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L4fcrX7O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3292B606A320;
	Wed, 18 Nov 2026 23:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L4fcrX7O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8461B1F000C4;
	Wed, 18 Nov 2026 23:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044532;
	bh=89m5NhTZP9KL6yksIls713TNeiJSS041zo7zABORCJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L4fcrX7ONiqzk4vdcptxLluc1+dDMUj8dU7J0PplzBpglW9hwQ4w9Fd1BpHT5NVQk
	 LHDRfsdctPlEBj+JLjcMsnOMn53+niC67yI3unD9e51FH6C3l2w7pIhzo2xDHoNTLv
	 m61zT8fgzJ7Fw8235LnjkWcEOvupHVVdHnY4xee0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0600/2857] pnfs/blocklayout: Complete a device upcall when the pipe is closed
Date: Wed, 18 Nov 2026 15:27:14 +0100
Message-ID: <20261118150223.095409974@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -151,10 +151,31 @@ static void bl_pipe_destroy_msg(struct r
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


