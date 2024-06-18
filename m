Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F36916191B;
	Tue, 18 Jun 2024 12:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715123; cv=none; b=tOXyuSjlJJIbawvr76hUXAYwYtGbxRKwOFr3+Hv3sN4xejlC0QzF3iGJXW2WYA37xDECgY9/Ha5dBalMKG9FxCNsOCpzKXAwiLGkpc5RKmAETQZlF69zV2kZZ5di+zLAQFTCzdXcADY+hdVcoop99uN8e7rQ6LMJjVpvbToyK3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715123; c=relaxed/simple;
	bh=GtWYVHZc1YlSwk3L/KAuT4IZLEZiIOkrBh1XEAcTqA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2Rn5UJ9OjJq47uy2T3F4R4onyEoxqtZvaiplCYmxsX6/23kKdEqSWLB/pyfE6HY8i35gCOmVEoBLjxSdRuJlrDrJXD54FSusnvfHlLnQxhnGuHxjfkHQJc7pcX595YXGntDe7EZrE1WMkB7UxguP5bvnsxyyqq/ifupqR8I3Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=elftsB2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="elftsB2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04759C3277B;
	Tue, 18 Jun 2024 12:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715123;
	bh=GtWYVHZc1YlSwk3L/KAuT4IZLEZiIOkrBh1XEAcTqA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=elftsB2SOIzOpZV+I/GtuIqVXz5H/PTxLmu27DtO9XG/3nBJ/OevVc+xwrxYO20Cm
	 6/SO6B/MNmB9D4qBR1uUd0SlU5+UnsGOFY6AjAAnAn45KoCGNzqdPTA028VRD30f8V
	 xdhPtv2eOt/udp0ZbUViU1URi5Aff9jUxHghNyJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/770] nfsd: remove unused stats counters
Date: Tue, 18 Jun 2024 14:30:28 +0200
Message-ID: <20240618123414.026330583@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 1b76d1df1a3683b6b23cd1c813d13c5e6a9d35e5 ]

Commit 501cb1849f86 ("nfsd: rip out the raparms cache") removed the
code that updates read-ahead cache stats counters,
commit 8bbfa9f3889b ("knfsd: remove the nfsd thread busy histogram")
removed code that updates the thread busy stats counters back in 2009
and code that updated filehandle cache stats was removed back in 2002.

Remove the unused stats counters from nfsd_stats struct and print
hardcoded zeros in /proc/net/rpc/nfsd.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/stats.c | 41 ++++++++++++++++-------------------------
 fs/nfsd/stats.h | 10 ----------
 2 files changed, 16 insertions(+), 35 deletions(-)

diff --git a/fs/nfsd/stats.c b/fs/nfsd/stats.c
index b1bc582b0493e..e928e224205ac 100644
--- a/fs/nfsd/stats.c
+++ b/fs/nfsd/stats.c
@@ -7,16 +7,14 @@
  * Format:
  *	rc <hits> <misses> <nocache>
  *			Statistsics for the reply cache
- *	fh <stale> <total-lookups> <anonlookups> <dir-not-in-dcache> <nondir-not-in-dcache>
+ *	fh <stale> <deprecated filehandle cache stats>
  *			statistics for filehandle lookup
  *	io <bytes-read> <bytes-written>
  *			statistics for IO throughput
- *	th <threads> <fullcnt> <10%-20%> <20%-30%> ... <90%-100%> <100%> 
- *			time (seconds) when nfsd thread usage above thresholds
- *			and number of times that all threads were in use
- *	ra cache-size  <10%  <20%  <30% ... <100% not-found
- *			number of times that read-ahead entry was found that deep in
- *			the cache.
+ *	th <threads> <deprecated thread usage histogram stats>
+ *			number of threads
+ *	ra <deprecated ra-cache stats>
+ *
  *	plus generic RPC stats (see net/sunrpc/stats.c)
  *
  * Copyright (C) 1995, 1996, 1997 Olaf Kirch <okir@monad.swb.de>
@@ -38,31 +36,24 @@ static int nfsd_proc_show(struct seq_file *seq, void *v)
 {
 	int i;
 
-	seq_printf(seq, "rc %u %u %u\nfh %u %u %u %u %u\nio %u %u\n",
+	seq_printf(seq, "rc %u %u %u\nfh %u 0 0 0 0\nio %u %u\n",
 		      nfsdstats.rchits,
 		      nfsdstats.rcmisses,
 		      nfsdstats.rcnocache,
 		      nfsdstats.fh_stale,
-		      nfsdstats.fh_lookup,
-		      nfsdstats.fh_anon,
-		      nfsdstats.fh_nocache_dir,
-		      nfsdstats.fh_nocache_nondir,
 		      nfsdstats.io_read,
 		      nfsdstats.io_write);
+
 	/* thread usage: */
-	seq_printf(seq, "th %u %u", nfsdstats.th_cnt, nfsdstats.th_fullcnt);
-	for (i=0; i<10; i++) {
-		unsigned int jifs = nfsdstats.th_usage[i];
-		unsigned int sec = jifs / HZ, msec = (jifs % HZ)*1000/HZ;
-		seq_printf(seq, " %u.%03u", sec, msec);
-	}
-
-	/* newline and ra-cache */
-	seq_printf(seq, "\nra %u", nfsdstats.ra_size);
-	for (i=0; i<11; i++)
-		seq_printf(seq, " %u", nfsdstats.ra_depth[i]);
-	seq_putc(seq, '\n');
-	
+	seq_printf(seq, "th %u 0", nfsdstats.th_cnt);
+
+	/* deprecated thread usage histogram stats */
+	for (i = 0; i < 10; i++)
+		seq_puts(seq, " 0.000");
+
+	/* deprecated ra-cache stats */
+	seq_puts(seq, "\nra 0 0 0 0 0 0 0 0 0 0 0 0\n");
+
 	/* show my rpc info */
 	svc_seq_show(seq, &nfsd_svcstats);
 
diff --git a/fs/nfsd/stats.h b/fs/nfsd/stats.h
index b23fdac698201..5e3cdf21556a1 100644
--- a/fs/nfsd/stats.h
+++ b/fs/nfsd/stats.h
@@ -15,19 +15,9 @@ struct nfsd_stats {
 	unsigned int	rcmisses;	/* repcache hits */
 	unsigned int	rcnocache;	/* uncached reqs */
 	unsigned int	fh_stale;	/* FH stale error */
-	unsigned int	fh_lookup;	/* dentry cached */
-	unsigned int	fh_anon;	/* anon file dentry returned */
-	unsigned int	fh_nocache_dir;	/* filehandle not found in dcache */
-	unsigned int	fh_nocache_nondir;	/* filehandle not found in dcache */
 	unsigned int	io_read;	/* bytes returned to read requests */
 	unsigned int	io_write;	/* bytes passed in write requests */
 	unsigned int	th_cnt;		/* number of available threads */
-	unsigned int	th_usage[10];	/* number of ticks during which n perdeciles
-					 * of available threads were in use */
-	unsigned int	th_fullcnt;	/* number of times last free thread was used */
-	unsigned int	ra_size;	/* size of ra cache */
-	unsigned int	ra_depth[11];	/* number of times ra entry was found that deep
-					 * in the cache (10percentiles). [10] = not found */
 #ifdef CONFIG_NFSD_V4
 	unsigned int	nfs4_opcount[LAST_NFS4_OP + 1];	/* count of individual nfsv4 operations */
 #endif
-- 
2.43.0



