Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DE6372244;
	Sat, 28 Feb 2026 17:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301497; cv=none; b=IOK68bFbX96uA/iPiC7c1oxRey2HpPk3TuWv7R/XQU0kp5OtrFFy+0aWHxsNRH2Kq+s+8v++M5OW3NLxtl1kCYWx1GkNZsBtd0zmoV8AgKHxV2052DONx6dPqsC96gPziRyiLQZDJZhXO+81xxylRFpD6OW+oTVlEcghF21hxm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301497; c=relaxed/simple;
	bh=uCj6fyoWP8ic3Hhbfari2dvyUvkMRZW3CnuTEJyV7O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtjG7IsSuANaumB2Y2HOwiL6j4jIAEMOahxPN+TgLIiLiiMxpkZH5useAJuHuCl7Z2bmfw1LnSjAzQpBcWIWtQSKajGKlRt4F3NmEeStV7Hog8GHwOqlcFwhYcnBpd+gcL9Do+m1lcSijqZOAjXF7pP1hlbagXlaODcFe5m0CJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IWzjKQqJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IWzjKQqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1827C19423;
	Sat, 28 Feb 2026 17:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301497;
	bh=uCj6fyoWP8ic3Hhbfari2dvyUvkMRZW3CnuTEJyV7O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWzjKQqJlXtiefcrdQowyPg6e4ehlFLfKQTQylnY43vaIbuv78L9O9O9u8HoJy0Qz
	 QidL769JVzEKX5Me4SCralRS1QaFXiBGZiYDawWEdPBZ3x1T53xw3KNZITd0IEk9/7
	 WyOr9orSz8RHGwSytoRUOA44yY5uPukN/3pSzCnt/CXmvbsZ+c+sUjWwcV2A2+hhJF
	 hb9AFImu7XnkDUSe1AeuWjrE0fx6S9CXlmIqM3TLcayo9zlBOysOA1dToJHJoJjFCR
	 fzVy0fpWvjJNuYK0bk2ZjRXa2DTtwToYOQzasizqCIXTdwlypw5EMGYo6+nfM7L+6d
	 KtkhkSGWzGDWA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	stable@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 681/752] cifs: Fix locking usage for tcon fields
Date: Sat, 28 Feb 2026 12:46:32 -0500
Message-ID: <20260228174750.1542406-681-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 96c4af418586ee9a6aab61738644366426e05316 ]

We used to use the cifs_tcp_ses_lock to protect a lot of objects
that are not just the server, ses or tcon lists. We later introduced
srv_lock, ses_lock and tc_lock to protect fields within the
corresponding structs. This was done to provide a more granular
protection and avoid unnecessary serialization.

There were still a couple of uses of cifs_tcp_ses_lock to provide
tcon fields. In this patch, I've replaced them with tc_lock.

Cc: stable@vger.kernel.org
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cached_dir.c | 4 ++--
 fs/smb/client/smb2misc.c   | 6 +++---
 fs/smb/client/smb2ops.c    | 8 +++-----
 fs/smb/client/smb2pdu.c    | 2 ++
 fs/smb/client/trace.h      | 1 +
 5 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index e3ea6fe7edb47..09939fe9666ea 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -788,11 +788,11 @@ static void cfids_laundromat_worker(struct work_struct *work)
 		cfid->dentry = NULL;
 
 		if (cfid->is_open) {
-			spin_lock(&cifs_tcp_ses_lock);
+			spin_lock(&cfid->tcon->tc_lock);
 			++cfid->tcon->tc_count;
 			trace_smb3_tcon_ref(cfid->tcon->debug_id, cfid->tcon->tc_count,
 					    netfs_trace_tcon_ref_get_cached_laundromat);
-			spin_unlock(&cifs_tcp_ses_lock);
+			spin_unlock(&cfid->tcon->tc_lock);
 			queue_work(serverclose_wq, &cfid->close_work);
 		} else
 			/*
diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 96bfe4c63ccf9..a6fc8ff398ebf 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -819,14 +819,14 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 	int rc;
 
 	cifs_dbg(FYI, "%s: tc_count=%d\n", __func__, tcon->tc_count);
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&tcon->tc_lock);
 	if (tcon->tc_count <= 0) {
 		struct TCP_Server_Info *server = NULL;
 
 		trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
 				    netfs_trace_tcon_ref_see_cancelled_close);
 		WARN_ONCE(tcon->tc_count < 0, "tcon refcount is negative");
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&tcon->tc_lock);
 
 		if (tcon->ses) {
 			server = tcon->ses->server;
@@ -840,7 +840,7 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 	tcon->tc_count++;
 	trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
 			    netfs_trace_tcon_ref_get_cancelled_close);
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&tcon->tc_lock);
 
 	rc = __smb2_handle_cancelled_cmd(tcon, SMB2_CLOSE_HE, 0,
 					 persistent_fid, volatile_fid);
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index c3c5fddb2caab..1b404def355e9 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3074,7 +3074,9 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
 						struct cifs_tcon,
 						tcon_list);
 		if (tcon) {
+			spin_lock(&tcon->tc_lock);
 			tcon->tc_count++;
+			spin_unlock(&tcon->tc_lock);
 			trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
 					    netfs_trace_tcon_ref_get_dfs_refer);
 		}
@@ -3143,13 +3145,9 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
  out:
 	if (tcon && !tcon->ipc) {
 		/* ipc tcons are not refcounted */
-		spin_lock(&cifs_tcp_ses_lock);
-		tcon->tc_count--;
+		cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_dfs_refer);
 		trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
 				    netfs_trace_tcon_ref_dec_dfs_refer);
-		/* tc_count can never go negative */
-		WARN_ON(tcon->tc_count < 0);
-		spin_unlock(&cifs_tcp_ses_lock);
 	}
 	kfree(utf16_path);
 	kfree(dfs_req);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index e661d40213eab..8082507586e81 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4174,7 +4174,9 @@ void smb2_reconnect_server(struct work_struct *work)
 
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			if (tcon->need_reconnect || tcon->need_reopen_files) {
+				spin_lock(&tcon->tc_lock);
 				tcon->tc_count++;
+				spin_unlock(&tcon->tc_lock);
 				trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
 						    netfs_trace_tcon_ref_get_reconnect_server);
 				list_add_tail(&tcon->rlist, &tmp_list);
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 28e00c34df1cb..e592b2627119f 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -59,6 +59,7 @@
 	EM(netfs_trace_tcon_ref_put_cancelled_close_fid, "PUT Cn-Fid") \
 	EM(netfs_trace_tcon_ref_put_cancelled_mid,	"PUT Cn-Mid") \
 	EM(netfs_trace_tcon_ref_put_mnt_ctx,		"PUT MntCtx") \
+	EM(netfs_trace_tcon_ref_put_dfs_refer,		"PUT DfsRfr") \
 	EM(netfs_trace_tcon_ref_put_reconnect_server,	"PUT Reconn") \
 	EM(netfs_trace_tcon_ref_put_tlink,		"PUT Tlink ") \
 	EM(netfs_trace_tcon_ref_see_cancelled_close,	"SEE Cn-Cls") \
-- 
2.51.0

