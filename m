Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC08175A89;
	Wed, 30 Sep 2026 18:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794025; cv=none; b=CbsdTnUPwypieXs1Mj71iZzvyGaj1yoXa7mGTrfEePft7eMCk55eYytvxyqYnNRjGFVJsBUh2UxMB6NKUnyxmO+SeF7yQEva1qj64sZC5hdRSHpQOdbd9wS0kzX8XMwCPuSiPAf6knMlgitOuRoj3w15oyFclC25G+NL3sD7/7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794025; c=relaxed/simple;
	bh=Zz6yBCDUN5k+Aa4L/I9EP0hdvXr6kkHbSkIHgehEag4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eV33UnCpM54HL6h64Rt+FMxfzlGso1nJnaNb9PmhuFqgw+1xvkuS4lNTWvpF5NWP0m501pzqfJl8kSPDz2fN3R6u/fCpjK71y4vyqhllTiAIAQ4Ga4GVRy0ZUi379g4WjWsx6Nu9G9j7DMqfJSA7qrkiWz/yC/1CieWpTq9rGAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvcmACUM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvcmACUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F201F00898;
	Wed, 30 Sep 2026 18:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794023;
	bh=SrYOqS//JfS1hB5w6s25VmYcdaGKh7E6gPz7psXd6wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pvcmACUMVfsAWmm3tMGBpPQzR/ulClBTauwx3u23pn/t9XCgsXpU2Q6J5urj/mHZ8
	 NfjeVkRVsUJOjA9FFhIW3jefUQ9b8RDFH8/wFkjM1WZvgTIpD+H0PSQD+DrJ92DXLT
	 9Mw8JJonwApyFdPlV58QcywqnI7BSsrQw6Ir1Rs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Barre <pierre@barre.sh>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0066/1193] 9p: invalidate readdir buffer on seek
Date: Wed, 30 Sep 2026 17:12:30 +0200
Message-ID: <20260930152435.737201057@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4102759a5cb56..b2775165afb44 100644
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



