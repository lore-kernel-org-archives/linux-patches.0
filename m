Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39E31E8855;
	Wed, 19 Mar 2025 14:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395121; cv=none; b=qW/opf5CkH1MJNUEp0YuB6UU2P2S25zTPED77Ai1F/x0AWOFGSKW/0kiVpgalWgu4DTjohxvwGblevQUAj/hzr4VY24wRhDQT2zX4F/8M2SuRGFsL3XHkAze0gGKm6QuIESg6mnimcg0gjP7Shboqv2JAcGsPvagHFqWwX5FPdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395121; c=relaxed/simple;
	bh=Zj77N0lumPapj/JQL+Sf5oPw7rX5QtCwg1st335e3Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMHRI3zGRDbU7pYQe8OFNQNnOch0Y6IFg++lDt8ElmarvY2R+pz1lyVoO2D7bAqWVyUEeZdwzuJboTiWcEQsmPuDqEDiliZmKi4WeeBREzAIuqGX5BFTlwJiLq6g4jQs2+sXt2zZk6W0tVagLV7yvnnx1sj+eR8GIm4en9fntLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TIHy/8lT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TIHy/8lT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73CCC4CEE4;
	Wed, 19 Mar 2025 14:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395121;
	bh=Zj77N0lumPapj/JQL+Sf5oPw7rX5QtCwg1st335e3Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TIHy/8lToDrHdHsUinxZA7/hHzi8uHxBN2+dho38gsnPtnOltYGTjNvktgwG+GEgZ
	 gw9hVlV0As8y4Yr7IEz0Flw66JtnAtStDeedFWW+c4El2FmID7MdSpbkfylPWWopPH
	 NzEhbinE/8JOh3LLr0NkchA9hZK5zZvyIIyiJ/Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 183/231] ksmbd: fix use-after-free in ksmbd_free_work_struct
Date: Wed, 19 Mar 2025 07:31:16 -0700
Message-ID: <20250319143031.355286238@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit bb39ed47065455604729404729d9116868638d31 upstream.

->interim_entry of ksmbd_work could be deleted after oplock is freed.
We don't need to manage it with linked list. The interim request could be
immediately sent whenever a oplock break wait is needed.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/ksmbd_work.c |    3 ---
 fs/smb/server/ksmbd_work.h |    1 -
 fs/smb/server/oplock.c     |   37 +++++++++++++++----------------------
 fs/smb/server/oplock.h     |    1 -
 4 files changed, 15 insertions(+), 27 deletions(-)

--- a/fs/smb/server/ksmbd_work.c
+++ b/fs/smb/server/ksmbd_work.c
@@ -26,7 +26,6 @@ struct ksmbd_work *ksmbd_alloc_work_stru
 		INIT_LIST_HEAD(&work->request_entry);
 		INIT_LIST_HEAD(&work->async_request_entry);
 		INIT_LIST_HEAD(&work->fp_entry);
-		INIT_LIST_HEAD(&work->interim_entry);
 		INIT_LIST_HEAD(&work->aux_read_list);
 		work->iov_alloc_cnt = 4;
 		work->iov = kcalloc(work->iov_alloc_cnt, sizeof(struct kvec),
@@ -56,8 +55,6 @@ void ksmbd_free_work_struct(struct ksmbd
 	kfree(work->tr_buf);
 	kvfree(work->request_buf);
 	kfree(work->iov);
-	if (!list_empty(&work->interim_entry))
-		list_del(&work->interim_entry);
 
 	if (work->async_id)
 		ksmbd_release_id(&work->conn->async_ida, work->async_id);
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -89,7 +89,6 @@ struct ksmbd_work {
 	/* List head at conn->async_requests */
 	struct list_head                async_request_entry;
 	struct list_head                fp_entry;
-	struct list_head                interim_entry;
 };
 
 /**
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -46,7 +46,6 @@ static struct oplock_info *alloc_opinfo(
 	opinfo->fid = id;
 	opinfo->Tid = Tid;
 	INIT_LIST_HEAD(&opinfo->op_entry);
-	INIT_LIST_HEAD(&opinfo->interim_list);
 	init_waitqueue_head(&opinfo->oplock_q);
 	init_waitqueue_head(&opinfo->oplock_brk);
 	atomic_set(&opinfo->refcount, 1);
@@ -803,7 +802,6 @@ out:
 static int smb2_lease_break_noti(struct oplock_info *opinfo)
 {
 	struct ksmbd_conn *conn = opinfo->conn;
-	struct list_head *tmp, *t;
 	struct ksmbd_work *work;
 	struct lease_break_info *br_info;
 	struct lease *lease = opinfo->o_lease;
@@ -831,16 +829,6 @@ static int smb2_lease_break_noti(struct
 	work->sess = opinfo->sess;
 
 	if (opinfo->op_state == OPLOCK_ACK_WAIT) {
-		list_for_each_safe(tmp, t, &opinfo->interim_list) {
-			struct ksmbd_work *in_work;
-
-			in_work = list_entry(tmp, struct ksmbd_work,
-					     interim_entry);
-			setup_async_work(in_work, NULL, NULL);
-			smb2_send_interim_resp(in_work, STATUS_PENDING);
-			list_del_init(&in_work->interim_entry);
-			release_async_work(in_work);
-		}
 		INIT_WORK(&work->work, __smb2_lease_break_noti);
 		ksmbd_queue_work(work);
 		wait_for_break_ack(opinfo);
@@ -871,7 +859,8 @@ static void wait_lease_breaking(struct o
 	}
 }
 
-static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level)
+static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
+			struct ksmbd_work *in_work)
 {
 	int err = 0;
 
@@ -914,9 +903,15 @@ static int oplock_break(struct oplock_in
 		}
 
 		if (lease->state & (SMB2_LEASE_WRITE_CACHING_LE |
-				SMB2_LEASE_HANDLE_CACHING_LE))
+				SMB2_LEASE_HANDLE_CACHING_LE)) {
+			if (in_work) {
+				setup_async_work(in_work, NULL, NULL);
+				smb2_send_interim_resp(in_work, STATUS_PENDING);
+				release_async_work(in_work);
+			}
+
 			brk_opinfo->op_state = OPLOCK_ACK_WAIT;
-		else
+		} else
 			atomic_dec(&brk_opinfo->breaking_cnt);
 	} else {
 		err = oplock_break_pending(brk_opinfo, req_op_level);
@@ -1116,7 +1111,7 @@ void smb_send_parent_lease_break_noti(st
 			if (ksmbd_conn_releasing(opinfo->conn))
 				continue;
 
-			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE);
+			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE, NULL);
 			opinfo_put(opinfo);
 		}
 	}
@@ -1152,7 +1147,7 @@ void smb_lazy_parent_lease_break_close(s
 
 			if (ksmbd_conn_releasing(opinfo->conn))
 				continue;
-			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE);
+			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE, NULL);
 			opinfo_put(opinfo);
 		}
 	}
@@ -1252,8 +1247,7 @@ int smb_grant_oplock(struct ksmbd_work *
 		goto op_break_not_needed;
 	}
 
-	list_add(&work->interim_entry, &prev_opinfo->interim_list);
-	err = oplock_break(prev_opinfo, SMB2_OPLOCK_LEVEL_II);
+	err = oplock_break(prev_opinfo, SMB2_OPLOCK_LEVEL_II, work);
 	opinfo_put(prev_opinfo);
 	if (err == -ENOENT)
 		goto set_lev;
@@ -1322,8 +1316,7 @@ static void smb_break_all_write_oplock(s
 	}
 
 	brk_opinfo->open_trunc = is_trunc;
-	list_add(&work->interim_entry, &brk_opinfo->interim_list);
-	oplock_break(brk_opinfo, SMB2_OPLOCK_LEVEL_II);
+	oplock_break(brk_opinfo, SMB2_OPLOCK_LEVEL_II, work);
 	opinfo_put(brk_opinfo);
 }
 
@@ -1386,7 +1379,7 @@ void smb_break_all_levII_oplock(struct k
 			    SMB2_LEASE_KEY_SIZE))
 			goto next;
 		brk_op->open_trunc = is_trunc;
-		oplock_break(brk_op, SMB2_OPLOCK_LEVEL_NONE);
+		oplock_break(brk_op, SMB2_OPLOCK_LEVEL_NONE, NULL);
 next:
 		opinfo_put(brk_op);
 		rcu_read_lock();
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -67,7 +67,6 @@ struct oplock_info {
 	bool			is_lease;
 	bool			open_trunc;	/* truncate on open */
 	struct lease		*o_lease;
-	struct list_head        interim_list;
 	struct list_head        op_entry;
 	struct list_head        lease_entry;
 	wait_queue_head_t oplock_q; /* Other server threads */


