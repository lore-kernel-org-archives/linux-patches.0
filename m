Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4000C223DD0;
	Mon, 23 Jun 2025 21:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715727; cv=none; b=kecMbOaB32QU6HtOuPWJJ+2Pd1JZsPMYV+oxxIL6mot9I7tPAQTFVTqFqHjP6/A5YvwvIHBxVIO2mVfue6qAGM7KXX3l0XzhEzONXa0DJCwdOXS1bKjEIrbLRV99oqvrLAWJXhTcFnZZpEeq/5hDq40LKS+yjseaXOPG6lzDXNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715727; c=relaxed/simple;
	bh=FUJzrs+UnRYI3NngdG3yT+LGJ62VpfSFgKCpLfVZXng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZfdZRImlDn3gefesV9A5Qg4iDcLtjEjaQ4tRQJAn0Fj4jLTl0b3HsfINzGBWJfgQZfzF7S5BONYJPUo4kSU5HlTuOJ9DV4XROQlXsGFh6icjvDYw4s7GthqXdJvU8OJbrE1b0KE1nJlaQTJybthQWYCDK+HOahWF6JIovI/RyeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jthC0IKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jthC0IKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB19C4CEEA;
	Mon, 23 Jun 2025 21:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715726;
	bh=FUJzrs+UnRYI3NngdG3yT+LGJ62VpfSFgKCpLfVZXng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jthC0IKoAxBhsmXtJo38f2uQNgaMAVP6Wy8gzxiVNQwvs5PJ4lNERtUGGs/tYYgeg
	 +KZCBQQ8JluDiCjWuDeJ7QuAXjllb9T+iTYbjMvHkikiEwny6joOvcmAt/DDgaDgfJ
	 N+Pxu8cpTyubh3hpywrnyXIqqQT3ENXR5vyg8hgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 217/290] cifs: do not disable interface polling on failure
Date: Mon, 23 Jun 2025 15:07:58 +0200
Message-ID: <20250623130633.456292482@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

commit 42ca547b13a20e7cbb04fbdf8d5f089ac4bb35b7 upstream.

When a server has multichannel enabled, we keep polling the server
for interfaces periodically. However, when this query fails, we
disable the polling. This can be problematic as it takes away the
chance for the server to start advertizing again.

This change reschedules the delayed work, even if the current call
failed. That way, multichannel sessions can recover.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    6 +-----
 fs/smb/client/smb2pdu.c |    9 +++++----
 2 files changed, 6 insertions(+), 9 deletions(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -132,13 +132,9 @@ static void smb2_query_server_interfaces
 	rc = server->ops->query_server_interfaces(xid, tcon, false);
 	free_xid(xid);
 
-	if (rc) {
-		if (rc == -EOPNOTSUPP)
-			return;
-
+	if (rc)
 		cifs_dbg(FYI, "%s: failed to query server interfaces: %d\n",
 				__func__, rc);
-	}
 
 	queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
 			   (SMB_INTERFACE_POLL_INTERVAL * HZ));
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -437,6 +437,10 @@ skip_sess_setup:
 		free_xid(xid);
 		ses->flags &= ~CIFS_SES_FLAGS_PENDING_QUERY_INTERFACES;
 
+		/* regardless of rc value, setup polling */
+		queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
+				   (SMB_INTERFACE_POLL_INTERVAL * HZ));
+
 		mutex_unlock(&ses->session_mutex);
 
 		if (rc == -EOPNOTSUPP && ses->chan_count > 1) {
@@ -457,11 +461,8 @@ skip_sess_setup:
 		if (ses->chan_max > ses->chan_count &&
 		    ses->iface_count &&
 		    !SERVER_IS_CHAN(server)) {
-			if (ses->chan_count == 1) {
+			if (ses->chan_count == 1)
 				cifs_server_dbg(VFS, "supports multichannel now\n");
-				queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
-						 (SMB_INTERFACE_POLL_INTERVAL * HZ));
-			}
 
 			cifs_try_adding_channels(ses);
 		}


