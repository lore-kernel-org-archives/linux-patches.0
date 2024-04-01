Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6664F4596E;
	Mon,  1 Apr 2024 16:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989799; cv=none; b=gi+aiS2xLeHTXUbtCYwI8WPJTzMx/sLmD+VlOD67vhq8nkWqbWuBSnc1jdzFwlPyR+IdtqeazYnXsmzvyPrF8yXiqJiSX/7xEDzwmgxb/Sj9jmVlN0y8y3lgkqXxUKie7hUyYFGdcs5VQjt/DFIPeh0X4s7UB6T8nsnhd+hanxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989799; c=relaxed/simple;
	bh=UY/YgUaUUQP70ez9K6UeU7ZptB7doxEXCMjJY5U7GcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CRrMZpOtLGA84iDbm51kt2eOZx8A7c5+dku33qL2FVBGAsySKvIN7ufrsZZzMfeoSz2wEPK7L4SnUs7Vfk1tQhxLLwmU+W8Cm4DROGBIH96EGazrFM3ugOcv/AAurEhJ3GuUWy+csqy8sagDR60mH+J1hoICalO+zkObPCM5orA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tkTgUQRu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tkTgUQRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EB3C433F1;
	Mon,  1 Apr 2024 16:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989799;
	bh=UY/YgUaUUQP70ez9K6UeU7ZptB7doxEXCMjJY5U7GcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tkTgUQRu26GFnt6US6whlmkFu9SoH9fGHa8sQoWvSOIi0s/GDFQhemZ+Wt9rj49VO
	 NZBWNnOBWp8X7uU8Sy2jkDgJryODb/y54JJ2xdgd4EHhE7t7eUE2nCbTcBoMZRwXck
	 aVdWdIG4nU2Mre4n5zVSXZWSejet6bYqyAcm4Ol8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20=C4=8Cerm=C3=A1k?= <sairon@sairon.cz>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 157/396] cifs: make sure server interfaces are requested only for SMB3+
Date: Mon,  1 Apr 2024 17:43:26 +0200
Message-ID: <20240401152552.624806514@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 13c0a74747cb7fdadf58c5d3a7d52cfca2d51736 ]

Some code paths for querying server interfaces make a false
assumption that it will only get called for SMB3+. Since this
function now can get called from a generic code paths, the correct
thing to do is to have specific handler for this functionality
per SMB dialect, and call this handler.

This change adds such a handler and implements this handler only
for SMB 3.0 and 3.1.1.

Cc: stable@vger.kernel.org
Cc: Jan Čermák <sairon@sairon.cz>
Reported-by: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h | 3 +++
 fs/smb/client/connect.c  | 6 +++++-
 fs/smb/client/smb2ops.c  | 2 ++
 fs/smb/client/smb2pdu.c  | 5 +++--
 4 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 91a4061233f1a..35a12413bbee6 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -339,6 +339,9 @@ struct smb_version_operations {
 	/* informational QFS call */
 	void (*qfs_tcon)(const unsigned int, struct cifs_tcon *,
 			 struct cifs_sb_info *);
+	/* query for server interfaces */
+	int (*query_server_interfaces)(const unsigned int, struct cifs_tcon *,
+				       bool);
 	/* check if a path is accessible or not */
 	int (*is_path_accessible)(const unsigned int, struct cifs_tcon *,
 				  struct cifs_sb_info *, const char *);
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 2a564f19dbb39..4c958129181d3 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -123,12 +123,16 @@ static void smb2_query_server_interfaces(struct work_struct *work)
 	struct cifs_tcon *tcon = container_of(work,
 					struct cifs_tcon,
 					query_interfaces.work);
+	struct TCP_Server_Info *server = tcon->ses->server;
 
 	/*
 	 * query server network interfaces, in case they change
 	 */
+	if (!server->ops->query_server_interfaces)
+		return;
+
 	xid = get_xid();
-	rc = SMB3_request_interfaces(xid, tcon, false);
+	rc = server->ops->query_server_interfaces(xid, tcon, false);
 	free_xid(xid);
 
 	if (rc) {
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 5850f861e7e13..978a9f409857a 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5436,6 +5436,7 @@ struct smb_version_operations smb30_operations = {
 	.tree_connect = SMB2_tcon,
 	.tree_disconnect = SMB2_tdis,
 	.qfs_tcon = smb3_qfs_tcon,
+	.query_server_interfaces = SMB3_request_interfaces,
 	.is_path_accessible = smb2_is_path_accessible,
 	.can_echo = smb2_can_echo,
 	.echo = SMB2_echo,
@@ -5550,6 +5551,7 @@ struct smb_version_operations smb311_operations = {
 	.tree_connect = SMB2_tcon,
 	.tree_disconnect = SMB2_tdis,
 	.qfs_tcon = smb3_qfs_tcon,
+	.query_server_interfaces = SMB3_request_interfaces,
 	.is_path_accessible = smb2_is_path_accessible,
 	.can_echo = smb2_can_echo,
 	.echo = SMB2_echo,
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index fca55702b51ad..4d7d0bdf7a472 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -409,14 +409,15 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	spin_unlock(&ses->ses_lock);
 
 	if (!rc &&
-	    (server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
+	    (server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL) &&
+	    server->ops->query_server_interfaces) {
 		mutex_unlock(&ses->session_mutex);
 
 		/*
 		 * query server network interfaces, in case they change
 		 */
 		xid = get_xid();
-		rc = SMB3_request_interfaces(xid, tcon, false);
+		rc = server->ops->query_server_interfaces(xid, tcon, false);
 		free_xid(xid);
 
 		if (rc == -EOPNOTSUPP && ses->chan_count > 1) {
-- 
2.43.0



