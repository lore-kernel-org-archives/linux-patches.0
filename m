Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AF212C48A;
	Tue, 30 Apr 2024 10:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473949; cv=none; b=OqJ1aRqfxwYZgYUPY7pQ9oe/6xSOhjCnayzs8N4/3JIjGebI2aFrcxAOst/u0d3DMzkX0yfZ+tAgZ7xV1fE0rFlg9UPdRYnj9WtziXRd5fzE5yCs8Wfu3M6QFmK6g9wGOq+xuLmQ/QNik0j7Kf/COdHLjzLzhjQ3ILm0MCwRddc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473949; c=relaxed/simple;
	bh=09GT1LCeMZUL0AMRUNhEg49Tp437ZwQTtqmIOdx1er0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7kz3q71ze6MeBPgOvsOqkMsHPSo2sZYdvheFZG7NkJR/TA1gLfl1Bt1gvoD/c1PeC+wsrf34SYQwWRrcDTfBr1UCnrKWuFkj0iHOku3JJqcFL09mzTOVYJEkc1DKYbpNtPROZnEDhAGg84bDczZ8PkM+HpXko+AD4yvb5vQWDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBL4i8lT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBL4i8lT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E41C2BBFC;
	Tue, 30 Apr 2024 10:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473949;
	bh=09GT1LCeMZUL0AMRUNhEg49Tp437ZwQTtqmIOdx1er0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yBL4i8lTH7ScnxBxP1QtbvA0BFHAsFa5dTfJh5ERLoAZbz2ksS/X/mew0B1JEumH8
	 gF3IOMZ8bI6VLcwgqjyVLPPxqt/zzS/bkUL1UlQ/fIFpxCne/jtadJRaVOmM82+Zpw
	 ubB7mqoPgrXNF7p0Xn5W82gfIjCZj/iTi+JFTJSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takayuki Nagata <tnagata@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 003/228] cifs: reinstate original behavior again for forceuid/forcegid
Date: Tue, 30 Apr 2024 12:36:21 +0200
Message-ID: <20240430103103.911408801@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takayuki Nagata <tnagata@redhat.com>

[ Upstream commit 77d8aa79ecfb209308e0644c02f655122b31def7 ]

forceuid/forcegid should be enabled by default when uid=/gid= options are
specified, but commit 24e0a1eff9e2 ("cifs: switch to new mount api")
changed the behavior. Due to the change, a mounted share does not show
intentional uid/gid for files and directories even though uid=/gid=
options are specified since forceuid/forcegid are not enabled.

This patch reinstates original behavior that overrides uid/gid with
specified uid/gid by the options.

Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
Signed-off-by: Takayuki Nagata <tnagata@redhat.com>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
Acked-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 12 ++++++++++++
 fs/smb/client/fs_context.h |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index d9fe17b2ba375..775b0ca605892 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -715,6 +715,16 @@ static int smb3_fs_context_validate(struct fs_context *fc)
 	/* set the port that we got earlier */
 	cifs_set_port((struct sockaddr *)&ctx->dstaddr, ctx->port);
 
+	if (ctx->uid_specified && !ctx->forceuid_specified) {
+		ctx->override_uid = 1;
+		pr_notice("enabling forceuid mount option implicitly because uid= option is specified\n");
+	}
+
+	if (ctx->gid_specified && !ctx->forcegid_specified) {
+		ctx->override_gid = 1;
+		pr_notice("enabling forcegid mount option implicitly because gid= option is specified\n");
+	}
+
 	if (ctx->override_uid && !ctx->uid_specified) {
 		ctx->override_uid = 0;
 		pr_notice("ignoring forceuid mount option specified with no uid= option\n");
@@ -984,12 +994,14 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 			ctx->override_uid = 0;
 		else
 			ctx->override_uid = 1;
+		ctx->forceuid_specified = true;
 		break;
 	case Opt_forcegid:
 		if (result.negated)
 			ctx->override_gid = 0;
 		else
 			ctx->override_gid = 1;
+		ctx->forcegid_specified = true;
 		break;
 	case Opt_perm:
 		if (result.negated)
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index b3d51b345eaef..61776572b8d2d 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -156,6 +156,8 @@ enum cifs_param {
 };
 
 struct smb3_fs_context {
+	bool forceuid_specified;
+	bool forcegid_specified;
 	bool uid_specified;
 	bool cruid_specified;
 	bool gid_specified;
-- 
2.43.0



