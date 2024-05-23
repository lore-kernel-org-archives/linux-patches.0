Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE1414AD36;
	Thu, 23 May 2024 13:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470740; cv=none; b=p0VNlKuae/lRK8bPmTWQZAjAs9O/HODwcm+XRjzu3eW2lUWwWwpAwtJeiROtQVRI/qkVLYbWCpDf/zfLghNYzxFf8D0CnoKMFr7ldXdctpZQg21jQZMMt4Q9hlZOvMhYde1VGJMVyNhynSken2IXgHPZimU0+D2P50PmAnU8sTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470740; c=relaxed/simple;
	bh=ARW6wELzP0214cYmOPUbV/TDv/VEcXbVYGPGeLiTV4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ymjr0B0xBgLu9OUbzXkc1ZVz27EOFgY5zx0hutttrUMq/xgKSaO/d1NrzaHUGtmWOgCplv/BvE3KXnlMyfvqCLsOukb89aGo0THJ16NGBz/aSpCVn78n29hCT541HCuvhtyZS928bzOfvH3s5OBJ9ztALItHO3BLht/NmiSvtAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGqHrUy6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGqHrUy6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E188C3277B;
	Thu, 23 May 2024 13:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470740;
	bh=ARW6wELzP0214cYmOPUbV/TDv/VEcXbVYGPGeLiTV4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGqHrUy6e/kfRhQaR87HED8oF/zj5hAXeRy8EpLGUWrANGQxnMNLuZIHdTZivntza
	 gckYyi3F4kkZK8u88oBsfh4Tl4z8D7bMshPnbV6HYYEx/55KT83hLznZURcXWwtmAv
	 vUx054ynUXlGB6/euKvmvus6GCKv97zOUKgEiPY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/102] smb3: add trace event for mknod
Date: Thu, 23 May 2024 15:13:36 +0200
Message-ID: <20240523130345.146284211@linuxfoundation.org>
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

From: Steve French <stfrench@microsoft.com>

[ Upstream commit e9e9fbeb83f65d3d487e0a0838c0867292c99fb2 ]

Add trace points to help debug mknod and mkfifo:

   smb3_mknod_done
   smb3_mknod_enter
   smb3_mknod_err

Example output:

      TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
         | |         |   |||||     |         |
    mkfifo-6163    [003] .....   960.425558: smb3_mknod_enter: xid=12 sid=0xb55130f6 tid=0x46e6241c path=\fifo1
    mkfifo-6163    [003] .....   960.432719: smb3_mknod_done: xid=12 sid=0xb55130f6 tid=0x46e6241c

Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/dir.c   | 7 +++++++
 fs/smb/client/trace.h | 4 +++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 37897b919dd5a..864b194dbaa0a 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -627,11 +627,18 @@ int cifs_mknod(struct mnt_idmap *idmap, struct inode *inode,
 		goto mknod_out;
 	}
 
+	trace_smb3_mknod_enter(xid, tcon->ses->Suid, tcon->tid, full_path);
+
 	rc = tcon->ses->server->ops->make_node(xid, inode, direntry, tcon,
 					       full_path, mode,
 					       device_number);
 
 mknod_out:
+	if (rc)
+		trace_smb3_mknod_err(xid,  tcon->ses->Suid, tcon->tid, rc);
+	else
+		trace_smb3_mknod_done(xid, tcon->ses->Suid, tcon->tid);
+
 	free_dentry_path(page);
 	free_xid(xid);
 	cifs_put_tlink(tlink);
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index f9c1fd32d0b8c..5e83cb9da9028 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -375,6 +375,7 @@ DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(get_reparse_compound_enter);
 DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(delete_enter);
 DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(mkdir_enter);
 DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(tdis_enter);
+DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(mknod_enter);
 
 DECLARE_EVENT_CLASS(smb3_inf_compound_done_class,
 	TP_PROTO(unsigned int xid,
@@ -415,7 +416,7 @@ DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(query_wsl_ea_compound_done);
 DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(delete_done);
 DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(mkdir_done);
 DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(tdis_done);
-
+DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(mknod_done);
 
 DECLARE_EVENT_CLASS(smb3_inf_compound_err_class,
 	TP_PROTO(unsigned int xid,
@@ -461,6 +462,7 @@ DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(query_wsl_ea_compound_err);
 DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(mkdir_err);
 DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(delete_err);
 DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(tdis_err);
+DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(mknod_err);
 
 /*
  * For logging SMB3 Status code and Command for responses which return errors
-- 
2.43.0



