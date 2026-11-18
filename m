Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054480;
	b=oiQ64+YYZL/UgWSXcVcFEX9syjECUME1/zrOu98Mt80HTKp+WjI/cKzlXRKLfF7vx9Kz
	 1M3cPGvKIk9utDFOJS7Lwlawr0RWRxuh3qrE5/Wvl7A/4jj9u81uM28A6W+GNk3aBfW1i
	 8mGqcrkuo1Qd3gIQLumpi19mEGzBflsQGt4I3cVQqQHXJiUnxI4VeAo2aDJPIgcJUSRaa
	 z1vVEfpb39brV2PcNF/oo28ZXLgkucvR2UbiJgvUdkTU+cUVblh4wAe4PLjzqJM5+GwVz
	 fJiEwPbQhPd9pmUP3ut2C7iBEVPx1rgraIVDLKW3ITvEQwVlNtyxyHS4QSCNfxmbUrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JkfpDgmlao2ZSjxD475JFRryBKzK4Klt8hEDYcGiwlQ=;
	b=P7Ko3HKL/Xp5WQLnd2hKQakKTa2gONSW7huEWzJNCn7D1P3HdnUiF19iVi1s085mQyDt
	 RmJEeJAdYVSCq4T+y6qeXLVyDVu4TrsREFetNsmARICvIXPWDaR6G72wTido7kVBMa8qw
	 3646OnfrznyYRVneAwojftLV+FSqrSjLhtxDMnR3oUKX/4wy7Lmv6TNv9qx2vxxnJlNdG
	 mtLpP2MiSoTgcCLU+t7C9tDXDOMdOBXxi2gkeYgG9yKdyiuQnzaNO4e2WXgFwUUQHLhvO
	 3MGQ6QdEdWmY14uSro6xqr+YhDAWinT9R/r2KDI85t5bn1Rr7MqY4bw7AOYUwtQCsDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w49oL1b7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB583606A320;
	Thu, 19 Nov 2026 02:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w49oL1b7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE981F000C4;
	Thu, 19 Nov 2026 02:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054480;
	bh=JkfpDgmlao2ZSjxD475JFRryBKzK4Klt8hEDYcGiwlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w49oL1b72YXhYH8kxwYgRpq9dhrx6uUa/zfPGwctJ3nPlR+hNjw3QVm36nxNURl6S
	 t+2Tivb1JUwB2+PgH1I+RfhS7zejOcXn8yoC2JhnvwPa+FWyYveaBaUQdECIZzTif0
	 6ji1H6A+ThbiPOMU1PMMpaOocBdXNEBmeqPfH8ZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1249/2214] backing-file: always end a queued write
Date: Wed, 18 Nov 2026 15:48:45 +0100
Message-ID: <20261118150101.653196923@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
[ sashal: Adapted backing-file write tracking to overlayfs's shared cleanup handler, preserving its existing freeze-protection release logic. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 49d3feded593f..3fb7bfd00b88c 100644
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



