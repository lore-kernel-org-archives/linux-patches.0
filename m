Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE6B3C17;
	Fri, 31 Oct 2025 14:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919565; cv=none; b=QUqch8pBdPxmXXhpo1gk6pSsWxsW+0X2cfyIL3gEgMHu5Dag8lG3xYmJ1fyI8fbzCi7pLbO13QeVbdRN++bmBARpFARYSlyhOUqbIle5x8BumRZg9aIp0dtpdQ5dKtUYng/H7jgsgN53cHMieyVaQpG4L0pT07kBHQLM7Czqmxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919565; c=relaxed/simple;
	bh=OJYq1NK4/LPJgcG5xiLWnX/jiefpOOed8iT37dk6m7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=of37yBzNo4xTSzrhPBBRZQ9EeUD5HXUO5lVf7TlZsxaLohL9wb4y5LggBEvqMyNvsjGlBUYURfZ2jzSs3Q3QemK1ESStnjzkrANfDjQx2xHcyzw23Kojywi3sT/J4w2e8KO2jJ5L76TmmNRCyAhnpQfwvgIsNLI5Y2V0j2Gsp1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EzfDA/eU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EzfDA/eU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D7BC4CEE7;
	Fri, 31 Oct 2025 14:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919564;
	bh=OJYq1NK4/LPJgcG5xiLWnX/jiefpOOed8iT37dk6m7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EzfDA/eU1UNVGTKs6O0hGu+v80rJRENFcBHRxClwIQ9bx0uIaWtuoOnkKIP4XNw0V
	 ER3IGi6/+mD+sn21BI3OQI+qDMKtC1pC7fEpvDC/LlH5zhZdsyhj4+FxVDcLjgfERQ
	 su4fAnX5fsN9MXgdcq4vDEuQElfdu4JuFQi/CwFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Lu <ziqianlu@bytedance.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 20/35] sched/fair: update_cfs_group() for throttled cfs_rqs
Date: Fri, 31 Oct 2025 15:01:28 +0100
Message-ID: <20251031140044.050079148@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Lu <ziqianlu@bytedance.com>

[ Upstream commit fcd394866e3db344cbe0bb485d7e3f741ac07245 ]

With task based throttle model, tasks in a throttled hierarchy are
allowed to continue to run if they are running in kernel mode. For this
reason, PELT clock is not stopped for these cfs_rqs in throttled
hierarchy when they still have tasks running or queued.

Since PELT clock is not stopped, whether to allow update_cfs_group()
doing its job for cfs_rqs which are in throttled hierarchy but still
have tasks running/queued is a question.

The good side is, continue to run update_cfs_group() can get these
cfs_rq entities with an up2date weight and that up2date weight can be
useful to derive an accurate load for the CPU as well as ensure fairness
if multiple tasks of different cgroups are running on the same CPU.
OTOH, as Benjamin Segall pointed: when unthrottle comes around the most
likely correct distribution is the distribution we had at the time of
throttle.

In reality, either way may not matter that much if tasks in throttled
hierarchy don't run in kernel mode for too long. But in case that
happens, let these cfs_rq entities have an up2date weight seems a good
thing to do.

Signed-off-by: Aaron Lu <ziqianlu@bytedance.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4770d25ae2406..3e0d999e5ee2c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3957,9 +3957,6 @@ static void update_cfs_group(struct sched_entity *se)
 	if (!gcfs_rq || !gcfs_rq->load.weight)
 		return;
 
-	if (throttled_hierarchy(gcfs_rq))
-		return;
-
 	shares = calc_group_shares(gcfs_rq);
 	if (unlikely(se->load.weight != shares))
 		reweight_entity(cfs_rq_of(se), se, shares);
-- 
2.51.0



