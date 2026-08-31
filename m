Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FAD572687;
	Mon, 31 Aug 2026 13:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184129; cv=none; b=g0xyVh7RZdkSC1QcsQU4NldSG3bqnU/8iYjvnbWVN0iWfj0S8HkE/RvFEBgAIEUyA3iSP5XWYsbic1Q2LzInV9QhWJkmje1RQRA3x1TANnWiMueePFfKRrR6Ecu6ZYBYfjjn9KitUvC5xgQDG6kgk2UUFNewngTnizD0trknAEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184129; c=relaxed/simple;
	bh=SbUyM8dH1HgueDDcxRwQUvqOjtmsiV1FO/dYAFGIZu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PPiBerDhD5phN4tMGHuAl7VWmHrgbj92nJfdlqaRKa9ox7izSwnKYSnj3h0abiADiftqwbJTVeS6L89l3jg/bgviC8gcnmkrbugpIYGUt4iex/C/0+VqtbDVi6Do6PPzJ2IOwiWSqHzTYSPYcK9mUTiqECwqJ/r+eB0ivNMrZko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C/pQDoAj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C/pQDoAj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73861F00A3F;
	Mon, 31 Aug 2026 13:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184126;
	bh=OWuC30t49rvl9ZqBhhu5VKIWT9sCxrBri9E8/rbZgFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C/pQDoAjpaeLfNCBpud2ZqjgNXHncSCe51/ZnitLPS/U069x5RtdmYSta0cf57Edf
	 rWM32S0vNelg2ro+tAhncB+Ffx9F0YuB+QzDGJrKuI0Xfg01LSrYwUiTHJ66a68/Vn
	 Dl68EvNp4GfRnYLtYCCjmI82e29ZyiQrzga3KKySxk7VIdT6b/WJJElUp4+/bhnGAw
	 qWBQIQFOiViICsiyMBMvQh1frlabvohoVs0qrBU60WqiWQbJfTiFGKDCaKYzPN+I2M
	 brsW7lTKWlpYOWfnR+rZiJPM0OPnsfkNNfNsDqKenhPq+htD4Ofm3UV6dklgVhWb5T
	 Tz289qRinSSKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pierre Barre <pierre@barre.sh>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>,
	ericvh@kernel.org,
	lucho@ionkov.net,
	v9fs@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] 9p: invalidate readdir buffer on seek
Date: Mon, 31 Aug 2026 09:28:56 -0400
Message-ID: <20260831133314.4125787-508-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pierre Barre <pierre@barre.sh>

[ Upstream commit e661e17ddbed524b5fbda789a091b48b6b677067 ]

The per-fid readdir buffer (fid->rdir) is populated lazily and only
refilled when fully drained (rdir->head == rdir->tail). userspace
lseek() on a directory fd updates file->f_pos via generic_file_llseek()
but does not touch the cached buffer, so the next getdents() iterates
the stale cache and emits entries from the previous position instead
of the one the caller asked for.

Track the file position the cached data corresponds to in
struct p9_rdir, and drop the cache on entry to iterate_shared when it
no longer matches ctx->pos. The 9p protocol's Tread/Treaddir already
take an arbitrary offset on every request, so a refill at the new
position is always legal; no .llseek override or seek restriction is
needed.

Reported-by: Pierre Barre <pierre@barre.sh>
Link: https://lore.kernel.org/v9fs/496d10b9-40fe-4f81-8014-37497c37ff63@app.fastmail.com/
Signed-off-by: Pierre Barre <pierre@barre.sh>
Message-ID: <20260512132032.369281-2-pierre@barre.sh>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background searches finished and match the earlier analysis:

- **Current tree (`stable/linux-6.18.y` at v6.18.44):** The fix is
  **not** present — `e661e17ddbed` is not an ancestor of HEAD, and there
  are no matching commits on HEAD.
- **Other branches:** The fix exists on `autosel` as `7ac74f9369bf6`
  (stable backport) and upstream as `e661e17ddbed`.
- **Subject grep on HEAD:** Only found the unrelated overlayfs readdir
  cache fix (`65cd913ec9d9d`), not the 9p patch.
- **Author history:** No prior Pierre Barre commits in `fs/9p/` in this
  checkout.

**Verdict remains YES** — the bug is present in 6.18.y, the fix is small
and standalone, and it should be backported.

 fs/9p/vfs_dir.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index e0d34e4e9076e..edef553bbd59e 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -27,6 +27,7 @@
  * struct p9_rdir - readdir accounting
  * @head: start offset of current dirread buffer
  * @tail: end offset of current dirread buffer
+ * @offset: file position the data at @head corresponds to
  * @buf: dirread buffer
  *
  * private structure for keeping track of readdir
@@ -36,6 +37,7 @@
 struct p9_rdir {
 	int head;
 	int tail;
+	loff_t offset;
 	uint8_t buf[];
 };
 
@@ -102,6 +104,9 @@ static int v9fs_dir_readdir(struct file *file, struct dir_context *ctx)
 	kvec.iov_base = rdir->buf;
 	kvec.iov_len = buflen;
 
+	if (rdir->head < rdir->tail && rdir->offset != ctx->pos)
+		rdir->head = rdir->tail = 0;
+
 	while (1) {
 		if (rdir->tail == rdir->head) {
 			struct iov_iter to;
@@ -117,6 +122,7 @@ static int v9fs_dir_readdir(struct file *file, struct dir_context *ctx)
 
 			rdir->head = 0;
 			rdir->tail = n;
+			rdir->offset = ctx->pos;
 		}
 		while (rdir->head < rdir->tail) {
 			err = p9stat_read(fid->clnt, rdir->buf + rdir->head,
@@ -134,6 +140,7 @@ static int v9fs_dir_readdir(struct file *file, struct dir_context *ctx)
 
 			rdir->head += err;
 			ctx->pos += err;
+			rdir->offset = ctx->pos;
 		}
 	}
 }
@@ -161,6 +168,9 @@ static int v9fs_dir_readdir_dotl(struct file *file, struct dir_context *ctx)
 	if (!rdir)
 		return -ENOMEM;
 
+	if (rdir->head < rdir->tail && rdir->offset != ctx->pos)
+		rdir->head = rdir->tail = 0;
+
 	while (1) {
 		if (rdir->tail == rdir->head) {
 			err = p9_client_readdir(fid, rdir->buf, buflen,
@@ -170,6 +180,7 @@ static int v9fs_dir_readdir_dotl(struct file *file, struct dir_context *ctx)
 
 			rdir->head = 0;
 			rdir->tail = err;
+			rdir->offset = ctx->pos;
 		}
 
 		while (rdir->head < rdir->tail) {
@@ -190,6 +201,7 @@ static int v9fs_dir_readdir_dotl(struct file *file, struct dir_context *ctx)
 
 			ctx->pos = curdirent.d_off;
 			rdir->head += err;
+			rdir->offset = ctx->pos;
 		}
 	}
 }
-- 
2.53.0

