Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2402E5411;
	Tue,  8 Jul 2025 16:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993172; cv=none; b=p2VW4uyeWbT4h+PbKDld25u3RVmsoDdHDyeCBlsF1rkTMIfJlqverjbcIiqGjLsaPhGUKoW8eFy1Wv9InHMZrt1yrFiCiSeGNain5oeFBuKtZ5SkjW8yCr+5N7kiVngfXHsLKjG0dpPvxZc4bRXYVcMTqPkwoVz3FQ3Hk4yuL6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993172; c=relaxed/simple;
	bh=M5i6ftJqg1+Eb3PfOk59uG4ACFFqjb2EbMijWZb4duU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VCWqQNDCUrQ0h+SwZlkuYKOg1/DzuSNia/BVeR8hqhCTNhtbL+8H2zgEevMloqt4KUD1Tt8aeFUvu5jvG3EvQzisOFPgl361MYfvld4DkSs4I3MFl8/rmsOkos08ayOQ51uoul/V1ZB0Hc940zJHN0lOpMyooCRR/nw6kVdY2OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10Uj2QS2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10Uj2QS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3502C4CEF0;
	Tue,  8 Jul 2025 16:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993172;
	bh=M5i6ftJqg1+Eb3PfOk59uG4ACFFqjb2EbMijWZb4duU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=10Uj2QS21w1mtJ/eJ/NXPebmIsiXkB81820Mv2yl1v2ktexKuKbYSTMDCubPHD3Mq
	 uIfa8diRnNAEjskMRMFyxtKa5PWAJsckV5HuM1QoEeRVAduMWylC340R7u/WR3+/IH
	 WlEqW67/0j4s8r7N/m506zY3iXeoSPTynXdg5PW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 213/232] cifs: all initializations for tcon should happen in tcon_info_alloc
Date: Tue,  8 Jul 2025 18:23:29 +0200
Message-ID: <20250708162247.013046646@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Shyam Prasad N <sprasad@microsoft.com>

commit 74ebd02163fde05baa23129e06dde4b8f0f2377a upstream.

Today, a few work structs inside tcon are initialized inside
cifs_get_tcon and not in tcon_info_alloc. As a result, if a tcon
is obtained from tcon_info_alloc, but not called as a part of
cifs_get_tcon, we may trip over.

Cc: <stable@vger.kernel.org>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsproto.h |    1 +
 fs/smb/client/connect.c   |    8 +-------
 fs/smb/client/misc.c      |    6 ++++++
 3 files changed, 8 insertions(+), 7 deletions(-)

--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -136,6 +136,7 @@ extern int SendReceiveBlockingLock(const
 			struct smb_hdr *out_buf,
 			int *bytes_returned);
 
+void smb2_query_server_interfaces(struct work_struct *work);
 void
 cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
 				      bool all_channels);
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -113,7 +113,7 @@ static int reconn_set_ipaddr_from_hostna
 	return rc;
 }
 
-static void smb2_query_server_interfaces(struct work_struct *work)
+void smb2_query_server_interfaces(struct work_struct *work)
 {
 	int rc;
 	int xid;
@@ -2819,20 +2819,14 @@ cifs_get_tcon(struct cifs_ses *ses, stru
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
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -148,6 +148,12 @@ tcon_info_alloc(bool dir_leases_enabled,
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


