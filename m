Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037124;
	b=2+m8iBOsf4bPaFB4LNgAkcv6rSU2UfDijO6XMbNCZ4fYBd79HMhl6fkgl6YhFoj8C5gf
	 zRLVB7NnSY/3FZo5G+dIObuAcYOuyy2oC2Jq/Ruc6Rt8ONDMtm6C0e6ctcKZ5yPTftUvh
	 emRfRd9EXy/9zwPHYRGTc/Jk1lvAZL1rGa7V7P0nDkN2ldyYQOZgYO6P55Blqbh7BJvNv
	 F0vAUvGDoT/0MDwlRXeBYBEpNPH2Pxcc83yRqaUNc4IUbSx1dyv5AtD2WnY7exSd3yzTF
	 imFhCNNLu8RHfzZie/A1LcqM+QdVjqCnanCjgruzkLCDsD8te3PW2KGLj8Pu2/IieSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cPYQJ44mPV0AcPj3C4zTXONAxNyZvXiDr2zAgfy4zz4=;
	b=1ycufsYdEXVKDNO6unGE+x/Yd6jdtmtDzjq7wj2xcmzsoQZn7UdpfRyff3yU2mcwyw2m
	 SDzO2mcnOVnIIrgyqj9uN3T3PcCm/zhuVXZ64BGEy0sC5dNG+Sosv/3NGfMF9SeYbcu2G
	 hPKGbvSmpFQw/vq+7CtMid4SOumzC7Wzeq0OZwKszGjwqjrMTqYCKbVcdqqetWE2xxojd
	 +x/gGbNhkfcEvFGgVWrYiQX+hJhDfi9Qg0RmybiKqWjbpYyIObfhb5EguwYd2D0srGaf7
	 ndIR1tlKbiH6aNcia13cjtJWIzCRrmQ5UJ/LEso3kx5vKalHUirloK5pK1cRHdH7URA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ykOy/InE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D090606BE76;
	Wed, 18 Nov 2026 21:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ykOy/InE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD301F000CB;
	Wed, 18 Nov 2026 21:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037124;
	bh=cPYQJ44mPV0AcPj3C4zTXONAxNyZvXiDr2zAgfy4zz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ykOy/InE8XEH6cPfS++vQ69h7zAOObLktxn162DzWF8U4DrXaUHge6oS5EpAfyH2L
	 +4ATA+2hlOYYT1WSs9SLEAM993uGsSlM3y4YdvH44+7/KCMqgpzg5vXjupgBPKnMOb
	 9M30myAXvZOsdLEuOVzEJgvSeNOGR4fTjli0arIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1303/3318] backing-file: always end a queued write
Date: Wed, 18 Nov 2026 15:32:05 +0100
Message-ID: <20261118150359.357162283@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

commit 627cdcbc2a2eceb0452078a0c14370f9f1f17a91 upstream.

Writes to a loop device with direct I/O on an overlay file make the
next freeze of the upper filesystem hang for ever.

Every kiocb_start_write() needs a kiocb_end_write(). For a write that
is queued, vfs_iocb_iter_write() leaves the end to the completion, and
backing_aio_rw_complete() only calls kiocb_end_write() when IOCB_WRITE
is set in the flags copied from the submitter. In-kernel submitters
such as loop do not set that flag, so each queued write keeps the
freeze protection of the backing filesystem.

Direct writes to a loop device with direct I/O backed by an overlay
file left fsfreeze of the ext4 upper filesystem, and a later touch
there, blocked in D state. It takes write access to the node of the
loop device, which root has by default, to attach the file and to write.

The fix used here is to mark a write in struct backing_aio and to call
kiocb_end_write() on completion of every marked write.

Reproduced under qemu without KVM, on v7.3-rc6-21-g602042bf29f6 with
earlier fixes of this series applied, with and without this change,
once each. The kernel was not changed for the run. With this change
fsfreeze finished in about a second. Not run: the nvmet and LIO file
backends, which do not set IOCB_WRITE either, FUSE passthrough, and an
xfs upper filesystem.

Fixes: 2406a307ac7d ("ovl: implement async IO routines")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[amir: use aio->is_write to explicitly mark a write aio]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://patch.msgid.link/20261029180319.2852090-1-amir73il@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[backport: no fs/backing-file.c, mark the write in struct ovl_aio_req and
 test it in ovl_aio_cleanup_handler()]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index a493eed7f6053..967dfc88a69ad 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -19,6 +19,7 @@ struct ovl_aio_req {
 	struct kiocb iocb;
 	refcount_t ref;
 	struct kiocb *orig_iocb;
+	bool is_write;
 };
 
 static struct kmem_cache *ovl_aio_request_cachep;
@@ -289,7 +290,8 @@ static void ovl_aio_cleanup_handler(struct ovl_aio_req *aio_req)
 	struct kiocb *iocb = &aio_req->iocb;
 	struct kiocb *orig_iocb = aio_req->orig_iocb;
 
-	if (iocb->ki_flags & IOCB_WRITE) {
+	/* Pairs with kiocb_start_write() in ovl_write_iter() */
+	if (aio_req->is_write) {
 		struct inode *inode = file_inode(orig_iocb->ki_filp);
 
 		kiocb_end_write(iocb);
@@ -413,6 +415,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 			goto out;
 
 		aio_req->orig_iocb = iocb;
+		aio_req->is_write = true;
 		kiocb_clone(&aio_req->iocb, iocb, get_file(real.file));
 		aio_req->iocb.ki_flags = ifl;
 		aio_req->iocb.ki_complete = ovl_aio_rw_complete;
-- 
2.53.0



