Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8D4522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85F7C433C8;
	Sun,  9 Jul 2023 11:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902534;
	bh=KvykWeI8iEHKDhBwjfV7Sz98/tWjsPqX4svlOow6Po8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdvlcJRsHW8kWFn8+zpyTz+0VYezS+aAlDafMMTJXIBQWkG4d9vt+1aNI2N+im2yX
	 4eDGColSIUm1SY+DVAU33y4rkjEzXb4VvzGLK2FG2hNTZgTg9FoVwc5AYi/CNImK2k
	 cJkfdItOlsmPx3r3fvkZ8l2xU2rVpqEEyIJS9tGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 411/431] SMB3: Do not send lease break acknowledgment if all file handles have been closed
Date: Sun,  9 Jul 2023 13:15:59 +0200
Message-ID: <20230709111500.823746661@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bharath SM <bharathsm@microsoft.com>

[ Upstream commit da787d5b74983f7525d1eb4b9c0b4aff2821511a ]

In case if all existing file handles are deferred handles and if all of
them gets closed due to handle lease break then we dont need to send
lease break acknowledgment to server, because last handle close will be
considered as lease break ack.
After closing deferred handels, we check for openfile list of inode,
if its empty then we skip sending lease break ack.

Fixes: 59a556aebc43 ("SMB3: drop reference to cfile before sending oplock break")
Reviewed-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/file.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 051283386e229..1a854dc204823 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4936,20 +4936,19 @@ void cifs_oplock_break(struct work_struct *work)
 
 	_cifsFileInfo_put(cfile, false /* do not wait for ourself */, false);
 	/*
-	 * releasing stale oplock after recent reconnect of smb session using
-	 * a now incorrect file handle is not a data integrity issue but do
-	 * not bother sending an oplock release if session to server still is
-	 * disconnected since oplock already released by the server
+	 * MS-SMB2 3.2.5.19.1 and 3.2.5.19.2 (and MS-CIFS 3.2.5.42) do not require
+	 * an acknowledgment to be sent when the file has already been closed.
+	 * check for server null, since can race with kill_sb calling tree disconnect.
 	 */
-	if (!oplock_break_cancelled) {
-		/* check for server null since can race with kill_sb calling tree disconnect */
-		if (tcon->ses && tcon->ses->server) {
-			rc = tcon->ses->server->ops->oplock_response(tcon, persistent_fid,
-				volatile_fid, net_fid, cinode);
-			cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
-		} else
-			pr_warn_once("lease break not sent for unmounted share\n");
-	}
+	spin_lock(&cinode->open_file_lock);
+	if (tcon->ses && tcon->ses->server && !oplock_break_cancelled &&
+					!list_empty(&cinode->openFileList)) {
+		spin_unlock(&cinode->open_file_lock);
+		rc = tcon->ses->server->ops->oplock_response(tcon, persistent_fid,
+						volatile_fid, net_fid, cinode);
+		cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
+	} else
+		spin_unlock(&cinode->open_file_lock);
 
 	cifs_done_oplock_break(cinode);
 }
-- 
2.39.2



