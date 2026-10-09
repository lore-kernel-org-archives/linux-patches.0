Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A45B4E73CD;
	Fri,  9 Oct 2026 14:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557444; cv=none; b=nmoHzsPfjuh8n8L4hdy+4hsjvmwCpBdpGp5C9OYfxwQ8g5NqRTH15TpTw/zKbxhmBpmC6Q+jM+DdKF+8exV+R9JM5N2P7VNgIRW8JpR2CvBz78SmH+34dgWcbfU3z+6mbPF6G/rQwV9X9uW0NyWagadb0mnimGO+zxyPkz38x1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557444; c=relaxed/simple;
	bh=1DnBrZoUk6rRJqUQXGgpjfYNKd2zvBToYiTg8MK3NmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3UrONdBu92aTgo1A/eVxTQAyMq1Ma9yCtvU4B5u24VhldPW+SClG6Yh0xAMWXqqszjpoOqnKWZrqUGo8NzWXxhO5IZILoia2VlTiZh9Q+6HM64xBr0+7m5nz7HtiuOClaBa4C2c+ZlFvuRr+3yL1NipLi+95jvtoAAmwVcrPGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUbNb0iU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUbNb0iU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0DC1F000FF;
	Fri,  9 Oct 2026 14:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557443;
	bh=j9QtGR8+ULu3L5JXKXRW3Typ2HdOOBl5xo8/abjo0KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hUbNb0iUqnPfY09ja2J5o4nI00Tn99krUFKPtHMVABzvUkSZ1cNFwMn5ApcZwT3Fm
	 qlnhOcjIqB1IqtLAZVn/nj/+Vx5Y4WJnZsSx8aD1eI3iIjNDDJAaNM2+fH+oxfWYqR
	 2AboX+4Nzrq7mopKvSZrpL6lzKQNAUunoN8XwalQ=
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
Subject: [PATCH 7.2 361/428] smb: client: discard post-EOF pagecache when extending a file via copy range
Date: Fri,  9 Oct 2026 16:11:38 +0200
Message-ID: <20261009140954.105592251@linuxfoundation.org>
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

commit 7b473ac7cd6f7e087876d3c67b1bc6df662fb429 upstream.

cifs_file_copychunk_range() invalidated the pagecache only for the
destination region, so when a copy extends the file the folio straddling
the old EOF - which may hold data dirtied past EOF through an mmap - was
never dropped and became visible as file content once the file was
extended.

Start the invalidation at the smaller of the destination offset and the
old EOF.  filemap_invalidate_inode() writes back before invalidating
while i_size is still old, so nothing past the old EOF is flushed to the
server.

Fixes: 8101d6e112e2 ("cifs: Fix copy offload to flush destination region")
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
 fs/smb/client/cifsfs.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1585,8 +1585,13 @@ ssize_t cifs_file_copychunk_range(unsign
 	/* Flush and invalidate all the folios in the destination region.  If
 	 * the copy was successful, then some of the flush is extra overhead,
 	 * but we need to allow for the copy failing in some way (eg. ENOSPC).
+	 *
+	 * Start at the old EOF when extending so the folio straddling it, which
+	 * may hold data written past EOF through an mmap, is dropped too.
 	 */
-	rc = filemap_invalidate_inode(target_inode, true, destoff, destoff + len - 1);
+	rc = filemap_invalidate_inode(target_inode, true,
+				      min(destoff, i_size_read(target_inode)),
+				      destoff + len - 1);
 	if (rc)
 		goto unlock;
 


