Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF0C3438BE;
	Sat, 12 Sep 2026 19:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240941; cv=none; b=Nk/V/W+UUb/8MG0w9MzkParuc0MhCqY8KcItDnFL5LULiJINxWXi0qlhsbnCrAwqycrMyB5hEBbJXTEAq5W0NAwknrMe6jEoEy+hyL8li7tbqypgWXT7KAD1dlMRhW5lh+/AK2pG9i3G6+vkQ4cTAbO7Ry5p4QZcalwGjDfCw9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240941; c=relaxed/simple;
	bh=T7/g/ezl77RA3+Aqz93Z5xBn+lZ4pg4vGzA6/eg8ZTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Su0dtqFbZXsqpEizHQseHMsIKjFJ3qNbrZHJwuKu9Si8ucn2U/s5yY76moYkbpNBi8JvxM0/WWs14Be6iG7ydfwW+MoF/NamepDAEsO4cDHbNZNExCjfbdQd/pusq8kN/1JlmM8jmWexjjVLYLIh5F2M6r92lFjegMOUd5iawi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FNoOZguK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FNoOZguK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70B01F000FF;
	Sat, 12 Sep 2026 19:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240939;
	bh=/1ogddFE0gUqrfiv4pfjbg4CzdUbF4MCzJOSAaQYZaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FNoOZguKO1PwC67xT242vpzvq2cHpzGOFl+F9AhNc0VweAeRKLTTjZ+xL9Brk4v1F
	 ulBVbqw9mt8mxIm0c49lJFb01OO2NAmq2IqhX9LfcaIofR9T/7UssrnWbkUKkOEjl7
	 mSpC7FUegYUx53R2Lzd1EDWkM3AL6Er5EpL4y66o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 034/798] nfsd: sample writeback error cursor before async COPY loop
Date: Sat, 12 Sep 2026 08:54:22 +0200
Message-ID: <20260912065517.743868071@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1607,6 +1607,7 @@ static ssize_t _nfsd_copy_file_range(str
 	/* See RFC 7862 p.67: */
 	if (bytes_total == 0)
 		bytes_total = ULLONG_MAX;
+	since = READ_ONCE(dst->f_wb_err);
 	do {
 		if (kthread_should_stop())
 			break;
@@ -1621,7 +1622,6 @@ static ssize_t _nfsd_copy_file_range(str
 	} while (bytes_total > 0 && nfsd4_copy_is_async(copy));
 	/* for a non-zero asynchronous copy do a commit of data */
 	if (nfsd4_copy_is_async(copy) && copy->cp_res.wr_bytes_written > 0) {
-		since = READ_ONCE(dst->f_wb_err);
 		end = copy->cp_dst_pos + copy->cp_res.wr_bytes_written - 1;
 		status = vfs_fsync_range(dst, copy->cp_dst_pos, end, 0);
 		if (!status)


