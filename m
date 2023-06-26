Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C55CC8E5
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1418BC433C9;
	Mon, 26 Jun 2023 18:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804660;
	bh=6dJqU+kqgxDwj9RrefSR1GyK9tQI68CiUWjx3i7/quU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IAkgnWDYF5WkdMWFA7ht2Z5177IfO/hr5ao92Ck+WgV3xS9liXWaWm6+dBeV7luQK
	 TPITcf4qtZ9Y0vjnCbWQq0J7ZrOSvG8782dSt4SkQnkzqbeiRUyIPvW6Zn066xjspG
	 sZkTt9SqioptY+IBgEYq3uV+uSVz9fWIRx1j9ZmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Aurelien Aptel <aaptel@suse.com>,
	Steve French <stfrench@microsoft.com>,
	Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 5.4 21/60] cifs: Introduce helpers for finding TCP connection
Date: Mon, 26 Jun 2023 20:12:00 +0200
Message-ID: <20230626180740.420929568@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180739.558575012@linuxfoundation.org>
References: <20230626180739.558575012@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Paulo Alcantara (SUSE)" <pc@cjr.nz>

commit 345c1a4a9e09dc5842b7bbb6728a77910db69c52 upstream.

Add helpers for finding TCP connections that are good candidates for
being used by DFS refresh worker.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/dfs_cache.c |   44 +++++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)

--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1305,6 +1305,30 @@ static char *get_dfs_root(const char *pa
 	return npath;
 }
 
+static inline void put_tcp_server(struct TCP_Server_Info *server)
+{
+	cifs_put_tcp_session(server, 0);
+}
+
+static struct TCP_Server_Info *get_tcp_server(struct smb_vol *vol)
+{
+	struct TCP_Server_Info *server;
+
+	server = cifs_find_tcp_session(vol);
+	if (IS_ERR_OR_NULL(server))
+		return NULL;
+
+	spin_lock(&GlobalMid_Lock);
+	if (server->tcpStatus != CifsGood) {
+		spin_unlock(&GlobalMid_Lock);
+		put_tcp_server(server);
+		return NULL;
+	}
+	spin_unlock(&GlobalMid_Lock);
+
+	return server;
+}
+
 /* Find root SMB session out of a DFS link path */
 static struct cifs_ses *find_root_ses(struct vol_info *vi,
 				      struct cifs_tcon *tcon,
@@ -1347,13 +1371,8 @@ static struct cifs_ses *find_root_ses(st
 		goto out;
 	}
 
-	server = cifs_find_tcp_session(&vol);
-	if (IS_ERR_OR_NULL(server)) {
-		ses = ERR_PTR(-EHOSTDOWN);
-		goto out;
-	}
-	if (server->tcpStatus != CifsGood) {
-		cifs_put_tcp_session(server, 0);
+	server = get_tcp_server(&vol);
+	if (!server) {
 		ses = ERR_PTR(-EHOSTDOWN);
 		goto out;
 	}
@@ -1451,19 +1470,18 @@ static void refresh_cache_worker(struct
 	mutex_lock(&vol_lock);
 
 	list_for_each_entry(vi, &vol_list, list) {
-		server = cifs_find_tcp_session(&vi->smb_vol);
-		if (IS_ERR_OR_NULL(server))
+		server = get_tcp_server(&vi->smb_vol);
+		if (!server)
 			continue;
-		if (server->tcpStatus != CifsGood)
-			goto next;
+
 		get_tcons(server, &list);
 		list_for_each_entry_safe(tcon, ntcon, &list, ulist) {
 			refresh_tcon(vi, tcon);
 			list_del_init(&tcon->ulist);
 			cifs_put_tcon(tcon);
 		}
-next:
-		cifs_put_tcp_session(server, 0);
+
+		put_tcp_server(server);
 	}
 	queue_delayed_work(dfscache_wq, &refresh_task, cache_ttl * HZ);
 	mutex_unlock(&vol_lock);


