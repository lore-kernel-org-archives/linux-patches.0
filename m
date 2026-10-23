Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774850;
	b=gciXrNmV8LNc0At+zK/dPbjFHCYRhv8g5g+pLJiBMf/xWHolvudBQGnUl8MopJlhbQVW
	 OHf1N+4I5VdwIRW0nYTDPaj/qY2n+IpK7c9eyrnnysAoiDrIWwPX+krG/lR9S3sYsTdW7
	 o6Z8jYl/ajG2kovvh/TkpB52nSp/ptpqBgbH7r8MgWk736riu5d2Xj3e59Os7UlpW0mNA
	 pqX+Dy9Lw4g6rPP8JKen3QWBs+bq+UBWb5uWR0eceHwAzAzK/A9ag99q9LI9ypGeQziT8
	 4AG9IOCmLv88rgN9y4+poDwUuQ+jDXekP+PlJESp7He91iFWPPvj4XDf+g4GDqhpqQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mRuvDtwZFdG2diVPopnuUHF7yK8nqzHVkbSlif/PhUM=;
	b=e7+SAjPjVZuNOwIC5zjNrPw5kMMHc3MxHKGqHkfObdtDeLd3rzQ/aoS7Ysu/vH0WEnhE
	 da7Tl4N4OkI2fODiWvrgCAf6B11k3JnmfO5+UKKzbZpqJiVLBv+MB11auQej74Du0WMFk
	 TW3LzYa+WZ3EReu3vrTwijJ0p1hTynwO+MkJltupIoLh6IvLpt5dmJgKzfcve/MXxmcfM
	 quvulFixe2JbXcB18ogj4elge7gP7d2/uPPHMc7mgbnPe21smR19YL703U9PMswTffyYV
	 MOf/TA+Mgfa6mIX2vvExltOoGRgjwLuy3BpMqesRmvEBh+/o5evLcfVUwcvCuY2xK/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r8O2E23G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B85D606A31A;
	Fri, 23 Oct 2026 17:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r8O2E23G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6E31F01825;
	Fri, 23 Oct 2026 17:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774849;
	bh=mRuvDtwZFdG2diVPopnuUHF7yK8nqzHVkbSlif/PhUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r8O2E23Gw1fgc7AAI8ZjAb7BZzITivMzRxsEr6qeZCbjsDHoOxbBASJeCNR0/XNVl
	 9GkAl22yFPBowW+xG4VxwXISXpJPngQ8E7J8Ucp9CdteyD2XjHegO9zevsCXCNypI5
	 Vksue23+a6osUBDBiUQd132nq0i0cFeVcQ9btE6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.2 180/242] cifs: add revalidation on FSCTL failure in smb2_duplicate_extents()
Date: Fri, 23 Oct 2026 18:40:22 +0200
Message-ID: <20261023163718.039516515@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

commit 53676a5e28231186c9f56d87b7998b640699bc15 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2305,7 +2305,7 @@ smb2_duplicate_extents(const unsigned in
 			       trgtfile->fid.volatile_fid, tcon->tid,
 			       tcon->ses->Suid, src_off, dest_off, len);
 	inode = d_inode(trgtfile->dentry);
-	if (inode->i_size < dest_off + len) {
+	if (i_size_read(inode) < dest_off + len) {
 		rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
 		if (rc)
 			goto duplicate_extents_out;
@@ -2322,7 +2322,10 @@ smb2_duplicate_extents(const unsigned in
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


