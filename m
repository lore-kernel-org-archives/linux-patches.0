Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211921;
	b=pxAT3Q7Clllw6eURQM0jQz6DGmNoHp2qdPttSt5oVoNMwIzfImEf9KGlJKZWWB7pCDER
	 aJfJ3i8neEtiKM1naFAVeM11/8QRpwdpDYtEIEEQ3oUpAmHvaxyB/7SLdjWGby7XsoLCp
	 3PpTnHLbUrwJHFg85fBMm1fp61UxFEDU5XpicCy4FFDorB79wrWANmAq5LVasVdI+0H36
	 lkNljfxv858bXM2gXS00E3sA3HObK6uejFlWZHYdRYnk+VVrImt5LKtGaobA9X0QiqmvI
	 b4K12XOmUMcIEAoClB/PT/OzjTYyau7dHysabgcZviz2ipzMdWFgv25a+VbvEF2FtaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211921;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LLYGntTk3lYiZRm/ypxS/HCOJkj2kybgRGWBvORfwHQ=;
	b=Ff4ptohI/pLr514CpzYA6GMnLab9lmEmhDtKNn4EwGq807NYnRjcEK31x9s5+1nx0iy1
	 ckieF3P8Eyqt5i4RBj3ZNGb25zCtt4c82G7FoNKqxvbkC4phqy0ojQn6EAOc4oz+7i9bM
	 U9dt9trgKL3GVjeSqlozClrWG6t6TQOga6z7q3qsSyLuwRY/6Ojdp1OU7FrLW5u4mGnV9
	 w8xQ/h93R9DTzzsvSaPDz1hK7tINSMhpxAaGdBnWrkWHNPuNDB0CrO0HEtDYFqxqB/eFh
	 SySKdoB15m2WiE09kYRWtR+ODE46xhK3Cno83kctu6ViFFcj44m1QQqo9NBfmLA1fVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="x9Qg/L4g";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D66C606A31F;
	Wed, 28 Oct 2026 18:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x9Qg/L4g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284F01F01825;
	Wed, 28 Oct 2026 18:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211920;
	bh=LLYGntTk3lYiZRm/ypxS/HCOJkj2kybgRGWBvORfwHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x9Qg/L4g0Q4uG9+gkCBoL4te/qAqgszBZCwVmRugLC4EcOGzWCsrXgWgLo8JOkjrz
	 gUV8MSobYDsQjv32nZHEN6NLW3RrTHsX+wOPqX2I3T2Cza7pN0cx55ZwL0odoaW5et
	 37odsYfH5jqRCHwxbHgbMLcxI7Z0H+uLCLwdf15o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 546/571] cifs: add revalidation on FSCTL failure in smb2_duplicate_extents()
Date: Wed, 28 Oct 2026 18:01:33 +0100
Message-ID: <20261028170020.992120398@linuxfoundation.org>
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
[ sashal: replaced cifs_invalidate_cache() with fscache_invalidate() guarded by CONFIG_CIFS_FSCACHE. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 57ba6f7d813d7..781fe599dda7e 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -8,6 +8,7 @@
 #include <linux/pagemap.h>
 #include <linux/vfs.h>
 #include <linux/falloc.h>
+#include <linux/fscache.h>
 #include <linux/scatterlist.h>
 #include <linux/uuid.h>
 #include <linux/sort.h>
@@ -2160,7 +2161,7 @@ smb2_duplicate_extents(const unsigned int xid,
 		src_off, dest_off, len);
 
 	inode = d_inode(trgtfile->dentry);
-	if (inode->i_size < dest_off + len) {
+	if (i_size_read(inode) < dest_off + len) {
 		rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
 		if (rc)
 			goto duplicate_extents_out;
@@ -2185,6 +2186,13 @@ smb2_duplicate_extents(const unsigned int xid,
 	if (ret_data_len > 0)
 		cifs_dbg(FYI, "Non-zero response length in duplicate extents\n");
 
+	if (rc) {
+		CIFS_I(inode)->time = 0; /* force reval */
+#ifdef CONFIG_CIFS_FSCACHE
+		fscache_invalidate(CIFS_I(inode)->fscache);
+#endif
+	}
+
 duplicate_extents_out:
 	return rc;
 }
-- 
2.53.0



