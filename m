Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829046;
	b=a34hV2X53DJ8X5F7a5eOnlmYycSgrR9dgwipqja8VtM8vVSDV3iGok83LDYQPh4L4o8F
	 N9Qy7D2JvDWKL/kMIeSbBoXT2G+H/LHasXOzNT1ltlYILH9csow744YefMXzSnRPDu+3u
	 6k5ForbUYbPzRj1+yxSKF+3mJCE9jt05bAztGHe5zk/gVVqf1+2ETu+ZKDlOGLEN8iFVo
	 ozqC5zQJA2dAshVTrhDqxhOkG/6+QaqBUlYmHbmOI6X6O/yqWB8R7loIP/SNeQKsAOyYH
	 hdfOlYw+7HU1jsTDzuu+Ud6GPGuisQBRFsOs3Fo/Yo3k2fMY0xIUPKeluE3RlbUYqPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nq24nu6fJi9KIcrf2G9Cb6q47CQBSV9HN6F9Bc7T3mo=;
	b=N678K4LUsVSx6g8L/ljtMMyLXGZNstX1fmALZ8r7Yj+c1yRudfiG+FOJUz4MBAlzuqjg
	 ZVPvogef9IcW31BEyICQL35nIDAyHmC+kz8luv3GpCoxKUVSWinYmcYAypG8rGZ+Ilvtf
	 r90ALdJfDoZhff8LvJCWmm/9Q5JbwqlqX3qNXX+xLP4PCkQitR8UrozS6cXx6f5fJ1atz
	 9ocpdm2n7M98YoeH4kaQxXkiRb6WST4oR9RIwdadiCh8h01ocOOvzyXe7pBjirybTGzIt
	 avnGnrogekqRYY+ZzKaP/9m6zyoAiqvHqBy1i69lHCXEQcgI1C8zIpp9dbU0ayEUFMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hCuVPpEj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201C46080797;
	Wed,  4 Nov 2026 21:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hCuVPpEj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAC71F00A16;
	Wed,  4 Nov 2026 21:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829045;
	bh=Nq24nu6fJi9KIcrf2G9Cb6q47CQBSV9HN6F9Bc7T3mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hCuVPpEj/AB9sUo8Kc40rYuWXPP07T0lY6KAabI5VXufM5kuR784yHAvXIMXEXGe7
	 /ot2RynpMomya1bwFM2rMt5AYEYKSH1lKRq/UcBjFULcycoOZ9Bsooy7COF19UNOXo
	 AKahGSXyTFnhyDAzsw1alXGSRPB9fpzeAtQ/laNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 7.3 409/547] NFS/localio: report the stability a DIO WRITE actually has
Date: Wed,  4 Nov 2026 16:09:53 -0500
Message-ID: <20261104211049.939490186@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@kernel.org>

commit 077d39c1ac8c9b2e2fad8e66a2ba6250ced1a860 upstream.

Since commit d32ddfeb5593 ("nfs/localio: Ensure DIO WRITE's IO on
stable storage upon completion") a DIO WRITE issued through LOCALIO
is persisted before it completes: nfs_local_iters_init() sets
IOCB_DSYNC|IOCB_SYNC on it despite whatever the caller asked for, so
that the buffered head and tail and the O_DIRECT middle of a
misaligned write cannot complete out of order.  The reply still
reported the stability that was asked for, so an UNSTABLE write came
back UNSTABLE, the client kept its pages on the commit list, and the
COMMIT that followed ran an fsync for data that is already on stable
storage.

Report the stability the kiocb actually carries instead: FILE_SYNC
when IOCB_SYNC is set, DATA_SYNC when only IOCB_DSYNC is.  A write
told FILE_SYNC has no reason to COMMIT and sends none.  Buffered
writes, and any write that asked for at least what it got, are
unchanged.

Fixes: d32ddfeb5593 ("nfs/localio: Ensure DIO WRITE's IO on stable storage upon completion")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/localio.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -936,6 +936,7 @@ static void nfs_local_do_write(struct nf
 			       const struct rpc_call_ops *call_ops)
 {
 	struct nfs_pgio_header *hdr = iocb->hdr;
+	enum nfs3_stable_how committed = hdr->args.stable;
 
 	dprintk("%s: vfs_write count=%u pos=%llu %s\n",
 		__func__, hdr->args.count, hdr->args.offset,
@@ -954,9 +955,20 @@ static void nfs_local_do_write(struct nf
 		iocb->kiocb.ki_flags |= IOCB_DSYNC|IOCB_SYNC;
 	}
 
+	/*
+	 * Report the stability the write will actually have.  A DIO WRITE
+	 * is persisted before it completes whatever was asked for, see
+	 * nfs_local_iters_init(), and a caller told so has no reason to
+	 * COMMIT data that is already on stable storage.
+	 */
+	if (iocb->kiocb.ki_flags & IOCB_SYNC)
+		committed = NFS_FILE_SYNC;
+	else if (iocb->kiocb.ki_flags & IOCB_DSYNC)
+		committed = NFS_DATA_SYNC;
+
 	nfs_local_pgio_init(hdr, call_ops);
 
-	nfs_set_local_verifier(hdr->inode, hdr->res.verf, hdr->args.stable);
+	nfs_set_local_verifier(hdr->inode, hdr->res.verf, committed);
 
 	INIT_WORK(&iocb->work, nfs_local_call_write);
 	if (nfs_local_defer_io())


