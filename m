Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E59B26CE27;
	Tue, 15 Jul 2025 13:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586055; cv=none; b=YT3FeBIbSAel/pU3kX8U86tabpoXc73zzp3X5kAGGgnP1YSTqVCghq5b8LBGVQjZ8zVE0FrGBaVCqCRd4GUnPjWHQAIEo49XiuMkOyB/csdvJtyyUZhFue5DlTNmwNcrUBbToYUJcPaUX7/Uqn/O2Y3+oFQRZuffec/pjSyXRKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586055; c=relaxed/simple;
	bh=6129G5mgFGCVq9DINgmpiOQ0zllzGZpk9wTRNTHiRr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQ1CXgjqzLjJ1u+5FLYGR7N18gEHR3m61hWscHLa6kD5yZETt4jbZTOHB8r1TLnO8lbHZTVXYanunVLgVcle5CqWmER+U8Vnqqm32aNDIBnXnP7ye75WFdrmmOgibBrYc7Pd4n1W8kZGJujS1rCmqnIYpkmEgqIZrREWOCng3kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qMbFhSu6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qMbFhSu6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A3CC4CEF7;
	Tue, 15 Jul 2025 13:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586055;
	bh=6129G5mgFGCVq9DINgmpiOQ0zllzGZpk9wTRNTHiRr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qMbFhSu6As6K1ompjaJpfYTz+s5at/U0YG3FkMJ7+dHz5RifMCeqBbUcfAOciXoir
	 Ws1cj14AX9fOS4TCsYO2JKEB6RwgmYjOT7HitBQgLvEiNOYko5munCpbzOXgUwDA2A
	 LLJbsXtmJ43ZErVIXqyHglmcLCKozSu2Uvgd/Exs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/109] cifs: all initializations for tcon should happen in tcon_info_alloc
Date: Tue, 15 Jul 2025 15:13:33 +0200
Message-ID: <20250715130801.966652822@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 74ebd02163fde05baa23129e06dde4b8f0f2377a ]

Today, a few work structs inside tcon are initialized inside
cifs_get_tcon and not in tcon_info_alloc. As a result, if a tcon
is obtained from tcon_info_alloc, but not called as a part of
cifs_get_tcon, we may trip over.

Cc: <stable@vger.kernel.org>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsproto.h | 1 +
 fs/smb/client/connect.c   | 8 +-------
 fs/smb/client/misc.c      | 6 ++++++
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 8edb6fe89a97c..5ab877e480abc 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -136,6 +136,7 @@ extern int SendReceiveBlockingLock(const unsigned int xid,
 			struct smb_hdr *out_buf,
 			int *bytes_returned);
 
+void smb2_query_server_interfaces(struct work_struct *work);
 void
 cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
 				      bool all_channels);
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 14be8822d23a2..33a292dabdb87 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -113,7 +113,7 @@ static int reconn_set_ipaddr_from_hostname(struct TCP_Server_Info *server)
 	return rc;
 }
 
-static void smb2_query_server_interfaces(struct work_struct *work)
+void smb2_query_server_interfaces(struct work_struct *work)
 {
 	int rc;
 	int xid;
@@ -2818,20 +2818,14 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 	tcon->max_cached_dirs = ctx->max_cached_dirs;
 	tcon->nodelete = ctx->nodelete;
 	tcon->local_lease = ctx->local_lease;
-	INIT_LIST_HEAD(&tcon->pending_opens);
 	tcon->status = TID_GOOD;
 
-	INIT_DELAYED_WORK(&tcon->query_interfaces,
-			  smb2_query_server_interfaces);
 	if (ses->server->dialect >= SMB30_PROT_ID &&
 	    (ses->server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
 		/* schedule query interfaces poll */
 		queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
 				   (SMB_INTERFACE_POLL_INTERVAL * HZ));
 	}
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	INIT_DELAYED_WORK(&tcon->dfs_cache_work, dfs_cache_refresh);
-#endif
 	spin_lock(&cifs_tcp_ses_lock);
 	list_add(&tcon->tcon_list, &ses->tcon_list);
 	spin_unlock(&cifs_tcp_ses_lock);
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 2e9a14e28e466..bbbe48447765d 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -148,6 +148,12 @@ tcon_info_alloc(bool dir_leases_enabled, enum smb3_tcon_ref_trace trace)
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	INIT_LIST_HEAD(&ret_buf->dfs_ses_list);
 #endif
+	INIT_LIST_HEAD(&ret_buf->pending_opens);
+	INIT_DELAYED_WORK(&ret_buf->query_interfaces,
+			  smb2_query_server_interfaces);
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	INIT_DELAYED_WORK(&ret_buf->dfs_cache_work, dfs_cache_refresh);
+#endif
 
 	return ret_buf;
 }
-- 
2.39.5



