Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792775046;
	b=R0y0oVZV6HTcr9y4Owi9SdszHIqxQvRzyYixDlVPYDXAO9hWmdRjR7KXas7wKneQmHTU
	 DkLT9UQWfmPC/Rwyzmu9s3qCvFSJqo0ru1MgePTsSfSdRI51ZO4H/ab5BLuh8zQ21JRaS
	 1hZIPWRuA6srvHwO+4GOf9ViPbDUu6ZBLhravGgjvzXpuuRomjGp1Pft2hV+30wYpq5V/
	 qKji0SjMrVK5DCcfNeY1fIYxEMzaSCKRceFWdeSRYNDlOAEMZOo27V2sKtkt62yYm9Ptw
	 hFTNi10sbXsKJhMg62eAjwiNvUo7R6Ykwe5CYyIyU+PdKQLEVRJp0NFjY3XB1KYKHrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792775046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V9ZJNsoTniIP1KFZN3fHNGYAr1guddKxWKcQjmLsc4Q=;
	b=W90eXEe2M02cdBmfNPFUWR7QFfItPfZ48Ixv1vBQi15GXzSkJqcetmb1nVEgqyBUPK36
	 HwuDcJm3BfP2hhp+ueWGUhgGzbnruyl1BL0Cb0CahfkqfjRl+27jaCP51E5KfR3TVFwpZ
	 FF2sW+iHsVCXMUbroBH5BjarwO2Lp+7ZhB/ISGHMNy9X3P9IHRJ3yN/bAjc4piI7LwOwA
	 JbwOWUNPTXQROS1Eu5Zch3MUudT1dJsTjibAEnf9eKb6n5hF1xSyUzUHf8t0LySOdtDK8
	 1zRQzddjyBMjNwOUl0auMqKXJBhpJtchdlNY1Ni8Mc/HUCKSdnxlFNiTo7RjhzPkhYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PnKzoRUQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806AA606A31D;
	Fri, 23 Oct 2026 17:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PnKzoRUQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37C11F01828;
	Fri, 23 Oct 2026 17:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792775046;
	bh=V9ZJNsoTniIP1KFZN3fHNGYAr1guddKxWKcQjmLsc4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PnKzoRUQRSBvsSusHV7mBujDUx2/6GmXqZZ16YqfvHrNOoqfwOLgzwfhBlXRyYXgz
	 nZmlJI+4PIE89a6Pps7XtBMQgbFYyGAxPtBOz0JyEK3kxbALS4ioihrwrTsiG0lz5V
	 P9k5ZYTiBplTdZIz22XJv90SI+BQYzfSMANFmbZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 7.2 242/242] smb: client: drain outstanding I/O before truncating on O_TRUNC open
Date: Fri, 23 Oct 2026 18:41:24 +0200
Message-ID: <20261023163719.587596007@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit 3581f843defa0bb30fd7da1e7dba170465e13a95 upstream.

cifs_do_truncate() flushes the pagecache with filemap_write_and_wait()
before resetting the file size to zero, but that does not wait for
direct/async I/O that was already in flight, which can complete after the
truncate and reinstate stale data past the new EOF.

Drain outstanding netfs I/O with netfs_wait_for_outstanding_io()
before resizing the file.

Reported-by: Frank Sorenson <sorenson@redhat.com>
Fixes: a8603b52b39f ("smb: client: fix data corruption with concurrent writes and O_TRUNC")
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
 fs/smb/client/file.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1012,6 +1012,8 @@ static int cifs_do_truncate(const unsign
 	}
 	mapping_set_error(inode->i_mapping, rc);
 
+	netfs_wait_for_outstanding_io(inode);
+
 	cfile = find_writable_file(cinode, FIND_FSUID_ONLY);
 	rc = cifs_file_flush(xid, inode, cfile);
 	if (!rc) {


