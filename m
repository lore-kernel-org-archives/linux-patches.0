Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB45B5381A;
	Tue, 10 Sep 2024 10:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965058; cv=none; b=M8xhif/L+Kxn5I7QvaOyOU66DNA0KGVSVPrmcA6UwY8xYhgjehU2ixb+/xF7PyHe0wxcDzmASdegYeD1m7o24z0xsq8TvOKP0kyMZfJgVushuMklDzWCLRmf98HGPVGRhpYIL3QbNBJ8PD9Z9D6GhTrkXC57ReIbq8Oz2Beez7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965058; c=relaxed/simple;
	bh=DvQ/eYCCusgHq192Aln2TWTfA+smOyh0KpDncdIfcyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDyVoc3gvHjkawbIuGT754rLK+1n5V53sxK53pHc61X4ukO8zZpccP4cEz2+4P9FyK9lle7ayjdpZrCk5wscO9PN0Cw0l0wvnVrYkRueexDL+ooyMFMf3iHaK5gJUbINcWNgTHqts9h0yE8SjnW18fkbnw0JHEKMEuY5iI5N8zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d2RmL+jt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d2RmL+jt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F16C4CEC3;
	Tue, 10 Sep 2024 10:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965057;
	bh=DvQ/eYCCusgHq192Aln2TWTfA+smOyh0KpDncdIfcyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d2RmL+jtrUONjPAovGUzl7FLKqcdiEcIqplrz2PGSZCLSrlJbg2uvdYl3bGEydxFf
	 3REBizEGOPDBbXI5yvowwsxLrJXMmP9cp6nKbEESI9M60XTGdVi/VykEdOYFlXzw3v
	 lPeJjXAQoq0oT+oQN8+7/OtTEtWE+zD8V4FONUdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 095/186] nfsd: remove nfsd_stats, make th_cnt a global counter
Date: Tue, 10 Sep 2024 11:33:10 +0200
Message-ID: <20240910092558.411762060@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit e41ee44cc6a473b1f414031782c3b4283d7f3e5f ]

This is the last global stat, take it out of the nfsd_stats struct and
make it a global part of nfsd, report it the same as always.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsd.h   |    1 +
 fs/nfsd/nfssvc.c |    5 +++--
 fs/nfsd/stats.c  |    3 +--
 fs/nfsd/stats.h  |    6 ------
 4 files changed, 5 insertions(+), 10 deletions(-)

--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -69,6 +69,7 @@ extern struct mutex		nfsd_mutex;
 extern spinlock_t		nfsd_drc_lock;
 extern unsigned long		nfsd_drc_max_mem;
 extern unsigned long		nfsd_drc_mem_used;
+extern atomic_t			nfsd_th_cnt;		/* number of available threads */
 
 extern const struct seq_operations nfs_exports_op;
 
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -34,6 +34,7 @@
 
 #define NFSDDBG_FACILITY	NFSDDBG_SVC
 
+atomic_t			nfsd_th_cnt = ATOMIC_INIT(0);
 extern struct svc_program	nfsd_program;
 static int			nfsd(void *vrqstp);
 #if defined(CONFIG_NFSD_V2_ACL) || defined(CONFIG_NFSD_V3_ACL)
@@ -935,7 +936,7 @@ nfsd(void *vrqstp)
 
 	current->fs->umask = 0;
 
-	atomic_inc(&nfsdstats.th_cnt);
+	atomic_inc(&nfsd_th_cnt);
 
 	set_freezable();
 
@@ -959,7 +960,7 @@ nfsd(void *vrqstp)
 		validate_process_creds();
 	}
 
-	atomic_dec(&nfsdstats.th_cnt);
+	atomic_dec(&nfsd_th_cnt);
 
 out:
 	/* Release the thread */
--- a/fs/nfsd/stats.c
+++ b/fs/nfsd/stats.c
@@ -27,7 +27,6 @@
 
 #include "nfsd.h"
 
-struct nfsd_stats	nfsdstats;
 struct svc_stat		nfsd_svcstats = {
 	.program	= &nfsd_program,
 };
@@ -47,7 +46,7 @@ static int nfsd_show(struct seq_file *se
 		   percpu_counter_sum_positive(&nn->counter[NFSD_STATS_IO_WRITE]));
 
 	/* thread usage: */
-	seq_printf(seq, "th %u 0", atomic_read(&nfsdstats.th_cnt));
+	seq_printf(seq, "th %u 0", atomic_read(&nfsd_th_cnt));
 
 	/* deprecated thread usage histogram stats */
 	for (i = 0; i < 10; i++)
--- a/fs/nfsd/stats.h
+++ b/fs/nfsd/stats.h
@@ -10,12 +10,6 @@
 #include <uapi/linux/nfsd/stats.h>
 #include <linux/percpu_counter.h>
 
-struct nfsd_stats {
-	atomic_t	th_cnt;		/* number of available threads */
-};
-
-extern struct nfsd_stats	nfsdstats;
-
 extern struct svc_stat		nfsd_svcstats;
 
 int nfsd_percpu_counters_init(struct percpu_counter *counters, int num);


