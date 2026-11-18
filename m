Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021883;
	b=uzs9TRfen1nR/NV5NavwnWbqnE0U5x66FxoOQpZjEx0YwliyALQk3KRpvRaKd2G3R4g6
	 EzO3yo/WScIUGMKkKZ6xZzuJ27FG1UJEnfMtFyLk6LDytUImJ7wk6bbfsAZZKkUf9aTtd
	 i97yjmQ5Al0PSYQXjp3Qy2HK1v+trG1ooOjTsczPBtTZibiqEuYOUaKSP5TYLTBxniwae
	 pybFwWy/SJQfspy1ayjdtuizU+rEDCFXIefkBUZDa0O7K7YRT6YYy1+O8bpOcuPkiIphF
	 rkaunr/UlsLXBHMf4wkO9NceiGBn6o0QABJ2sp0WEyJz7jV9Gz9oXoDu+RPIRLsLlBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021883;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BptWKzM72etuDo5SW6Tc6Y/DUxb1TkkLSI2s3io+jt0=;
	b=R6e3WchvH7+3AK4JyaCRbgtDu13GW9ljtL5eWLQ+NKz4Rfe/9f8fKGLFuwYqafS6i4W+
	 PsRqyxkIrpR5N3MIQNcGXorBRwswo1Eh0HBZRRCC3vW8kUE8c1zcpqkEbEdV8Zef/FTBC
	 ozLZPSyupqSUK3X4HhsqBd0V5OD/VpzwoSxbpWZiZV0Q90i/Pdme6CO0I9FaZeFH9rOmM
	 RysHmLjDmZkkD50V2R12BlFnZB9rnPrnAEWJg2/d6iXJnI/+YjLvUm2x6f29nOszYNO/Y
	 mqNiP0E6sRuk859ocaHE7UM4slulsFmvVq4dsSy7K8Eno2IBReXxK0fLMlKVToxbtYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dY921yIU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53CB606A31C;
	Wed, 18 Nov 2026 17:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dY921yIU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5691F000C5;
	Wed, 18 Nov 2026 17:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021883;
	bh=BptWKzM72etuDo5SW6Tc6Y/DUxb1TkkLSI2s3io+jt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dY921yIUnVOyOpYrvWWKKKq5QqAdx0v8HzRTOMwArZGKNTRPxkAS5MhlFx+w12RxY
	 59JtgpQ0V84k4OdWgZJUFk0ckjfKnslZnHkgRL5VKLgDPo5PqY+3/cvVfOItElvrGf
	 7pfCig53DJW8U922AepXFXMwOiO9VTHSJpJ7Y4Gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2466/2651] ksmbd: fix SMB2 CREATE response buffer overflow in compound requests
Date: Wed, 18 Nov 2026 16:01:46 +0100
Message-ID: <20261118150413.796727609@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit d1557d8324c8f757229619f96f8227f7674bdd9e ]

A CREATE response that carries an AAPL create context can reach
create_rsp_size (572 bytes for SMB 3.1.1). Commit 713c31a3a225
("ksmbd: fix SMB2 CREATE response buffer overflow") makes
smb2_allocate_rsp_buf() reserve that much, but only for the first
command of a compound. A CREATE later in the compound is guarded by
is_chained_smb2_message() instead, which reserves only
MAX_CIFS_SMALL_BUFFER_SIZE (448 bytes) for the next response. smb2_open()
then appends the create contexts without checking the space left.

That check also uses the unpadded length of the response so far.
init_chained_smb2_rsp() pads the previous response to 8 bytes before the
next command runs, so the next response can start up to 7 bytes later
than the check assumes.

When a CREATE follows a command that fills the response buffer, such as
QUERY_DIRECTORY, it writes its create contexts past the end of the
buffer. The AAPL context is written last.

  BUG: KASAN: slab-out-of-bounds in create_aapl_rsp_buf+0x31/0x6e0 [ksmbd]
  Call Trace:
   create_aapl_rsp_buf+0x31/0x6e0 [ksmbd]
   smb2_open+0x4fa8/0xd900 [ksmbd]
   handle_ksmbd_work+0x88c/0x1cb0 [ksmbd]

When the next command is a CREATE, reserve create_rsp_size, as
smb2_allocate_rsp_buf() does for a single CREATE, and check the reserve
against the 8-byte aligned offset where the next response starts.

Fixes: 8f1b796ff113 ("ksmbd: add AAPL kAAPL_SERVER_QUERY create context support")
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 55aa09a07aed4..d43ea48fcaf31 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -694,6 +694,9 @@ bool is_chained_smb2_message(struct ksmbd_work *work)
 	hdr = ksmbd_req_buf_next(work);
 	next_cmd = le32_to_cpu(hdr->NextCommand);
 	if (next_cmd > 0) {
+		size_t next_rsp_sz = MAX_CIFS_SMALL_BUFFER_SIZE;
+		struct smb2_hdr *next_hdr;
+
 		if ((u64)work->next_smb2_rcv_hdr_off + next_cmd +
 			__SMB2_HEADER_STRUCTURE_SIZE >
 		    get_rfc1002_len(work->request_buf)) {
@@ -702,8 +705,19 @@ bool is_chained_smb2_message(struct ksmbd_work *work)
 			return false;
 		}
 
-		if ((u64)get_rfc1002_len(work->response_buf) + MAX_CIFS_SMALL_BUFFER_SIZE >
-		    work->response_sz) {
+		/*
+		 * The next response starts at the 8-byte aligned end of this one.
+		 * smb2_open() appends create contexts without checking the space
+		 * left, so reserve the largest CREATE response for a chained
+		 * CREATE, as smb2_allocate_rsp_buf() does for a single one.
+		 */
+		next_hdr = (struct smb2_hdr *)((char *)hdr + next_cmd);
+		if (le16_to_cpu(next_hdr->Command) == SMB2_CREATE_HE)
+			next_rsp_sz = max_t(size_t, next_rsp_sz,
+					    work->conn->vals->create_rsp_size);
+
+		if ((u64)ALIGN(get_rfc1002_len(work->response_buf), 8) +
+		    next_rsp_sz > work->response_sz) {
 			pr_err("next response offset exceeds response buffer size\n");
 			return false;
 		}
-- 
2.53.0



