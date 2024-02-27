Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947C613EFE4;
	Tue, 27 Feb 2024 14:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043188; cv=none; b=PUFP7OGKYHpo214OEeoLNv+/bFhlXl4JnMRffq8xfqFu2zxu8UacNkjPt4DEyKA5mp/z9eorRHgOuIOxS5VX5yyHkFpu9E+RKxXgl4CeEdnF9lcBu63wRLH4pfxk94YlrY+2M/r4RF3Ft4+mvNh2elGGK5WLpz+Q4Z1ZDsDcFFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043188; c=relaxed/simple;
	bh=K6DiBGAFCugeDaDYfNemGdaWHHXNE9GLb+EzpI78wpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FELdtDmXZnZhBj7UcoY6f1WE3F0Gkc5q9CfLDc4U/0IZfwFn0SvMWcd8zZX0uJ+sNmMMOzHUmbI96hkxTZ8rampInJvRM29E9sbtQAzJuol9d4oqETYKHYtIiutMISAsc5fttEs4Ue6kwPNCPQYfun5P54w4x0kJRtU7QVoFcrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z32NAQsX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z32NAQsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260E4C433F1;
	Tue, 27 Feb 2024 14:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043188;
	bh=K6DiBGAFCugeDaDYfNemGdaWHHXNE9GLb+EzpI78wpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z32NAQsX/R3591T9TBAfTCY7tDAPJYnEMJd+5TTyraP3+0EqI0iHVBOeVBHhPe9G2
	 MRSUX1ui2zDGKo4rkW5ZNZQo858PMLsh1qr8N8+DHSDXnqSONr2jUX2Pl8HC2D5lGt
	 4gw1JTiuqVr7iasEdO79Cs6+iash9HOCQPZFPFcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/195] cifs: translate network errors on send to -ECONNABORTED
Date: Tue, 27 Feb 2024 14:24:41 +0100
Message-ID: <20240227131611.062138971@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8a1dd8407a3a7..97bf46de8e429 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -427,10 +427,17 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
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



