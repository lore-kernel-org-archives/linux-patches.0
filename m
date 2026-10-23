Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774285;
	b=JVKK9foyCdBoMc+CyZ1iKQ3ZDGOAQaNWSubjtispN0xkpIIG27UPGmLMsar4Hwxr7MmB
	 oqrnTfgW+uLXLc/tqxxVF29iOQqPSbi3EU60MTox8rNpRwadjcksvOWZCJjoGIgPtbj2W
	 iO1kLF6VU4yEfYJ4LxghsNYw+0fpk2R1NPUC2TmbzyEDjnhxrcIcvy03QGRksT4TP3QPm
	 8PsRWrxza5RSDKzeR8HTE0BwmTXvx7TDrTqFPHk1PQLSa2/urWsg5NTu+FD/lgcEDRh3i
	 PZ3ue2VOLL/NuF5oIl6TuSGyvFC9S5xLVKxWw/o1K6twtE/T/UzWVOlLUHqMkGYnJ0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774285;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gTuoB1rYj56yPUzMe5fxJ5aaiWGxqJ7N6YCboWMwTbc=;
	b=VW1VlfahHSso0uRF8m1bxO6ThRZ0gFA9Q3TKe3Zg0CnDBFm/L6Drqm5Gdwxz1dhTLjhy
	 BlOMTpkOaRPU/FhJlIwV14gKxIcBorl9ZaV/jdvCEpSV5P1LDYvZBROLCXukxQmUUlWdG
	 cKgj/mYGkoF2IRdDBZdvJ44lL/bMZFg3p1WJN+3xtzKRa0Dz8/n1f3+6Ug1oqWfjtvGSL
	 fUNqexpW8sCzbCYaZTF1+MM+E0kwYcbfEOEksLB19DNrillIgHi6F8zW+68PBm1JF8Zso
	 9N5siwe7/OvMrfE7sC9Usc4dBM9xBsNdGemWMiFoegJlWlV9/6IDBWSyiKO9QOVDhNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rld89AFv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F377606A31A;
	Fri, 23 Oct 2026 16:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rld89AFv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF8D1F01825;
	Fri, 23 Oct 2026 16:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774285;
	bh=gTuoB1rYj56yPUzMe5fxJ5aaiWGxqJ7N6YCboWMwTbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rld89AFvd7/oAjOrqIgzcoaYVx8nrlKDhiO/d1zW+WAjmRNuR0FSIwb2mxFrGV9dS
	 R/z9gSYJtnF12LUqUeLnos68sqVW+w7yPuh6hcp9rm6yPhKPt/VP6K5yci098I9VtT
	 gbWd1mUVZqHPLPksHK8vDuoy0bRmxi15DlNd6GEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 176/193] cifs: add revalidation on FSCTL failure in smb2_duplicate_extents()
Date: Fri, 23 Oct 2026 18:37:33 +0200
Message-ID: <20261023163718.380940455@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2296,7 +2296,7 @@ smb2_duplicate_extents(const unsigned in
 			       trgtfile->fid.volatile_fid, tcon->tid,
 			       tcon->ses->Suid, src_off, dest_off, len);
 	inode = d_inode(trgtfile->dentry);
-	if (inode->i_size < dest_off + len) {
+	if (i_size_read(inode) < dest_off + len) {
 		rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
 		if (rc)
 			goto duplicate_extents_out;
@@ -2313,7 +2313,10 @@ smb2_duplicate_extents(const unsigned in
 	if (ret_data_len > 0)
 		cifs_dbg(FYI, "Non-zero response length in duplicate extents\n");
 
-	if (rc == 0) {
+	if (rc) {
+		CIFS_I(inode)->time = 0; /* force reval */
+		cifs_invalidate_cache(inode, 0);
+	} else {
 		qrc = SMB2_query_info(xid, tcon, trgtfile->fid.persistent_fid,
 				      trgtfile->fid.volatile_fid, &file_inf);
 		spin_lock(&inode->i_lock);


