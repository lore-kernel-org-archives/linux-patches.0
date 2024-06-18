Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33869156C7F;
	Tue, 18 Jun 2024 13:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715776; cv=none; b=fqd6RH/bltuYoA2ZiurmTCERGvTmkpkTpI7f3is2MMYOQwUfR7/dZ6Fnw0NHaZaRqKiPMv+8Fb05TmSHv2JGHk8lbZ8yZxTn/eZnFDs+UoWlb2EAS5hgdA96ykUaA6eKFqLRqptVf7OMRkVsjx3rFDgyD8OWgJRgFEi9q+U075E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715776; c=relaxed/simple;
	bh=cNuwcvedgHReVC/iNBmLgTasp+4nlQphxDqFAq9xoaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/Xd1Nc9h6ds8spCcxvauYBFwpnrXeZ64VOuh/VzLGLuEm6T1pJV6hAkM0IvaRI41/j9arJ57tiLq72e8Elzf1OXCJTKlBIwzJsLmLsnPHKAKEY8CeoNHao0GjPJLBEjwZgHzCNMBgE1MCG6buWEYX/H2Uof3g3cS8U4Rp2fIUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZ/uqb0A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZ/uqb0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84357C3277B;
	Tue, 18 Jun 2024 13:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715776;
	bh=cNuwcvedgHReVC/iNBmLgTasp+4nlQphxDqFAq9xoaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZ/uqb0ASgsx+CY2eFTtx6+hlI8MaRVEaGyeFkbsp9DUXfsHMEa+R8X2cKsTNAakC
	 6i9lBOEJRxXzIkw+UNd7VfvFxDNGuEHWJUB5BtqcveC5mLgyNEd396ORNCimO6NhaY
	 zE8CC532hC03kpHwYMfQVcso6wqY0+jkGRUAqS/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 423/770] nfsd: make nfsd_stats.th_cnt atomic_t
Date: Tue, 18 Jun 2024 14:34:36 +0200
Message-ID: <20240618123423.611871502@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit 9b6c8c9bebccd5fb785c306b948c08874a88874d ]

This allows us to move the updates for th_cnt out of the mutex.
This is a step towards reducing mutex coverage in nfsd().

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfssvc.c | 6 +++---
 fs/nfsd/stats.c  | 2 +-
 fs/nfsd/stats.h  | 4 +---
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 141d884fee4f4..32f2c46a38323 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -57,7 +57,7 @@ static __be32			nfsd_init_request(struct svc_rqst *,
 /*
  * nfsd_mutex protects nn->nfsd_serv -- both the pointer itself and the members
  * of the svc_serv struct. In particular, ->sv_nrthreads but also to some
- * extent ->sv_temp_socks and ->sv_permsocks. It also protects nfsdstats.th_cnt
+ * extent ->sv_temp_socks and ->sv_permsocks.
  *
  * If (out side the lock) nn->nfsd_serv is non-NULL, then it must point to a
  * properly initialised 'struct svc_serv' with ->sv_nrthreads > 0 (unless
@@ -955,8 +955,8 @@ nfsd(void *vrqstp)
 	allow_signal(SIGINT);
 	allow_signal(SIGQUIT);
 
-	nfsdstats.th_cnt++;
 	mutex_unlock(&nfsd_mutex);
+	atomic_inc(&nfsdstats.th_cnt);
 
 	set_freezable();
 
@@ -983,8 +983,8 @@ nfsd(void *vrqstp)
 	/* Clear signals before calling svc_exit_thread() */
 	flush_signals(current);
 
+	atomic_dec(&nfsdstats.th_cnt);
 	mutex_lock(&nfsd_mutex);
-	nfsdstats.th_cnt --;
 
 out:
 	/* Take an extra ref so that the svc_put in svc_exit_thread()
diff --git a/fs/nfsd/stats.c b/fs/nfsd/stats.c
index 1d3b881e73821..a8c5a02a84f04 100644
--- a/fs/nfsd/stats.c
+++ b/fs/nfsd/stats.c
@@ -45,7 +45,7 @@ static int nfsd_proc_show(struct seq_file *seq, void *v)
 		   percpu_counter_sum_positive(&nfsdstats.counter[NFSD_STATS_IO_WRITE]));
 
 	/* thread usage: */
-	seq_printf(seq, "th %u 0", nfsdstats.th_cnt);
+	seq_printf(seq, "th %u 0", atomic_read(&nfsdstats.th_cnt));
 
 	/* deprecated thread usage histogram stats */
 	for (i = 0; i < 10; i++)
diff --git a/fs/nfsd/stats.h b/fs/nfsd/stats.h
index 51ecda852e23b..9b43dc3d99913 100644
--- a/fs/nfsd/stats.h
+++ b/fs/nfsd/stats.h
@@ -29,11 +29,9 @@ enum {
 struct nfsd_stats {
 	struct percpu_counter	counter[NFSD_STATS_COUNTERS_NUM];
 
-	/* Protected by nfsd_mutex */
-	unsigned int	th_cnt;		/* number of available threads */
+	atomic_t	th_cnt;		/* number of available threads */
 };
 
-
 extern struct nfsd_stats	nfsdstats;
 
 extern struct svc_stat		nfsd_svcstats;
-- 
2.43.0



