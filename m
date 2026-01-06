Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE34C3659ED;
	Tue,  6 Jan 2026 17:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722070; cv=none; b=ljUOIpvWibjzNkmbl6Da1qHwy1FMOQQ+4WnX7dynaMboT/xPXRRuyW9ZziKY0iwU8xeq+GFa2pe0bQKY5TJnD0M9F/iV+rlzpjZT0PKu+tTXq3/hO6Qi7QYA2o9+e3Qt85SYbKTbqoSo6i4wvaJUpChs46t+WgQpXevoA7EsIO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722070; c=relaxed/simple;
	bh=mrqSl0CPfohsx+aEW8RxNq2c/JXfdXfK13Ib6LCUwxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mss7Z3+2f71uKghJ8O3u9+hB9hCoD1Z+SIOWr0BcZfcLSQ+cjgM6KClTdA7aoreadCLuSA9pk4lwp8uYX8uWwvQsMxp6aTkZkJI8ltJW8rcnd7UmJM+56wqGAJcjhA44xGutRZhthPCQL7G4mbxtjOROlqeOE9KLydv2hpK6u0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hvbQ12aV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hvbQ12aV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6DAC116C6;
	Tue,  6 Jan 2026 17:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722070;
	bh=mrqSl0CPfohsx+aEW8RxNq2c/JXfdXfK13Ib6LCUwxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hvbQ12aVFyn3IvUFqrI9UyMj8fskn/ZhqnRoVnnbN7mbcPZiD2reBdFcdnYfeYw6N
	 oYcoBnv4cJZ7WPgnRGqw8OpoPbfjW/jdYri2gXsDsR/Wcb4mq8Gv0bOKaWPMluWCLk
	 0qBDY5aJfR+LkTDptu0WBy7n16XDkFb3Yj/urn9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 155/312] NFSD: Make FILE_SYNC WRITEs comply with spec
Date: Tue,  6 Jan 2026 18:03:49 +0100
Message-ID: <20260106170553.445714139@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit e3e8e176ca4876e6212582022ad80835dddc9de4 upstream.

Mike noted that when NFSD responds to an NFS_FILE_SYNC WRITE, it
does not also persist file time stamps. To wit, Section 18.32.3
of RFC 8881 mandates:

> The client specifies with the stable parameter the method of how
> the data is to be processed by the server. If stable is
> FILE_SYNC4, the server MUST commit the data written plus all file
> system metadata to stable storage before returning results. This
> corresponds to the NFSv2 protocol semantics. Any other behavior
> constitutes a protocol violation. If stable is DATA_SYNC4, then
> the server MUST commit all of the data to stable storage and
> enough of the metadata to retrieve the data before returning.

Commit 3f3503adb332 ("NFSD: Use vfs_iocb_iter_write()") replaced:

-		flags |= RWF_SYNC;

with:

+		kiocb.ki_flags |= IOCB_DSYNC;

which appears to be correct given:

	if (flags & RWF_SYNC)
		kiocb_flags |= IOCB_DSYNC;

in kiocb_set_rw_flags(). However the author of that commit did not
appreciate that the previous line in kiocb_set_rw_flags() results
in IOCB_SYNC also being set:

	kiocb_flags |= (__force int) (flags & RWF_SUPPORTED);

RWF_SUPPORTED contains RWF_SYNC, and RWF_SYNC is the same bit as
IOCB_SYNC. Reviewers at the time did not catch the omission.

Reported-by: Mike Snitzer <snitzer@kernel.org>
Closes: https://lore.kernel.org/linux-nfs/20251018005431.3403-1-cel@kernel.org/T/#t
Fixes: 3f3503adb332 ("NFSD: Use vfs_iocb_iter_write()")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neil@brown.name>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1228,8 +1228,18 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 		stable = NFS_UNSTABLE;
 	init_sync_kiocb(&kiocb, file);
 	kiocb.ki_pos = offset;
-	if (stable && !fhp->fh_use_wgather)
-		kiocb.ki_flags |= IOCB_DSYNC;
+	if (likely(!fhp->fh_use_wgather)) {
+		switch (stable) {
+		case NFS_FILE_SYNC:
+			/* persist data and timestamps */
+			kiocb.ki_flags |= IOCB_DSYNC | IOCB_SYNC;
+			break;
+		case NFS_DATA_SYNC:
+			/* persist data only */
+			kiocb.ki_flags |= IOCB_DSYNC;
+			break;
+		}
+	}
 
 	nvecs = xdr_buf_to_bvec(rqstp->rq_bvec, rqstp->rq_maxpages, payload);
 	iov_iter_bvec(&iter, ITER_SOURCE, rqstp->rq_bvec, nvecs, *cnt);


