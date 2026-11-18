Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045962;
	b=YPXNAcE3jdnK4j1fDolTe0WKstLqwx3y9MO5f/djJDJGiY3XFQKfRfUTwxTPYWv/ICZt
	 ZcAMnPdAL8SsCXYsg4i/h+vntqPFHvtljISRLFpLR5Bs6QD4F5idmwCSSyd7kzn9M7uwa
	 weQUMsnLe7qNgbO72dH6ZIhVPBGfrGvA/NWE7kTCYpLRe2tfY5c71W7F8LHxV/1ZGRF7y
	 gmIYy1o1Kz+NTh8hYU6LK7ihhtAq/Boh18U6BbkCIU09rBxF7ep4AzVqcnw5ORBsZv0gm
	 fzh2ICk0vRGGfENn8klKQCgk5a/Rg1NJ15BoODpM9DaP1bnAMFkIncDlmOZS1AdGAdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bGNpA8BfbWd8kQ5aElOubj00iM2a4tBv/MaefyiGJXs=;
	b=TPmYuPztDjUjgdsR4A4BdR1dMldlTZM12fg+RgZSr+DRg+z00izYVsZ/95/XSN2pWXX0
	 F7IsxIU/2/3e9WVU3nCatTJGMGH7D7JriVE4+OSG20j5TUzE0PuexbguhYCZKtWtBeIzi
	 SIh0P9+f/flT/TajZhAD3gQGtW6aZ0RhYxNMv00L5q/7IL9iOyMjRg8k8qkkayM6t6kNR
	 ylalpYXGPOj1S8A6A062tYZ6Wzv1iGJS3+YjaYG+f1t5SzS99tWfO7PVPeyT7NoSeU25M
	 1ftCcMdgzy4/yNLrefxu23sAwvcCmX9gJVTm7uUW+mOGahyjC2xxtmkobYIxwgNJjsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j2WY4j6W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FA6606A31C;
	Wed, 18 Nov 2026 23:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j2WY4j6W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7091F000C4;
	Wed, 18 Nov 2026 23:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045962;
	bh=bGNpA8BfbWd8kQ5aElOubj00iM2a4tBv/MaefyiGJXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j2WY4j6WGNSF9+YC7gpoQY7ArGyOBJwuHm9k+PpW7IS6X+ePeUFAHtJtiAxn8Pi3O
	 xb8SbMJgplvlxtr9DzVr3VSckJNoVojDAYgkhOZsaKgvnyeNdJFwDK0Vsoq4ZcqiBR
	 adGmjTeh58muY73bKLWTh8cPB35/pScv77ysulMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1110/2857] backing-file: always end a queued write
Date: Wed, 18 Nov 2026 15:35:44 +0100
Message-ID: <20261118150241.598437784@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 fs/overlayfs/file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 3eec30bb6406e..e440f9452594e 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -19,6 +19,7 @@ struct ovl_aio_req {
 	struct kiocb iocb;
 	refcount_t ref;
 	struct kiocb *orig_iocb;
+	bool is_write;
 };
 
 static struct kmem_cache *ovl_aio_request_cachep;
@@ -269,7 +270,7 @@ static void ovl_aio_cleanup_handler(struct ovl_aio_req *aio_req)
 	struct kiocb *iocb = &aio_req->iocb;
 	struct kiocb *orig_iocb = aio_req->orig_iocb;
 
-	if (iocb->ki_flags & IOCB_WRITE) {
+	if (aio_req->is_write) {
 		struct inode *inode = file_inode(orig_iocb->ki_filp);
 
 		/* Actually acquired in ovl_write_iter() */
@@ -396,6 +397,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 				     SB_FREEZE_WRITE);
 		real.flags = 0;
 		aio_req->orig_iocb = iocb;
+		aio_req->is_write = true;
 		kiocb_clone(&aio_req->iocb, iocb, get_file(real.file));
 		aio_req->iocb.ki_flags = ifl;
 		aio_req->iocb.ki_complete = ovl_aio_rw_complete;
-- 
2.53.0



