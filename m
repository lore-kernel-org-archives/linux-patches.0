Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E841B4E780C;
	Fri,  9 Oct 2026 14:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557458; cv=none; b=gKbRoa/e1fxQfsT4AJwNywbiVb6OSe1W6DJqXol81HicMWVmmmSF5IR4mgXnMC9uGEN+SmSmMYzV+2h9pLsDj/8DmAy725Xzc5FyS49L5PozsrJFa3ynZZ+KeRlyb27dwLlQmMTPFTkFr0faqjzWFswDsn0Fk+TjWsZmee3+lmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557458; c=relaxed/simple;
	bh=PqZiewxeCTjXRZdVOd7z3UnkkCFFHhnXRwsUMQAPtDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnngIa+yujIlUYcm0fkDb1yBs7PEcguTSwWQAG390bym7SkSbL6lFsnSa/1kZAdy4YtK3NzV4ItbSY4YzcLmVuCGJmyJZRVH5UdC2Wt8HiDxQn7W0T7u2DVN/ZCbvaLxkqi9Pq9ma6ToadXasqymSDgeBko68hSntFZGw+LPp/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsUksOAZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsUksOAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC6C1F000FF;
	Fri,  9 Oct 2026 14:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557456;
	bh=qTGD202iIoZMedsDn7Jf3lKx0eWMUROxiPA7XObLynw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nsUksOAZP5YyqQiQ26wj4EXDioE5ECkZNGn5c1Iu2d5G6lqOTGrZMMu+8Lunfql5s
	 4gin1bW6rXZW3W+pEPjTxHPZN8hVvy9BaC7TA6kwiYfZSrfHstaf4Y00hTuR5jULsW
	 dKPs9VL6ASLQGP6oyOODkxmXJJPctzRtBVfncBF4=
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
Subject: [PATCH 7.2 366/428] smb: client: distinguish real EOF from a stale remote_i_size on read
Date: Fri,  9 Oct 2026 16:11:43 +0200
Message-ID: <20261009140954.218697997@linuxfoundation.org>
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

commit 75aa4b4d557114276bb72e19a9bce5cb27b5e4b8 upstream.

smb2_readv_callback() sets NETFS_SREQ_HIT_EOF whenever a short read
lines up with netfs_read_remote_i_size(inode), the server's EOF as the
client currently believes it. That belief can be stale: after a lease
downgrade and handle reopen, the tracked remote_i_size can sit below
the client's own i_size while an extending write hasn't reached the
server yet. A read in that gap comes back short for a reason that has
nothing to do with the file's real size, but was still marked HIT_EOF,
and netfs reports a short read for it as-is.

Only treat it as real EOF when the position is also at or past the
client's own i_size; otherwise mark it NETFS_SREQ_CLEAR_TAIL instead,
which tells netfs the shortfall is safe to zero-fill rather than
report as a short read.

This is what fsx (generic/363) sees as "short read: 0x0 bytes instead
of 0x<n>" against a Windows server.

Fixes: 1da29f2c39b6 ("netfs, cifs: Fix handling of short DIO read")
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
 fs/smb/client/smb2pdu.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4796,14 +4796,20 @@ do_retry:
 				     rdata->got_bytes);
 
 	if (rdata->result == -ENODATA) {
-		__set_bit(NETFS_SREQ_HIT_EOF, &rdata->subreq.flags);
 		rdata->result = 0;
+		if (rdata->subreq.start + rdata->subreq.transferred >= i_size_read(inode))
+			__set_bit(NETFS_SREQ_HIT_EOF, &rdata->subreq.flags);
+		else
+			__set_bit(NETFS_SREQ_CLEAR_TAIL, &rdata->subreq.flags);
 	} else {
 		size_t trans = rdata->subreq.transferred + rdata->got_bytes;
 		if (trans < rdata->subreq.len &&
 		    rdata->subreq.start + trans >= netfs_read_remote_i_size(inode)) {
-			__set_bit(NETFS_SREQ_HIT_EOF, &rdata->subreq.flags);
 			rdata->result = 0;
+			if (rdata->subreq.start + trans >= i_size_read(inode))
+				__set_bit(NETFS_SREQ_HIT_EOF, &rdata->subreq.flags);
+			else
+				__set_bit(NETFS_SREQ_CLEAR_TAIL, &rdata->subreq.flags);
 		}
 		if (rdata->got_bytes)
 			__set_bit(NETFS_SREQ_MADE_PROGRESS, &rdata->subreq.flags);


