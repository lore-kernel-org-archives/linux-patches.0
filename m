Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317C31DF973;
	Wed, 19 Mar 2025 14:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395280; cv=none; b=iEgc65BfxP4GsoQDTZ+NZF8FaOfwSXva2TaSlBrglUY5BiVYvKYSAWKnkQJh45qWFYq7FHmNRa9YpRmfttbuH/GFhxmGdhMiaJBlOmli2c1VVye0FRcmwgcSGDaPOz1rX4pjdcUl6I9P5yYmQo6y54s/O5ExPmCcBhABJCi6GeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395280; c=relaxed/simple;
	bh=KuVjdH2wv+UcySyhNdqKROp6x/y7r3oMbI1xL6pwX5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/wO5zF2/Gv3xfgv2WnSBrR7uNP5l03ciiJSTnygK8Ri3LcdVZqAOvCf+QAxrkCH7hbgAXXnG1BRLpeBJ+6NjaWMd5tsUM5B/u+nPTvaGx2heoTaZUelZ+lwvqVdSR4pdl2LBQrOCC+a1tpWOG/tWcuS44LW/ji8AzXpFB45GYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YL3ynPHT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YL3ynPHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22E0C4CEE4;
	Wed, 19 Mar 2025 14:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395280;
	bh=KuVjdH2wv+UcySyhNdqKROp6x/y7r3oMbI1xL6pwX5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YL3ynPHT7K+yyEpeWG/eN3LogGEOwlXTQZJR+vp4upNZRVkuI3vckoP+wzXiZHnee
	 46y2QDlu8X8uHj8M95PoUQMXMhJCqkzAUV4dhR0VzUw2XY9huhYPFc3OQJAK8V40Pu
	 BExb6b12svcskKUrJUTPO1jVYKRf7gUeqsu3J/Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/166] smb: client: Fix match_session bug preventing session reuse
Date: Wed, 19 Mar 2025 07:32:09 -0700
Message-ID: <20250319143024.310720473@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

From: Henrique Carvalho <henrique.carvalho@suse.com>

[ Upstream commit 605b249ea96770ac4fac4b8510a99e0f8442be5e ]

Fix a bug in match_session() that can causes the session to not be
reused in some cases.

Reproduction steps:

mount.cifs //server/share /mnt/a -o credentials=creds
mount.cifs //server/share /mnt/b -o credentials=creds,sec=ntlmssp
cat /proc/fs/cifs/DebugData | grep SessionId | wc -l

mount.cifs //server/share /mnt/b -o credentials=creds,sec=ntlmssp
mount.cifs //server/share /mnt/a -o credentials=creds
cat /proc/fs/cifs/DebugData | grep SessionId | wc -l

Cc: stable@vger.kernel.org
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index dbcaaa274abdb..198681d14153e 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1884,9 +1884,8 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 /* this function must be called with ses_lock and chan_lock held */
 static int match_session(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 {
-	if (ctx->sectype != Unspecified &&
-	    ctx->sectype != ses->sectype)
-		return 0;
+	struct TCP_Server_Info *server = ses->server;
+	enum securityEnum ctx_sec, ses_sec;
 
 	if (ctx->dfs_root_ses != ses->dfs_root_ses)
 		return 0;
@@ -1898,11 +1897,20 @@ static int match_session(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 	if (ses->chan_max < ctx->max_channels)
 		return 0;
 
-	switch (ses->sectype) {
+	ctx_sec = server->ops->select_sectype(server, ctx->sectype);
+	ses_sec = server->ops->select_sectype(server, ses->sectype);
+
+	if (ctx_sec != ses_sec)
+		return 0;
+
+	switch (ctx_sec) {
+	case IAKerb:
 	case Kerberos:
 		if (!uid_eq(ctx->cred_uid, ses->cred_uid))
 			return 0;
 		break;
+	case NTLMv2:
+	case RawNTLMSSP:
 	default:
 		/* NULL username means anonymous session */
 		if (ses->user_name == NULL) {
-- 
2.39.5



