Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8AC17A30D;
	Wed, 19 Mar 2025 14:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394992; cv=none; b=ihuR28FJXNXy1y+xI6xsECtl/BABCSCTDqQ7lumkv8/sXw0UxQOlD54tE3zhay6YOIthmkC0pCG93LtmLBPSznXBZH5QhLOjM4RLnCrVkc9z4bS6rZsmyXzX9gJmuXHJTVI4wBGggZ/gTNyrYqUirweKgVey56WtONbcNH+rttc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394992; c=relaxed/simple;
	bh=fiyPU+ch/9LBhH5vpjh7z9bDArjjOAmcPbo78xDsTuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELi9TKWODkpEkwN4iR0yHJTQreBa+r48rTyuRCriTtHNUm35PlKowQbtmCvCLYHlsuGxkI+zcCfzlK6WmgF69TaPIV1UuiIDZPD0zoPYskG6PtJnGgmk7dtyP8aucRW9ZdOtntUBgAYYsmH2A3GLl2+wESQAtGVFb6jRPWpD5Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hG7VR3lv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hG7VR3lv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82269C4CEE4;
	Wed, 19 Mar 2025 14:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394992;
	bh=fiyPU+ch/9LBhH5vpjh7z9bDArjjOAmcPbo78xDsTuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hG7VR3lvE1qSt2XRYxP17EmmMdA1qWeNxNwTLPljYOlbLMjNEvx1iGKiCZmEJoO9W
	 QM6wToOWo6Xp1WL5fd6h0aizphyBGn5U+uO3hxdat14ktdEo2rSwRHLugb0jWrCx/1
	 OFrV14Mv5F7ub1bHpzIDNXoYI6czFMi2jn/g1TJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 234/241] smb: client: Fix match_session bug preventing session reuse
Date: Wed, 19 Mar 2025 07:31:44 -0700
Message-ID: <20250319143033.532107044@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index eaa6be4456d0e..a5d443c42996c 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1873,9 +1873,8 @@ static int match_session(struct cifs_ses *ses,
 			 struct smb3_fs_context *ctx,
 			 bool match_super)
 {
-	if (ctx->sectype != Unspecified &&
-	    ctx->sectype != ses->sectype)
-		return 0;
+	struct TCP_Server_Info *server = ses->server;
+	enum securityEnum ctx_sec, ses_sec;
 
 	if (!match_super && ctx->dfs_root_ses != ses->dfs_root_ses)
 		return 0;
@@ -1887,11 +1886,20 @@ static int match_session(struct cifs_ses *ses,
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



