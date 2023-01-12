Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE94749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E15C433EF;
	Thu, 12 Jan 2023 14:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532513;
	bh=tfU/DkmOk2Xx6bEy1TtvBr5U69bE3AgAoqNWQqXV3oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJdGkTAeMyj4ZTH2N5hb1R9gYQ/zaFlMbYf+T0YthhnsopLkM5xHG2+j6PWaWMMLX
	 F54w47tO/TgmNYRsXorXK6S3j8Irml9/iLRHrE09ktK+Krx33QPw6L/gVtHamzQqbQ
	 CdhyKKKXdMvGPI/3QVcbJfISdKTZwAkkKs+FR4pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 187/783] NFSv4: Fix a deadlock between nfs4_open_recover_helper() and delegreturn
Date: Thu, 12 Jan 2023 14:48:23 +0100
Message-Id: <20230112135532.993975656@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 51069e4aef6257b0454057359faed0ab0c9af083 ]

If we're asked to recover open state while a delegation return is
outstanding, then the state manager thread cannot use a cached open, so
if the server returns a delegation, we can end up deadlocked behind the
pending delegreturn.
To avoid this problem, let's just ask the server not to give us a
delegation unless we're explicitly reclaiming one.

Fixes: be36e185bd26 ("NFSv4: nfs4_open_recover_helper() must set share access")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 15550d673e61..ee46ab09e330 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2126,18 +2126,18 @@ static struct nfs4_opendata *nfs4_open_recoverdata_alloc(struct nfs_open_context
 }
 
 static int nfs4_open_recover_helper(struct nfs4_opendata *opendata,
-		fmode_t fmode)
+				    fmode_t fmode)
 {
 	struct nfs4_state *newstate;
+	struct nfs_server *server = NFS_SB(opendata->dentry->d_sb);
+	int openflags = opendata->o_arg.open_flags;
 	int ret;
 
 	if (!nfs4_mode_match_open_stateid(opendata->state, fmode))
 		return 0;
-	opendata->o_arg.open_flags = 0;
 	opendata->o_arg.fmode = fmode;
-	opendata->o_arg.share_access = nfs4_map_atomic_open_share(
-			NFS_SB(opendata->dentry->d_sb),
-			fmode, 0);
+	opendata->o_arg.share_access =
+		nfs4_map_atomic_open_share(server, fmode, openflags);
 	memset(&opendata->o_res, 0, sizeof(opendata->o_res));
 	memset(&opendata->c_res, 0, sizeof(opendata->c_res));
 	nfs4_init_opendata_res(opendata);
@@ -2713,10 +2713,15 @@ static int _nfs4_open_expired(struct nfs_open_context *ctx, struct nfs4_state *s
 	struct nfs4_opendata *opendata;
 	int ret;
 
-	opendata = nfs4_open_recoverdata_alloc(ctx, state,
-			NFS4_OPEN_CLAIM_FH);
+	opendata = nfs4_open_recoverdata_alloc(ctx, state, NFS4_OPEN_CLAIM_FH);
 	if (IS_ERR(opendata))
 		return PTR_ERR(opendata);
+	/*
+	 * We're not recovering a delegation, so ask for no delegation.
+	 * Otherwise the recovery thread could deadlock with an outstanding
+	 * delegation return.
+	 */
+	opendata->o_arg.open_flags = O_DIRECT;
 	ret = nfs4_open_recover(opendata, state);
 	if (ret == -ESTALE)
 		d_drop(ctx->dentry);
-- 
2.35.1



