Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208420;
	b=elHg8A2ZuB5t0qBl2C22c+nW0lTpcGc7uS0UTFgtu3TaOhvm9hONjyFlj5qjmUtN2ZvJ
	 HrsWX0YAj5o8S+YGPJbpCC5jgOhDkz2uIB5xXFirjZQK1ng2Nm4Owseep8fBp4MWXv6+a
	 3yshUGF61CD9lL3mr12v6YzKDDE+cnE4s2AGGedAScfQWMftocR7QwHc0RBdVSOaG0yu/
	 ZyVgvExuiiASyXHhU1FQkJkl8en78BIeGXmtQxzmxaLHwBZ84pOP0uTB1C49x5c4BPyff
	 SLbSBa683ooHsEsq7E9cDTM2wtds/t7bl1joHKx+dRxmid5/rDrbOb91ti5mdwpI3TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WrfEn8Tpro0vHKbBwgj7A1FUf9G+dgCJvwqtSz3ELJ4=;
	b=wpQ36W5cVW8L+iS6tmSUcscaxmEZw11KSG/TNr2cXqVwNNICJCQAn6YnEtJZOGKQPrFE
	 86jhnJobaxYaifdyhL6dUfo9X1+Q3WHxzEMZohYsHTwnBXL9sYBvDVqFKRYA58/L6w3r+
	 EwbwjFcZAGZETVrnPZqxkpWwtj8nyC58go18xDbC4M+pyH2DtH0aOOMZ5h7Wry8nC51vH
	 oYWr4HWpJ86PVTHBxCC1LwuVw0zSn/UnCUjBPaqF+ail0H7/UmuSeyCRitsIwS67UvPjQ
	 cx0WbQso0F78CjG+dmoXFma1O+87HbUMA2f8lQXJkfOZwV8qoyS5m276+PpopG5subw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XUEcu+MU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4990A606A31A;
	Wed, 28 Oct 2026 17:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XUEcu+MU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17A61F01825;
	Wed, 28 Oct 2026 17:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208420;
	bh=WrfEn8Tpro0vHKbBwgj7A1FUf9G+dgCJvwqtSz3ELJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XUEcu+MU9ZhdU401uiVyr2+Tln++HcRgYlVlNm5kwPXCpIqP19k/Qo5NZkXk5LBJg
	 dVpuYNzNNKSrPWGXBbcxZB8HIoq1RpQZi/7F+zUVqJpy3HF1cHZCCkBxbxTBUIPOLr
	 yuFKFe42shuQVFb8cdVofAfRIJJuNNohFKCT1MBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>,
	Zihan Xi <zihanx@nebusec.ai>,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/516] smb: client: fix create context out-of-bounds reads
Date: Wed, 28 Oct 2026 17:54:26 +0100
Message-ID: <20261028170006.219036688@linuxfoundation.org>
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

From: Zihan Xi <zihanx@nebusec.ai>

[ Upstream commit 67f4c1c6a1b51e203d986779299824d1c2c590a6 ]

smb2_parse_contexts() validates the complete create-context area but
does not limit each record to its Next field before dispatching it.  A
malformed chain can therefore expose bytes beyond the current context to
a handler.  The QFid handler also used a full response-structure cast
although it only reads DiskFileId.

The SMB2/SMB3 lease parsers made the same layout assumption: they read
LeaseState and LeaseFlags at canonical offsets rather than at
DataOffset.  A valid non-canonical DataOffset could therefore yield
unrelated in-bounds data, while a short DataLength was still accepted.

Limit each context to its Next value, reject offsets before the context
header, and reject malformed chains.  Bound the name range by the current
context and do not dispatch a known handler when DataLength is zero.  Read
the QFid DiskFileId only when the context data covers that field.  Parse the
lease context from DataOffset and require DataLength to match the v1 or v2
lease_context size used by ksmbd.  A size mismatch skips lease parsing
without failing the open.

Fixes: b8c32dbb0deb ("CIFS: Request SMB2.1 leases")
Fixes: f047390a097e ("CIFS: Add create lease v2 context for SMB3")
Fixes: 89a5bfa350fa ("smb3: optimize open to not send query file internal info")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Tested-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 28 ++++++++++++++++++++--------
 fs/cifs/smb2pdu.c | 44 ++++++++++++++++++++++++++++++++++----------
 2 files changed, 54 insertions(+), 18 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 8261e08080d09..5d07e1400015b 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4171,25 +4171,37 @@ smb3_create_lease_buf(u8 *lease_key, u8 oplock)
 static __u8
 smb2_parse_lease_buf(void *buf, unsigned int *epoch, char *lease_key)
 {
-	struct create_lease *lc = (struct create_lease *)buf;
+	struct create_context *cc = buf;
+	struct lease_context lc;
 
 	*epoch = 0; /* not used */
-	if (lc->lcontext.LeaseFlags & SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE)
+	if (le32_to_cpu(cc->DataLength) != sizeof(lc))
+		return 0;
+
+	memcpy(&lc, (u8 *)cc + le16_to_cpu(cc->DataOffset), sizeof(lc));
+	if (lc.LeaseFlags & SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE)
 		return SMB2_OPLOCK_LEVEL_NOCHANGE;
-	return le32_to_cpu(lc->lcontext.LeaseState);
+	return le32_to_cpu(lc.LeaseState);
 }
 
 static __u8
 smb3_parse_lease_buf(void *buf, unsigned int *epoch, char *lease_key)
 {
-	struct create_lease_v2 *lc = (struct create_lease_v2 *)buf;
+	struct create_context *cc = buf;
+	struct lease_context_v2 lc;
+
+	if (le32_to_cpu(cc->DataLength) != sizeof(lc)) {
+		*epoch = 0;
+		return 0;
+	}
 
-	*epoch = le16_to_cpu(lc->lcontext.Epoch);
-	if (lc->lcontext.LeaseFlags & SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE)
+	memcpy(&lc, (u8 *)cc + le16_to_cpu(cc->DataOffset), sizeof(lc));
+	*epoch = le16_to_cpu(lc.Epoch);
+	if (lc.LeaseFlags & SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE)
 		return SMB2_OPLOCK_LEVEL_NOCHANGE;
 	if (lease_key)
-		memcpy(lease_key, &lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
-	return le32_to_cpu(lc->lcontext.LeaseState);
+		memcpy(lease_key, lc.LeaseKey, SMB2_LEASE_KEY_SIZE);
+	return le32_to_cpu(lc.LeaseState);
 }
 
 static unsigned int
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index a10431a9f9e99..0205307d0f9cd 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1955,11 +1955,17 @@ create_reconnect_durable_buf(struct cifs_fid *fid)
 static void
 parse_query_id_ctxt(struct create_context *cc, struct smb2_file_all_info *buf)
 {
-	struct create_disk_id_rsp *pdisk_id = (struct create_disk_id_rsp *)cc;
+	u16 doff = le16_to_cpu(cc->DataOffset);
+	u32 dlen = le32_to_cpu(cc->DataLength);
+	u8 *beg;
 
-	cifs_dbg(FYI, "parse query id context 0x%llx 0x%llx\n",
-		pdisk_id->DiskFileId, pdisk_id->VolumeId);
-	buf->IndexNumber = pdisk_id->DiskFileId;
+	if (dlen < sizeof(__le64))
+		return;
+
+	beg = (u8 *)cc + doff;
+	memcpy(&buf->IndexNumber, beg, sizeof(__le64));
+	cifs_dbg(FYI, "parse query id context 0x%llx\n",
+		 le64_to_cpu(buf->IndexNumber));
 }
 
 static void
@@ -2007,6 +2013,7 @@ int smb2_parse_contexts(struct TCP_Server_Info *server,
 	struct smb2_create_rsp *rsp = rsp_iov->iov_base;
 	struct create_context *cc;
 	size_t rem, off, len;
+	size_t cc_len;
 	size_t doff, dlen;
 	size_t noff, nlen;
 	char *name;
@@ -2029,29 +2036,41 @@ int smb2_parse_contexts(struct TCP_Server_Info *server,
 		buf->IndexNumber = 0;
 
 	while (rem >= sizeof(*cc)) {
+		off = le32_to_cpu(cc->Next);
+		if (off) {
+			if ((off & 0x7) || off >= rem || off < sizeof(*cc))
+				return -EINVAL;
+			cc_len = off;
+		} else {
+			cc_len = rem;
+		}
+
 		doff = le16_to_cpu(cc->DataOffset);
 		dlen = le32_to_cpu(cc->DataLength);
-		if (check_add_overflow(doff, dlen, &len) || len > rem)
+		if (doff < sizeof(*cc) ||
+		    check_add_overflow(doff, dlen, &len) || len > cc_len)
 			return -EINVAL;
 
 		noff = le16_to_cpu(cc->NameOffset);
 		nlen = le16_to_cpu(cc->NameLength);
-		if (noff + nlen > doff)
+		if (noff < sizeof(*cc) ||
+		    check_add_overflow(noff, nlen, &len) || len > cc_len ||
+		    (dlen && len > doff))
 			return -EINVAL;
 
 		name = (char *)cc + noff;
 		switch (nlen) {
 		case 4:
-			if (!strncmp(name, SMB2_CREATE_REQUEST_LEASE, 4)) {
+			if (dlen && !strncmp(name, SMB2_CREATE_REQUEST_LEASE, 4)) {
 				*oplock = server->ops->parse_lease_buf(cc, epoch,
 								       lease_key);
-			} else if (buf &&
+			} else if (dlen && buf &&
 				   !strncmp(name, SMB2_CREATE_QUERY_ON_DISK_ID, 4)) {
 				parse_query_id_ctxt(cc, buf);
 			}
 			break;
 		case 16:
-			if (posix && !memcmp(name, smb3_create_tag_posix, 16))
+			if (dlen && posix && !memcmp(name, smb3_create_tag_posix, 16))
 				parse_posix_ctxt(cc, buf, posix);
 			break;
 		default:
@@ -2063,13 +2082,18 @@ int smb2_parse_contexts(struct TCP_Server_Info *server,
 		}
 
 		off = le32_to_cpu(cc->Next);
-		if (!off)
+		if (!off) {
+			rem = 0;
 			break;
+		}
 		if (check_sub_overflow(rem, off, &rem))
 			return -EINVAL;
 		cc = (struct create_context *)((u8 *)cc + off);
 	}
 
+	if (rem)
+		return -EINVAL;
+
 	if (rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE)
 		*oplock = rsp->OplockLevel;
 
-- 
2.53.0



