Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64F2128816;
	Tue, 30 Apr 2024 10:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474653; cv=none; b=OeKpWrhwOYsNnEvoaIzmM7j9WAO61Q1uL5heZFWeopz16Q7Wqy53ekrE/kdlcmhdQ2WLwK8U5zeRUZkTmUq4vsQQGvOuOyjprT0Mi3/dibG2ewnK21vTTNl8ux14QcioxSZ4mXZJHF6qPgLBST3PxOxMV6zjygKuuqmEnTn4pKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474653; c=relaxed/simple;
	bh=IY6CmH7G8Bie4BJI+cAwadMlyg4Q/VFVa/KOQ41glEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTSWTkq0yry4c99LRkK5Lds+/7rqFB/O4KIf2+IUGNuNynnNC84QunFbnbA2GRczpkHMSaC9yfxyyPu40TsEPHDEqlgmEK4lWS5yTqKCtYWJ3+lZUWf5Lij3S65dpPUfIcygprTiVgmX0mATTQKdbvGYbwYd0ixKQScNzThp2s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vAvelzOw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vAvelzOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DCCC2BBFC;
	Tue, 30 Apr 2024 10:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474653;
	bh=IY6CmH7G8Bie4BJI+cAwadMlyg4Q/VFVa/KOQ41glEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vAvelzOw78b3O2CkXsxSQGM7bj9D06pMeuT453AW3m2YdCsqdRLX+99BIxN+UEfkM
	 AbC9lJmP1eq+bu6XKOG2PNahWvXDHCNfXUTzIBMnPWulrgoW4j2gSR1bch5ubTKoOy
	 rioYmPj12cz3MN1uaxf5etvPAC7+J9S9kyb54xcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergei Trofimovich <slyich@gmail.com>,
	Igor Raits <igor@gooddata.com>,
	Breno Leitao <leitao@debian.org>,
	kernel test robot <oliver.sang@intel.com>,
	Yujie Liu <yujie.liu@intel.com>,
	Xuewen Yan <xuewen.yan@unisoc.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>,
	Chen Yu <yu.c.chen@intel.com>
Subject: [PATCH 6.8 220/228] sched/eevdf: Prevent vlag from going out of bounds in reweight_eevdf()
Date: Tue, 30 Apr 2024 12:39:58 +0200
Message-ID: <20240430103110.151861740@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuewen Yan <xuewen.yan@unisoc.com>

[ Upstream commit 1560d1f6eb6b398bddd80c16676776c0325fe5fe ]

It was possible to have pick_eevdf() return NULL, which then causes a
NULL-deref. This turned out to be due to entity_eligible() returning
falsely negative because of a s64 multiplcation overflow.

Specifically, reweight_eevdf() computes the vlag without considering
the limit placed upon vlag as update_entity_lag() does, and then the
scaling multiplication (remember that weight is 20bit fixed point) can
overflow. This then leads to the new vruntime being weird which then
causes the above entity_eligible() to go side-ways and claim nothing
is eligible.

Thus limit the range of vlag accordingly.

All this was quite rare, but fatal when it does happen.

Closes: https://lore.kernel.org/all/ZhuYyrh3mweP_Kd8@nz.home/
Closes: https://lore.kernel.org/all/CA+9S74ih+45M_2TPUY_mPPVDhNvyYfy1J1ftSix+KjiTVxg8nw@mail.gmail.com/
Closes: https://lore.kernel.org/lkml/202401301012.2ed95df0-oliver.sang@intel.com/
Fixes: eab03c23c2a1 ("sched/eevdf: Fix vruntime adjustment on reweight")
Reported-by: Sergei Trofimovich <slyich@gmail.com>
Reported-by: Igor Raits <igor@gooddata.com>
Reported-by: Breno Leitao <leitao@debian.org>
Reported-by: kernel test robot <oliver.sang@intel.com>
Reported-by: Yujie Liu <yujie.liu@intel.com>
Signed-off-by: Xuewen Yan <xuewen.yan@unisoc.com>
Reviewed-and-tested-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240422082238.5784-1-xuewen.yan@unisoc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b9ee4397b484a..aee5e7a70170c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -696,15 +696,21 @@ u64 avg_vruntime(struct cfs_rq *cfs_rq)
  *
  * XXX could add max_slice to the augmented data to track this.
  */
-static void update_entity_lag(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static s64 entity_lag(u64 avruntime, struct sched_entity *se)
 {
-	s64 lag, limit;
+	s64 vlag, limit;
+
+	vlag = avruntime - se->vruntime;
+	limit = calc_delta_fair(max_t(u64, 2*se->slice, TICK_NSEC), se);
+
+	return clamp(vlag, -limit, limit);
+}
 
+static void update_entity_lag(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
 	SCHED_WARN_ON(!se->on_rq);
-	lag = avg_vruntime(cfs_rq) - se->vruntime;
 
-	limit = calc_delta_fair(max_t(u64, 2*se->slice, TICK_NSEC), se);
-	se->vlag = clamp(lag, -limit, limit);
+	se->vlag = entity_lag(avg_vruntime(cfs_rq), se);
 }
 
 /*
@@ -3754,7 +3760,7 @@ static void reweight_eevdf(struct sched_entity *se, u64 avruntime,
 	 *	   = V  - vl'
 	 */
 	if (avruntime != se->vruntime) {
-		vlag = (s64)(avruntime - se->vruntime);
+		vlag = entity_lag(avruntime, se);
 		vlag = div_s64(vlag * old_weight, weight);
 		se->vruntime = avruntime - vlag;
 	}
-- 
2.43.0



