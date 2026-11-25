Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620227;
	b=wkuZoXtpJtT2Eu/r/AHI3/plfxNVQztmLdKWIMX0e9PpI9G72qv946OwJ+9sqMwXs2hl
	 dXWr0rsaxmhQK5L/LKzd3GjFAHjEErE2+TSo2pED9B8zGEInWkdUDrdoxBaL3dSXko1rd
	 sfDfbnlrMGV5jxec2QX/qdaMraRzyvVmbBdCuRZVT8BGMktLxqGQhe1rn8/Ozs0LxMwFF
	 Rr25lJCADd9XXM7hs7dqkgba7P5mMY1+UOsc+2eM5oZU65tM9VKRVUh41CHfRAZTwuxZJ
	 J2n+pD83mC377fog/G4gIDiBKNUEwCbgRRCp4i4cIuyAxceludaCJSzjEYov7XZuJVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J1xA38aAcotWootxn1fPXyUe8pS6Baov0+nZIu5DaTE=;
	b=euula5MH9F1gmFoHpYNQDo4DCcfyUX0m/tfUToacmk+c7NSirGN778YGUlvSjNaWVQya
	 ooPAKs8uwmweSTSi0V2jiQlviOVlekw7pKYRo63OKnrUag5rPj19Hkj95qBpw2VdOIoQH
	 Uop8X6n2cd6iE7LQasICuBmbBa6EG3danl0Ic3Y2KXgPHCOuLILtBr2baIC97tsZUT9Xg
	 MfFWwGfBzW0+2wMB0J7zkKUq9KJCdhAlXI1S6xuSvXRrCMxqrTItzPRGe3ojzkvpm4j9h
	 Mvv1Oat7Q916RZ8XwAr6YYTISiLTjnOzSloYp9yIwIJCgXoNvTUrEwpKjXV4sgHtZPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0I4dXOsW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EEB606A331;
	Wed, 25 Nov 2026 15:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0I4dXOsW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7E61F000C4;
	Wed, 25 Nov 2026 15:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620227;
	bh=J1xA38aAcotWootxn1fPXyUe8pS6Baov0+nZIu5DaTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0I4dXOsWkmANSl9bWqJUwGq9kEp9ZJoOTsTwEzvP32edN/f/yRIuUQjeg/8NKBT4F
	 i4scfvJYmVD8i/byHWCo7TB2HNqfLybWhiyExWftbuGOj8HmkrrkRz543pcVxZU9RB
	 n4CjBhAhn1jM3gwwHKtqV8n/zP/QKqdoAxKlf8LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 0851/1005] smb: client: dont write back through O_DIRECT handles
Date: Wed, 25 Nov 2026 15:36:29 +0100
Message-ID: <20261125143841.645169082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

commit 0e85145af984f7cae2aadaa694cb8612009027ac upstream.

Writeback uses the first writable handle of the inode, which may have
been opened with O_DIRECT.  Such handles are opened with
FILE_NO_INTERMEDIATE_BUFFERING, for which Windows rejects any unaligned
I/O with STATUS_INVALID_PARAMETER.  Writeback of partly dirty pages and
of the unaligned tail of a file through one of them fails, so netfs ends
it with the folios clean and the data never reaches the server.

xfstests generic/051, where fsstress mixes both kinds of opens, loses
about 1% of its writes this way:

  smb3_write_err: ... offset=0xde90d7 len=0xbd0b rc=-22

All the rejected writes in a network capture were unaligned writes on a
no-buffering handle; none of the aligned ones, and none of the unaligned
ones on regular handles, were.

Prefer a handle that was not opened with O_DIRECT, and use one that was
only if there is no other.

Fixes: 1013e760d10e ("SMB3: Don't ignore O_SYNC/O_DSYNC and O_DIRECT flags")
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsglob.h |    1 +
 fs/smb/client/file.c     |   15 ++++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1897,6 +1897,7 @@ enum cifs_find_flags {
 	FIND_WITH_DELETE	= (1U << 1),
 	FIND_NO_PENDING_DELETE	= (1U << 2),
 	FIND_OPEN_FLAGS		= (1U << 3),
+	FIND_NO_DIRECT		= (1U << 4),
 };
 
 #define   MID_FREE 0
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -362,9 +362,15 @@ static void cifs_begin_writeback(struct
 	struct cifs_io_request *req = container_of(wreq, struct cifs_io_request, rreq);
 	int ret;
 
-	ret = cifs_get_writable_file(CIFS_I(wreq->inode), FIND_ANY, &req->cfile);
+	ret = cifs_get_writable_file(CIFS_I(wreq->inode), FIND_NO_DIRECT,
+				     &req->cfile);
 	if (ret) {
-		cifs_dbg(VFS, "No writable handle in writepages ret=%d\n", ret);
+		ret = cifs_get_writable_file(CIFS_I(wreq->inode), FIND_ANY,
+					     &req->cfile);
+	}
+	if (ret) {
+		cifs_dbg(VFS, "%s: couldn't find writable handle: %d\n",
+			 __func__, ret);
 		return;
 	}
 
@@ -2835,7 +2841,7 @@ int __cifs_get_writable_file(struct cifs
 	}
 
 	if (test_bit(CIFS_INO_TMPFILE, &cifs_inode->flags))
-		find_flags = FIND_ANY;
+		find_flags &= FIND_NO_DIRECT;
 
 	cifs_sb = CIFS_SB(cifs_inode);
 
@@ -2865,6 +2871,9 @@ refind_writable:
 		    !open_flags_match(cifs_inode, open_flags,
 				      open_file->f_flags))
 			continue;
+		if ((find_flags & FIND_NO_DIRECT) &&
+		    (open_file->f_flags & O_DIRECT))
+			continue;
 		if (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE) {
 			if (!open_file->invalidHandle) {
 				/* found a good writable file */


