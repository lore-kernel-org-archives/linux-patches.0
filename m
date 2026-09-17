Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0514B44C5;
	Thu, 17 Sep 2026 16:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661284; cv=none; b=CNYZG/ePkSGb9oP5Jr7TW+ZlPTdWiB4xGHXaNoO1f6moQqDehuMNkyp/DSvXYScJ66BAKiSnuovevQ1tZ0ILMxqxZTcvqUHqpdlsAaiD2su2v6OcODOe6hUQFGFjOmELYZqHXBN+UbmcY0NaEHEM18DCu6dGWh9LtgRSinClXsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661284; c=relaxed/simple;
	bh=9Ha8MtyYW8At0r3iII5Awj9xSduQdSM281xYLhkr7RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvaQSzhSJwk2hfBmvlsFIpHSHXzrQueMFzDGSIo8cxszXCYccYzPg0bULe/zylAhFUTJW1NWBuVmTtoM0MyycWNF8F0Pgt+KsD+6xeaa+k9TIOvrlMqWvjsWRcQO+VKm65luQO3LLxAWUwr31UQqXDbtDNbDh7avcV85rFhwEo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=loC9JUsm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="loC9JUsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67C01F00893;
	Thu, 17 Sep 2026 16:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661282;
	bh=wCC7TMxcv0cIvAMLgLDY3Iw9aH5WACpCvatIYTI5KCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=loC9JUsmrPuSriGXTbbmkzNsPhP6XCEpS/1ICSFQS4X8vlx5HuHiuWoxvEcs0uqfE
	 VOWrqy+b7Jmk1/ybXhZkE/NOZnUG+8V3GjQi8kVztFptMREVNQygxrB/RLcVR9sbYV
	 yZdDAhCjFVp2MvhswDGc9oeaWBWBY+Va+6E8jV4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Barre <pierre@barre.sh>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0144/1250] 9p: invalidate readdir buffer on seek
Date: Thu, 17 Sep 2026 15:58:59 +0100
Message-ID: <20260917151555.961040515@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



