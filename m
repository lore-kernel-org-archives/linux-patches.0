Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208483;
	b=TLe9Qhhi1W+xRgE6SsUP+8BbVOngcyJOYpvALtFSqQIMbQGQi9qqQGlxwg7mEnagGHSg
	 5RUMg8cYDPaSDNjvVY54fwJwTZZ+A6hx9yHvkKq9GK4FqKfypt9P2dS7o8ahkakdFvDNg
	 19dBUMFOpGGRnRraJz4UsjJ7V1ISvGWRq834zKO6eovD1GIwd0Vq6CY/i1gdyMY5bLbnT
	 INQk8vmr/ahqc9OGKz5OY/C5QcUfZNuYQdwxq/PhR8kRW1JWo8/dlVGqYd6Q864B4+ZgW
	 1PVUzpnTR3+UYQZAuARwyjXPXh6kZ6uinH+r9ZDQpZMVnKTVe/e+6UvEQuClmy0lzsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y7KmqxHV1JETH8mlbkEtCFL3LjsL/WGLKoHpwV6QYac=;
	b=nWM+bCEgo5LQ0YCa5eak1R1e37p23ZDLPWSwJfOI1Kaj458DTvLPEP72JpTbwXuMvcBn
	 MuRyI0M8YeRwZToD3dObgN8zVzitUZFRrhn6E8ekaJFMxj/IFF2GRho/72kzEM8UHvaRm
	 AbvN4/nLOaYDb0XyEHZATbt+p37auv9o8l4/eHRZcIfSN5KC92T32+OYxxTOBBu7AWvXS
	 gUOHPMqr2fDlmevFE3IxhnVbLueOKbdh3J6vjtXd1p2DEt/HR2LjiveDss2Gp8gSbWyFm
	 IP9RfPQenhJ2BaeWYZQnAuYBe1P6+mC4sdLzU4ViN1M0S2g7IMgXpMEfb2Vul4ODEKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L1qRAYAv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A9B606A31A;
	Wed, 28 Oct 2026 17:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L1qRAYAv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6B71F01825;
	Wed, 28 Oct 2026 17:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208482;
	bh=Y7KmqxHV1JETH8mlbkEtCFL3LjsL/WGLKoHpwV6QYac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L1qRAYAvryg5tlrX6hcvm6vkD3sLUmP7tLTwXl/qc0u4AzMXCUKZmt/5MMTMTMZkk
	 lDQor3RD3SKzJC7K4vPacmCBjc0c10S+Z7YT/rdcai0xv5lCnYtnWpbyviD3mGcROK
	 ddS7VFPcQO9OmaxzyZsgAyjanTZgMnssd7L+C08s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/516] smb/client: use stack-allocated smb2_file_all_info in smb3_query_mf_symlink()
Date: Wed, 28 Oct 2026 17:54:46 +0100
Message-ID: <20261028170006.685457620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4fc6eb8e786d4..0779fd9a70594 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -396,7 +396,7 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	int buf_type = CIFS_NO_BUFFER;
 	__le16 *utf16_path;
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
-	struct smb2_file_all_info *pfile_info = NULL;
+	struct smb2_file_all_info file_info = {};
 
 	oparms.tcon = tcon;
 	oparms.cifs_sb = cifs_sb;
@@ -410,20 +410,12 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
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
@@ -441,7 +433,6 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 qmf_out_open_fail:
 	kfree(utf16_path);
-	kfree(pfile_info);
 	return rc;
 }
 
-- 
2.53.0



