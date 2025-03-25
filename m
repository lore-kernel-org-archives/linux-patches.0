Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13495267700;
	Tue, 25 Mar 2025 12:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905804; cv=none; b=K64OCzGTOfiBsQFTLYu0j+M0cmazJ7Levjmcz/Mr5nlR8IOFxeSMBprSKdzPjE05UmIif7AGk1sPfcKWwb5VT/KtHKKsYWSRHc0uVP78ZLfebaV4S4nPIDnavBEplLifyPJ38mZuWWLS2GpFmDRwWNTPNivxsZ9RzE55ULRg7LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905804; c=relaxed/simple;
	bh=6LuDw8RrRA+22cRNRs30JjGt7T04/fUkpPR5yNNCSag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZB4SXDhCl0aBJu+ssiEW3p4uWsQFTA0K42aTyt7unfhn2BrS8s9zYueH/yVR5kYAv9lS4Pv8mTZUQI6suU2ODpc5IXF+Dvw7y1aaZ2xfJzpNZa4KEpd4JjRXdJii2Unl17IdHFFen3f38bPOpzQY5ubJx1J23UfkiDxksyoaqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xc5z8FSZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xc5z8FSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81DDC4CEE4;
	Tue, 25 Mar 2025 12:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905803;
	bh=6LuDw8RrRA+22cRNRs30JjGt7T04/fUkpPR5yNNCSag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xc5z8FSZFJA8OxjcFI7hrjyn479jZBgkerUQZ0FJZM7dDaTTAvJbe3UeJYqwUKAMB
	 MnjlgKKvXLqAIvtQgD8YzLdSt/oOj9tVkfPSJwYfdLM3++EKJrxLaOINAcb3NwQfPO
	 4ckFwevuWHcSCH/H/1/eN6w+Gp/cluk6TJUEJV0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 142/198] smb: client: Fix match_session bug preventing session reuse
Date: Tue, 25 Mar 2025 08:21:44 -0400
Message-ID: <20250325122200.382209903@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index db30c4b8a2211..01ce81f77e891 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1881,9 +1881,8 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 /* this function must be called with ses_lock and chan_lock held */
 static int match_session(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 {
-	if (ctx->sectype != Unspecified &&
-	    ctx->sectype != ses->sectype)
-		return 0;
+	struct TCP_Server_Info *server = ses->server;
+	enum securityEnum ctx_sec, ses_sec;
 
 	/*
 	 * If an existing session is limited to less channels than
@@ -1892,11 +1891,20 @@ static int match_session(struct cifs_ses *ses, struct smb3_fs_context *ctx)
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



