Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C944E1C9B;
	Fri,  9 Oct 2026 14:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557454; cv=none; b=RMSc7ZmBa/DxusJraPMWUzer6LI0Yfq1Hl6WtFvWt9hQMK0TnDCIVTiWa5zdPhwzAzKMJs0HswtIR3wA1EuVq0ys6+5CtBcEAhyh8oVgG1XgI9nF6Z289T3bqlJNWs8XVn5AxOrVKAsDsboE545E662l1Pdhn2ddfTtjYqIRems=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557454; c=relaxed/simple;
	bh=5J3M278RPQ5zy7ew9SIF1KeiTWRt7KgqFPOW44RMbH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fs/usJHpd8vfbP/iVpDGjNJ/FJrwPjvNb3zy5krlPW4HFd9AXUS0tGrq4vUlz75w5dVRp4rD/62rIZPej2CZUt69JwBhGvlA4AHVSM9B7svDTEPaOwyX/7jnboy5ZRIirQ0zi+IVLfADY+in2srZJbK0Z/yiLkppUrBRz8kbQ+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rXwbDf7t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXwbDf7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBB11F000FF;
	Fri,  9 Oct 2026 14:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557453;
	bh=EkqzD9QwKCs7QGYTZtT9e4GcuVlWb82mBwYoul+QEVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rXwbDf7t1FwvvOD5Qo3lDHeytRGxvk4rfVduYOQQlXQqL4ePeYhFltCcCBou0rZem
	 ph4JrztQLFytzDhB2x4yBM4icEvKNTleAAwSUTOPIzOmCzEUtXZSGaZtK7pXtNpB+P
	 PNSuykuIYuwC+OXi0K/0Yz5ut4B7l4zSvG3ejpFo=
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
Subject: [PATCH 7.2 365/428] smb: client: flush dirty data before zeroing a range
Date: Fri,  9 Oct 2026 16:11:42 +0200
Message-ID: <20261009140954.195630893@linuxfoundation.org>
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

commit 8f8d32c1044f70e46e87550e039a15ff20a4b21c upstream.

smb3_zero_range() emulates FALLOC_FL_ZERO_RANGE by invalidating the
page cache over the target range with truncate_pagecache_range() and
then issuing FSCTL_SET_ZERO_DATA to the server.

Dirty data was only flushed conditionally, when the range reached or
extended EOF.  For a purely interior zero range that does not reach
EOF, no flush happened, so a dirty folio overlapping the range could
be written back to the server after the FSCTL and refill the range
that was just zeroed with stale data.

Fix this by unconditionally flushing and waiting for dirty data in the
range before invalidating the page cache and issuing
FSCTL_SET_ZERO_DATA, exactly as was done for smb3_punch_hole() in
commit d7d2adcd022b ("smb/client: flush dirty data before punching a
hole"); the two paths are structurally identical here.

This is observed as generic/363 randomly reading stale data where a
zeroed range is expected against Windows Server.

Fixes: 91d1dfae4649 ("cifs: Fix FALLOC_FL_ZERO_RANGE to preflush buffered part of target region")
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
 fs/smb/client/smb2ops.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3559,13 +3559,11 @@ static long smb3_zero_range(struct file
 	filemap_invalidate_lock(inode->i_mapping);
 
 	netfs_read_sizes(inode, &i_size, &remote_i_size, &zero_point);
-	if (offset + len >= remote_i_size && offset < i_size) {
-		unsigned long long top = umin(offset + len, i_size);
 
-		rc = filemap_write_and_wait_range(inode->i_mapping, offset, top - 1);
-		if (rc < 0)
-			goto zero_range_exit;
-	}
+	rc = filemap_write_and_wait_range(inode->i_mapping, offset,
+					  offset + len - 1);
+	if (rc < 0)
+		goto zero_range_exit;
 
 	/*
 	 * We zero the range through ioctl, so we need remove the page caches


