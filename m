Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081401E497;
	Thu, 23 May 2024 13:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470614; cv=none; b=BEzrMs/bGbi1nq94/VQy/4Vq+yCrSy13n2q0KFqgiuKt4haQuLdUZgMT4dSIxfUQT/2lB59Uwvy5i+eCnmxxUCFe68QuDZF0WJKzGQIR+FUfQ467+I0rZCXp11W3c2sk+/YVBaAOIDvWjGx90lYArlxgHau0das0xC2Ra4nmSog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470614; c=relaxed/simple;
	bh=nsrZ0InUB23PC2zXl/I1xvHGOMG7fDwlJUprFddflhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gd//KE/29eUp+gQxhdepdHxCLSDt/54k29mjhc2v+XE6ItcjiMDfqrOOD3XqMxa9dOhrG6dfqoIPAvVxqYvh/WKJbN94iPPZYXuL0OadRqpywr3fZ2n2162EvRSghSrwGAzWJ/9+e82B5p5a0s1tUOn5QKGTJbJgmf7aK+6LGPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+vqihPB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+vqihPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379EFC2BD10;
	Thu, 23 May 2024 13:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470613;
	bh=nsrZ0InUB23PC2zXl/I1xvHGOMG7fDwlJUprFddflhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P+vqihPBrcl1MDeF5Xc4Zu4ORNDMBrIf+UXV7sgsa8LMez9Bq96p8IVPfpjbw4CC5
	 jLshjHUIMdzSgZsBnZM64/k/oQotngCFYwTGee32zeme2xxznJ/S9TC8e65O0DcMls
	 CtVIH1/To0HyxNOixy7Cyx+o4dr6jasrtRse/64k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/102] cifs: pick channel for tcon and tdis
Date: Thu, 23 May 2024 15:12:53 +0200
Message-ID: <20240523130343.524174586@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 268b8b5797becb242013fcd63173eb28c007c8ae ]

Today, the tree connect and disconnect requests are
sent on the primary channel only. However, the new
multichannel logic allows the session to remain active
even if one of the channels are alive. So a tree connect
can now be triggered during a reconnect on any of
its channels.

This change changes tcon and tdis calls to pick an
active channel instead of the first one.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2pdu.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 3f9448b5ada9b..95b5b4bdb4b7f 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2019,10 +2019,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	__le16 *unc_path = NULL;
 	int flags = 0;
 	unsigned int total_len;
-	struct TCP_Server_Info *server;
-
-	/* always use master channel */
-	server = ses->server;
+	struct TCP_Server_Info *server = cifs_pick_channel(ses);
 
 	cifs_dbg(FYI, "TCON\n");
 
@@ -2155,6 +2152,7 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 	struct smb2_tree_disconnect_req *req; /* response is trivial */
 	int rc = 0;
 	struct cifs_ses *ses = tcon->ses;
+	struct TCP_Server_Info *server = cifs_pick_channel(ses);
 	int flags = 0;
 	unsigned int total_len;
 	struct kvec iov[1];
@@ -2177,7 +2175,7 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 
 	invalidate_all_cached_dirs(tcon);
 
-	rc = smb2_plain_req_init(SMB2_TREE_DISCONNECT, tcon, ses->server,
+	rc = smb2_plain_req_init(SMB2_TREE_DISCONNECT, tcon, server,
 				 (void **) &req,
 				 &total_len);
 	if (rc)
@@ -2195,7 +2193,7 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 	rqst.rq_iov = iov;
 	rqst.rq_nvec = 1;
 
-	rc = cifs_send_recv(xid, ses, ses->server,
+	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buf_type, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	if (rc) {
-- 
2.43.0



