Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831272;
	b=VBdMVrKhAAoZu7Sq8Tg6CnmTp9w5qsooouA0NoqSn6UE0iciMcivUT5HXwSiI1Mhcr3Z
	 J0q1keC7Ut4bTMGluUv7yVCooIQdtkoEjHPT/SyVjKbuQVI1wKL0R1txFVlsCohjWkdzx
	 Lu+bRzIdOkE6dlBEpv2KOJIQ80c42h4DNSCi1HKaEvRQihDDjB279fBCTD88ritMRALBy
	 hkN8WS9EFSPhK7HvDiS5PKNF2ssNUkJLDbOoKi1ONefxtPp/zHGXNKysOYtQsb7wc58eY
	 w0ZfuLld5GeDCadDTRQLPSSy3wB9C0UeZ3N3R6jcvXYVAENxegZKJUYvsxOVGbN7CoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=smuhS9ifGqNY6LTAlW9hjhQ3Bzf45YTzwAb2PdHhqFQ=;
	b=mskOsEfo+TxqY8/eWpsHhRdDljwEhncy+snS19xnxFjgSUYxtS09OmNa25LFyhudnZlQ
	 eVFHnbtOCsXTR0aesoZpH++cM9Ij46nXkE8Uj0SxAhxy11CDEpEdqoO26JaDG0sL9B+jg
	 af8MJIo+PRfagHNIIZ4kd0/ojFZYklOS2+33TJQpO0vhmSOqzTI1Wtna9bhq6CiQUQOxW
	 aHH21oCqf4bT1eg/+z3wzYMKcYenM3iAP7UFC5pPp3Q7AXIKxDl+h5WNjjHqRv1E2Lf/F
	 QZo8D1YZsg2Ys3tHp7QVUJDo6MygOGas+kv96o3QWjXNCAFVPk8uGUpBg2t8/MmzzeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rdLzkvcF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C31606A328;
	Wed,  4 Nov 2026 22:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rdLzkvcF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71871F000C1;
	Wed,  4 Nov 2026 22:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831271;
	bh=smuhS9ifGqNY6LTAlW9hjhQ3Bzf45YTzwAb2PdHhqFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rdLzkvcFdtVZB+eCevz+7OnFyjx9Ic0ExDU01ZT2R5b41aTkzzxEuydk7fqIawJyF
	 TX2vXUwzvopysAcr/pMtLSuzJ8dunq/zbH7FD03Y0OqUF0bFk9uHQoMWYhfwNT/mjw
	 U85prPVDO67MhbZz1cNKQbrYu4iy2cgDxyMgS+TE=
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
Subject: [PATCH 6.18 0605/1005] smb: client: discard post-EOF pagecache when extending a file via clone range
Date: Wed,  4 Nov 2026 16:05:38 -0500
Message-ID: <20261104211100.797893131@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced the missing local i_size with (unsigned long long)i_size_read(target_inode) in the min() that bounds the pagecache discard, since the earlier refactor that adds i_size is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsfs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 0429e90dcfd6d..73a749d949f7e 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1429,9 +1429,16 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 		target_cifsi->netfs.zero_point = fend + 1;
 	old_size = target_cifsi->netfs.remote_i_size;
 
-	/* Discard all the folios that overlap the destination region. */
+	/*
+	 * Discard all the folios that overlap the destination region.  Start at
+	 * the old EOF when extending so the folio straddling it, which may hold
+	 * data written past EOF through an mmap, is dropped too.
+	 */
 	cifs_dbg(FYI, "about to discard pages %llx-%llx\n", fstart, fend);
-	truncate_inode_pages_range(&target_inode->i_data, fstart, fend);
+	truncate_inode_pages_range(&target_inode->i_data,
+				   min(fstart,
+				       (unsigned long long)i_size_read(target_inode)),
+				   fend);
 
 	fscache_invalidate(cifs_inode_cookie(target_inode), NULL,
 			   i_size_read(target_inode), 0);
-- 
2.53.0



