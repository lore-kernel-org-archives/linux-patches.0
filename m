Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704913;
	b=tc56IISDWagZcVotv1lQsOoh87cB+6hvkUDVzQ1YvkkBR3PqfRbh+Hot4U2byUZGylsJ
	 ukc0FA0orspjUvpl/gaSj25tESWRMQkfBhCaFiHla8MHO1UOQKMDFcZhUsRoEpOvMSzG+
	 9/etH46arwKWJpVTJ1HTrfY0K5mAw+WhXyrw6ny5mQKFXD7E+tVo9cj3HkR4E5zhdRdnb
	 PFGY6INHqb6/z1RPFiv/spRnKYWQnCo8kcnecE3J6Jh6mfHa+ze99LTmehyqN0eKjkvUL
	 reNvxjvlqMRe5dCM/npvFuW12Bqzdbsy5Sg+Bd9eEjupGUYjSUJX2BmdT2qeXtnwIEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HXEPtIWVc7LklSkZ6/je8ic4vMUK8WFrCJ+qxM6kQX8=;
	b=uPM5zCcb+qIjFRmtasrNISsS6ghsAsDFKgm+Dljm6boYuXM1OfcN3dNvlqQTb9TTnOz4
	 0/0++8SYYwP31vVBYbmT3+oKJaEiZ9IIh1nDnbvzIQOCJO3WPY/Sd6ewk1zl5w632QDIG
	 /NCJkVIYFotvcjCnajvt+FBlxu82TbNvBoyUv7qAsEmRLhbOawa4NltBWF6L6wdWAj5e8
	 NyKd/PZhXebmGz64Re0UUSbC8T5T/+gI8ic+mvc58SMfbV1pk1uEVmfnHNPvWOtnbC49H
	 GgYQ5ZwhNO+jgGRJ+kwajVqJHMrAccDmeGT3ayJgo5kSZqpJkJsJoaDd2QQb1D1UvuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vlcr9ROH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12342606A31C;
	Thu, 26 Nov 2026 14:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vlcr9ROH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7C31F000CA;
	Thu, 26 Nov 2026 14:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704912;
	bh=HXEPtIWVc7LklSkZ6/je8ic4vMUK8WFrCJ+qxM6kQX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vlcr9ROH89wBHUtxlvmcr6HgLB34PjL2qUVKmo1NgOGrtptZsQszNc0ywHy88O40y
	 MVbyhnk4Q7QsYuu2LUsB6gWl39Vli65WX/KGEPOOjSjHpMES2x2AW6q/hRd0EFtpDS
	 RkqlSMjnELVQgtitqtfMeXxgC/CEAF/2ZmiB0DRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haobin Wu <853555@gmail.com>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/319] 9p: skip intermediate directory entry name copy in p9dirent_read()
Date: Thu, 26 Nov 2026 15:36:27 +0100
Message-ID: <20261126144007.174711283@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haobin Wu <853555@gmail.com>

[ Upstream commit 8bb0279930cc90975f03bad4d83282613e5f57fa ]

v9fs_dir_readdir_dotl() decodes each entry of a Rreaddir reply with
p9dirent_read(), which parses it through p9pdu_readf("Qqbs"). The 's'
conversion in p9pdu_vreadf() already allocates a NUL-terminated copy
of the name from the wire buffer; p9dirent_read() then strscpy()s that
copy into the fixed 256-byte p9_dirent::d_name and frees the original.

The wire format carries the name length in 16 bits, so a name longer
than 255 bytes is valid on the wire and may well be valid on the
server's filesystem, but it makes strscpy() return -E2BIG.
v9fs_dir_readdir_dotl() turns that into -EIO and aborts getdents64(),
so every entry after the long one disappears from the listing.

Drop the second copy: keep the string allocated by p9pdu_vreadf() in
p9_dirent and let v9fs_dir_readdir_dotl(), its only user, free it once
dir_emit() has consumed it. p9_dirent is a short-lived stack object, so
the string's lifetime does not change.

Note that the VFS only rejects names of PATH_MAX bytes or more in
verify_dirent_name(), so after this change a name between NAME_MAX and
PATH_MAX is returned by getdents64() even though any later lookup on it
fails with -ENAMETOOLONG. The next patch skips such entries.

Fixes: 7751bdb3a095 ("9p: readdir implementation for 9p2000.L")
Closes: https://github.com/microsoft/WSL/issues/41192
Signed-off-by: Haobin Wu <853555@gmail.com>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Message-ID: <20260918024851.51229-2-853555@gmail.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_dir.c         |  6 +++++-
 include/net/9p/client.h |  2 +-
 net/9p/protocol.c       | 12 ++----------
 3 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index 9786fb2c5a99a..4ce08e3125b02 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -197,8 +197,12 @@ static int v9fs_dir_readdir_dotl(struct file *file, struct dir_context *ctx)
 			if (!dir_emit(ctx, curdirent.d_name,
 				      strlen(curdirent.d_name),
 				      QID2INO(&curdirent.qid),
-				      curdirent.d_type))
+				      curdirent.d_type)) {
+				kfree(curdirent.d_name);
 				return 0;
+			}
+
+			kfree(curdirent.d_name);
 
 			ctx->pos = curdirent.d_off;
 			rdir->head += err;
diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index 7060de84c5593..0a068e2062053 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -173,7 +173,7 @@ struct p9_dirent {
 	struct p9_qid qid;
 	u64 d_off;
 	unsigned char d_type;
-	char d_name[256];
+	char *d_name;
 };
 
 struct iov_iter;
diff --git a/net/9p/protocol.c b/net/9p/protocol.c
index d473e5eb29cce..d4387f9724475 100644
--- a/net/9p/protocol.c
+++ b/net/9p/protocol.c
@@ -607,7 +607,7 @@ int p9dirent_read(struct p9_client *clnt, char *buf, int len,
 {
 	struct p9_fcall fake_pdu;
 	int ret;
-	char *nameptr;
+	char *nameptr = NULL;
 
 	fake_pdu.size = len;
 	fake_pdu.capacity = len;
@@ -622,15 +622,7 @@ int p9dirent_read(struct p9_client *clnt, char *buf, int len,
 		return ret;
 	}
 
-	ret = strscpy(dirent->d_name, nameptr, sizeof(dirent->d_name));
-	if (ret < 0) {
-		p9_debug(P9_DEBUG_ERROR,
-			 "On the wire dirent name too long: %s\n",
-			 nameptr);
-		kfree(nameptr);
-		return ret;
-	}
-	kfree(nameptr);
+	dirent->d_name = nameptr;
 
 	return fake_pdu.offset;
 }
-- 
2.53.0



