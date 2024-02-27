Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D41E13B798;
	Tue, 27 Feb 2024 13:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040598; cv=none; b=deTP0wLRz+aIJ4HbY1tsMgSWwQnoRy6OXn14IJRTOgVI+vgz4jbVSFJHJZ+lgyMKGIv2fuLudztIWqHTWVTpbjOgN3zS4YuGmeguL59x2Nily8H7YvEGva6zEknZW36KTpGtFDKKU6g3ArlvSuaaFKrsozxd73N3xP5ZUwpKVbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040598; c=relaxed/simple;
	bh=LXtRglMZ07l5P6UmSNnrMcOXlxu81NfWP/f9dhfMvcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUBr/tgYTaUMnNjoh5B5W2JxbjkjRd5mfgYocj5HNBUOztzAbGF8NeFuVI0s1og8EZRjc+lQl8DLg7Uy3AnbEMc/j1LnZ5Gy8rrMnxNKGmehiquchmGevVUHN4jpEmBjSEWp/y1VFZwL56MmPhxUDZLlporK8P0uayzIM4faGmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eygfOInm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eygfOInm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A69C433F1;
	Tue, 27 Feb 2024 13:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040597;
	bh=LXtRglMZ07l5P6UmSNnrMcOXlxu81NfWP/f9dhfMvcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eygfOInmLsZ8JJe5Lx1jaZ4ViI4SJA5l4z4AwULcVA9EvGS1EP4C74+Xs/M04wACB
	 uNaBapCHQmd0yE3qN/0eeavNOW+71KbL7jg1VSLugcp5U5EqTDCBv/Lwrrw4l42+gi
	 BPMDZvd/T9cSNODZ9i66w1nliuwYDBYU+GT22Xh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 024/334] cifs: translate network errors on send to -ECONNABORTED
Date: Tue, 27 Feb 2024 14:18:02 +0100
Message-ID: <20240227131631.384657452@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit a68106a6928e0a6680f12bcc7338c0dddcfe4d11 ]

When the network stack returns various errors, we today bubble
up the error to the user (in case of soft mounts).

This change translates all network errors except -EINTR and
-EAGAIN to -ECONNABORTED. A similar approach is taken when
we receive network errors when reading from the socket.

The change also forces the cifsd thread to reconnect during
it's next activity.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/transport.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 8695c9961f5aa..e00278fcfa4fa 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -400,10 +400,17 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 						  server->conn_id, server->hostname);
 	}
 smbd_done:
-	if (rc < 0 && rc != -EINTR)
+	/*
+	 * there's hardly any use for the layers above to know the
+	 * actual error code here. All they should do at this point is
+	 * to retry the connection and hope it goes away.
+	 */
+	if (rc < 0 && rc != -EINTR && rc != -EAGAIN) {
 		cifs_server_dbg(VFS, "Error %d sending data on socket to server\n",
 			 rc);
-	else if (rc > 0)
+		rc = -ECONNABORTED;
+		cifs_signal_cifsd_for_reconnect(server, false);
+	} else if (rc > 0)
 		rc = 0;
 out:
 	cifs_in_send_dec(server);
-- 
2.43.0



