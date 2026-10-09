Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401B13D34A2;
	Fri,  9 Oct 2026 14:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557213; cv=none; b=MrsOuQdbx27USwVTD6qzikH81TXGjf0KdOtgzlASYCCnvbS6+0mHd84GK8QjO1sAvC1H/IyLAE/L4RWuiAvKOGa5F1hInjTe0RyK1Ol9Il/QVFbDhbNEQYrKzDIcO4rf4sPo7hoc8qr7G9AimeGX9v06b79k0jXHknj1pZTf55w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557213; c=relaxed/simple;
	bh=mIhYiku2nSQ2GxlEXX+1c5JvapDlhXmfYSwobYbeTGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUowdW6jVJ+HE47fvZoxyM57e06PT/KKcDbgercFTe8PsaQT4X1xHOXU+WWKdQ/XkhyNlB0keWWMFf7c9PBZ4NqtKevhr8+IM2+6O5ht8g114P2KkelPO7PzS/OFZLMcbIcSmkNYyv2MXcm/mDNjLWd4BoENXQoKBMRtg/4uQs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHOEMlnz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHOEMlnz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F851F000FF;
	Fri,  9 Oct 2026 14:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557212;
	bh=9PCyzkBfohW8eMB6HD3sKjgt8gR5+N/1QHHhGVN+GA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MHOEMlnzoosOC59BeMxQthRDWO+lrehG/76UzmD8zeHL7ncK2LzD+ECLGkK+Z5kgR
	 YSnTtQcr9DXMNxU9jduGU5++ZZ8zSoathMruyA1GQgVvy1zwMM1+kP5647Tsxh+2jH
	 acyu64pZr9qKdAr0sMxNl5UkiC9N9Ym1fxH1f73o=
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
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 365/403] smb: client: distinguish real EOF from a stale remote_i_size on read
Date: Fri,  9 Oct 2026 16:12:06 +0200
Message-ID: <20261009141000.829539009@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 75aa4b4d557114276bb72e19a9bce5cb27b5e4b8 ]

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
[ sashal: Changed i_size_read(inode) to i_size_read(&ictx->inode) because the local inode variable is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4706,14 +4706,20 @@ do_retry:
 				     rdata->got_bytes);
 
 	if (rdata->result == -ENODATA) {
-		__set_bit(NETFS_SREQ_HIT_EOF, &rdata->subreq.flags);
 		rdata->result = 0;
+		if (rdata->subreq.start + rdata->subreq.transferred >= i_size_read(&ictx->inode))
+			__set_bit(NETFS_SREQ_HIT_EOF, &rdata->subreq.flags);
+		else
+			__set_bit(NETFS_SREQ_CLEAR_TAIL, &rdata->subreq.flags);
 	} else {
 		size_t trans = rdata->subreq.transferred + rdata->got_bytes;
 		if (trans < rdata->subreq.len &&
 		    rdata->subreq.start + trans >= ictx->remote_i_size) {
-			__set_bit(NETFS_SREQ_HIT_EOF, &rdata->subreq.flags);
 			rdata->result = 0;
+			if (rdata->subreq.start + trans >= i_size_read(&ictx->inode))
+				__set_bit(NETFS_SREQ_HIT_EOF, &rdata->subreq.flags);
+			else
+				__set_bit(NETFS_SREQ_CLEAR_TAIL, &rdata->subreq.flags);
 		}
 		if (rdata->got_bytes)
 			__set_bit(NETFS_SREQ_MADE_PROGRESS, &rdata->subreq.flags);


