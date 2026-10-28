Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209517;
	b=nC/OBkVB4JbWXbUk0MVIeTdOutxzoqKiciFZD0aTW8i0iqvqN1s5GVcgw+6ge6tvOJzl
	 LjBS0Pa8xkagE1+2WTEtOl3juFHiE1tTHloY8BJmj5+qkO4QqKIW5NTHYR80tXPbTAsW5
	 ckZHl4oYz1DZ37Y6x9RX/5+IWXbs0LeuS7oh5ksP9++g3cqR4q2gAQfYJ1xyfretaV9A4
	 uDqxOx7unQHCL+d29cHv4RCdOPKiMh8742v8orH9nnF8oBa7nan8C8ntK4G9d6ErS7jfv
	 gbKib4xfdHXfWdKUKO5ohQ7u6Sz7iomGVzhzaZ53BUPzc9HIrF6Kj41dpDGJlp4ra/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/RfrY4hc5amdmiA625d/OhzVRwqDV16uJ3KWuhCSVQw=;
	b=ba49BxzRisGwb8YOCFMgThSUUHBzU8r0X+rTqtsyQXAwINKODrg+c5nAT8w+m7s/qetI
	 KgoOsuLfvFvlOpIR8o6TmTYbbVvFPU6U/fEI3NVRcQ+El9DDYbcZ1menBEzz8CizUFMu3
	 WFb1pmnusjaAhRKVWPg/2Tvm8L+0GNEsoL+LJlFW3LuPN2PsQZwfyW8TceWzZp6WZPLme
	 3CSo+gYsLzBS4IBq0y9hc70PXX/z9/VphnvdAQrjYFFC9ZxKJYCBGlE3n2Z7puSPXiuHH
	 zjX2b4alLvUJltrq4HcrG42INtVnNNSi2AC2GjjJT1rE0mCL3h5L6vc+xbV+Fge13Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aSTr6Yst;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842C5606A323;
	Wed, 28 Oct 2026 17:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aSTr6Yst
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54D81F01828;
	Wed, 28 Oct 2026 17:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209517;
	bh=/RfrY4hc5amdmiA625d/OhzVRwqDV16uJ3KWuhCSVQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aSTr6Ystah/7b2pLtQrMESYyIqfAjjcNfF4/SHCci3NeR/XNi5kLAv9aasLE18Iv0
	 ktVKlfkDBV7vASU6BV7g4vZqNeE9fIF76eOLTensOmi/ci4r75PNp00ZjEAbWC0rRZ
	 h3zsWEwm4yTBAnNXWQ2eMLdWZ7O1o+XYMSdCPyn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 498/516] cifs: add revalidation on FSCTL failure in smb2_duplicate_extents()
Date: Wed, 28 Oct 2026 18:00:50 +0100
Message-ID: <20261028170015.276312716@linuxfoundation.org>
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
[ sashal: replaced cifs_invalidate_cache() with fscache_invalidate() guarded by CONFIG_CIFS_FSCACHE ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 5d07e1400015b..0e95065ae0767 100644
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
@@ -2045,7 +2046,7 @@ smb2_duplicate_extents(const unsigned int xid,
 		src_off, dest_off, len);
 
 	inode = d_inode(trgtfile->dentry);
-	if (inode->i_size < dest_off + len) {
+	if (i_size_read(inode) < dest_off + len) {
 		rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
 		if (rc)
 			goto duplicate_extents_out;
@@ -2070,6 +2071,13 @@ smb2_duplicate_extents(const unsigned int xid,
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



