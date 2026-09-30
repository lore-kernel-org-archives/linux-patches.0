Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FC45335AA;
	Wed, 30 Sep 2026 17:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790683; cv=none; b=fvhhppG6jew/1AGr/1+4PceTiafQortwmwrJSqvtEyPzzF8DTqiG12uf/QJ5vFDhUqYKP7RIF5iRY2hwgfhc+CCyxqcVKIp/kU1EEg6b5hsEBUuPbNkWDTn3zjuC9Z0aoEq1vvzxnPyzTuvrqGxkJHrg7LOWsCkuAi63F+JCuLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790683; c=relaxed/simple;
	bh=F/HuZ2kX9WrInqL0cSJb5uIn/MqDyHyrLRpStnCwLkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oilhysb6CwHH8z5l7LW0hhTfQJg5l3CUoUhFndMUkfSaIO9eud2uYivPY2IZ9MvVU9ErOVwpUh6Pzc6AtG5iu7xEoVY5DLC2o8U5lU0KNkvfvWJ2r7R+OQEjBR+beigXWzY52HXET80mJeJN7+cX2Ro4UluMa+t3diIXVN247zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D4/CwkOI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D4/CwkOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BBF1F00898;
	Wed, 30 Sep 2026 17:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790682;
	bh=GNFGxeHMUoecSAyHWCp2bYkG5jE0WAYv+GiUzyfDdL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D4/CwkOIHdcM0byrmGRdAA77gsK3gh3uPUKxLyj4Rkr2Jt/3rdpMag+wzuVocdEsw
	 gg0yQ5vNDCnw/awmNNAQnZ5iXu8UQIzv2d/XoG3Uq5PMcsagaXrh+Pk07lg+b9jjIO
	 lhHdnTg/snRS9zUn26LFh4tov7Dch6ey45MmuWrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Barre <pierre@barre.sh>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/752] 9p: invalidate readdir buffer on seek
Date: Wed, 30 Sep 2026 17:18:28 +0200
Message-ID: <20260930152358.978496698@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 fs/9p/vfs_dir.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index 67bbcf24ed2a7..78a9a1838142d 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -30,6 +30,7 @@
  * struct p9_rdir - readdir accounting
  * @head: start offset of current dirread buffer
  * @tail: end offset of current dirread buffer
+ * @offset: file position the data at @head corresponds to
  * @buf: dirread buffer
  *
  * private structure for keeping track of readdir
@@ -39,6 +40,7 @@
 struct p9_rdir {
 	int head;
 	int tail;
+	loff_t offset;
 	uint8_t buf[];
 };
 
@@ -104,6 +106,9 @@ static int v9fs_dir_readdir(struct file *file, struct dir_context *ctx)
 	kvec.iov_base = rdir->buf;
 	kvec.iov_len = buflen;
 
+	if (rdir->head < rdir->tail && rdir->offset != ctx->pos)
+		rdir->head = rdir->tail = 0;
+
 	while (1) {
 		if (rdir->tail == rdir->head) {
 			struct iov_iter to;
@@ -118,6 +123,7 @@ static int v9fs_dir_readdir(struct file *file, struct dir_context *ctx)
 
 			rdir->head = 0;
 			rdir->tail = n;
+			rdir->offset = ctx->pos;
 		}
 		while (rdir->head < rdir->tail) {
 			err = p9stat_read(fid->clnt, rdir->buf + rdir->head,
@@ -135,6 +141,7 @@ static int v9fs_dir_readdir(struct file *file, struct dir_context *ctx)
 
 			rdir->head += err;
 			ctx->pos += err;
+			rdir->offset = ctx->pos;
 		}
 	}
 }
@@ -162,6 +169,9 @@ static int v9fs_dir_readdir_dotl(struct file *file, struct dir_context *ctx)
 	if (!rdir)
 		return -ENOMEM;
 
+	if (rdir->head < rdir->tail && rdir->offset != ctx->pos)
+		rdir->head = rdir->tail = 0;
+
 	while (1) {
 		if (rdir->tail == rdir->head) {
 			err = p9_client_readdir(fid, rdir->buf, buflen,
@@ -171,6 +181,7 @@ static int v9fs_dir_readdir_dotl(struct file *file, struct dir_context *ctx)
 
 			rdir->head = 0;
 			rdir->tail = err;
+			rdir->offset = ctx->pos;
 		}
 
 		while (rdir->head < rdir->tail) {
@@ -191,6 +202,7 @@ static int v9fs_dir_readdir_dotl(struct file *file, struct dir_context *ctx)
 
 			ctx->pos = curdirent.d_off;
 			rdir->head += err;
+			rdir->offset = ctx->pos;
 		}
 	}
 }
-- 
2.53.0



