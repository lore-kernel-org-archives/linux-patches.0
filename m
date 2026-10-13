Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFA44F68AB;
	Tue, 13 Oct 2026 12:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895413; cv=none; b=hTVSRSop9NFUTxbNgVd/yoq/mlbRYzZMfJbLLP7iPFFSxt8Tju4sQaj3qfvEoH+gidfJzzVX/zkqXwohLhakICrgIiAWi3hPxxvLRjgKgK5S87z2nUPBpbH4oJ2S9/6qWU+yU5bbYx0VASq++zWbS2LG0xGg+JSw2zAHkWY0tBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895413; c=relaxed/simple;
	bh=ttSVWoi7UTOqLnu1pzsIrg65guM6PluJDTfFzt/yokg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+LerlgwrtWcXeCIk68eAe6xc+yBY7u9YJ2NBk6/Y1jKpypGQ4DamjA+m6zzYGgq9fa1C93J49/GKrWSOeUgbq7YjsqnXwfV4Xe3LNEAhgAQRu7IzgUL0z/TZDPjL8Ll3aTGBzgaviQM+yIhgqgeIHwEbFDI4cahzQHb8um/Guw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxIqA7oW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxIqA7oW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437741F000FF;
	Tue, 13 Oct 2026 12:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895411;
	bh=1ffcQ72Y6MHHZJgskXsLnu9elKcOVf52cqktNlBVzwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DxIqA7oWNvpZRvT6f/GdEtXg1r1f35IYJHzrE08nAfHlsSf80V++5XQN+imzZQe9i
	 7Eoy9K3RXxiqTmuiZvagEq/6JebSbQoLkrS499my4uH5KaFjRUHubuupevPbYMxbV5
	 gGQGsy4aWN2lqCyHhQuQnNTbXzkyuWDSbo0GR81s=
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
Subject: [PATCH 6.12 229/497] smb: client: discard post-EOF pagecache when extending a file via copy range
Date: Tue, 13 Oct 2026 13:36:36 +0200
Message-ID: <20261013112913.331541641@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -1488,8 +1488,13 @@ ssize_t cifs_file_copychunk_range(unsign
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
 


