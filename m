Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590056;
	b=5WHR9Bd4nyHiv6iTTi7TrJYSeiBfmzaIFnr0E6CPwIpVykzLarRV1QZeOtG6bGH8VpOh
	 JIoHm9mm7uTVRZVd01c6maRYhcmNTEdzX+8vVg7e1RBXM+mzhrNt0J0fEosn4I91/8yxJ
	 cTUKyl/gIjv47+t8wdd3ZsC9+x17D2Mbdi507Z9b+9MNC0Hb4IdLQ+uXdziMT1/c4IUC+
	 cDhZqCvLQLn81gjUFyY/x2waBxG8ZVw52xNVBlYVbVM/vQOpdjvfeLsnQa3mleIMbVA1M
	 k0YniNOV5jA01KGvfJuufXPPSUEIFiv3JiI/a043/YsCnAScxG+XY8s0EEgFBYL4j7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oAdm3GMsldrK9aA8D+9yYcZGoly8BzemHiVnANo7bjU=;
	b=Leiw2dsPsThgdmKMzUVQ9aW/Hj+6WRrnLn23afK2qmyNGIxSxiZbBHxmsb1MyW6ZOZwv
	 Fp9auP3ZjbnmctbNW4Hm5z+VwnuDlSg0UrEKyyJ2T88HRUY+WdTmVELDJ6n0rozLrpTFg
	 sSJkXi6GAnnt1XdWGn9LaiFVsHK1sW8KOI8kjqup9ARo71wUx1A570rAcXYZ2AkLq2H0e
	 sgzMVUoNXU15q87NUQ2bA3HOh4Q6Wz9iJ2rZ+qZUS7Mm982oGADOjgCENowafK76LtliO
	 +oeLsGaVW6xs7JU+YIgGBAdwNVm8UjbQYRPtAJW/3t/UWMc9PwDlDpbQBCyLV798d0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uBkPlB4p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E158F606A880;
	Fri, 13 Nov 2026 17:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uBkPlB4p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E41A1F000C6;
	Fri, 13 Nov 2026 17:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590055;
	bh=oAdm3GMsldrK9aA8D+9yYcZGoly8BzemHiVnANo7bjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uBkPlB4pXkWPwBx+GN8tdNNqPUmgm/vyJ8pwc3TmFI5YgLZhSB3VhoEZlIkYUJlDD
	 kKPrSCB/IFK2Dc1M9LjYWFgbyOizfm2+h38/zRRGIcgrR3am+SHZ1of6D+qT7swdWr
	 cZ1pbhnKW3HTUTf7KWnZ7gcdSMPrWaiwKAi40ea4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diego Oliva <diego@bynar.io>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 087/686] smb: client: reject FIND data areas that run past the received response
Date: Fri, 13 Nov 2026 10:43:40 -0500
Message-ID: <20261113153823.827003620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Diego Oliva <diego@bynar.io>

[ Upstream commit 29bd6773187cb5c1bbbdf90d677c6add7d58af26 ]

CIFSFindFirst() and CIFSFindNext() take the directory entries of a
TRANS2_FIND_FIRST2 or TRANS2_FIND_NEXT2 response from DataOffset for
DataCount bytes. validate_t2() bounds DataOffset at 1024 and
ParameterCount + DataCount by the byte count, and nothing compares
DataOffset + DataCount with the number of bytes SendReceive() copied
into the buffer.

smb_init() places the request and the response in the same
cifs_request allocation and cifs_buf_get() clears only the start of
it, so a short response whose data area extends past its end has
srch_entries_start point at bytes of the request that was just sent,
or at whatever the allocation held before, and those bytes are parsed
as directory entries. cifs_readdir() and find_cifs_entry() walk the
entries with nxt_dir_entry(), which checks every entry but the first
of a response against the end of the SMB; cifs_query_path_info() and
cifs_backup_query_path_info() read the first entry with no check at
all. Those reads stay inside the allocation, but what they return is
not part of the response. The last entry, which LastNameOffset locates
relative to the data area, is bounded against the received response
by an earlier patch of this series, as is every entry that
cifs_fill_dirent() parses; the walk itself and the two query functions
are not.

SMB1 is not negotiated by default; reaching this code requires an
explicit vers=1.0 mount.

Reject a response whose data area extends past the received length,
with the -EINVAL that validate_t2() returns for the other malformed
transaction responses. cifs_query_path_info() and
cifs_backup_query_path_info() still read a whole entry from a data
area that may be smaller than one; that is not changed here.

A conforming server is not affected. The data block of a transaction
response is part of the SMB, so DataOffset + DataCount cannot exceed
the smbCalcSize() bytes that SendReceive() copies; coalesce_t2()
appends each secondary response to the data area and adds its length
to both DataCount and the byte count, which keeps that relation.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: Bynario AI
Signed-off-by: Diego Oliva <diego@bynar.io>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ sashal: Adjusted declaration context in CIFSFindFirst() and CIFSFindNext() to account for the missing in_len variable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 1049a64241bc0..320274e7f7051 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -4325,8 +4325,9 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 /* level 257 SMB_ */
 	TRANSACTION2_FFIRST_REQ *pSMB = NULL;
 	TRANSACTION2_FFIRST_RSP *pSMBr = NULL;
-	T2_FFIRST_RSP_PARMS *parms;
+	unsigned int data_off, data_count;
 	struct nls_table *nls_codepage;
+	T2_FFIRST_RSP_PARMS *parms;
 	unsigned int lnoff;
 	__u16 params, byte_count;
 	int bytes_returned = 0;
@@ -4445,11 +4446,19 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 		return rc;
 	}
 
+	data_off = le16_to_cpu(pSMBr->t2.DataOffset);
+	data_count = le16_to_cpu(pSMBr->t2.DataCount);
+	if (data_off + data_count > (unsigned int)bytes_returned) {
+		cifs_dbg(VFS, "%s: data area offset %u count %u past response length %d\n",
+			 __func__, data_off, data_count, bytes_returned);
+		cifs_buf_release(pSMB);
+		return -EINVAL;
+	}
+
 	psrch_inf->unicode = !!(pSMBr->hdr.Flags2 & SMBFLG2_UNICODE);
 	psrch_inf->ntwrk_buf_start = (char *)pSMBr;
 	psrch_inf->smallBuf = false;
-	psrch_inf->srch_entries_start = (char *)&pSMBr->hdr.Protocol +
-		le16_to_cpu(pSMBr->t2.DataOffset);
+	psrch_inf->srch_entries_start = (char *)&pSMBr->hdr.Protocol + data_off;
 
 	parms = (T2_FFIRST_RSP_PARMS *)((char *)&pSMBr->hdr.Protocol +
 					le16_to_cpu(pSMBr->t2.ParameterOffset));
@@ -4482,8 +4491,9 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	TRANSACTION2_FNEXT_REQ *pSMB = NULL;
 	TRANSACTION2_FNEXT_RSP *pSMBr = NULL;
-	T2_FNEXT_RSP_PARMS *parms;
+	unsigned int data_off, data_count;
 	unsigned int name_len;
+	T2_FNEXT_RSP_PARMS *parms;
 	unsigned int lnoff;
 	__u16 params, byte_count;
 	char *response_data;
@@ -4566,13 +4576,22 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_buf_release(pSMB);
 		return rc;
 	}
+
+	data_off = le16_to_cpu(pSMBr->t2.DataOffset);
+	data_count = le16_to_cpu(pSMBr->t2.DataCount);
+	if (data_off + data_count > (unsigned int)bytes_returned) {
+		cifs_dbg(VFS, "%s: data area offset %u count %u past response length %d\n",
+			 __func__, data_off, data_count, bytes_returned);
+		cifs_buf_release(pSMB);
+		return -EINVAL;
+	}
+
 	/* BB fixme add lock for file (srch_info) struct here */
 	psrch_inf->unicode = !!(pSMBr->hdr.Flags2 & SMBFLG2_UNICODE);
 	response_data = (char *)&pSMBr->hdr.Protocol +
 		le16_to_cpu(pSMBr->t2.ParameterOffset);
 	parms = (T2_FNEXT_RSP_PARMS *)response_data;
-	response_data = (char *)&pSMBr->hdr.Protocol +
-		le16_to_cpu(pSMBr->t2.DataOffset);
+	response_data = (char *)&pSMBr->hdr.Protocol + data_off;
 
 	if (psrch_inf->smallBuf)
 		cifs_small_buf_release(psrch_inf->ntwrk_buf_start);
-- 
2.53.0



