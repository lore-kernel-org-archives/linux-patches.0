Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DE71A08CB;
	Thu, 15 Aug 2024 14:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730857; cv=none; b=UxBAY3YI/wfMDtgL+0u0NkO7Z6SuYWWYpjdSdCFRhvVQ2Ss/cIc6dthk5+LKV3VRxwdfFPEnVkMtoQQALUhITic44lEnwo3kcmgqTAqVmlh4U/oEnoYG3hvnbIDlG6djbcHQQh2SGrXxLOzZb/tBYYg3VPcfh/W1jQYBcVHfI8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730857; c=relaxed/simple;
	bh=yHq5sh1hGY2dmajnct871LO+fduSXKSig9VyxIh1Gyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRhHrzqiLwbt4/+XntR4t3L946EWT7lT8yki45RUJQ/JdRuMVod0YfXSj3z8yhbCBobS5x8sEQSMUcks5safrz2X/DkDMQ89NDahjeIqlhdmF8niHOiWoQwP9P8W1hs96ojmXaWEXDSr1x+frKbNs0T7n9LFhTeSvVdOt2TR510=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nWpyGtEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nWpyGtEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9C0C32786;
	Thu, 15 Aug 2024 14:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730857;
	bh=yHq5sh1hGY2dmajnct871LO+fduSXKSig9VyxIh1Gyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nWpyGtEg843a2N+hubWZ/A1mUBVwBRLnySE5p/FjQh6F+HXgLMMIGyBrFDbgqJ4fl
	 BjzwdPxPoSqQNgRD49CK7mBad3BaiCB160b0SfN6g+7oYFjYKOtJdV0D2ggXje/ndL
	 rd2D5ib1ktD8C7QpOaPwiRFEAcaGcKU2MSpN2RXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 15/67] nfsd: remove nfsd_stats, make th_cnt a global counter
Date: Thu, 15 Aug 2024 15:25:29 +0200
Message-ID: <20240815131838.918225561@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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
@@ -945,7 +946,7 @@ nfsd(void *vrqstp)
 
 	current->fs->umask = 0;
 
-	atomic_inc(&nfsdstats.th_cnt);
+	atomic_inc(&nfsd_th_cnt);
 
 	set_freezable();
 
@@ -959,7 +960,7 @@ nfsd(void *vrqstp)
 		svc_recv(rqstp);
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


