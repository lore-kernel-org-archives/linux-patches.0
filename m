Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829237;
	b=pmIkPtJb38QADeCmLnvslxeR6BGNzvyZpTiiMD9BHaTSjAcOmZDYUKJDzdQkGYB2h6Bs
	 wulVBNsd6wYwLo4dyleS69ZQuXRWL+MpdCCSlgS2OcGzzExnAZGoTZ+l2lnUvQ3Lqs/JT
	 ouX3CJq/GHxlwsssEP8MyCU0DUn+p4Zd/9znSbmFpCYi1KqIhHCcmJAzyKLVMi4fNo2MA
	 g3k4KZNWm2G2dvPPftDCykzcpG7LinugQ744IVysCOJD//5n6GVT/bWeqypLR4R/PJE1G
	 dWlB8iAu7vkZPCBhTbA09jRFaiNZBLftPXvhpIwTGxbWtVK2ZwFT5Yh+VjqxF258e8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829237;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pvc+aBPYxX1eRo1w+vr+DgU3Wh+yp8jJVIoZnjmGSRs=;
	b=AKVuTmgFqughNx2NEpDa/OLbFsAtbA43F3gQj1gLIAEG4o8JTfcWzaW8tV2UKhxXOor7
	 YRlXXh+PBM2ULWBANZCVgFbo134tCcSPHpILvcbPP2i+jUkB5PgnUu3qQCavyanibZrL4
	 Y9W18gS340uqA3+QUJI03edUVGXIbJxl18YNSEsrVK/aLMEGRZ5ehwpSy/jyjC0VmaPlH
	 h021KKmOyvcnQTWsgQv+k4Ho1jFln6SEqJuBL9Fl16gfW3LVM5xG/tsM5p66bU3ESkhLD
	 iqB80/JlL+pX5K0K/Q4jgSSx9JT1aDXnu83U36SYcttDtUmTdNnUzjIb+pq1zJrCjyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ey0hQ1wZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DA7606D80D;
	Wed,  4 Nov 2026 21:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ey0hQ1wZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADA81F000C1;
	Wed,  4 Nov 2026 21:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829237;
	bh=pvc+aBPYxX1eRo1w+vr+DgU3Wh+yp8jJVIoZnjmGSRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ey0hQ1wZ2xPZAzgk94NJK+jTkehkATnO2tSONLkFjq58N2cP5gDEaBXQYfsnW5vMs
	 35H5aT5yOQMp3ZbQFrNUZMErwSeoJFgUvaQ9SVinxOHUYe8FfqOT9hJ3bpQce02dVK
	 2sSb8KOzRUeUEOCA0K0d0cvjl9viYvsEFgeMjOtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 534/547] ksmbd: fix SMB2 CREATE response buffer overflow
Date: Wed,  4 Nov 2026 16:11:58 -0500
Message-ID: <20261104211053.565517560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 713c31a3a225b6239a37ac7fbfb394567f8b3519 ]

smb2_allocate_rsp_buf() uses the MAX_CIFS_SMALL_BUFFER_SIZE
(448-byte) buffer for a single SMB2_CREATE response. That buffer also
holds a 4-byte length field, which only leaves 444 bytes for the SMB2
body.

The AAPL response made this buffer too small. After 8f1b796ff113, a
request with AAPL response contexts may need at least 456 bytes. In
the 456-byte case, create_aapl_rsp_buf() is appended last, clears 128
bytes, and writes 12 bytes past the allocation.

KASAN reports:

    BUG: KASAN: slab-out-of-bounds in create_aapl_rsp_buf+0x31/0x6e0
    Write of size 128 at addr ffff88800370954c by task kworker/0:0/9
    ...
    create_aapl_rsp_buf+0x31/0x6e0
    smb2_open+0x58f9/0xef10
    ...
    smb2_allocate_rsp_buf+0x19d/0x370
    ...
    The buggy address is located 332 bytes inside of
     allocated 448-byte region [ffff888003709400, ffff8880037095c0)

Reserve enough space for any fixed CREATE response KSMBD can build.
Store the required allocation size in the per-dialect values table.
This keeps the small buffer for other commands and avoids using the max
transaction buffer for every CREATE.

Fixes: 8f1b796ff113 ("ksmbd: add AAPL kAAPL_SERVER_QUERY create context support")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: 714f27729121 ("ksmbd: fix out-of-bounds read when padding the final compound response")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/common/smbglob.h |    1 +
 fs/smb/server/smb2ops.c |   33 +++++++++++++++++++++++++++++++++
 fs/smb/server/smb2pdu.c |    6 +++++-
 3 files changed, 39 insertions(+), 1 deletion(-)

--- a/fs/smb/common/smbglob.h
+++ b/fs/smb/common/smbglob.h
@@ -40,6 +40,7 @@ struct smb_version_values {
 	size_t		create_disk_id_size;
 	size_t		create_posix_size;
 	size_t		create_aapl_size;
+	size_t		create_rsp_size;
 };
 
 static inline unsigned int get_rfc1002_len(void *buf)
--- a/fs/smb/server/smb2ops.c
+++ b/fs/smb/server/smb2ops.c
@@ -13,6 +13,35 @@
 #include "server.h"
 #include "stats.h"
 
+/*
+ * work->response_sz includes the RFC1002 length field while smb_get_msg()
+ * skips over it. Durable v1 and v2 response contexts are mutually exclusive,
+ * and POSIX CREATE contexts are only negotiated for SMB3.1.1.
+ */
+#define SMB2_CREATE_RSP_SIZE(lease_size, durable_size)			\
+	(sizeof(__be32) + offsetof(struct smb2_create_rsp, Buffer) +	\
+	 (lease_size) + (durable_size) +				\
+	 sizeof(struct create_mxac_rsp) +				\
+	 sizeof(struct create_disk_id_rsp) +				\
+	 AAPL_RSP_MAX_SIZE)
+
+#define SMB21_CREATE_RSP_SIZE						\
+	SMB2_CREATE_RSP_SIZE(sizeof(struct create_lease),		\
+			     sizeof(struct create_durable_rsp))
+
+#define SMB3_CREATE_DURABLE_RSP_SIZE					\
+	((sizeof(struct create_durable_rsp) >				\
+	  sizeof(struct create_durable_rsp_v2)) ?			\
+	 sizeof(struct create_durable_rsp) :				\
+	 sizeof(struct create_durable_rsp_v2))
+
+#define SMB3_CREATE_RSP_SIZE						\
+	SMB2_CREATE_RSP_SIZE(sizeof(struct create_lease_v2),		\
+			     SMB3_CREATE_DURABLE_RSP_SIZE)
+
+#define SMB311_CREATE_RSP_SIZE						\
+	(SMB3_CREATE_RSP_SIZE + sizeof(struct create_posix_rsp))
+
 static struct smb_version_values smb21_server_values = {
 	.version_string = SMB21_VERSION_STRING,
 	.protocol_id = SMB21_PROT_ID,
@@ -38,6 +67,7 @@ static struct smb_version_values smb21_s
 	.create_disk_id_size = sizeof(struct create_disk_id_rsp),
 	.create_posix_size = sizeof(struct create_posix_rsp),
 	.create_aapl_size = AAPL_RSP_MAX_SIZE,
+	.create_rsp_size = SMB21_CREATE_RSP_SIZE,
 };
 
 static struct smb_version_values smb30_server_values = {
@@ -66,6 +96,7 @@ static struct smb_version_values smb30_s
 	.create_disk_id_size = sizeof(struct create_disk_id_rsp),
 	.create_posix_size = sizeof(struct create_posix_rsp),
 	.create_aapl_size = AAPL_RSP_MAX_SIZE,
+	.create_rsp_size = SMB3_CREATE_RSP_SIZE,
 };
 
 static struct smb_version_values smb302_server_values = {
@@ -94,6 +125,7 @@ static struct smb_version_values smb302_
 	.create_disk_id_size = sizeof(struct create_disk_id_rsp),
 	.create_posix_size = sizeof(struct create_posix_rsp),
 	.create_aapl_size = AAPL_RSP_MAX_SIZE,
+	.create_rsp_size = SMB3_CREATE_RSP_SIZE,
 };
 
 static struct smb_version_values smb311_server_values = {
@@ -122,6 +154,7 @@ static struct smb_version_values smb311_
 	.create_disk_id_size = sizeof(struct create_disk_id_rsp),
 	.create_posix_size = sizeof(struct create_posix_rsp),
 	.create_aapl_size = AAPL_RSP_MAX_SIZE,
+	.create_rsp_size = SMB311_CREATE_RSP_SIZE,
 };
 
 static struct smb_version_ops smb2_0_server_ops = {
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -873,14 +873,18 @@ static void smb2_update_lock_sequence(st
 int smb2_allocate_rsp_buf(struct ksmbd_work *work)
 {
 	struct smb2_hdr *hdr = smb_get_msg(work->request_buf);
+	struct smb_version_values *vals = work->conn->vals;
 	size_t small_sz = MAX_CIFS_SMALL_BUFFER_SIZE;
-	size_t large_sz = small_sz + work->conn->vals->max_trans_size;
+	size_t large_sz = small_sz + vals->max_trans_size;
 	size_t sz = small_sz;
 	int cmd = le16_to_cpu(hdr->Command);
 
 	if (cmd == SMB2_IOCTL_HE || cmd == SMB2_QUERY_DIRECTORY_HE)
 		sz = large_sz;
 
+	if (cmd == SMB2_CREATE_HE)
+		sz = max_t(size_t, sz, vals->create_rsp_size);
+
 	if (cmd == SMB2_QUERY_INFO_HE) {
 		struct smb2_query_info_req *req;
 


