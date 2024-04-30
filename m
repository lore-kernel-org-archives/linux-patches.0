Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD1312C47A;
	Tue, 30 Apr 2024 11:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476365; cv=none; b=tKDNRWRPJPasXGWV3R+4/tOBUShs1MOLE79sgkxx6HBXexy2Wqco5q/cXSh/lYYsBOL/DraZspkxU8ekAXrxEgVgtTTli6+DP8UZkSyfIU+aEcNOCoiU2nRSFNvrylezFX0WDXGy/ztnQFsWZQ58P1+peeNokoDs/zvMwGcgiWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476365; c=relaxed/simple;
	bh=5jViKmQUR/H3HaigYP2QWe9tZqiMeO7maiFfy6gswHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tithGlNcXTBBI6ap2y4zI0lK45lqZZox0/t0UbzTIPizYbDCTrCMTg2atwSEdeyAhUFsJd/sHxdLkGWj64CFTvdPzrDkZmqhmByEje+weQgRcUvws7o7ZwrUA7tchJaLqoM/4a/p4HZIGcCn+sxVHWJYZAtefMx8nf2BnyQw+p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zCsl7FCa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zCsl7FCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B954C2BBFC;
	Tue, 30 Apr 2024 11:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476365;
	bh=5jViKmQUR/H3HaigYP2QWe9tZqiMeO7maiFfy6gswHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zCsl7FCaMd71SdohgtDR5Fjy3pOOWGqfQ4Yext63nTiCTcRo85Eg3cG9uaMg8y7E9
	 q7m0vcs7suE74R6RQ6AHcGxStAxtpkOzqI8vX9GjMaubvbpHI3tUs/o+FK60Jri2Eu
	 DZmVhURSNTk1YlQ0im6+A8nF75dRbm6oVXFwEBSY=
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
Subject: [PATCH 6.1 002/110] cifs: reinstate original behavior again for forceuid/forcegid
Date: Tue, 30 Apr 2024 12:39:31 +0200
Message-ID: <20240430103047.638783423@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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
index 4d5302b58b534..ca39d01077cdf 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -676,6 +676,16 @@ static int smb3_fs_context_validate(struct fs_context *fc)
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
@@ -923,12 +933,14 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
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
index 26093f54d3e65..319a91b7f6700 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -154,6 +154,8 @@ enum cifs_param {
 };
 
 struct smb3_fs_context {
+	bool forceuid_specified;
+	bool forcegid_specified;
 	bool uid_specified;
 	bool cruid_specified;
 	bool gid_specified;
-- 
2.43.0



