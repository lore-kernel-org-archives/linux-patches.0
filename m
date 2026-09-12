Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33E747DFBF;
	Sat, 12 Sep 2026 13:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219838; cv=none; b=qREBUKBF2VPBaeGGlpvkNyjsF1eumSkqkMolivAsByv9otKB6/RwRr4ShtYIKX7VL0R+cIxhRACZRYLXpL0VB2WJjWev/jWynDAqRGflwn9t3jj3zHmn/rN3CrC5PKq4IcSlJ2WwG4AAHftxxx+3Z9Zfv+Sa5zxGgzXcoSdGgrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219838; c=relaxed/simple;
	bh=bbKMgmc00xYrPw0Zu+biq4Vr2iu01cF0leisw9XFPWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZV8fiyCIdGHjMBTQGEVWiErabQg5hZ6cZhdjHdSz9Zh6AtXOppIKsIG2M3D1qmeJqfvsYnh8TmWNQat16ugYaWZeQSJZdnAIE9hLz1wEIlqjhP98+pxFQ19ExybT+IYIZ6PMZdVG6ZTI9ERBa70HX1PXTeRJIWmvOq60nOSsyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dcAuy/47; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dcAuy/47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4B91F000FF;
	Sat, 12 Sep 2026 13:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219837;
	bh=cg4CuJOkGcJNru2YjK9iL1hVemKhp1GAFwj2w8dSGwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dcAuy/47cSl1g7LnhtkTL+RJ1rx2mBvO5yq1KFqyLrC841sa02peprE6dSYR2tByz
	 qlR8KGoJ2O0e4w7UTgAKFAil/ayHmjTjO+wmxl3eUSBzY5izI/N1LaXrmwZR+nc42f
	 K2v6k6maGrP4LaEOlETOB8cyyWXxRH/IuqBL7Lv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 0054/1424] nfsd: sample writeback error cursor before async COPY loop
Date: Sat, 12 Sep 2026 08:41:26 +0200
Message-ID: <20260912065608.512229811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1639,6 +1639,7 @@ static ssize_t _nfsd_copy_file_range(str
 	/* See RFC 7862 p.67: */
 	if (bytes_total == 0)
 		bytes_total = ULLONG_MAX;
+	since = READ_ONCE(dst->f_wb_err);
 	do {
 		if (kthread_should_stop())
 			break;
@@ -1653,7 +1654,6 @@ static ssize_t _nfsd_copy_file_range(str
 	} while (bytes_total > 0 && nfsd4_copy_is_async(copy));
 	/* for a non-zero asynchronous copy do a commit of data */
 	if (nfsd4_copy_is_async(copy) && copy->cp_res.wr_bytes_written > 0) {
-		since = READ_ONCE(dst->f_wb_err);
 		end = copy->cp_dst_pos + copy->cp_res.wr_bytes_written - 1;
 		status = vfs_fsync_range(dst, copy->cp_dst_pos, end, 0);
 		if (!status)


