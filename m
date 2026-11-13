Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590832;
	b=D3GebxWDG0TtOCrB2Btz90Sr3CwnKx5kWQEYXVqoHckWaPJoFciUqKUnPSSS1m36OLu0
	 YIA0/tDpYw8hT+YHqhl3OomMXXzTiEanQQ1duLNorkaAEF8O21nzL7ryTdyH6k1NMLOCy
	 697zsiPd2lj+wSY0nD5wPaZkNkDiA4Nw2MDuOP/6Dbr2GE2FtVcYtLv4/UpFJVyICPVqk
	 5og4NIp6TVVdkNTZQ5gBqT9MENakKN9dL2ERIYWwSJ9FU5R+eIy1YNb+hOOjBAv8lcK5V
	 /S15f1N40WIDwm44Ob/kKiHErjQaCpl11DE+6VQtH9nKVZsiTTbJ3D3NMNqIL11eI0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590832;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ys9nQaf81lI82prytNt+P9HRg/rFKjSjsPCc5nKD6Z0=;
	b=cwnIqji9mqO/J1czUr5iC0U6Vmcp5AUJKSgSEtrJKgEVQqMG2LV0Y6A3OgFwwyW0yRy5
	 JAPzG8bg5oEG9rpAI2aD3hWqb/fLj/Po9vCAak9LptyM7zvrMbIAUhVYsBsP1AzyeTiwj
	 +OE6e1/Xw3esJdkIB65O4pW8n7i+qmhUIuiZKfXtir1tyj+VwXhcCPCzwvQPwdmBlMnJu
	 JDrq8zNDrI1XZF0I31CgGpNKPu/VMlgJM+pEO8HfIEGjvSBH8WbfNSgpRZ5XdTNxXC0YO
	 YuuQZ2PO9iuUwCqFwuuynTO21lEFTjptfTc6jwyeoLNPje9CjerFCVkb25LE1G8jcuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rhdeA/m3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F5F606D486;
	Fri, 13 Nov 2026 17:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rhdeA/m3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D145B1F000C5;
	Fri, 13 Nov 2026 17:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590832;
	bh=ys9nQaf81lI82prytNt+P9HRg/rFKjSjsPCc5nKD6Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rhdeA/m3/7D4KU879HBayimORp77FqAPoyNASns+R5TfXYWnTAN1pKwehBgRfODDl
	 t6wxbx98ZQz0XDsbzkcTuXkc6NKW9o4xQUoNHzYVmWmNPeiJGjo9HIcpsaCTGtFV6G
	 33dFFqkyOIKKMjF4PBJVV1IIdrqkJYZ5Vdy9NrFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+edbebd898142ee5e24ce@syzkaller.appspotmail.com,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/670] NFSD: Complete a cld upcall when the daemon closes the pipe
Date: Fri, 13 Nov 2026 10:43:20 -0500
Message-ID: <20261113153812.379020861@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

[ Upstream commit 2a83fcb50f3c25c493cc4389619340fefe9d6ac4 ]

Once nfsdcld has read a whole upcall, rpc_pipe_read() unlinks the
message from every pipe list, so the purges in rpc_pipe_release()
and rpc_close_pipes() no longer reach it. cld_upcall_ops supplies no
.release_pipe callback, and cld_pipe_destroy_msg() returns without
completing the upcall because a downcall is expected to follow. A
daemon that exits between the read and the write therefore strands
its waiter: the nfsd thread sleeps in TASK_UNINTERRUPTIBLE in
__cld_pipe_upcall() and never returns, hung task warnings follow,
and the server cannot be shut down.

Add a .release_pipe that completes every upcall the daemon has
consumed. cu_inflight distinguishes those from upcalls still queued
on the pipe, which the framework purges before it calls this
callback; cld_pipe_downcall() removes an upcall it accepts from
cn_list under the same lock. Neither can be completed twice.

Fail the stranded upcall with -EPIPE rather than the -EAGAIN that
makes cld_pipe_upcall() retry. The daemon consumed the request, so
whether it acted on it before exiting is unknown.

Fixes: f3f8014862d8 ("nfsd: add the infrastructure to handle the cld upcall")
Reported-by: syzbot+edbebd898142ee5e24ce@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-nfs/6a99f6f0.2e567484.299ffc.000c.GAE@google.com/
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260901-alemi-v2-7-e163f94a3a6e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4recover.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index b493bb059a8b0..9c7f6d90a1b99 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -948,10 +948,34 @@ cld_pipe_destroy_msg(struct rpc_pipe_msg *msg)
 	complete(&cup->cu_done);
 }
 
+/*
+ * An upcall the daemon has consumed is off every pipe list, so the
+ * purge in rpc_pipe_release() and rpc_close_pipes() cannot reach it.
+ * Release its waiter here instead; no downcall can arrive now.
+ */
+static void
+cld_release_pipe(struct inode *inode)
+{
+	struct nfsd_net *nn = net_generic(inode->i_sb->s_fs_info, nfsd_net_id);
+	struct cld_net *cn = nn->cld_net;
+	struct cld_upcall *cup;
+
+	spin_lock(&cn->cn_lock);
+	list_for_each_entry(cup, &cn->cn_list, cu_list) {
+		if (!cup->cu_inflight)
+			continue;
+		cup->cu_inflight = false;
+		cup->cu_pipe_msg.errno = -EPIPE;
+		complete(&cup->cu_done);
+	}
+	spin_unlock(&cn->cn_lock);
+}
+
 static const struct rpc_pipe_ops cld_upcall_ops = {
 	.upcall		= rpc_pipe_generic_upcall,
 	.downcall	= cld_pipe_downcall,
 	.destroy_msg	= cld_pipe_destroy_msg,
+	.release_pipe	= cld_release_pipe,
 };
 
 static int
-- 
2.53.0



