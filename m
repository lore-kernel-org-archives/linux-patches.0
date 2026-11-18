Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021572;
	b=05SUEMwGUrhO7Co6k0UrUsV2FqySdpw0+zkD6CFjJtzUQQ5nNYSbNWaGEDVmqVTES6w7
	 9cCyZk6xIlF/2xXmCOdKqm6aACSR87YDdDkCYa2tlNH7KwmT1yL8IDCmvhxVu2vRAiCDG
	 JSGaugApJvrkefdMOCu5gXtSN5BezF9MYrcCQVeLSRexuyyD1/H7QGdM67r5hTb/KCcaJ
	 K3xG72NI2kxDEZBU29/fE4RPJz+O2Zmky9Q5SJ5HU+2tmw5E3V9m6bEIfBCai9rrChYjQ
	 ejGvD/wIIPIIHSXdfStKClMLWHbPe8E9cqXbyNKfZ97lPvLeULxYfcDR7ZKSDNp737A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RpMlvsgWShZgDQUuKF1BSCoqYRbnsmzIyix4iR4QNv8=;
	b=CgWEVX4MmRzsDgqjCub50B2ySyWKBmu4pAP8aNc9pY5jxtD3+VumvBtaYjOk6LtFVn59
	 ko22VpN1M4s4ASjeeWHyZDo1KNkd1X3hCzva9+DstQgWKyUPFA65SZuOfOW2NZ5BCZKpL
	 prUZ5kfPbMKBdHf47xY/+Ehc+jVbq6Yz/JGUcF3RpiK6eL52gJIdSGoYCeXBI+zvuML0y
	 2eiEr+dZ7ipgiACrt7suV5hB4NjzO7eLqoNrzBJHDwPZPSv4ITYYxjp03d7hPJbCg7lML
	 oKdWgGNtuW2tIvc1IPldNdIgENQEzMXbjUWqtRAOVtvMwrck9fY8t0p+ucMUUeIVFbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iu2g5ayt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9641606A334;
	Wed, 18 Nov 2026 17:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iu2g5ayt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7451F000C5;
	Wed, 18 Nov 2026 17:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021572;
	bh=RpMlvsgWShZgDQUuKF1BSCoqYRbnsmzIyix4iR4QNv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iu2g5ayt/YWVFCSNS6VKh9swz4jq0pfWdMbJt6Ky9LW93V+1MQicr+zR8fRnv5wFO
	 Jt9sU+G8JuiXKhdQ4KNzTUTXfG9Yyep/CskRs7l88wQ9d3o/I8U7k60bv1DeJuc1H3
	 zApU5pmxm9N8HndNDrnnU3PPEG5bglKwDYCbzD6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2354/2651] nsfs: check the trailing bytes of a file handle in bytes, not words
Date: Wed, 18 Nov 2026 15:59:54 +0100
Message-ID: <20261118150409.789928788@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

[ Upstream commit ad0312e1decd40d18e0e75de96c9c52013ec05be ]

open_by_handle_at(2) gets the wrong answer for a namespace file handle
longer than struct nsfs_file_handle: a 16-byte handle padded with
zeros to 48 bytes or more, which is what the comment above the check
promises to accept, is refused with -ESTALE, while a 20-byte handle
whose extra word is garbage is accepted. Reproduced on v7.0 and on
mainline with the handle of /proc/self/ns/net from
name_to_handle_at(AT_SYMLINK_FOLLOW); no privilege is needed, as
nsfs_fh_to_dentry() admits the caller's own namespaces. Since v6.18.

nsfs_fh_to_dentry() receives fh_len in 32-bit words, like every
fh_to_dentry(), and NSFS_FID_SIZE_U32_LATEST is the struct size in
words (4). The check that the bytes past the struct are zero adds that
word count to a byte pointer and passes the word difference to
memchr_inv() as a byte count: it inspects bytes 4 .. fh_len - 1 of the
handle instead of bytes 16 .. 4 * fh_len - 1. Up to a 44-byte handle
that range lies inside ns_id, ns_type and ns_inum, so the outcome
depends on the values of those fields (a padded net namespace handle
passes because the upper bytes of its ns_id and ns_type are zero) and
the real trailing bytes are never looked at; from 48 bytes on the range
always covers a non-zero field byte and every padded handle is refused.

Start NSFS_FILE_HANDLE_SIZE_LATEST bytes into the handle and check
(fh_len - NSFS_FID_SIZE_U32_LATEST) * sizeof(u32) bytes.

Tested with a program that encodes /proc/self/ns/net and opens the
handle with handle_bytes 16, 20, 36, 48 and 128 (zero padding), and 20
and 48 with a non-zero last byte. Before: 48 and 128 refused, the
20-byte garbage handle accepted; after: every padded handle opens, both
garbage handles are refused.

Fixes: 5222470b2fbb ("nsfs: support file handles")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Link: https://patch.msgid.link/20261018030342.799383-1-nickolai@csail.mit.edu
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nsfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index c3b6ae76594a8..0ef4e1455b7a0 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -529,8 +529,8 @@ static struct dentry *nsfs_fh_to_dentry(struct super_block *sb, struct fid *fh,
 
 	/* Check that any trailing bytes are zero. */
 	if ((fh_len > NSFS_FID_SIZE_U32_LATEST) &&
-	    memchr_inv((void *)fid + NSFS_FID_SIZE_U32_LATEST, 0,
-		       fh_len - NSFS_FID_SIZE_U32_LATEST))
+	    memchr_inv((void *)fid + NSFS_FILE_HANDLE_SIZE_LATEST, 0,
+		       (fh_len - NSFS_FID_SIZE_U32_LATEST) * sizeof(u32)))
 		return NULL;
 
 	switch (fh_type) {
-- 
2.53.0



