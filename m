Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A651F1A0714;
	Tue, 18 Jun 2024 13:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716195; cv=none; b=OhGRKNIYY3yjWlqA4muyGIu4lp3QjZ7Ap9PjvSEDaHUw1m8pliItEA6l3O5TD2N0nlBpS0N762r3U8Voo7c1PMysMG+7Uyh6qAULMjzpFvdFeWufJ8Q7ZSkjX8XPnUakGOPiMq/iTrX2NevUX3iodfKTakj0nk8aLOT0jsGt3nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716195; c=relaxed/simple;
	bh=uA7vicCcfOSWlTcbu01h+SigoPJVlLj2axY3sd4x9Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwioH2yafF7eqnIrrThMfUmfeJaQSYjFMN9f9KxyjbBtYBKRWI9/JePl8FYuPVr2+X7st0xGVLcvEah/AQi7QwivN0/P4o0ld46eZZhpLKN3OkxvP7HxW4OCMOxumiEPb8IFP/r4sHwMO0CWNdn429XXJBMafpj0XAqVrjwKdK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nbMpqKZA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nbMpqKZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D998EC3277B;
	Tue, 18 Jun 2024 13:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716195;
	bh=uA7vicCcfOSWlTcbu01h+SigoPJVlLj2axY3sd4x9Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nbMpqKZAeE8abEgzIe6oVRl93R5cnGXx5f/6/4jR9EJEXgZqtFZt2F+q3pgkLUKg/
	 nz0I0gf8SWx1jpEbdX6m0KV20lQ7ohQSbZ1TfQHdO8kXZQhFupijcEcIUeBymc/lp4
	 FZsPntth6nNFHj+ksEvk4OILjWb7zAb3k8xIDGLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 565/770] NFSD: Hook up the filecache stat file
Date: Tue, 18 Jun 2024 14:36:58 +0200
Message-ID: <20240618123429.108642863@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 2e6c6e4c4375bfd3defa5b1ff3604d9f33d1c936 ]

There has always been the capability of exporting filecache metrics
via /proc, but it was never hooked up. Let's surface these metrics
to enable better observability of the filecache.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsctl.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 66c352bf61b1d..7002edbf26870 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -25,6 +25,7 @@
 #include "state.h"
 #include "netns.h"
 #include "pnfs.h"
+#include "filecache.h"
 
 /*
  *	We have a single directory with several nodes in it.
@@ -45,6 +46,7 @@ enum {
 	NFSD_Ports,
 	NFSD_MaxBlkSize,
 	NFSD_MaxConnections,
+	NFSD_Filecache,
 	NFSD_SupportedEnctypes,
 	/*
 	 * The below MUST come last.  Otherwise we leave a hole in nfsd_files[]
@@ -229,6 +231,13 @@ static const struct file_operations reply_cache_stats_operations = {
 	.release	= single_release,
 };
 
+static const struct file_operations filecache_ops = {
+	.open		= nfsd_file_cache_stats_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /*----------------------------------------------------------------------------*/
 /*
  * payload - write methods
@@ -1370,6 +1379,7 @@ static int nfsd_fill_super(struct super_block *sb, struct fs_context *fc)
 		[NFSD_Ports] = {"portlist", &transaction_ops, S_IWUSR|S_IRUGO},
 		[NFSD_MaxBlkSize] = {"max_block_size", &transaction_ops, S_IWUSR|S_IRUGO},
 		[NFSD_MaxConnections] = {"max_connections", &transaction_ops, S_IWUSR|S_IRUGO},
+		[NFSD_Filecache] = {"filecache", &filecache_ops, S_IRUGO},
 #if defined(CONFIG_SUNRPC_GSS) || defined(CONFIG_SUNRPC_GSS_MODULE)
 		[NFSD_SupportedEnctypes] = {"supported_krb5_enctypes", &supported_enctypes_ops, S_IRUGO},
 #endif /* CONFIG_SUNRPC_GSS or CONFIG_SUNRPC_GSS_MODULE */
-- 
2.43.0



