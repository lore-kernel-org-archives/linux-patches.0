Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D3B1D545;
	Thu, 23 May 2024 13:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470622; cv=none; b=iuYyhQMFRAfWA2lx6JXftcelqul2JmDlxEYBMH0fFS1UxxrP9FkM5i9TxA2aU43m3frU4/vHH2VfuhlJ870N1A0v8xfFwRN8Awb/dxZiGKhUtTsQFxy6Tvd46iObv7eZniqGqh+q2xKFVPp6nBVYAb6DeEuDfBkjDI4JwwrHsw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470622; c=relaxed/simple;
	bh=/dB1saJSM7i1ClqqnPCSBFNN9+kvYE6pXVXjUgzXUCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ku77cywxKVYn26j4vADvuE++CBVJzdMS7zDfJZOXEiYzY0GqkbHWV/eFZGJ+yLvkL8zejtkJuhHuCUDma1kzkAYuxNR5aH9CBswWzFuXoiJajfPuJTkmOzXyRAkMjC0D9VbEmK7F5PvbhNoDudyfVTq/AyruCCVSdSQdNd/sHWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0lk6mMT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0lk6mMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E6FC2BD10;
	Thu, 23 May 2024 13:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470622;
	bh=/dB1saJSM7i1ClqqnPCSBFNN9+kvYE6pXVXjUgzXUCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f0lk6mMT6g4mRhBq3oKn2ErPh/rmtZqXot9H6lA4inA38B7BsY+tB9IN+DsTXjZRk
	 xC4/xQeVo1gvQp4atFBZ+T4T5X5hIVpo+BqFLJdgpRlaRTtp5YvK9d4jaL/EZulU8t
	 WgtZDcbLMtTlWx3udgxMZy4EiCbj17Ngkx2vp6B4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/102] cifs: new mount option called retrans
Date: Thu, 23 May 2024 15:12:56 +0200
Message-ID: <20240523130343.638464049@linuxfoundation.org>
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

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit ce09f8d8a7130e6edfdd6fcad8eb277824d5de95 ]

We have several places in the code where we treat the
error -EAGAIN very differently. Some code retry for
arbitrary number of times.

Introducing this new mount option named "retrans", so
that all these handlers of -EAGAIN can retry a fixed
number of times. This applies only to soft mounts.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsfs.c     | 2 ++
 fs/smb/client/cifsglob.h   | 1 +
 fs/smb/client/connect.c    | 4 ++++
 fs/smb/client/fs_context.c | 6 ++++++
 fs/smb/client/fs_context.h | 2 ++
 5 files changed, 15 insertions(+)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 44e2cc37a8b63..6d9d2174ee691 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -682,6 +682,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_printf(s, ",rasize=%u", cifs_sb->ctx->rasize);
 	if (tcon->ses->server->min_offload)
 		seq_printf(s, ",esize=%u", tcon->ses->server->min_offload);
+	if (tcon->ses->server->retrans)
+		seq_printf(s, ",retrans=%u", tcon->ses->server->retrans);
 	seq_printf(s, ",echo_interval=%lu",
 			tcon->ses->server->echo_interval / HZ);
 
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 414648bf816b2..6acadb53ada79 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -754,6 +754,7 @@ struct TCP_Server_Info {
 	unsigned int	max_read;
 	unsigned int	max_write;
 	unsigned int	min_offload;
+	unsigned int	retrans;
 	__le16	compress_algorithm;
 	__u16	signing_algorithm;
 	__le16	cipher_type;
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 2466b28379ff8..e28f011f11d6c 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1592,6 +1592,9 @@ static int match_server(struct TCP_Server_Info *server,
 	if (server->min_offload != ctx->min_offload)
 		return 0;
 
+	if (server->retrans != ctx->retrans)
+		return 0;
+
 	return 1;
 }
 
@@ -1816,6 +1819,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 		goto out_err_crypto_release;
 	}
 	tcp_ses->min_offload = ctx->min_offload;
+	tcp_ses->retrans = ctx->retrans;
 	/*
 	 * at this point we are the only ones with the pointer
 	 * to the struct since the kernel thread not created yet
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 4d9e57be84dbc..f119035a82725 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -139,6 +139,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 	fsparam_u32("dir_mode", Opt_dirmode),
 	fsparam_u32("port", Opt_port),
 	fsparam_u32("min_enc_offload", Opt_min_enc_offload),
+	fsparam_u32("retrans", Opt_retrans),
 	fsparam_u32("esize", Opt_min_enc_offload),
 	fsparam_u32("bsize", Opt_blocksize),
 	fsparam_u32("rasize", Opt_rasize),
@@ -1098,6 +1099,9 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	case Opt_min_enc_offload:
 		ctx->min_offload = result.uint_32;
 		break;
+	case Opt_retrans:
+		ctx->retrans = result.uint_32;
+		break;
 	case Opt_blocksize:
 		/*
 		 * inode blocksize realistically should never need to be
@@ -1678,6 +1682,8 @@ int smb3_init_fs_context(struct fs_context *fc)
 	ctx->backupuid_specified = false; /* no backup intent for a user */
 	ctx->backupgid_specified = false; /* no backup intent for a group */
 
+	ctx->retrans = 1;
+
 /*
  *	short int override_uid = -1;
  *	short int override_gid = -1;
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index d7c090dbe75db..369a3fea1dfe0 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -118,6 +118,7 @@ enum cifs_param {
 	Opt_file_mode,
 	Opt_dirmode,
 	Opt_min_enc_offload,
+	Opt_retrans,
 	Opt_blocksize,
 	Opt_rasize,
 	Opt_rsize,
@@ -249,6 +250,7 @@ struct smb3_fs_context {
 	unsigned int rsize;
 	unsigned int wsize;
 	unsigned int min_offload;
+	unsigned int retrans;
 	bool sockopt_tcp_nodelay:1;
 	/* attribute cache timemout for files and directories in jiffies */
 	unsigned long acregmax;
-- 
2.43.0



