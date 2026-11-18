Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060030;
	b=soc+ilWXBZfod1k5gq0LTbmDp3hE4OXelr1GhfDJKmuegODgNsVeFt4HMxusl/t3JsLe
	 chqyhIu8NqhY9KJpcHtNmHyVdqUWZ861fx6UeKDnriWro03xyNtORYZ28nuyO0mpOSn8X
	 6eTDQjS/mNnQlwStzCvKiWKyuKaWHbom1ydWKOtabQn6QOGCzgoi1ThWXWIBJ8SCeNevq
	 YMC+ty48ajap1SP95+6p3ld6fvw5g0aTvvKHPmzZt27z1koj+MvHgJyK02FzBV+jZHhQK
	 Ut9U240hmslSS+XMuurEHlJ3PWcntayK9asVc6jxj7GjayGueVivqp8O6s0xpKYjvFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060030;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YkghfKhpzopZSrC2FyuNZaHdio5XH45JXZ9BTjZ3L5U=;
	b=b5+fAanFWc7ix9fb3NJjZotCs0qGdZAMMjWMcNq4JIKMTX4YLe1NZpOTE6/Hqz0thPEw
	 rgFVQkp/9bIihXAuqdiPjc4i5nnaJSbs5l55Kvxu6MHVR4BTnKp17XESwRuhdlmBLx52A
	 4BakWlmqOACtYpmlsFCGRumNrgglp35GHYR6FvhZsnHRNgVx9kFseAjWnyCD7q+v9vygg
	 HyyUoBbfMIbXMv224xrF/HeHjOzgV1YUJiDKReqwThC9bfMkY/8lqqbLKDOHtRCrpPJsH
	 vJTgzSV0ENBL9a3EvTkaj41qbtRvsJlC22YWJU4qwilBmiQaBhfesJdn8PXGVoRbKLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="DeDop7/Q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8812606A320;
	Thu, 19 Nov 2026 03:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DeDop7/Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87D71F000C4;
	Thu, 19 Nov 2026 03:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060030;
	bh=YkghfKhpzopZSrC2FyuNZaHdio5XH45JXZ9BTjZ3L5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DeDop7/Qlk7vIafxTD+abTghe3FgCpRxZy2JVBoFdBnAY2kvagqOPJlpPMG2+qs+s
	 jBYEMv6tSGZgUAtEt72TIGGwE5+IemnVGnppgWg4K/XxpIfht6ncQxN5LqD2Yni+1B
	 dxn2nW/BCfQI/yyMH3xFloEFK8kg9NDN2ZEcQsJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1052/1848] backing-file: always end a queued write
Date: Wed, 18 Nov 2026 15:51:30 +0100
Message-ID: <20261118150001.339212829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit 627cdcbc2a2eceb0452078a0c14370f9f1f17a91 ]

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
[ sashal: adapted backing_aio changes to ovl_aio_req and overlayfs-specific write and cleanup handlers ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 4440ff43cb66d..2e74de6f4a563 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -19,6 +19,7 @@ struct ovl_aio_req {
 	struct kiocb iocb;
 	refcount_t ref;
 	struct kiocb *orig_iocb;
+	bool is_write;
 };
 
 static struct kmem_cache *ovl_aio_request_cachep;
@@ -265,7 +266,7 @@ static void ovl_aio_cleanup_handler(struct ovl_aio_req *aio_req)
 	struct kiocb *iocb = &aio_req->iocb;
 	struct kiocb *orig_iocb = aio_req->orig_iocb;
 
-	if (iocb->ki_flags & IOCB_WRITE) {
+	if (aio_req->is_write) {
 		struct inode *inode = file_inode(orig_iocb->ki_filp);
 
 		/* Actually acquired in ovl_write_iter() */
@@ -394,6 +395,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 				     SB_FREEZE_WRITE);
 		real.flags = 0;
 		aio_req->orig_iocb = iocb;
+		aio_req->is_write = true;
 		kiocb_clone(&aio_req->iocb, iocb, get_file(real.file));
 		aio_req->iocb.ki_flags = ifl;
 		aio_req->iocb.ki_complete = ovl_aio_rw_complete;
-- 
2.53.0



