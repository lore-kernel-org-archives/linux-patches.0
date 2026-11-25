Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621045;
	b=w5tkGN7ybDNR+6ViI68PEaOMDyEN5KWRt0vDpsaaRz0rbbNN5kx7KzKiDIabZOwhWYIy
	 CSPyzVuOW7lk/+gxB2ZhhMCt5wR0TmUoGhm4gizjUfHXUYlovtuzKxjmGcw3mZKOlPHlY
	 iNNksTwr3S0+sPRW0NMNia4cxPwTVJACTZ5FDQn0IlEkV1dSUoiXjxRT6huKYILBGSNh1
	 K7VDzAwqcze8u+xoc5e9piWYDVmaA4kk+dEfj9J0K6q4c7shBJw+ECn8EdOX4G5ZQ30S9
	 WjuMHX/RqgrMfZ/StNyVrAZ3mHRVJYbe8X162dE2/JtGNYdwtgqdmSrSsEvwwj2Ik2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dZ2YM9mC9GiECdlo2KmBZ/APgMaDphBzgaN5IgFNUxc=;
	b=hWOSK/Z8NmOd/ZtnNWd1em1kTjjcpFxV0b3Y+1r1AqJTS8cIzf/BlpuNDQ09QteiXYQu
	 D9UlhTXipp0/LGnKwju7fgUcZmtvqbjyhB4lUQvEkcJgqf4HMw09kAaJexRzeEngL7iTb
	 uQTnDzDZf5Vq1a6k8fC9ln5PGtRwcNQivCQspWVsZBXbgbMJPVkjA7Sa1DvPyHQ991Bef
	 d1ro3s928uMZdW3i6M/5kr/WAa+ewgNzCrWkt7bnrk2jU+krxFnOdTcfdR+9H/j+1iSK6
	 VTMX1q1/6lQ69Ai9hqj9gXf2IjocT699bYUowEXqbZQ0trfCt4bfBv4/d0eYQC4vgYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bupzICDR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1828606A688;
	Wed, 25 Nov 2026 15:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bupzICDR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776DA1F000C6;
	Wed, 25 Nov 2026 15:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621045;
	bh=dZ2YM9mC9GiECdlo2KmBZ/APgMaDphBzgaN5IgFNUxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bupzICDRuPfEBJTtmAp3nLerz5nKq8qKLQTv6ubFjozbj9t0LtL0YwrZCBocsVnfI
	 kq7Bu1HCyXbMBVs/hqQN99KDz2M0A31qzo8mSAt8AD6My9FgR4VDWA7AL5FgXr6sje
	 EOFuropDZFZhU3Q51US0vxWfPPnt/cZJgogcQ40Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haobin Wu <853555@gmail.com>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 066/990] 9p: skip intermediate directory entry name copy in p9dirent_read()
Date: Wed, 25 Nov 2026 15:23:53 +0100
Message-ID: <20261125143823.635000690@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index 323f85352f6a4..733ec42258bc6 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -196,8 +196,12 @@ static int v9fs_dir_readdir_dotl(struct file *file, struct dir_context *ctx)
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
index 838a94218b593..9f3079c6f3867 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -268,7 +268,7 @@ struct p9_dirent {
 	struct p9_qid qid;
 	u64 d_off;
 	unsigned char d_type;
-	char d_name[256];
+	char *d_name;
 };
 
 struct iov_iter;
diff --git a/net/9p/protocol.c b/net/9p/protocol.c
index 0e6603b1ec906..0a97b4de243ab 100644
--- a/net/9p/protocol.c
+++ b/net/9p/protocol.c
@@ -771,7 +771,7 @@ int p9dirent_read(struct p9_client *clnt, char *buf, int len,
 {
 	struct p9_fcall fake_pdu;
 	int ret;
-	char *nameptr;
+	char *nameptr = NULL;
 
 	fake_pdu.size = len;
 	fake_pdu.capacity = len;
@@ -786,15 +786,7 @@ int p9dirent_read(struct p9_client *clnt, char *buf, int len,
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



