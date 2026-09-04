Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2586D415B8F;
	Fri,  4 Sep 2026 06:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502078; cv=none; b=UFDiq/AimK0XTR+vjAP44O1aye42wN0IaQjMcWmzrIsZ6CKI4NLoQygQ9tRCeE0BKgSQR7uuQfyJ2v5J+UUtZFyOI26357fGchWMrQKbsO4M1xIVtuEnUf1zVE3RhMIhFuRJgjiY/yF/ZQ27e8U0WMjdfx/28FP0trk5UglncGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502078; c=relaxed/simple;
	bh=k+nLS7HLIqiJU1DGzfD9O+lKfZNbg8UNCxroMReHikI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9cygXwlMvGqMnuYo5D7ZU/N0MFQp+g8Zx2KTTnwtHnjeMBzz3VBVBr0e9GeeHfD0mkwWJQSGcnFCrYNj9NNzmInpFaFeUveEe6+KDEJcIfpqGfiqWR6nVfpDukNJT4+FEuI7zLQo6uMfzgVLGdwNV485NxCGsatFGntGrV8MmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gkpf6Fuw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gkpf6Fuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3892D1F00A3D;
	Fri,  4 Sep 2026 06:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502076;
	bh=kdZypQLjtz6aj+YCuL9CknGoUTNrWGu1uaQkRxw4Uus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gkpf6Fuwf0j7YFT0WIm5GOt1P4HKOABLOVtTrbZS/2sjipGIWOuBntWIOnwQCi8vm
	 cfLecoIbXyF2YLb+ytPG9cEAm/0fP9UMRNG0Of4R+t+ttYcNuRqVo+CGbeX0rYPB30
	 Y3YlnbFdanCxllSk9V+FZu4/EfRfiZUog1bW5kSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 079/403] nfsd: sample writeback error cursor before async COPY loop
Date: Fri,  4 Sep 2026 06:58:02 +0200
Message-ID: <20260904045736.627650740@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 20a67a7d18221af736f124770c2c5e859b479046 upstream.

_nfsd_copy_file_range() samples dst->f_wb_err into "since"
after the copy loop, then uses it to detect writeback errors
via filemap_check_wb_err() once vfs_fsync_range() returns.
Because the nfsd_file cache reuses a single struct file
across requests targeting the same inode, a concurrent
COMMIT or stable WRITE on dst advances dst->f_wb_err to the
current mapping->wb_err via file_check_and_advance_wb_err()
during its own vfs_fsync_range(). If that advancement lands
between the writeback error appearing in mapping->wb_err
and the COPY worker sampling "since", the worker captures
the already-advanced cursor, errseq_check() sees cur ==
since and returns zero, and NFSD4_COPY_F_COMMITTED is set
even though writeback failed. CB_OFFLOAD then encodes
wr_stable_how = FILE_SYNC4, the client treats the copied
data as durable, and the failure becomes silent data loss.

Sample since once at the start of the function. The cursor
then reflects state in effect before this COPY issues any
writes, and filemap_check_wb_err() detects any error that
occurs during the copy regardless of which thread first
observes it. This matches the pattern used by
nfsd_vfs_write() and nfsd4_clone_file_range().

Closes: https://sashiko.dev/#/patchset/20260522194441.436065-1-cel@kernel.org?part=1
Fixes: 555dbf1a9aac ("nfsd: Replace use of rwsem with errseq_t")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260522214558.460859-1-cel@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1645,6 +1645,7 @@ static ssize_t _nfsd_copy_file_range(str
 	/* See RFC 7862 p.67: */
 	if (bytes_total == 0)
 		bytes_total = ULLONG_MAX;
+	since = READ_ONCE(dst->f_wb_err);
 	do {
 		/* Only async copies can be stopped here */
 		if (kthread_should_stop())
@@ -1660,7 +1661,6 @@ static ssize_t _nfsd_copy_file_range(str
 	} while (bytes_total > 0 && nfsd4_copy_is_async(copy));
 	/* for a non-zero asynchronous copy do a commit of data */
 	if (nfsd4_copy_is_async(copy) && copy->cp_res.wr_bytes_written > 0) {
-		since = READ_ONCE(dst->f_wb_err);
 		end = copy->cp_dst_pos + copy->cp_res.wr_bytes_written - 1;
 		status = vfs_fsync_range(dst, copy->cp_dst_pos, end, 0);
 		if (!status)


