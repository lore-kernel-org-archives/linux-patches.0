Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9180146420;
	Mon,  1 Apr 2024 15:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987082; cv=none; b=O+oi0a2TErsEtoZFs3vgNmwDWuMsQHYe3Bv+rER38e0PfQfQu/YwEAA/2MICX8qjoSh2QH2X4x8//MrqpJsBjAvqhw+DOK4I3H1mQ/jbpb30Cw1Qo2hWalzv1+cie4RrEzjs9QfoKsXzW6hDU4ZxSN+LeILsQz8ZSwNDA2FVGKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987082; c=relaxed/simple;
	bh=vt/hagJVPPngA0qEtwpv7f/9+/cxxGR/CCsFQczKrkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o7VkIhMTa1atoKnr+HFUh1yOXcToiqSWL66x3cxQ752mty5cPf4qO5IFXlBtLY/yf5ibEP/otKF72JxQPiP9gWbY1+yLU7DxEh1y3XsgL6J3q4kBebKniwRmrTISRo/eRHhZdN+i9NsyjtbqI+D3ZD/hXnODf9ntuPOBVQE0nyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1kogxDYP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1kogxDYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B21C433F1;
	Mon,  1 Apr 2024 15:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987082;
	bh=vt/hagJVPPngA0qEtwpv7f/9+/cxxGR/CCsFQczKrkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1kogxDYPpO6aP7Lt1g+IApO0gH3tzIpWRIgN16gUosuMcsI/0gxOwsAkNw8xIXqwv
	 QIvuLDIRjFUwgxMFi13Y/TO2A09S8egX+mfTQsyRfXkg5qFVO36VgWGHh6StpQ2D7o
	 3k6e49t2771JdpYfl927r3lHN9VGPkfpN3qM/bp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20=C4=8Cerm=C3=A1k?= <sairon@sairon.cz>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 179/399] cifs: make sure server interfaces are requested only for SMB3+
Date: Mon,  1 Apr 2024 17:42:25 +0200
Message-ID: <20240401152554.519418724@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index ec9a26bd05a12..06e81afe31c14 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -346,6 +346,9 @@ struct smb_version_operations {
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
index ac9595504f4b1..2341604606157 100644
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
index 4695433fcf397..3b8896987197e 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5538,6 +5538,7 @@ struct smb_version_operations smb30_operations = {
 	.tree_connect = SMB2_tcon,
 	.tree_disconnect = SMB2_tdis,
 	.qfs_tcon = smb3_qfs_tcon,
+	.query_server_interfaces = SMB3_request_interfaces,
 	.is_path_accessible = smb2_is_path_accessible,
 	.can_echo = smb2_can_echo,
 	.echo = SMB2_echo,
@@ -5653,6 +5654,7 @@ struct smb_version_operations smb311_operations = {
 	.tree_connect = SMB2_tcon,
 	.tree_disconnect = SMB2_tdis,
 	.qfs_tcon = smb3_qfs_tcon,
+	.query_server_interfaces = SMB3_request_interfaces,
 	.is_path_accessible = smb2_is_path_accessible,
 	.can_echo = smb2_can_echo,
 	.echo = SMB2_echo,
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index a500380d1b2e9..92c3710df6159 100644
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



