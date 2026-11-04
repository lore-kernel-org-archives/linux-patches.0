Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831723;
	b=2zZ94dRzSJD0z2OB4UX2IvqGToitoVlAWp2SosNFjHMimW/rfEdGBK+c1drvLWb4u2qb
	 9tnZVAVWu3coZyL+HboBDFqt/9d6DD87AMAh0aJ70ZkHSn2qEJK5vB3d+6EWEIS3vzKMY
	 iKcUi0cAVJFWxwrT80lJI+uQ9s4exOAbQlaEuqX74iCWE14tZQcZTsfliiK2cnXGsxtQ6
	 gLbJFmBCcbjkkyHVqxr5PHRD1tBa7nOYvKGbFkVY5g7mGOakBInCMF7HKYEImC/E8VjUE
	 eYxg8Wy0nthC6FTAEbcv2/5Mpe9AtOPy4iZR2qN2Wgrm6JdczW6HqQUl2ROL0Y84Aog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831723;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C0cuTy+MPCZJxZtCDso22n9fMDi+l699Q84Ttvv3hkM=;
	b=ntP8bmMT6UpOdbN4qHz72DpVP5QEIXR1uC4chaJNCqJYWZNmMLLW1YWex3p4FYIfNtZy
	 6ituiX3y1439z7ld9TQl+h5Oofx1p1scONdb/2DbrMa9V/6nVZrItV4QMYHzKeTO8QIPJ
	 ZVNeOFKv+jv2Z03yczK0JYpbHVSuuGZuxbO26yR837Jk9yoiglCeTapuBm7gFaPtt7em2
	 voIpuu8XMupLUc9j0JuvTJeeuGrVppt7yct7Eou2fIlEzPR//3FOaGqdpBrYOOgdqDZTK
	 vucz49iayZjL0zzkK1p9skTt7tEnjTlF16EcRVbj5fOlTmjt8mq/b8goNk0KY/imb7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nh2Kzd1F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588AB606A846;
	Wed,  4 Nov 2026 22:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nh2Kzd1F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C6C1F000C1;
	Wed,  4 Nov 2026 22:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831723;
	bh=C0cuTy+MPCZJxZtCDso22n9fMDi+l699Q84Ttvv3hkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nh2Kzd1FhwzxxI0I5U4EphaXpU4u3BIkami4ILXfEvw/CkBPrcCxFzW4VUIQ8vosw
	 g5xYQea3dqLLdcOPVMYCXtnBkeGbt5sk5elx82Kw5iv+gtpi8MOXUTOTZR8rI0tfcR
	 5OGJ8vPbfBSmmXQe06jkEfQEKeTd+DT3DzwJtZFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0874/1005] pnfs/blocklayout: Complete a device upcall when the pipe is closed
Date: Wed,  4 Nov 2026 16:10:07 -0500
Message-ID: <20261104211107.738828907@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 
 static int nfs4blocklayout_register_sb(struct super_block *sb,


