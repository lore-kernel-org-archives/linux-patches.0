Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A73345EA7;
	Sat, 12 Sep 2026 17:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232787; cv=none; b=iHXhcR0ZTNMVx+hIR8CG1gTjs56BZ1j2Jd5t2g3bQa2q7bOmoZjTralMxv60H09Sa8V2JaeIVQMWpB0lPzhtrW9Ne9P+ebna29r6vLuA0TrBDhWs4cCCg27qsiMxDZRcgDPWsKBzwUUPyF/y8RkPjSGMyXjgHIRvaBvAoEthCJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232787; c=relaxed/simple;
	bh=QUl95VaREmkBx6d0DURYLCz0Glh6DvirUGZiok/Azts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3dHJ0kmvHevg19QH1jm/1oCF6iVmEA8tqqjOSPc2NYgEF+zQxXFBOiSXLFC3VazS+UDGGt+4ACAdU7Zd0zw5TufJXNgL+ZSVZd8TelzN3RG/wedUMoK87oXufbfrVQ8NHVUB7bHdQmHCDe2K+rNGikufsWJQCPlBlwN64UcvDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VmYCtobu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VmYCtobu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1381F000FF;
	Sat, 12 Sep 2026 17:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232785;
	bh=GLC3JY1WfRq6B0sjNxEtih4LCsYrxUOfzH4IiT3MDXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VmYCtobuqSO13t1qdcYBGHmzVxhek0HrNqP9RgRAdMX/fDTUoRbXTmfOh67PvqkT8
	 j/Hxq1+zHtjESgX/4NTZ0UN2c3WEcDMbBw/dOT4uBrsFfJIi2TzK9dm3IIy1sompiJ
	 iuXGVWY3vjqUtlM7QzAuvCqcoGJjC+kNRR3wWd38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 038/935] nfsd: sample writeback error cursor before async COPY loop
Date: Sat, 12 Sep 2026 08:51:08 +0200
Message-ID: <20260912065527.713800664@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


