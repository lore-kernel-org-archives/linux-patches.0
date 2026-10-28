Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210204;
	b=M8h2vBZ4d2rdNZTT8Jr3Src2Qwo3bjFGINcbtw8t1enRhZkKvvCSWh6h5kZ+bLrhuQkl
	 5KN/zkPn2bTa90w8tGpgNSd9Rlp+/VeFFEWqdwIxvPYB89YeVMp6LIbuZKQ5a2gof6QoK
	 QjuglwmsEfVPZcOEFcWjbGyd1dEV/Uw34eOcLr3taOpUEbXvL3Sk/2TIf+wEqL3pHBOwW
	 19aVUsHP93Io27RhFGjgBlB4os+AfurrfLNA6tzwzvHDX/8KqXcHl4myK8U9tqO3ubY/j
	 Ie5d/82tk2ys2As02D2kIosUBBDB9AhjUOKwVZjF2uJn3X2wegf6NQJ2edmFWTTEDPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9u6fZfdgN5Bqfu4ouPZnnwpfP7xNf+GxQ1guAmLb0tI=;
	b=bR2/25bkI2kxN8wGWxFJKPfJ4NYLYVH1nUl+c4LC4AJmswmNo0wDwbYGNrM9zp6LZi+Y
	 HMP3tlcf5vsP4bcJrnKZ0lSe4E4iKPFAkZ2QE2R5frPAvHh8JoWGdZ3KDUFNpe/IneiBP
	 wyCV6nk3L1Y6VO+vg267Yq/HzvR33ITKSF+lu23eZ3Ek7EmQqpxWQGV1QMDWpnNHVBtvW
	 s3Qo+zX+k05okIae12m1A64tswcqgrY68zpujlVDB/gJpSOv0wnApgCzkW0RPlst6OLLz
	 VauhS/3Ht6h+9zAQleIWBM5fEj5dDGdPiz3/zYqCh9YbqDhT4d7OJNsFmrIVh9AyfRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y2SBviNF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E490606A31E;
	Wed, 28 Oct 2026 17:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y2SBviNF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11D91F01825;
	Wed, 28 Oct 2026 17:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210204;
	bh=9u6fZfdgN5Bqfu4ouPZnnwpfP7xNf+GxQ1guAmLb0tI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y2SBviNFalv72S1W6EN8bSjh7VshaDWs+mXPiabDsD5B5bvDtYUT9FanWtY2z5zMB
	 FnKQT0+4hbymFJsnOcO71QctzujIXu9KWO8lexZn6POsAN0cT8fhC7jsFzCrXtS55X
	 TMjdyvoPAnt13hI8vuh/P7sjgzmW1DjIrYyVi6Gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/168] cifs: add revalidation on FSCTL failure in smb2_duplicate_extents()
Date: Wed, 28 Oct 2026 18:00:50 +0100
Message-ID: <20261028165945.785892585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Made the failure check standalone because the existing code lacks the SMB2_query_info() success branch. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 4da027ee4b99b..21a2b265ae7c4 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2070,7 +2070,7 @@ smb2_duplicate_extents(const unsigned int xid,
 		src_off, dest_off, len);
 
 	inode = d_inode(trgtfile->dentry);
-	if (inode->i_size < dest_off + len) {
+	if (i_size_read(inode) < dest_off + len) {
 		rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
 		if (rc)
 			goto duplicate_extents_out;
@@ -2095,6 +2095,11 @@ smb2_duplicate_extents(const unsigned int xid,
 	if (ret_data_len > 0)
 		cifs_dbg(FYI, "Non-zero response length in duplicate extents\n");
 
+	if (rc) {
+		CIFS_I(inode)->time = 0; /* force reval */
+		cifs_invalidate_cache(inode, 0);
+	}
+
 duplicate_extents_out:
 	return rc;
 }
-- 
2.53.0



