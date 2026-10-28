Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208417;
	b=XguutjMyQdUGTjmfvM5Kmug4YnPVKPzS4HiRB8wU44/7cZqzIQVKGxKuh+xL5L/1paUF
	 UmH9IDybindvH2ZzyAPnlfI2mxcvPKnoSQNwgeIiEWWQD/3u2ARrwJAWsrWRgf2sjDTiT
	 i0q6jOT3rm3YCBnB4zP7Sgv2Ku9Rb3ZxQQPdA7r1h4ouPNO1VUKkruHpo4U+0rNwMJ9zP
	 A4vTSDe2np2v59U2NVnxxDcJYc7Vt4XyBkd6Cstg7RbBjK2EcWvetX2k1lPY8OISeAW4B
	 Wi/N5ojy6m8mNIH6kPO1ll5zy+LiWaPlefmEhhOKooajhu+txAdUdjno1PVQxAWF5rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=owGm5EeWyinSgEsgPVv/teLyBOlsyG9PBGwqAUdyLYU=;
	b=wv1oASnAlsKzZU1dC1MrET4w2oaj57k2qFhWPWVz2rwUJVfKFauRfL0i5DxrX/uC2ttV
	 5Vsts9NyDHekwKlCnGubVZ4bPT3vNYpRukwWgWg5Uy2YttjtxkHB+y3KIEfEtjfv8DpcT
	 LiFAGC57lK90bsovF1szMDWLkjMhNA8C4kQoWv0IbiaVU1xQN1b5P8nH5zS0SlehF+sSE
	 hS/aRok8HGRsyRSDL4VaUsUKAOCrWLltWvMf1/tvGe30BZJImK/NiYWf7tq0pnxPF51He
	 Cl8hLCfnd2lf/o/qLInY6+C/aSCpdW7LYyimvoHsJPamcgW99JnyzF0kQmkUTG9BYrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bh/P5/mn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FC8606A31A;
	Wed, 28 Oct 2026 17:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bh/P5/mn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F871F01825;
	Wed, 28 Oct 2026 17:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208417;
	bh=owGm5EeWyinSgEsgPVv/teLyBOlsyG9PBGwqAUdyLYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bh/P5/mnmGi92xd8Y3Lc86+xBD1lYGK879U07HL5haNll0ggI0SmSvnA2FBbiV7Qj
	 4k5FFyBnXahuVE6bcr314wHWYhJXYb3Lzb1jNyT5bFn60Q2ow86kd8U/U0b4Zl7nqP
	 SsO4XxKZc31a6SGG5hi4ZI2YyORyJGci6xD5JuhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/516] smb3: make query_on_disk_id open context consistent and move to common code
Date: Wed, 28 Oct 2026 17:54:25 +0100
Message-ID: <20261028170006.195677549@linuxfoundation.org>
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

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 1149c8467ddebfb6bb9aab37830f70a49cab7085 ]

cifs and ksmbd were using a slightly different version of the query_on_disk_id
struct which could be confusing. Use the ksmbd version of this struct, and
move it to common code.

Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>

[5.15 dependency adaptation for 67f4c1c6a1b:
Keep the create-context declarations in the existing per-subsystem headers.
This tree has not consolidated create_context into smbfs_common, and ksmbd
still defines its own SMB2 headers. Moving the response into the common
header would require unrelated header conversions.

Retain the client response rename and match ksmbd's 16-byte Reserved array,
without changing the packed wire layout. Leave the ksmbd and common headers
unchanged and omit the upstream common-header lease comments.

Rename the client's lease-break flag and both existing parser uses to the
upstream _LE spelling. This is a value-preserving prerequisite for the
target's lease-parser changes; no functions are added.]

[ sashal: Reduced backport -- upstream 1149c8467ddeb touches 4 file(s), this
  backport carries 3. Not backported here:
  fs/ksmbd/smb2pdu.h
  fs/smbfs_common/smb2pdu.h
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 67f4c1c6a1b5 ("smb: client: fix create context out-of-bounds reads")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 4 ++--
 fs/cifs/smb2pdu.c | 2 +-
 fs/cifs/smb2pdu.h | 6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 65a85f7388eef..8261e08080d09 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4174,7 +4174,7 @@ smb2_parse_lease_buf(void *buf, unsigned int *epoch, char *lease_key)
 	struct create_lease *lc = (struct create_lease *)buf;
 
 	*epoch = 0; /* not used */
-	if (lc->lcontext.LeaseFlags & SMB2_LEASE_FLAG_BREAK_IN_PROGRESS)
+	if (lc->lcontext.LeaseFlags & SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE)
 		return SMB2_OPLOCK_LEVEL_NOCHANGE;
 	return le32_to_cpu(lc->lcontext.LeaseState);
 }
@@ -4185,7 +4185,7 @@ smb3_parse_lease_buf(void *buf, unsigned int *epoch, char *lease_key)
 	struct create_lease_v2 *lc = (struct create_lease_v2 *)buf;
 
 	*epoch = le16_to_cpu(lc->lcontext.Epoch);
-	if (lc->lcontext.LeaseFlags & SMB2_LEASE_FLAG_BREAK_IN_PROGRESS)
+	if (lc->lcontext.LeaseFlags & SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE)
 		return SMB2_OPLOCK_LEVEL_NOCHANGE;
 	if (lease_key)
 		memcpy(lease_key, &lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 19b4f426e9afa..a10431a9f9e99 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1955,7 +1955,7 @@ create_reconnect_durable_buf(struct cifs_fid *fid)
 static void
 parse_query_id_ctxt(struct create_context *cc, struct smb2_file_all_info *buf)
 {
-	struct create_on_disk_id *pdisk_id = (struct create_on_disk_id *)cc;
+	struct create_disk_id_rsp *pdisk_id = (struct create_disk_id_rsp *)cc;
 
 	cifs_dbg(FYI, "parse query id context 0x%llx 0x%llx\n",
 		pdisk_id->DiskFileId, pdisk_id->VolumeId);
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index f92a431617d58..e2f2cdb7d7c3c 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -555,7 +555,7 @@ struct create_context {
 #define SMB2_LEASE_HANDLE_CACHING	cpu_to_le32(0x02)
 #define SMB2_LEASE_WRITE_CACHING	cpu_to_le32(0x04)
 
-#define SMB2_LEASE_FLAG_BREAK_IN_PROGRESS cpu_to_le32(0x00000002)
+#define SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE cpu_to_le32(0x00000002)
 #define SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET cpu_to_le32(0x00000004)
 
 #define SMB2_LEASE_KEY_SIZE 16
@@ -637,12 +637,12 @@ struct durable_reconnect_context_v2 {
 } __packed;
 
 /* See MS-SMB2 2.2.14.2.9 */
-struct create_on_disk_id {
+struct create_disk_id_rsp {
 	struct create_context ccontext;
 	__u8   Name[8];
 	__le64 DiskFileId;
 	__le64 VolumeId;
-	__u32  Reserved[4];
+	__u8  Reserved[16];
 } __packed;
 
 /* See MS-SMB2 2.2.14.2.12 */
-- 
2.53.0



