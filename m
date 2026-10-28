Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210811;
	b=lo8dE3R/ADRv6SX90X0wO45sBHmG414q8uNEJEjl8PP2ZaVmBaOnby4KQUHOoqmM2aHE
	 oDv7uJ//SzvvwNz8NK/xJJezr0oRkECO6E8wXVyMqu37ezlY8rHYGqpxuLvZnyONLSbwX
	 VzAyGH47blAbU7gD6NmKQeo9+iP9NImKZqz9U/UKkrUH9iy3LdYb+jomompDrhtVolc7I
	 LTzMmSsim3GZYNHSt5+ef44ZcAjXLy0QVDBw6hQ+NlMcBT1hAkg1gL/U+S/B/4pudbcTH
	 oz11iSHeqMfS/faggWMDHD36gh1MisVix8kuJFkUE4XiifvytrchYGjiFPv6f/LxGFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0UekwiI+07hBTn4jaXUNEGzsFv7Sf2K9r4B5qE+uyzg=;
	b=2qMFG+D/RqmbRBClidxb3iXGrq7ask143olKbWRjNq5Scnmk0JPjXShhYT41dKLxcCGC
	 Nt6oaMDa+5s1kevWGatjZ4a88awoIdQOuktp13ZwpBPa0JIEG1z+FmWn54CXr8i5YgH1p
	 4YvP2A2bY9n2SkUa2AZ+8Kv+aXmQtqJbCOeAKyx0mG3Qc5XmmeWp+UC/eS0nqJh0gWkgD
	 MS/IXhyGgJeKNRayfjSfJhsDI1r6Kytw0ziU93Xd6WDoudooVb+2I0Mzzh2DyNJOMbsEK
	 0hMsEFKFSJsQnnospDjCPBaI8w+KC9aBiXrW+Og8lzvRFDlwwgqIJ1rHViqGr1Fzueg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z4gy10JH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844BE606A31A;
	Wed, 28 Oct 2026 18:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z4gy10JH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B5D1F01825;
	Wed, 28 Oct 2026 18:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210811;
	bh=0UekwiI+07hBTn4jaXUNEGzsFv7Sf2K9r4B5qE+uyzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4gy10JHLFUKsIyv7ckH1fRW0KAyaC3EJ266x4LFqE1cBH3Xb8tjjZu8L9gyLqbWR
	 FFmkpe7ltstwMZU4ZOuPhyf8eeQikVjhbU36yqR7V4aegtobBpW5alPF4axHFCMQil
	 Jo4jAu/emiMOYTCs7c1EqZRLY6WIKqe2MAcoRauo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/571] smb/client: use stack-allocated smb2_file_all_info in smb3_query_mf_symlink()
Date: Wed, 28 Oct 2026 17:54:37 +0100
Message-ID: <20261028170011.103348994@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit fc8789bb57e625e5f32ac57ca2e7d3e7b7fda225 ]

SMB2_open() only fills the fixed fields, so a stack-allocated
smb2_file_all_info is sufficient here.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 566820af017e ("smb: client: close handle after create-context parsing failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/link.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 4308b27ba3464..ec1b9cd44b511 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -384,7 +384,7 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	int buf_type = CIFS_NO_BUFFER;
 	__le16 *utf16_path;
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
-	struct smb2_file_all_info *pfile_info = NULL;
+	struct smb2_file_all_info file_info = {};
 
 	oparms.tcon = tcon;
 	oparms.cifs_sb = cifs_sb;
@@ -398,20 +398,12 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	if (utf16_path == NULL)
 		return -ENOMEM;
 
-	pfile_info = kzalloc(sizeof(struct smb2_file_all_info) + PATH_MAX * 2,
-			     GFP_KERNEL);
-
-	if (pfile_info == NULL) {
-		kfree(utf16_path);
-		return  -ENOMEM;
-	}
-
-	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, pfile_info, NULL,
+	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, &file_info, NULL,
 		       NULL, NULL);
 	if (rc)
 		goto qmf_out_open_fail;
 
-	if (pfile_info->EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
+	if (file_info.EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
 		/* it's not a symlink */
 		rc = -ENOENT; /* Is there a better rc to return? */
 		goto qmf_out;
@@ -429,7 +421,6 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 qmf_out_open_fail:
 	kfree(utf16_path);
-	kfree(pfile_info);
 	return rc;
 }
 
-- 
2.53.0



