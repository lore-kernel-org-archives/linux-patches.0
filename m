Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625049;
	b=ypN2VS67NnIyNPfqFwOrur8Kf2/U1C8JS9lu+C17zxwhlxXk8XiV9vrxVlIddYxQ61JR
	 AsUSayW/eLzkTDqXiE7/vgCgKpADzX95NALSaOL4t1y14Y/3M57cOem0MNY5HbvRT7lCk
	 MzUvhvj/QAKq93vbWUVtQVThw7O+D7uCSQzPzPzOCL+eAUPX5HanEXIOwLp00fVhyJYud
	 GRe9q9nrODGRirUomwOmv/KMkVAEbbsPhz/egF0l5DBYFlFYNPR+ETO+lFrEdlSaPMgiv
	 /vUCIxSC/WFlyX+xja5uoj/QABoaqM+x1TnF5GxCu7HEfSzsDJlJiLzQ8rHhlbMdp9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625049;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=54zAwcoKceQzRMjVlqgYCC+M14Pfvrc2iR1V1AZMVi8=;
	b=LiaMjNs53fr1KqIuez8oDB+UY58B6kyg2Iz9rn9SlbU0y1euOUTOdT4u9qAF5qxK4zTh
	 mg0cEx6f8a/Fw6Dpwx/UJNbA0tl7/unoIPEPOz/g8CdTtXfKps1MBU3/52AfR8d0YjSET
	 I6XWDTXKN3DwLwMEvop9JQ3i6zPONppvoRusZxxPdOQ7uTb4PFRrQhyKhDLxwTaqVyOPM
	 6Fr3mBtPzsG08CZBVGgXFyrwI8322l784VtvTQ66K2M2VwhpCbwMqM9H7Hl9ZPI+nM7Ob
	 gDqgzm8BSk6XfE4N/h4WFYBI5IoTvEUPYAT7Z+WG1VeyCnxFT8AJLdgZu8gziDi0L9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e1NghXZi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35DA606A32C;
	Wed, 25 Nov 2026 16:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e1NghXZi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E390E1F000C6;
	Wed, 25 Nov 2026 16:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625049;
	bh=54zAwcoKceQzRMjVlqgYCC+M14Pfvrc2iR1V1AZMVi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e1NghXZi8Qp6qaywnchH7cYq9ch8QFjUqlb2f8eCoSTRUqXV5Dbmw8Ff00diRsMk1
	 ZE7BJbUUzFf887w4u4k7oX/bogcvBOEkl4CaTpw5SIqnMUjg2wreF+Uc+qKNOkNHwQ
	 Lat1wHdHYWAc+50rhiXUTny/z22nipCToOQ9++u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horst Birthelmer <hbirthelmer@ddn.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 390/816] fuse: dont bump attr_version for async direct read completion
Date: Wed, 25 Nov 2026 15:32:18 +0100
Message-ID: <20261125143858.228535499@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Jingbo Xu <jefflexu@linux.alibaba.com>

[ Upstream commit fc60668db85584da911e5d0a65c8698628f98bba ]

The attr_version counter should only be incremented when cached
attributes are actually modified (as documented in commit 1fb69e781729
("fuse: fix race between getattr and write")).  Async direct reads do not
modify any cached inode attributes (size, mtime, ctime), so bumping
attr_version in fuse_aio_complete() for reads is incorrect.

This unconditional bump causes a livelock when auto_inval_data is
enabled together with writeback_cache: fuse_cache_read_iter() issues a
FUSE_GETATTR before every read, but by the time the response arrives,
an async DIO read completion has already incremented fi->attr_version
past the snapshot taken before the request.  The GETATTR result is then
discarded (attr_version race), fi->i_time is never refreshed, and every
subsequent read triggers yet another GETATTR -- creating an infinite
loop of useless round-trips.

Fix this by only bumping attr_version for write completions, consistent
with the synchronous DIO write path (fuse_write_update_attr) and the
cached write path.

Fixes: 01e9d11a3e79 ("fuse: add support of async IO")
Reviewed-by: Horst Birthelmer <hbirthelmer@ddn.com>
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
[ sashal: Only the if condition line differs in context: inode is declared inside the if (res >= 0) block and there is no mapping variable, so the one-line condition change was applied to that layout. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index f733a0f781146..89b6021a428eb 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -735,7 +735,7 @@ static void fuse_aio_complete(struct fuse_io_priv *io, int err, ssize_t pos)
 	if (!left && !io->blocking) {
 		ssize_t res = fuse_get_res_by_io(io);
 
-		if (res >= 0) {
+		if (res >= 0 && io->write) {
 			struct inode *inode = file_inode(io->iocb->ki_filp);
 			struct fuse_conn *fc = get_fuse_conn(inode);
 			struct fuse_inode *fi = get_fuse_inode(inode);
-- 
2.53.0



