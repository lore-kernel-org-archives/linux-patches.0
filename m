Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585453;
	b=Y1v9ccP7R4HuLrcIy7k6Y3TXQk4CB3CS2kxNtHPXgkVr18V/7ByOvewKSZ+nQ+mqhc9P
	 8GrUJAD285JphclxkDhm8OCMIx766CXk/pmtnIZ4O8kUHMmao1W40E5HmQOh4Ahkwzbym
	 Orqpcy4qjy03LZ8n4lvbF9oqEAMuqWdL5uQ85SO/RHgpaFm3nqT/D2lZNpncI0PfkiCVE
	 f8bHYOcTS+lE3bJNjePlEu1QbmFIf+GmgBjBB0cLG4PTW5UAbXOo83W1URGND5z3Ib4zZ
	 jCoDByan3BUXmGNTJ0Eu1JfWsDV6xtnMXOJtOOdOQbStFudrtwkg+dMyat9rpzDzFkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585453;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4bhIMavD1exmBV1f25qWj329CbgNQEzAra3Ht/hkGLg=;
	b=uMz6BOYOcIQ31tOVp+zHEM4IO1Ckpq6r4fupAs6LjLXpE5gF31n4FM0fVUP2ZRbkYybs
	 9zJ2fcep+x7kPeAY73jXxSbEV7MTVdFxyWNa7xAJJ0coCB9DhSGf4JS3SDenr4wyZf4Jn
	 6/Yam46YU+nZT/eDyucbd1s/B7A6uPizHj5+MatHh9Y/U8g4DvmK3dxAfPN3otfGSgh5Z
	 iN0niI8/zf0a930mueX6ZkE+MJ3Csgbo9Zfxy+OhMXXa27WppQpetHkoy7xT9OTfRcV/H
	 Nnu1aj6Vlhnddata0PZCzk1TZU4f+Wp6x+TkS4NeKSQ556Z3YVPjSsKPYZmwxQfjyIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MoxW0Nnm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6299A60A5BEB;
	Fri, 13 Nov 2026 15:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MoxW0Nnm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2831F000C4;
	Fri, 13 Nov 2026 15:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585453;
	bh=4bhIMavD1exmBV1f25qWj329CbgNQEzAra3Ht/hkGLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MoxW0NnmDXsRg5C68ibA13GXZciBOlIzupIP/wVY6Zn8SfG9mlIIM5NAGbYXGTlw3
	 +9aaHEsxlnGresekRbTzC7EDrbOWrnEPpTyBSVx3T9N9oq9vTRuS3DrcEH4d29DN1x
	 Ll4IKF0cCoqHMa+auDh7nVzdXuKq7t5TdDX/gF94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 112/507] ksmbd: enforce the read-only share flag when creating a stream
Date: Fri, 13 Nov 2026 10:46:56 -0500
Message-ID: <20261113153758.125197042@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit 09139429fab3a5114c18d7c15fb161511d4d66c9 ]

When a share is read-only, smb2_open() rejects opens that would create
or truncate a file. Creating a named stream on an existing file with
streams_xattr sets neither O_CREAT nor O_TRUNC, so it passes this check,
and smb2_set_stream_name_xattr() then creates the stream. On a Time
Machine share, opening a missing AFP_AfpInfo stream also writes one. A
user who can write a file at the filesystem level can therefore add
streams to it through a read-only share.

Do not create a stream or synthesize AFP_AfpInfo when the share is not
writable. Existing streams still open normally, and a missing stream
opened with FILE_OPEN still returns STATUS_OBJECT_NAME_NOT_FOUND.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Fixes: eaff8e924f60 ("ksmbd: synthesize empty AFP_AfpInfo xattr on first probe")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b740be1030f57..abdbe54a2c04a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3453,7 +3453,8 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
 	if (fp->cdoption == FILE_OPEN_LE) {
 		if (!strcmp(stream_name, "AFP_AfpInfo") &&
 		    test_share_config_flag(fp->tcon->share_conf,
-					   KSMBD_SHARE_FLAG_TIME_MACHINE)) {
+					   KSMBD_SHARE_FLAG_TIME_MACHINE) &&
+		    test_tree_conn_flag(fp->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
 			/*
 			 * Synthesize an empty AFP_AfpInfo xattr on first access.
 			 * type=0/creator=0 tells macOS to use the file extension
@@ -3479,6 +3480,9 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
 		return -EBADF;
 	}
 
+	if (!test_tree_conn_flag(fp->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE))
+		return -EACCES;
+
 	rc = ksmbd_vfs_setxattr(idmap, path, xattr_stream_name, NULL, 0, 0, false);
 	if (rc < 0)
 		pr_err("Failed to store XATTR stream name :%d\n", rc);
-- 
2.53.0



