Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5882274FDF;
	Fri,  9 Oct 2026 14:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557450; cv=none; b=KvUuTVkGV5yukJ8lPlCVdgm6Yke9TVrJbOSiOHeGy1t3U0PuwbekliewgoOoAneSRgBU9rJ85ibT6wrPqF/iX5yjGGUd1FohPg4BH0Rq7msQahhOd9bidFTX4qyWzgEo3/GxbY8bo68/OXtWnE4DbJ/Qx4qKnS2lf7z7c1AafsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557450; c=relaxed/simple;
	bh=P3YM+dc9oFEbGKXFef/CVi9W4BRStu7JbvYh1qqMinI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7rMfJD3IGechqgJltj+ERhYghv9UDynPoQrEcng707iwzueZm51Vib0OvM9dRz84QC+8OCBuLy7K78lnVXl+3ygAfs5BD+cHKUf6wCmWRJx2pQAXg52Ctc4gez3Yxputf0boGqzN79CgG06hHzKJpkuuJKfFPkayunZV+AGjtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ttP0JepN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ttP0JepN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7C21F000FF;
	Fri,  9 Oct 2026 14:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557448;
	bh=OKQ5Au86iBRkznStvSz+21iO2vlSVGMRLNWL85BOW/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ttP0JepN3Rlg5LbYbVe33qqR4jViBRVvf808Zq9AG+ipHRbuf7GUQirExEgVTUEhW
	 Qmrso0rOjxno5YuCtRpUw8rnN5zmuAnzbTGxeWPoLjfOGo6Mq8EAACnyl3enafiOaC
	 O0jQzgVLsGRITPFIcZK9WkM3WrNTHIfCtBVmUWSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 7.2 363/428] smb: client: flush and commit data before querying allocated ranges
Date: Fri,  9 Oct 2026 16:11:40 +0200
Message-ID: <20261009140954.150661439@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit aa994489bd835547c191827acc460192e147032d upstream.

The mode 0 / FALLOC_FL_KEEP_SIZE fallocate emulation for small interior
ranges in smb3_simple_fallocate_range() issues
FSCTL_QUERY_ALLOCATED_RANGES and zero-fills any sub-range the server
reports as an unallocated hole, to force block allocation without
changing file contents.

This is unsafe against Windows servers.  Per the Win32 documentation,
FSCTL_QUERY_ALLOCATED_RANGES only reports ranges that *may* contain
nonzero data and is explicitly not coherent with recently written data:

  "a call to FSCTL_QUERY_ALLOCATED_RANGES [after writing to a network
   file] would not necessarily return a correct list of allocated
   regions.  To ensure coherency [...] flush the data to the file"

fsx (generic/363) reproduces the resulting corruption against Windows
Server 2022: a range is written, an uncached read returns the data, yet
the next FSCTL_QUERY_ALLOCATED_RANGES on that range reports it as a whole
hole, so the emulation overwrites live data with zeroes.  A network trace
confirmed the WRITE, the READ returning data and the query returning an
empty range list within microseconds.  Samba does not exhibit this; its
query is coherent with the written data.

Write back the dirty pages, drain any outstanding I/O and issue an SMB2
FLUSH to force the server to commit the data before querying the
allocated ranges, so the query reflects the data actually present.

With this, generic/363 passes against both Windows Server 2022 and Samba
over 100000 fsx operations.

Fixes: 966a3cb7c7db ("cifs: improve fallocate emulation")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3745,6 +3745,24 @@ static int smb3_simple_fallocate_range(u
 		goto out;
 	}
 
+	filemap_invalidate_lock(inode->i_mapping);
+
+	/*
+	 * Flush and commit the data to the server, otherwise
+	 * FSCTL_QUERY_ALLOCATED_RANGES might report recently written data as
+	 * unallocated holes on Windows Servers, and the loop below would
+	 * then zero-fill them and corrupt the file.
+	 */
+	rc = filemap_write_and_wait_range(inode->i_mapping, off,
+					  off + len - 1);
+	if (rc)
+		goto out_unlock;
+	netfs_wait_for_outstanding_io(inode);
+	rc = SMB2_flush(xid, tcon, cfile->fid.persistent_fid,
+			cfile->fid.volatile_fid);
+	if (rc)
+		goto out_unlock;
+
 	in_data.file_offset = cpu_to_le64(off);
 	in_data.length = cpu_to_le64(len);
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
@@ -3754,7 +3772,7 @@ static int smb3_simple_fallocate_range(u
 			1024 * sizeof(struct file_allocated_range_buffer),
 			(char **)&out_data, &out_data_len);
 	if (rc)
-		goto out;
+		goto out_unlock;
 
 	tmp_data = out_data;
 	while (len) {
@@ -3764,12 +3782,12 @@ static int smb3_simple_fallocate_range(u
 		if (out_data_len == 0) {
 			rc = smb3_simple_fallocate_write_range(xid, tcon,
 					       cfile, off, len, buf);
-			goto out;
+			goto out_unlock;
 		}
 
 		if (out_data_len < sizeof(struct file_allocated_range_buffer)) {
 			rc = -EINVAL;
-			goto out;
+			goto out_unlock;
 		}
 
 		range_start = le64_to_cpu(tmp_data->file_offset);
@@ -3777,7 +3795,7 @@ static int smb3_simple_fallocate_range(u
 		if (check_add_overflow(range_start, range_len, &range_end) ||
 		    range_end > S64_MAX) {
 			rc = -EINVAL;
-			goto out;
+			goto out_unlock;
 		}
 
 		if (off < range_start) {
@@ -3792,11 +3810,11 @@ static int smb3_simple_fallocate_range(u
 			rc = smb3_simple_fallocate_write_range(xid, tcon,
 					       cfile, off, l, buf);
 			if (rc)
-				goto out;
+				goto out_unlock;
 			off = off + l;
 			len = len - l;
 			if (len == 0)
-				goto out;
+				goto out_unlock;
 		}
 		/*
 		 * We are at a section of allocated data, just skip forward
@@ -3815,6 +3833,8 @@ static int smb3_simple_fallocate_range(u
 		out_data_len -= sizeof(struct file_allocated_range_buffer);
 	}
 
+ out_unlock:
+	filemap_invalidate_unlock(inode->i_mapping);
  out:
 	kfree(out_data);
 	kvfree(buf);


