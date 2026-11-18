Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034866;
	b=BlYfbgEmM9lvi7OxXELjWoTfMxryZd+kVUjm3jxrAiu21nB0cJ13OQpBCfKrLyHxGR3W
	 pz/qom51zfqUP8Jkk8DJj1IPAowRD5/n8v4pq0QTueAkv7hTvl362AxIGWms18Mc3WGa/
	 xqQA8CNVzgySBwl68pnohNSRu1lw1UDbWUYXhMac/qhbRfcn/jT9rFb8pZ4ffRKAbQga1
	 a9PxG75TmEvzAYtUSjz57okPYhjBbPNYy5fh/PE1+mFrlDOlns+QT6Pgm7qQi47QYVR+z
	 i/NHfcV87gtyJVhwefr8Ir7Ck9UzZQ2U1q8tigIuN7tIVkkqsiuBi97mH8zypcBL0Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034866;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2q3apNelWkZACp0xHRxaKx/9/1xhORWEFKofExUH9w4=;
	b=dE72/56RvhJtHTcticQOkbbhFhm7Mn3FEBR0aezEaYXbV2esWMKh/95czIjoKjIgwMkk
	 R9COEdrqYqu0T2uUTmGFOGzdyPwNXNl2uYewJwWy0QuYbiwRnUstjM3QfVCAk+AowKn1+
	 O0PGCdZpvQ71qX6luqyT/qXccx4UegdtY7TVXqOa5uQ1RTW0ineSLFRAlbmsIc/Hlf+jo
	 KhkeTYTvKtcrKp1itaRzMS0yabx8s7/cqOAJqrIs6X1JqCYjoIQib4Mk+Yk5oX9LFgUSa
	 AquT9/DDHU22JLbyEomM492IcVxDCkyX01XKA9ldQBvna7uwvzGfaZRcnJY/5/DQZxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gdphgzr8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D741606A32A;
	Wed, 18 Nov 2026 20:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gdphgzr8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97971F000C4;
	Wed, 18 Nov 2026 20:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034866;
	bh=2q3apNelWkZACp0xHRxaKx/9/1xhORWEFKofExUH9w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gdphgzr8dUIvgYBZHahoPHaVB6GkhExNiY0md/ivW8EzxrsOeXsAvXtvJcyuxidIr
	 szRv0+0H3Du5KiqEEr/leogCLzkyVwBCJnwM6CBHctioaZOtLSB5t3H8b/oMJWq+9H
	 lg5nF76dpPmATtDt2dkyazT5cm+hC5Jvc/kodrtI=
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
Subject: [PATCH 6.6 0521/3318] smb: client: discard post-EOF pagecache when extending a file via clone range
Date: Wed, 18 Nov 2026 15:19:03 +0100
Message-ID: <20261118150332.804368330@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 4721587f96cb8de8164f3fd203093a0875560999 ]

cifs_remap_file_range() discarded the pagecache only for the folios
overlapping the destination region, so when a clone extends the file the
folio straddling the old EOF - which may hold data dirtied past EOF
through an mmap - was never dropped and became visible as file content
once the file was extended.

Start the discard at the smaller of fstart and the old EOF.  i_size is
still old here, so nothing past the old EOF is flushed to the server.

Fixes: c54fc3a4f375 ("cifs: Fix flushing, invalidation and file size with FICLONE")
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
[ sashal: Used min_t(unsigned long long, fstart, i_size_read(target_inode)) in place of upstream's local i_size variable and i_lock/zero-point block, which this tree lacks. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsfs.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index a3dfeda8144d9..bb02e6ecd3c94 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1372,9 +1372,15 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	if (rc)
 		goto unlock;
 
-	/* Discard all the folios that overlap the destination region. */
+	/*
+	 * Discard all the folios that overlap the destination region.  Start at
+	 * the old EOF when extending so the folio straddling it, which may hold
+	 * data written past EOF through an mmap, is dropped too.
+	 */
 	cifs_dbg(FYI, "about to discard pages %llx-%llx\n", fstart, fend);
-	truncate_inode_pages_range(&target_inode->i_data, fstart, fend);
+	truncate_inode_pages_range(&target_inode->i_data,
+				   min_t(unsigned long long, fstart,
+					 i_size_read(target_inode)), fend);
 
 	fscache_invalidate(cifs_inode_cookie(target_inode), NULL,
 			   i_size_read(target_inode), 0);
-- 
2.53.0



