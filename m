Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB861171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C860C433D2;
	Mon, 22 May 2023 19:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684785142;
	bh=YoNZArswi4ZteFHkGmgQifHy3hElhvDwZMGXpzxhzBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kW8KWCcsrLq8Cvd96At9RgHUrEotDcEmSvvkmc7wuZBz4ykuX1/W7k4NxHYV/0whf
	 hPnVcq7idOwcLhAHCxT+yOMCWABz2+dv0l12+7kgDcuuC6vFFPVdkjin3+Sg5pEGqb
	 8MutY0BJdTVgMtonB6SRGMrUDXqrcBlYBRRVOBdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Yen Chang <cc85nod@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.3 324/364] ksmbd: fix global-out-of-bounds in smb2_find_context_vals
Date: Mon, 22 May 2023 20:10:29 +0100
Message-Id: <20230522190420.874177909@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chih-Yen Chang <cc85nod@gmail.com>

commit 02f76c401d17e409ed45bf7887148fcc22c93c85 upstream.

Add tag_len argument in smb2_find_context_vals() to avoid out-of-bound
read when create_context's name_len is larger than tag length.

[    7.995411] ==================================================================
[    7.995866] BUG: KASAN: global-out-of-bounds in memcmp+0x83/0xa0
[    7.996248] Read of size 8 at addr ffffffff8258d940 by task kworker/0:0/7
...
[    7.998191] Call Trace:
[    7.998358]  <TASK>
[    7.998503]  dump_stack_lvl+0x33/0x50
[    7.998743]  print_report+0xcc/0x620
[    7.999458]  kasan_report+0xae/0xe0
[    7.999895]  kasan_check_range+0x35/0x1b0
[    8.000152]  memcmp+0x83/0xa0
[    8.000347]  smb2_find_context_vals+0xf7/0x1e0
[    8.000635]  smb2_open+0x1df2/0x43a0
[    8.006398]  handle_ksmbd_work+0x274/0x810
[    8.006666]  process_one_work+0x419/0x760
[    8.006922]  worker_thread+0x2a2/0x6f0
[    8.007429]  kthread+0x160/0x190
[    8.007946]  ret_from_fork+0x1f/0x30
[    8.008181]  </TASK>

Cc: stable@vger.kernel.org
Signed-off-by: Chih-Yen Chang <cc85nod@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/oplock.c  |    5 +++--
 fs/ksmbd/oplock.h  |    2 +-
 fs/ksmbd/smb2pdu.c |   14 +++++++-------
 3 files changed, 11 insertions(+), 10 deletions(-)

--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -1449,11 +1449,12 @@ struct lease_ctx_info *parse_lease_state
  * smb2_find_context_vals() - find a particular context info in open request
  * @open_req:	buffer containing smb2 file open(create) request
  * @tag:	context name to search for
+ * @tag_len:	the length of tag
  *
  * Return:	pointer to requested context, NULL if @str context not found
  *		or error pointer if name length is invalid.
  */
-struct create_context *smb2_find_context_vals(void *open_req, const char *tag)
+struct create_context *smb2_find_context_vals(void *open_req, const char *tag, int tag_len)
 {
 	struct create_context *cc;
 	unsigned int next = 0;
@@ -1492,7 +1493,7 @@ struct create_context *smb2_find_context
 			return ERR_PTR(-EINVAL);
 
 		name = (char *)cc + name_off;
-		if (memcmp(name, tag, name_len) == 0)
+		if (name_len == tag_len && !memcmp(name, tag, name_len))
 			return cc;
 
 		remain_len -= next;
--- a/fs/ksmbd/oplock.h
+++ b/fs/ksmbd/oplock.h
@@ -118,7 +118,7 @@ void create_durable_v2_rsp_buf(char *cc,
 void create_mxac_rsp_buf(char *cc, int maximal_access);
 void create_disk_id_rsp_buf(char *cc, __u64 file_id, __u64 vol_id);
 void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp);
-struct create_context *smb2_find_context_vals(void *open_req, const char *str);
+struct create_context *smb2_find_context_vals(void *open_req, const char *tag, int tag_len);
 struct oplock_info *lookup_lease_in_table(struct ksmbd_conn *conn,
 					  char *lease_key);
 int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *ci,
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2491,7 +2491,7 @@ static int smb2_create_sd_buffer(struct
 		return -ENOENT;
 
 	/* Parse SD BUFFER create contexts */
-	context = smb2_find_context_vals(req, SMB2_CREATE_SD_BUFFER);
+	context = smb2_find_context_vals(req, SMB2_CREATE_SD_BUFFER, 4);
 	if (!context)
 		return -ENOENT;
 	else if (IS_ERR(context))
@@ -2693,7 +2693,7 @@ int smb2_open(struct ksmbd_work *work)
 
 	if (req->CreateContextsOffset) {
 		/* Parse non-durable handle create contexts */
-		context = smb2_find_context_vals(req, SMB2_CREATE_EA_BUFFER);
+		context = smb2_find_context_vals(req, SMB2_CREATE_EA_BUFFER, 4);
 		if (IS_ERR(context)) {
 			rc = PTR_ERR(context);
 			goto err_out1;
@@ -2713,7 +2713,7 @@ int smb2_open(struct ksmbd_work *work)
 		}
 
 		context = smb2_find_context_vals(req,
-						 SMB2_CREATE_QUERY_MAXIMAL_ACCESS_REQUEST);
+						 SMB2_CREATE_QUERY_MAXIMAL_ACCESS_REQUEST, 4);
 		if (IS_ERR(context)) {
 			rc = PTR_ERR(context);
 			goto err_out1;
@@ -2724,7 +2724,7 @@ int smb2_open(struct ksmbd_work *work)
 		}
 
 		context = smb2_find_context_vals(req,
-						 SMB2_CREATE_TIMEWARP_REQUEST);
+						 SMB2_CREATE_TIMEWARP_REQUEST, 4);
 		if (IS_ERR(context)) {
 			rc = PTR_ERR(context);
 			goto err_out1;
@@ -2736,7 +2736,7 @@ int smb2_open(struct ksmbd_work *work)
 
 		if (tcon->posix_extensions) {
 			context = smb2_find_context_vals(req,
-							 SMB2_CREATE_TAG_POSIX);
+							 SMB2_CREATE_TAG_POSIX, 16);
 			if (IS_ERR(context)) {
 				rc = PTR_ERR(context);
 				goto err_out1;
@@ -3135,7 +3135,7 @@ int smb2_open(struct ksmbd_work *work)
 		struct create_alloc_size_req *az_req;
 
 		az_req = (struct create_alloc_size_req *)smb2_find_context_vals(req,
-					SMB2_CREATE_ALLOCATION_SIZE);
+					SMB2_CREATE_ALLOCATION_SIZE, 4);
 		if (IS_ERR(az_req)) {
 			rc = PTR_ERR(az_req);
 			goto err_out;
@@ -3162,7 +3162,7 @@ int smb2_open(struct ksmbd_work *work)
 					    err);
 		}
 
-		context = smb2_find_context_vals(req, SMB2_CREATE_QUERY_ON_DISK_ID);
+		context = smb2_find_context_vals(req, SMB2_CREATE_QUERY_ON_DISK_ID, 4);
 		if (IS_ERR(context)) {
 			rc = PTR_ERR(context);
 			goto err_out;


