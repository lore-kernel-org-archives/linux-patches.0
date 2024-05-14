Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDC08615E;
	Tue, 14 May 2024 11:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687529; cv=none; b=P3akolWjI8NxcE2ADCL1qmuMcE/fyQjCExjU2Di4g8lwUd9X2u2+20KIDsYlv6MsJCB41Ee0/5Z1yYFkkJ4I9NOCa8kZWe2A1Q7IgTGtadRm/wnV3ckpt6DR8zgl6MsOb4vuhEOmXsgAnAUhtYXblof56AwAVI1ul7W73mcSJxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687529; c=relaxed/simple;
	bh=NasKqq0AjTBW8VoWufgoHzUgnskHuTWPMy8jYdp55n8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQEytRTeJ+RZtYQ0B+y0HFuA7VAMZytt2vFEXR+iiztO4/rrA7wrvSLXzfcNu8SpqlPjt7iUe0Qz9ozdLLk3/+JpuKeZ8tnYHpG6EZTz8m7hako86rg3hVBSJsInpUk0xPe8UrfMuV2X06vwK2W+UsBx7afcrolDZNroYZ7I1bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1d8X3LiC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1d8X3LiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B70C32781;
	Tue, 14 May 2024 11:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687529;
	bh=NasKqq0AjTBW8VoWufgoHzUgnskHuTWPMy8jYdp55n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1d8X3LiCap6Jrp2zJa0aHc8eQ/KKwA1wKXrrKYOUVPkp0sCclb4ZkJgdluWUSPStP
	 ZReyewK8/w62gkGE7+Deu4TOEaPGTwqYv9rrZVjYxzyShKHC8zwSApf5kIdVWQh5SQ
	 5uukxdNgRnncrxyujq/5ysGJWt0cdhvdZsUyV3L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/168] sunrpc: add a struct rpc_stats arg to rpc_create_args
Date: Tue, 14 May 2024 12:18:34 +0200
Message-ID: <20240514101007.300844121@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 2057a48d0dd00c6a2a94ded7df2bf1d3f2a4a0da ]

We want to be able to have our rpc stats handled in a per network
namespace manner, so add an option to rpc_create_args to specify a
different rpc_stats struct instead of using the one on the rpc_program.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: 24457f1be29f ("nfs: Handle error of rpc_proc_register() in nfs_net_init().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/clnt.h | 1 +
 net/sunrpc/clnt.c           | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/sunrpc/clnt.h b/include/linux/sunrpc/clnt.h
index 71ec22b1df860..9c5197c360b98 100644
--- a/include/linux/sunrpc/clnt.h
+++ b/include/linux/sunrpc/clnt.h
@@ -130,6 +130,7 @@ struct rpc_create_args {
 	const char		*servername;
 	const char		*nodename;
 	const struct rpc_program *program;
+	struct rpc_stat		*stats;
 	u32			prognumber;	/* overrides program->number */
 	u32			version;
 	rpc_authflavor_t	authflavor;
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index af1ca707c3d35..59fd6dedbbed2 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -398,7 +398,7 @@ static struct rpc_clnt * rpc_new_client(const struct rpc_create_args *args,
 	clnt->cl_maxproc  = version->nrprocs;
 	clnt->cl_prog     = args->prognumber ? : program->number;
 	clnt->cl_vers     = version->number;
-	clnt->cl_stats    = program->stats;
+	clnt->cl_stats    = args->stats ? : program->stats;
 	clnt->cl_metrics  = rpc_alloc_iostats(clnt);
 	rpc_init_pipe_dir_head(&clnt->cl_pipedir_objects);
 	err = -ENOMEM;
@@ -677,6 +677,7 @@ struct rpc_clnt *rpc_clone_client(struct rpc_clnt *clnt)
 		.version	= clnt->cl_vers,
 		.authflavor	= clnt->cl_auth->au_flavor,
 		.cred		= clnt->cl_cred,
+		.stats		= clnt->cl_stats,
 	};
 	return __rpc_clone_client(&args, clnt);
 }
@@ -699,6 +700,7 @@ rpc_clone_client_set_auth(struct rpc_clnt *clnt, rpc_authflavor_t flavor)
 		.version	= clnt->cl_vers,
 		.authflavor	= flavor,
 		.cred		= clnt->cl_cred,
+		.stats		= clnt->cl_stats,
 	};
 	return __rpc_clone_client(&args, clnt);
 }
@@ -979,6 +981,7 @@ struct rpc_clnt *rpc_bind_new_program(struct rpc_clnt *old,
 		.version	= vers,
 		.authflavor	= old->cl_auth->au_flavor,
 		.cred		= old->cl_cred,
+		.stats		= old->cl_stats,
 	};
 	struct rpc_clnt *clnt;
 	int err;
-- 
2.43.0



