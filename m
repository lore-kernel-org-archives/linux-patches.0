Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585348;
	b=bysZfMT6pUszNidHaohJUoZ77p0Qxi4PDGt1t8WgbL95Y58W2UzUuIUFPQRfzso2VYH0
	 FNOHI9dI/F1VdGChEkUtXDmwz8XmpZL2lGhlR+TfbSIb6rnMP65+wvAD0i2XKySIrVbeK
	 IAA7P22V0HkX+F8x91CslJDZBI2vspuiRdx3Kei886nq8TAhbZz95i4WiOQO6mUzmtWC4
	 fOblT31YdJNmbbZUYXybPK/97JMiGz8I4B3vRx8LsFJfoSOXc4w29kk8FL+T0BmYY3fo1
	 QfM/EGJCkbwRWJ5cFUtG5wm+Ut8bz03sDkrHyA4EeraFYAJL7kaNvFzdCZnM51KuJkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585348;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kvdhz5V6bPppatGqbZ060sqXptY+ZMCYvaIWlix7/0A=;
	b=h6HJnhGWmXJ1rmhcgasK05U1ALTNjPdH1m4EFHR6WQUdPJphlRVQ+hRxpxBM2VWkAqoS
	 O2bR7Fq2ravfh7Tome0mJwjJwqwsNxVtBxy9RST4AtgN8n3cqyLQ9iz3L8QylN0j6Wkbi
	 TLT37YiCYS1yAUK1aqieHhKmXZpFGg/515QAANrcd9IWNZjSNm4BlWmvGX7LJA9eQYIJk
	 KwnbfAuitqHQxleaWCXPOfSOI+LwU+iAImEQzZHK/0nx06f3tl/4xNm+Hki6/YQh9c05o
	 O31FTlR0q85A5V5MfJ09JNGu2AW/K/JQHAF38ESbKzjBSl9SCGcCkiPW0lVf+uckxMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IFk2VKvH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA7060A380B;
	Fri, 13 Nov 2026 15:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IFk2VKvH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA1F1F000C5;
	Fri, 13 Nov 2026 15:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585348;
	bh=kvdhz5V6bPppatGqbZ060sqXptY+ZMCYvaIWlix7/0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IFk2VKvHeEeK4xMJRhdKP6LOkYOS1wCYVloiOTDbfmcGA5gj9/g4MEYtJs07p+gGb
	 BeXk3T8GWTJzegW3ymxsWoqj1fyUpJ9gjSw1+G4ZRVgdZpb0wQOCCtUidt/mx3Or8U
	 ku+xhS4gDJsfhDlKw9Y3zM9+e59UP3ey9CxB1Ivk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuansheng Yang <0xbeac@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 030/507] io_uring/rsrc: hold uring_lock across index-alloc put_user
Date: Fri, 13 Nov 2026 10:45:34 -0500
Message-ID: <20261113153754.399160751@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuansheng Yang <0xbeac@gmail.com>

Commit d7c7037253f6935af243570635d71b4920b5a4ea upstream.

io_files_update_with_index_alloc() installs a fixed file via
io_fixed_fd_install(), which drops ->uring_lock when the request runs on
io-wq, then put_user()s the allocated slot back to userspace. If that
faults, the error path calls __io_close_fixed() by slot index after
re-taking the lock.

The slot can be closed and reused between the install and that cleanup:
another fixed CLOSE plus open/accept/pipe/socket, or a FILES_UPDATE, can
put an unrelated file into the same slot. The error path then removes
that file instead of the one this request installed, ending an unrelated
file's fixed-table reference early. This is a correctness/DoS issue, not
a use-after-free: fixed-file requests hold an io_rsrc_node reference, so
the node and file stay alive until they are done.

Hold ->uring_lock across __io_fixed_fd_install() and put_user(), and do
the failure cleanup with io_fixed_fd_remove() under the same lock. This
is the same class as the io_pipe_fixed() fix in a3d7ee11289f. Faulting
while holding ->uring_lock is fine, the registration paths already do
it.

Fixes: a7c41b4687f5 ("io_uring: let IORING_OP_FILES_UPDATE support choosing fixed file slots")
Signed-off-by: Yuansheng Yang <0xbeac@gmail.com>
Link: https://patch.msgid.link/20261104154655.81876-1-0xbeac@gmail.com
[axboe: various touch-ups]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rsrc.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d69baa47c7e75..c1ab760c4591c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -521,11 +521,12 @@ static int io_files_update_with_index_alloc(struct io_kiocb *req,
 {
 	struct io_rsrc_update *up = io_kiocb_to_cmd(req, struct io_rsrc_update);
 	__s32 __user *fds = u64_to_user_ptr(up->arg);
+	struct io_ring_ctx *ctx = req->ctx;
 	unsigned int done;
 	struct file *file;
 	int ret, fd;
 
-	if (!req->ctx->file_table.data.nr)
+	if (!ctx->file_table.data.nr)
 		return -ENXIO;
 
 	for (done = 0; done < up->nr_args; done++) {
@@ -539,15 +540,25 @@ static int io_files_update_with_index_alloc(struct io_kiocb *req,
 			ret = -EBADF;
 			break;
 		}
-		ret = io_fixed_fd_install(req, issue_flags, file,
-					  IORING_FILE_INDEX_ALLOC);
-		if (ret < 0)
+		/*
+		 * Hold the lock across the put_user(), if it's dropped the
+		 * slot can be closed and reused before the error path runs.
+		 */
+		io_ring_submit_lock(ctx, issue_flags);
+		ret = __io_fixed_fd_install(ctx, file,
+					    IORING_FILE_INDEX_ALLOC);
+		if (ret < 0) {
+			io_ring_submit_unlock(ctx, issue_flags);
+			fput(file);
 			break;
+		}
 		if (put_user(ret, &fds[done])) {
-			__io_close_fixed(req->ctx, issue_flags, ret);
+			io_fixed_fd_remove(ctx, ret);
+			io_ring_submit_unlock(ctx, issue_flags);
 			ret = -EFAULT;
 			break;
 		}
+		io_ring_submit_unlock(ctx, issue_flags);
 	}
 
 	if (done)
-- 
2.53.0



