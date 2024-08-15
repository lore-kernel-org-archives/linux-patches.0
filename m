Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21301BA89D;
	Thu, 15 Aug 2024 14:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730772; cv=none; b=psGNfFLLIN0FXmIUzF7wG0bpmXp3oKfifM2R3+Tb1IWhVjLIlM6Thjnu4MpAUh9EMf7mOzgdc7mLMUxBXV3Z5TotVXhiGUmhMOnAA0EMMVCPs4KzbZzHvy0ZEuwcP/2RMjK4BkdEA8AnYm53RJACe7SpoZ/B5YRey4UUuL/GFTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730772; c=relaxed/simple;
	bh=/HfexmrTWdfiQf1tHgTZWReh/oHpNdmzLOeL86wcDJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJXCg92lpd+7796b1CVL10v77Mzjd+kteh43lex76yVSDkxERMAmcAiTT6mqBax0uvMlG5igWVUdk/TE5Nccs2Tuk4T3DlD1tdT7MKt8j+NwkLmWqX70bb6PzvJjUfOBXT6tvxvfvyPwm5HNxWg36BE4XIjFtKwoX0y2QZdkL+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gOeYoUf1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gOeYoUf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6F6C32786;
	Thu, 15 Aug 2024 14:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730771;
	bh=/HfexmrTWdfiQf1tHgTZWReh/oHpNdmzLOeL86wcDJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gOeYoUf1ySjcyuS8sEKID+Sb/PlUFUA4X6ln51L05OqVrNTaGsvvV9apbsxC6fyD6
	 EmnR4mGkrGpC5Kys+t5oi4CM+NhNriYy67IT0A7pE9mF4T7z39D17PgsnSCRz0K4l0
	 tP1+ONMMWol+xRdFgpShCp9V5H31gxCZVgnKQdqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 26/38] nfsd: remove nfsd_stats, make th_cnt a global counter
Date: Thu, 15 Aug 2024 15:26:00 +0200
Message-ID: <20240815131833.963794305@linuxfoundation.org>
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
@@ -955,7 +956,7 @@ nfsd(void *vrqstp)
 
 	current->fs->umask = 0;
 
-	atomic_inc(&nfsdstats.th_cnt);
+	atomic_inc(&nfsd_th_cnt);
 
 	set_freezable();
 
@@ -979,7 +980,7 @@ nfsd(void *vrqstp)
 		validate_process_creds();
 	}
 
-	atomic_dec(&nfsdstats.th_cnt);
+	atomic_dec(&nfsd_th_cnt);
 
 out:
 	/* Take an extra ref so that the svc_put in svc_exit_thread()
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


