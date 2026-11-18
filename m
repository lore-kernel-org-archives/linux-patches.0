Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027761;
	b=kOGEaQjuV/9i2oUwKd7XWDJFjK63A7NVkcMIc3YT5oZYtZAR0MbQEigJsOSb0DGBBa3n
	 abV5lxvLpihuzVkKT0S59y9nk1aaMpDSxJm9ZQp34zsdauvrWFI0/CxJNhT8FXKtpdIzp
	 J9D/E9m/3YnZKn2ibIdz141gsiogl2ff/s6L+NaVnF2Zok+xCpufEc3OBIX9k3Y4YCVUE
	 mdmPWSuTtXVEIVOghOXe6S9yLw0NfVSErdIOUAw5gje03qNy7+S1xEB2gg+XbBCkfgToZ
	 lq1OKROYjX7lAvUxaDd5RzIxwEUdE2IoxBSKRkMWv4O96r8OrWDwx2d23dzME3w23FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JjnAQH9FoUXlnXfih+836lyG0MavwXqbVknJQBWaF1I=;
	b=sdGZzDE8JzFssYFuZGbxxi+MbJ/xW840pbCFTQ5FFUfjBn33xH/kE1yvB6ipX4QKHcFZ
	 5cmBTvWQgOg85a5/Ec3Nk8EHdLmXVVhh9sZ16fCDGJ0PnRK53BSxkhlNNqvtmPGFOaxu8
	 r0A6bIgqCi3qLvGZU85tXg+2vWbr68aSVy8dufUglrw4DmRCMXIQsYpewMnnFCQEOYdHD
	 5a7No6Vdsunt6CStvK5Gu4K3TRPLGrSfR+lI/vOJ8sz58cBYrLl8VZb9joPTYUjhDTFTD
	 tw8/YMO2XO/Lb9P31687A5YTHb/yf2oJMXExOyruaxLgzPGw+P8MRD6IUdghQ/15CHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oY+WNtO6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E18560A2603;
	Wed, 18 Nov 2026 18:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oY+WNtO6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44E71F000C5;
	Wed, 18 Nov 2026 18:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027761;
	bh=JjnAQH9FoUXlnXfih+836lyG0MavwXqbVknJQBWaF1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oY+WNtO6BJRMC3uAsdt9svKHhWy7m80uCxiudkMNkjhI/dQYXTEgvQR4krsgOf86z
	 xUen0a0HBN14xGMuOmLGV/6K0rcfacfukuVKeZqWgsFgwbSmiQ0xrR2JDz+PMGs4re
	 wqh4G05cxdaJSPlqIQpQ6Aa5i+tkWCdsddAFNnGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1903/2151] nsfs: check the trailing bytes of a file handle in bytes, not words
Date: Wed, 18 Nov 2026 16:00:38 +0100
Message-ID: <20261118150231.114489330@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 4dee1e728569d..8586a578a2b82 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -485,8 +485,8 @@ static struct dentry *nsfs_fh_to_dentry(struct super_block *sb, struct fid *fh,
 
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



