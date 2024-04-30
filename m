Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930728801;
	Tue, 30 Apr 2024 11:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475793; cv=none; b=fYk6o5P1LWB9iSqIni1OsWK6cQxWv2jYlSsSNvH+Cm65p153PkTbUkvo0sREpVvvOoBkWtcCaW9AocUgAG3kPWdEOgLzpc6t8GzC2AZM9mewlFbqeDEE6nGXZ320fFI5nGKfQC4sAnv1MxQtpikRzmJlVzEWRHedhO0q9joOE9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475793; c=relaxed/simple;
	bh=xIG2xB27LslhjcbnFoBJBiqjaxGyQcuh3q27YgV2rZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWy1lP8SC05sVrWBJ88bO7xXZPn1wp19wD0RkdVIeVos9EdDQ6Ub5rhtVIXXZ3zL0vPnUDGxV/V1ynwXHvkn8ynV+ev/WbKR9i6gXQwKUlvXh3/uHj5noVZfhDmOF21q62ddl5asVgpSblEh344pEkTfNvPwCkHx2ZWbtKnF3fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nCGAzng7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nCGAzng7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B362C2BBFC;
	Tue, 30 Apr 2024 11:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475793;
	bh=xIG2xB27LslhjcbnFoBJBiqjaxGyQcuh3q27YgV2rZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nCGAzng7rpCkQyDuTkEiqCKkBpu1ojB1/afwo5gRO9ldNU+jMQkBIDwkgggyot/Eq
	 WaHjSetk+0pamxJx/G087iaHukAEJyIhSCiiZFsZLfZbGL0l8pnvVF2w4AF5Hn4h9e
	 vMQAcwkC9FOKg+XU0RVdn4JzbsBPnopUYxaSrba8=
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
Subject: [PATCH 5.15 02/80] cifs: reinstate original behavior again for forceuid/forcegid
Date: Tue, 30 Apr 2024 12:39:34 +0200
Message-ID: <20240430103043.473550585@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/cifs/fs_context.c | 12 ++++++++++++
 fs/cifs/fs_context.h |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 6347e759b5ccf..fb3651513f83a 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -672,6 +672,16 @@ static int smb3_fs_context_validate(struct fs_context *fc)
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
@@ -903,12 +913,14 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
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
diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index 3cf8d6235162d..74bb19ec7c839 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -152,6 +152,8 @@ enum cifs_param {
 };
 
 struct smb3_fs_context {
+	bool forceuid_specified;
+	bool forcegid_specified;
 	bool uid_specified;
 	bool cruid_specified;
 	bool gid_specified;
-- 
2.43.0



