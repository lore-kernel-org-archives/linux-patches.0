Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207829;
	b=sxO6rxEYFo7BdMgVfRSHSuRZJGmA3H3WHLFiz+J91meo1mJix3dDpmFnIRD46TNmyM3h
	 7AYoxwnaQs+O8u5pSnIGG4vcJxzzaQjeM6Bk+7+Y7Vo9ArBaKCo44WeQwkFs2QTUfCemr
	 fckhRVFy5QM3gN7UoF+3OukJrOrovKYYgKWcOEraegGmrYUdliSvU52UI1vlb4jubcWkv
	 +A8txR2A1Xoa5UOReb2jgFzQRr4h2HNsVjCjFd6tXpe4JegXUr6h43cvSNYkEt3OXUbkJ
	 ZO+zsFvK4BgWjb/wWdH25278CTq3OfRy8RcgzVVbQvZC2Iq9ss7OJJO5ARd/PnFyi4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O+ewpsoqhoR8GUNAhLwuUf+m9sAUsNvSMuPkmGi2vpw=;
	b=G1JFvdH0LqMig5Q8zdplqG8RLFxaa1w4N3OBk5vWxQ6AOmRVfjqD3b7VljpnASwZyFUg
	 523WIz2C+BsbzqGDUBpy2NoZZDo39xNwhKIIczgOgihzDJLou3oxjvr1rPf8/rBldCFuD
	 14KjYdRUb7RlbUlV7s2npph1b0Ai8Iwm/P+0mSBO1b09kogY+YTK0E1ceflvFAZUH5Sj3
	 dUl6rVTe6T0GB8hc18rCN3a/+AZbzNG17EGfSCHw/Yz9/eTTmJTHftCkBYEP6wIlp9PfW
	 g5DsoXDjMpIiWlpWLrlgAO5HU4fDO0m3dhJrV0Rm7uhnhmntx+imdcn5LZCMFZ8nn3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DRRJ5a42;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B524606A32A;
	Wed, 28 Oct 2026 17:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DRRJ5a42
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1B31F031E1;
	Wed, 28 Oct 2026 17:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207829;
	bh=O+ewpsoqhoR8GUNAhLwuUf+m9sAUsNvSMuPkmGi2vpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DRRJ5a4267Bzb7JGT0cXXyg/T9YCOdbHg6SF4lbF7D/SEkuw+D7DQLFG/0kPxL/tE
	 3h3J/j+YUv1sBaCT0TfSKxlNUk3xfcbc0rofWCr5Bed4fms0czs0Qi+vomzq9rRfSw
	 EDvwzxckz+WsqInx1MtcHR9PaHg1ERRWAOuNeOCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 154/247] cifs: add revalidation on FSCTL failure in smb2_duplicate_extents()
Date: Wed, 28 Oct 2026 17:59:17 +0100
Message-ID: <20261028165951.058929701@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit 53676a5e28231186c9f56d87b7998b640699bc15 ]

smb2_duplicate_extents() has no handling for
FSCTL_DUPLICATE_EXTENTS_TO_FILE failure: when the FSCTL fails, local
inode metadata may be stale from the pre-extension or from concurrent
remote writes, but is never refreshed.

Force revalidation on FSCTL failure and use i_size_read() for the
pre-extension check.

Fixes: cfc63fc8126a ("smb3: fix cached file size problems in duplicate extents (reflink)")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ sashal: Used a standalone failure block because the upstream success branch is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 6ef0fcd9a05c2..7cd2e88a86b72 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2292,7 +2292,7 @@ smb2_duplicate_extents(const unsigned int xid,
 			       trgtfile->fid.volatile_fid, tcon->tid,
 			       tcon->ses->Suid, src_off, dest_off, len);
 	inode = d_inode(trgtfile->dentry);
-	if (inode->i_size < dest_off + len) {
+	if (i_size_read(inode) < dest_off + len) {
 		rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
 		if (rc)
 			goto duplicate_extents_out;
@@ -2318,6 +2318,11 @@ smb2_duplicate_extents(const unsigned int xid,
 	if (ret_data_len > 0)
 		cifs_dbg(FYI, "Non-zero response length in duplicate extents\n");
 
+	if (rc) {
+		CIFS_I(inode)->time = 0; /* force reval */
+		cifs_invalidate_cache(inode, 0);
+	}
+
 duplicate_extents_out:
 	if (rc)
 		trace_smb3_clone_err(xid, srcfile->fid.volatile_fid,
-- 
2.53.0



