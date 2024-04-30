Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8539312C530;
	Tue, 30 Apr 2024 11:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475219; cv=none; b=gusWU2+GUa1LVW3AnSwhTQ/lr/N+Mw0K+hfM+Cc2m+YucMpesK3qiK+f615n7A6T1AFMW9S+q7YDu3ddaahwi78TPciGad/3yPuugOPdOvHfaPTWmBEd9wcXkpSjuvBbZP6M5GIUeyHyxXyaoRXpKpCOAyqj8w3rRp5zOLVGu98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475219; c=relaxed/simple;
	bh=e+Y/bKTor1y3nHMSwk+boAPjsv62OfODT6vxn+ffNPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKChqIu2p8WhASbmFHOjppW0E4iOFINZT8/QkwpEVKxM8xGHMtJjNc52cW2FXgtKcxaeoDOHObXGKTdEVL1/eydJ6XM/gBuPKZHyRGDAMVWwcujedxMklyNcXxOwwFSB1zqrKCFkP4My81PFoLzeD47SDzi3C/D8eC4Np/UzjIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=njGEgUT1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="njGEgUT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F131C2BBFC;
	Tue, 30 Apr 2024 11:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475219;
	bh=e+Y/bKTor1y3nHMSwk+boAPjsv62OfODT6vxn+ffNPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=njGEgUT1grlDENjABeoBjB9/88Vs0ACeMJr41dslxmisqQcE0hrlmZKj6ohieB8gG
	 5/EPZi3s1xRqUP5NiRfGU2UwsUsMPEe8qhb61Xqb76IlULSYcDLsUW8oA+HebXhs+q
	 9ARDpM54PPNonY0DkuldGXxA5HKNZptsoPJJVKyc=
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
Subject: [PATCH 6.6 003/186] cifs: reinstate original behavior again for forceuid/forcegid
Date: Tue, 30 Apr 2024 12:37:35 +0200
Message-ID: <20240430103058.115824144@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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
index 58567ae617b9f..103421791bb5d 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -714,6 +714,16 @@ static int smb3_fs_context_validate(struct fs_context *fc)
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
@@ -983,12 +993,14 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
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
index 8cfc25b609b6b..4e409238fe8f7 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -155,6 +155,8 @@ enum cifs_param {
 };
 
 struct smb3_fs_context {
+	bool forceuid_specified;
+	bool forcegid_specified;
 	bool uid_specified;
 	bool cruid_specified;
 	bool gid_specified;
-- 
2.43.0



