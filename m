Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651151BB6AD;
	Thu, 15 Aug 2024 14:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730775; cv=none; b=HT5gRjdY+JJakyKzK3jEQ/bqaB1mYaJw5S/s9hqkd+B/J+OYcxd07qy4njmhvXO0NP9tH+VWlaCp7aVpxIRzW0iPNDbM2ZLZzQ5yoadMipmycr0DC+R4gPeDPZFkkvwLFODf0E1suqMTMtXb84F5hlUxpcHYBuhwyt6YowemGYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730775; c=relaxed/simple;
	bh=CqhZsu9JhJnEpUXkx7vQysQkha4+SK9g4KxrXhmhnt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upMFn2J1D/iGoJzP4rYCRzbR4/c9Co2CTcHhk6m/KQSD1cJ6A/cLXPgCehTRt5i/Ei8AFq/j87Q4J5iTe4BsP5evF271pfdvQZt05oZRYiZ1WgDrqE81pIP3WFJ1jh2b++WzGcNIP9t0niChE2fUCDaxv4K2zhRhnP7endrF2aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pyzXEL40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pyzXEL40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8095CC4AF0C;
	Thu, 15 Aug 2024 14:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730774;
	bh=CqhZsu9JhJnEpUXkx7vQysQkha4+SK9g4KxrXhmhnt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pyzXEL40TCO2OyKCo0nMsZyiCQZJrs4Ms8Pe28QtdJ7gt5ADYxdVKyqeNlbrGTrRs
	 RanM/D7JUlKzbNYbfosEfHswz/zlfkkNFFI8srLTdcy/IvdU3VLLAVZALGxnhyqW5Q
	 1le8jmFfru8mD4DVSRobL9mOpjzJNJ01Xp612J9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 27/38] nfsd: make svc_stat per-network namespace instead of global
Date: Thu, 15 Aug 2024 15:26:01 +0200
Message-ID: <20240815131834.002115924@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131832.944273699@linuxfoundation.org>
References: <20240815131832.944273699@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 16fb9808ab2c99979f081987752abcbc5b092eac ]

The final bit of stats that is global is the rpc svc_stat.  Move this
into the nfsd_net struct and use that everywhere instead of the global
struct.  Remove the unused global struct.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/netns.h  |    4 ++++
 fs/nfsd/nfsctl.c |    2 ++
 fs/nfsd/nfssvc.c |    2 +-
 fs/nfsd/stats.c  |   10 ++++------
 fs/nfsd/stats.h  |    2 --
 5 files changed, 11 insertions(+), 9 deletions(-)

--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -13,6 +13,7 @@
 #include <linux/nfs4.h>
 #include <linux/percpu_counter.h>
 #include <linux/siphash.h>
+#include <linux/sunrpc/stats.h>
 
 /* Hash tables for nfs4_clientid state */
 #define CLIENT_HASH_BITS                 4
@@ -183,6 +184,9 @@ struct nfsd_net {
 	/* Per-netns stats counters */
 	struct percpu_counter    counter[NFSD_STATS_COUNTERS_NUM];
 
+	/* sunrpc svc stats */
+	struct svc_stat          nfsd_svcstats;
+
 	/* longest hash chain seen */
 	unsigned int             longest_chain;
 
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1453,6 +1453,8 @@ static __net_init int nfsd_init_net(stru
 	retval = nfsd_stat_counters_init(nn);
 	if (retval)
 		goto out_repcache_error;
+	memset(&nn->nfsd_svcstats, 0, sizeof(nn->nfsd_svcstats));
+	nn->nfsd_svcstats.program = &nfsd_program;
 	nn->nfsd_versions = NULL;
 	nn->nfsd4_minorversions = NULL;
 	nfsd4_init_leases_net(nn);
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -657,7 +657,7 @@ int nfsd_create_serv(struct net *net)
 	if (nfsd_max_blksize == 0)
 		nfsd_max_blksize = nfsd_get_default_max_blksize();
 	nfsd_reset_versions(nn);
-	serv = svc_create_pooled(&nfsd_program, &nfsd_svcstats,
+	serv = svc_create_pooled(&nfsd_program, &nn->nfsd_svcstats,
 				 nfsd_max_blksize, nfsd);
 	if (serv == NULL)
 		return -ENOMEM;
--- a/fs/nfsd/stats.c
+++ b/fs/nfsd/stats.c
@@ -27,10 +27,6 @@
 
 #include "nfsd.h"
 
-struct svc_stat		nfsd_svcstats = {
-	.program	= &nfsd_program,
-};
-
 static int nfsd_show(struct seq_file *seq, void *v)
 {
 	struct net *net = pde_data(file_inode(seq->file));
@@ -56,7 +52,7 @@ static int nfsd_show(struct seq_file *se
 	seq_puts(seq, "\nra 0 0 0 0 0 0 0 0 0 0 0 0\n");
 
 	/* show my rpc info */
-	svc_seq_show(seq, &nfsd_svcstats);
+	svc_seq_show(seq, &nn->nfsd_svcstats);
 
 #ifdef CONFIG_NFSD_V4
 	/* Show count for individual nfsv4 operations */
@@ -119,7 +115,9 @@ void nfsd_stat_counters_destroy(struct n
 
 void nfsd_proc_stat_init(struct net *net)
 {
-	svc_proc_register(net, &nfsd_svcstats, &nfsd_proc_ops);
+	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+
+	svc_proc_register(net, &nn->nfsd_svcstats, &nfsd_proc_ops);
 }
 
 void nfsd_proc_stat_shutdown(struct net *net)
--- a/fs/nfsd/stats.h
+++ b/fs/nfsd/stats.h
@@ -10,8 +10,6 @@
 #include <uapi/linux/nfsd/stats.h>
 #include <linux/percpu_counter.h>
 
-extern struct svc_stat		nfsd_svcstats;
-
 int nfsd_percpu_counters_init(struct percpu_counter *counters, int num);
 void nfsd_percpu_counters_reset(struct percpu_counter *counters, int num);
 void nfsd_percpu_counters_destroy(struct percpu_counter *counters, int num);


