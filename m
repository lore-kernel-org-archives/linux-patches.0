Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F0F12CD9B;
	Tue, 30 Apr 2024 11:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475705; cv=none; b=LI7blnWliRm3SPlD+TxkVabgx4GsnNHs4x1ARBTp2KLKJECjlcNwTr12zdPuH4Bpfuv0Eyblz6Ot51HS1Fs2VcvOzsaRykQnhWAZJWH1CsLnYTHU2w6UYBysIeISoIo15DgYggxpGr5IqhrZQ22Ue9QXl6gqAOQzV3G138MzBjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475705; c=relaxed/simple;
	bh=uKR3p7HHsAJQ44tDIyvKSlWrgUFWBitQXWGG0qoIDIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zjq2EhDaT5mj35aYjl94+rKdhJYRhEOLzuS48S44AVRwcpx6z7Mkf92TgJtx2bESu9DRkkAWpL1vEK7jaDq6qIFbjxoctHsU/Hi/E3DQqZDa+n1QKLkIj9c7UkouQM63Qe8t81e3/egN7u/qnDPkvr3eFvueYGCHKliIpS3s1LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlpy6Gje; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlpy6Gje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F5AC2BBFC;
	Tue, 30 Apr 2024 11:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475704;
	bh=uKR3p7HHsAJQ44tDIyvKSlWrgUFWBitQXWGG0qoIDIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rlpy6Gje8ubpSYLhNEgnBIbceBfmLkMANWxXqftWJqdQhPIaSVk077Al0qy1ZDkmE
	 pgoDfa0HlHsfleSJScZIDKISNrVvz8qCKHSO44WFwabvCMNY68KViXfF2wfFsbt8a5
	 p4p/r6Ep0hLjG/FNfjTczduM67jpbbDSlYlETKhs=
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
Subject: [PATCH 6.6 178/186] sched/eevdf: Prevent vlag from going out of bounds in reweight_eevdf()
Date: Tue, 30 Apr 2024 12:40:30 +0200
Message-ID: <20240430103103.198157606@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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
index a5466eb6a1f15..397ef27c9bdb1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -707,15 +707,21 @@ u64 avg_vruntime(struct cfs_rq *cfs_rq)
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
@@ -3710,7 +3716,7 @@ static void reweight_eevdf(struct sched_entity *se, u64 avruntime,
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



