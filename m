Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591464;
	b=kLC9Oe4YPKZPya9uuzFYuNIsQYDcVCSub+04k9x5WsK0+9ffvfX0YN05GguDyDoEjCT5
	 4efaZbL0WtMOCBLa1SmXVzLejRu9eLBttHP5+r24/5L/KiLt3F5pu17i8v3iEkTqezpcD
	 eOfawB1pt5Kwv9JO987j2m38R0F+cPqWjsdpoa/zjbV+T4ihj1tQ9nFmhf553WJFSW+ll
	 DoQFZsc+SeXcE66o8U+aRLto2bazGoiGhtYJMxEbzaGmW5Hi2QQfmtv2pyhp3IHN0yvxv
	 ZINwSAdOzAN8bLRmgqCwroFZocqiWbR0S/03xwbL5uVhsPXn8PjWYa+Yx5RDYu4UhXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U3Xhniee56dqMSVBEAd420wGEA87TgkdN1nDsvbHYWA=;
	b=zW17lrtVmCyBiYhTzdS4rolLRUc6Hme2HTz7IOmqXAoGkH8D84Tcxd8FSnKm36xghix7
	 in7pwxOYyB7vxOpADi6DWmUcHph2AIutNkyyNLLV6036mqutW4R853yw+9Lb9td1e0E8N
	 Ny3vPAHvvyOiLFkSr2mG86lx5tMRRev6141UeU1xeBo2qozagA70ruKDbZ2QztrYR5TYh
	 BCZHgcoZNKkxyuGPew2W45LGfrkp65te++Xo4GoFs/UX9k0mFespfSp9otVs0gzXTykyE
	 6y7nQfI3Hmro2hLHR5g5yaIUgp+KRTEH8QQYGppe7pXZtyxHhlapBO9zLFE882eoLGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HotNc4yO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9F4606E20B;
	Fri, 13 Nov 2026 17:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HotNc4yO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BDA51F000C4;
	Fri, 13 Nov 2026 17:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591464;
	bh=U3Xhniee56dqMSVBEAd420wGEA87TgkdN1nDsvbHYWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HotNc4yOMwfQwGUroN/6Z0gnrVvhuX7BpdCQDDsQOPMt3Mqd/U5sjV/5MeQwBLdcL
	 E0Dsdi/fguP77lIM7OjjA3IWqBZlERoQ0mKlLGB3vX6kOHyRdmFLDYy3vQ8gFOx+Kt
	 KHriD0Jvue28wNSCPs8zZd+5Pd4z2KrL5VbpNJOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuto Ohnuki <ytohnuki@amazon.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 549/670] virtiofs: add FUSE protocol validation
Date: Fri, 13 Nov 2026 10:51:53 -0500
Message-ID: <20261113153830.491221235@linuxfoundation.org>
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

From: Yuto Ohnuki <ytohnuki@amazon.com>

[ Upstream commit 68b69fa0edb241a946cd4c850110990f30705164 ]

Add virtio_fs_verify_response() to validate that the server properly
follows the FUSE protocol by checking:

- Response length is at least sizeof(struct fuse_out_header).
- oh.len matches the actual response length.
- oh.unique matches the request's unique identifier.

On validation failure, set error to -EIO and normalize oh.len to prevent
underflow in copy_args_from_argbuf().

Addresses the TODO comment in virtio_fs_request_complete().

Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: 5364d081125a ("virtiofs: validate fixed-output response length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/virtio_fs.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 06e59b820ffa8..0d076cbd94237 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -749,6 +749,27 @@ static void copy_args_from_argbuf(struct fuse_args *args, struct fuse_req *req)
 	req->argbuf = NULL;
 }
 
+/* Verify that the server properly follows the FUSE protocol */
+static bool virtio_fs_verify_response(struct fuse_req *req, unsigned int len)
+{
+	struct fuse_out_header *oh = &req->out.h;
+
+	if (len < sizeof(*oh)) {
+		pr_warn("virtio-fs: response too short (%u)\n", len);
+		return false;
+	}
+	if (oh->len != len) {
+		pr_warn("virtio-fs: oh.len mismatch (%u != %u)\n", oh->len, len);
+		return false;
+	}
+	if (oh->unique != req->in.h.unique) {
+		pr_warn("virtio-fs: oh.unique mismatch (%llu != %llu)\n",
+			oh->unique, req->in.h.unique);
+		return false;
+	}
+	return true;
+}
+
 /* Work function for request completion */
 static void virtio_fs_request_complete(struct fuse_req *req,
 				       struct virtio_fs_vq *fsvq)
@@ -759,10 +780,6 @@ static void virtio_fs_request_complete(struct fuse_req *req,
 	unsigned int len, i, thislen;
 	struct page *page;
 
-	/*
-	 * TODO verify that server properly follows FUSE protocol
-	 * (oh.uniq, oh.len)
-	 */
 	args = req->args;
 	copy_args_from_argbuf(args, req);
 
@@ -818,6 +835,10 @@ static void virtio_fs_requests_done_work(struct work_struct *work)
 		virtqueue_disable_cb(vq);
 
 		while ((req = virtqueue_get_buf(vq, &len)) != NULL) {
+			if (!virtio_fs_verify_response(req, len)) {
+				req->out.h.error = -EIO;
+				req->out.h.len = sizeof(struct fuse_out_header);
+			}
 			spin_lock(&fpq->lock);
 			list_move_tail(&req->list, &reqs);
 			spin_unlock(&fpq->lock);
-- 
2.53.0



