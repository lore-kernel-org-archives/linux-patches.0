Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0047514532F;
	Thu, 23 May 2024 13:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470784; cv=none; b=Yuj94Y1AdeI8U5bEUNyoRx+lfxeCtlB5Pqe7dAf2G2EyjgI9io8W4NlDZG+NO5iSXI1FJJ8Vwc1T8DE1vj2lERaiGZHffSjkxuxj/EWzpLPKmsex5HZ/3c+8zN0ec7S2FCTDNq7G42lt8JZUrmUuOY7KbUPeJ6LWSEBOFK2qisg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470784; c=relaxed/simple;
	bh=VF/DR9MiXbxrS+lp6+kcTSwYkNEWuk9b2mcGHbc8Z1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4U7F2ujOsuXYTC3KEvXle3GMl2CJOxqqJw63toNvYtvqqWL36WDDPZE/iZMFDemNVwvhHHuph+vVFFackbQab9cZE01VMoruaI9GqMAGkuO1mRJJhHWCd9tfMhh9IrjUDCKer6kjSQ6sFkx+cAkamFgF10doVuHxZUaKL/vyac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=175p1sH7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="175p1sH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76303C3277B;
	Thu, 23 May 2024 13:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470783;
	bh=VF/DR9MiXbxrS+lp6+kcTSwYkNEWuk9b2mcGHbc8Z1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=175p1sH7U14kfk7N+u+c4PJI2Cg/NoXETfAn0LGiNZGKKbsLX5OLvfejIj3Sjw2Y7
	 C0obvzpm25NGx0CYlw3oHgwTNpC5uJzJJswT9Bwb21gidDzprGzgaM13ABEmDG3tWU
	 xOLVv8XrRVLTpZd7SPEZsriuDWeqDlpPpPd1cNyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/102] smb: client: negotiate compression algorithms
Date: Thu, 23 May 2024 15:13:21 +0200
Message-ID: <20240523130344.578698413@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enzo Matsumiya <ematsumiya@suse.de>

[ Upstream commit 8fe7062b7d11fcd21c4dcb5f530eaa1a099b24e7 ]

Change "compress=" mount option to a boolean flag, that, if set,
will enable negotiating compression algorithms with the server.

Do not de/compress anything for now.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifs_debug.c | 32 ++++++++++++++++++++++++++------
 fs/smb/client/cifsglob.h   |  6 +++++-
 fs/smb/client/connect.c    |  2 +-
 fs/smb/client/fs_context.c |  2 +-
 fs/smb/client/fs_context.h |  2 +-
 fs/smb/client/smb2pdu.c    | 20 +++++++++++++++-----
 6 files changed, 49 insertions(+), 15 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index aa95fa95ca112..c71ae5c043060 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -280,6 +280,24 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
+static __always_inline const char *compression_alg_str(__le16 alg)
+{
+	switch (alg) {
+	case SMB3_COMPRESS_NONE:
+		return "NONE";
+	case SMB3_COMPRESS_LZNT1:
+		return "LZNT1";
+	case SMB3_COMPRESS_LZ77:
+		return "LZ77";
+	case SMB3_COMPRESS_LZ77_HUFF:
+		return "LZ77-Huffman";
+	case SMB3_COMPRESS_PATTERN:
+		return "Pattern_V1";
+	default:
+		return "invalid";
+	}
+}
+
 static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 {
 	struct mid_q_entry *mid_entry;
@@ -425,12 +443,6 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			server->echo_credits,
 			server->oplock_credits,
 			server->dialect);
-		if (server->compress_algorithm == SMB3_COMPRESS_LZNT1)
-			seq_printf(m, " COMPRESS_LZNT1");
-		else if (server->compress_algorithm == SMB3_COMPRESS_LZ77)
-			seq_printf(m, " COMPRESS_LZ77");
-		else if (server->compress_algorithm == SMB3_COMPRESS_LZ77_HUFF)
-			seq_printf(m, " COMPRESS_LZ77_HUFF");
 		if (server->sign)
 			seq_printf(m, " signed");
 		if (server->posix_ext_supported)
@@ -462,6 +474,14 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 				   server->leaf_fullpath);
 		}
 
+		seq_puts(m, "\nCompression: ");
+		if (!server->compression.requested)
+			seq_puts(m, "disabled on mount");
+		else if (server->compression.enabled)
+			seq_printf(m, "enabled (%s)", compression_alg_str(server->compression.alg));
+		else
+			seq_puts(m, "disabled (not supported by this server)");
+
 		seq_printf(m, "\n\n\tSessions: ");
 		i = 0;
 		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 053556ca6f011..70a12584375de 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -772,7 +772,11 @@ struct TCP_Server_Info {
 	unsigned int	max_write;
 	unsigned int	min_offload;
 	unsigned int	retrans;
-	__le16	compress_algorithm;
+	struct {
+		bool requested; /* "compress" mount option set*/
+		bool enabled; /* actually negotiated with server */
+		__le16 alg; /* preferred alg negotiated with server */
+	} compression;
 	__u16	signing_algorithm;
 	__le16	cipher_type;
 	 /* save initital negprot hash */
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index deba1cfd11801..5acfd2057ca04 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1748,7 +1748,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	tcp_ses->channel_sequence_num = 0; /* only tracked for primary channel */
 	tcp_ses->reconnect_instance = 1;
 	tcp_ses->lstrp = jiffies;
-	tcp_ses->compress_algorithm = cpu_to_le16(ctx->compression);
+	tcp_ses->compression.requested = ctx->compress;
 	spin_lock_init(&tcp_ses->req_lock);
 	spin_lock_init(&tcp_ses->srv_lock);
 	spin_lock_init(&tcp_ses->mid_lock);
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index fbaa901d3493a..3bbac925d0766 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -978,7 +978,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 
 	switch (opt) {
 	case Opt_compress:
-		ctx->compression = UNKNOWN_TYPE;
+		ctx->compress = true;
 		cifs_dbg(VFS,
 			"SMB3 compression support is experimental\n");
 		break;
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index e77ee81846b31..cf577ec0dd0ac 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -277,7 +277,7 @@ struct smb3_fs_context {
 	unsigned int max_credits; /* smb3 max_credits 10 < credits < 60000 */
 	unsigned int max_channels;
 	unsigned int max_cached_dirs;
-	__u16 compression; /* compression algorithm 0xFFFF default 0=disabled */
+	bool compress; /* enable SMB2 messages (READ/WRITE) de/compression */
 	bool rootfs:1; /* if it's a SMB root file system */
 	bool witness:1; /* use witness protocol */
 	char *leaf_fullpath;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 4d805933e14f3..86c647a947ccd 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -743,7 +743,7 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
 	pneg_ctxt += sizeof(struct smb2_posix_neg_context);
 	neg_context_count++;
 
-	if (server->compress_algorithm) {
+	if (server->compression.requested) {
 		build_compression_ctxt((struct smb2_compression_capabilities_context *)
 				pneg_ctxt);
 		ctxt_len = ALIGN(sizeof(struct smb2_compression_capabilities_context), 8);
@@ -791,6 +791,9 @@ static void decode_compress_ctx(struct TCP_Server_Info *server,
 			 struct smb2_compression_capabilities_context *ctxt)
 {
 	unsigned int len = le16_to_cpu(ctxt->DataLength);
+	__le16 alg;
+
+	server->compression.enabled = false;
 
 	/*
 	 * Caller checked that DataLength remains within SMB boundary. We still
@@ -801,15 +804,22 @@ static void decode_compress_ctx(struct TCP_Server_Info *server,
 		pr_warn_once("server sent bad compression cntxt\n");
 		return;
 	}
+
 	if (le16_to_cpu(ctxt->CompressionAlgorithmCount) != 1) {
-		pr_warn_once("Invalid SMB3 compress algorithm count\n");
+		pr_warn_once("invalid SMB3 compress algorithm count\n");
 		return;
 	}
-	if (le16_to_cpu(ctxt->CompressionAlgorithms[0]) > 3) {
-		pr_warn_once("unknown compression algorithm\n");
+
+	alg = ctxt->CompressionAlgorithms[0];
+
+	/* 'NONE' (0) compressor type is never negotiated */
+	if (alg == 0 || le16_to_cpu(alg) > 3) {
+		pr_warn_once("invalid compression algorithm '%u'\n", alg);
 		return;
 	}
-	server->compress_algorithm = ctxt->CompressionAlgorithms[0];
+
+	server->compression.alg = alg;
+	server->compression.enabled = true;
 }
 
 static int decode_encrypt_ctx(struct TCP_Server_Info *server,
-- 
2.43.0



