Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9737EEF2;
	Mon,  8 Apr 2024 13:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584195; cv=none; b=YhatAb/kaZNcJCvwOCHHjKQ2PJwzh1PIbdSTWUZaMWaXSrpTtIrepUXsGOUfOO6K76lZibgZfec/eENGh032nN1d9t/azqEHkHcSgR+y3wsqINhhaisWojgeiiynbDd3yv9zdT/I/n9P6LlWDklWAc8Y5AZAxTwVrGK8GTc/bwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584195; c=relaxed/simple;
	bh=0Wf4Op1smJIoKeT1mWF598WF9h01LERGExaXUXCQa+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCFD+C4zEguFLVQX2bQsz8t3O5Z8vsrOLO3i9sBKB1tF3q7h41svG+bF4VEIMVLeluob99voUsSyNdh3ta4FKwFrzo9yk1E2Xc5qMzZ5nynnsjYJOcP4duf4JuhKKtHFqrugqCxnET5KCI7zBetVvRjoKW5eh8fCrhvrlc2Bc6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zI2dTFTk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zI2dTFTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44353C433F1;
	Mon,  8 Apr 2024 13:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584194;
	bh=0Wf4Op1smJIoKeT1mWF598WF9h01LERGExaXUXCQa+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zI2dTFTkCyKR3so1dn1WBQ1UKErGDAcF9pxRXN5fcolK4Lvw8ymHaEvMPedaGbB70
	 04n1h2IHKrdfvhESzYzmWRdr+B6HELKEMG+VSrvBj6Lowk5HBbswhBZUzXUvJ3Yk1k
	 i20mEPxVVdYKwX3R2CA4fN/P2rzAilA/aa1vuTLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 356/690] NFSD: Hook up the filecache stat file
Date: Mon,  8 Apr 2024 14:53:42 +0200
Message-ID: <20240408125412.492674137@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 2e6c6e4c4375bfd3defa5b1ff3604d9f33d1c936 ]

There has always been the capability of exporting filecache metrics
via /proc, but it was never hooked up. Let's surface these metrics
to enable better observability of the filecache.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
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



