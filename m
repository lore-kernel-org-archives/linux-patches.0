Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826989;
	b=07WAVxEWaB1IK0RuQjgKwXa5xt1CPkgtnIVQhQ4rIonQIaqAoFA/6o6EjtVw52YrToiH
	 J/5nnyH1Hla0nbF/WNKLzZf0UwQJXZVp3OMpVyWm9NbxgM1bKokMZ0fUDYNjb5j4outuj
	 nbFKkRKLb6ChCCKGuIr/ufTtwGhU3nyywoUFk1j7kPbFPVqxVsGhqEelmv25T7+gD5muY
	 ptPHFdikvRhOvfaxGwDWUtM2TUYMxLgO5l6/OX8VX2MvD9rPWaLvw55kbr3vs5/cF3Df7
	 0cr1P7avcBG3ePIMHr2gZ/fxQjoBGDQSgqysdljqUSMaHsLgROBCOclB9Tww0q768Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+VmnO6X2RK97Xa3zjb0i12pVSXXY6a/wqH4nx3EEtp8=;
	b=c5gZMX+oWrkqSIWcffFJ6OTbmgTtXm4i1jB2cxPKNz6cIx026ywjctzilvm7yjAXWKHV
	 crzqdy8fg05Wegl1Dr3nRtcYA4P+gysR0QWvM4eib4itKkezU2kbKWdru0VH0Nx2raaTV
	 INSxe/o4JWkcGALSFwCF03D9Na0AQz7Cge49DUK/P8MPtEVhQGdvMvZHGpRlIWfLH0Vcc
	 hy8Hm5kZ2sH8mA/0HKOVm9/fyUAKAuyVT8EEUXzbBSXcF9DSjqMnbTL3VhTOaVIjwjI6P
	 aPffWcFpxNPfQnaWemfC0nS33kgFVKRRkc2D3QfH7Xfo2olBly8QhH/BPY/PWuMh2zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tw6LF9t5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C8F6070AA2;
	Wed,  4 Nov 2026 21:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tw6LF9t5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710211F00919;
	Wed,  4 Nov 2026 21:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826988;
	bh=+VmnO6X2RK97Xa3zjb0i12pVSXXY6a/wqH4nx3EEtp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tw6LF9t5/KyhljtFdN4leJKVeVkpTbn4jsnvdqvpnDXupBWQEGiPrr4T61exAtwHb
	 qzLzlCRysglWtBjDJ5O8+SD96ZNzA0G3SeONU7vgi1s86Pp7OnS5ZneBpKK8o0FBeG
	 NqDXrOcZHQ6kbynW+Td1JdChcGGUfr/tsvrDajvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 126/547] ksmbd: preserve unreadable named streams on open
Date: Wed,  4 Nov 2026 16:05:10 -0500
Message-ID: <20261104211041.765318776@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: DaeMyung Kang <charsyam@gmail.com>

commit 80c816c047f7cae3c99cc75740c1f5d2c4d97b45 upstream.

A write-only client can open an existing named stream with FILE_OPEN_IF
without permission to read the underlying file. The case-insensitive
lookup finds the xattr name, but querying its value length then fails
with -EACCES. smb2_set_stream_name_xattr() treats every negative result
as a missing stream and replaces the existing xattr with an empty value.

A failed xattr list is not proof that the stream is absent either:
for example, -ENOMEM can lead to the same empty replacement. Preserve
listing errors and create a stream only for -ENOENT or -ENODATA. The
latter can occur if the xattr is removed between listing its name and
querying its value. Return other lookup errors without changing the
stream.

A write-only FILE_OPEN now reports access denied instead of name not
found. FILE_OVERWRITE_IF and FILE_SUPERSEDE on an unreadable stream
also fail instead of appearing to replace it. Stream writes and EOF
changes already need to read the old value, so such handles cannot
update the stream after opening either.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    2 ++
 fs/smb/server/vfs.c     |    6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3428,6 +3428,8 @@ static noinline int smb2_set_stream_name
 				     xattr_stream_size);
 	if (rc >= 0)
 		return 0;
+	if (rc != -ENOENT && rc != -ENODATA)
+		return rc;
 
 	if (fp->cdoption == FILE_OPEN_LE) {
 		if (!strcmp(stream_name, "AFP_AfpInfo") &&
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1912,7 +1912,11 @@ ssize_t ksmbd_vfs_casexattr_len(struct m
 	ssize_t value_len = -ENOENT, xattr_list_len;
 
 	xattr_list_len = ksmbd_vfs_listxattr(dentry, &xattr_list);
-	if (xattr_list_len <= 0)
+	if (xattr_list_len < 0) {
+		value_len = xattr_list_len;
+		goto out;
+	}
+	if (!xattr_list_len)
 		goto out;
 
 	for (name = xattr_list; name - xattr_list < xattr_list_len;


