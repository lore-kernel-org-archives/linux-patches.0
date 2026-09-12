Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB3934A79D;
	Sat, 12 Sep 2026 07:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198601; cv=none; b=E+hu9N7toaTLg7iCReUYKUL330HxR8CUePk2cDuDritGp7yvRfC4Van+Jjo4AZV+1OA90q5KfbPjpgOojr7n6nm2Hlh6TN7vTyMkybelD9hlVs6KRSkqPZ5XL70xVACOWxw4Bs+w2mdCikPwW8L3musXLwMJXzFg0GOVW2o/a44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198601; c=relaxed/simple;
	bh=f4ZWsQQR8QqX8+D1TitCgntsV2sZg1oIMpNfJ7iVu4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PT4wrBbFGukJavLdhO4rxCfERHD5pYdvXvyM3QbjTtTkowQzfpjRb/A6odijWCd6vV6FRvaRbG/6tNu0XPgAW/iFJnf9c/e9koTuSE1Yhv9S5kWNM7WvmKi0WtfrPeFEfn42oRew80ZyoBDtljbUOXQyxjVTkHqapQgOAlHsD0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PcgLXqP+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PcgLXqP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CDF61F000FF;
	Sat, 12 Sep 2026 07:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198599;
	bh=U93kSvNGfzMI8aywNDcMMKK0kC2Lm5bz6k/eL2DMQF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PcgLXqP+Gt+eP2nNNDoitGOAZC31qUFhH0mjJ99GP8gI3/IEV6k53GeVFmAdf0lVg
	 G4z3vEhLeE6jwRrQCDQdoeibiRhp8ZOdKsdPQ1ic5tiDOdSkmw1fag6F+pssi9hXSb
	 Pyqo0E8Ye/MFce81tuOQTtB7SEeaNp7lufpHEKeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Luo <luoliang@kylinos.cn>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0371/1815] tools/sched_ext: scx_flatcg: Fix uninitialized stats on allocation failure
Date: Sat, 12 Sep 2026 08:35:21 +0200
Message-ID: <20260912065657.613756580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liang Luo <luoliang@kylinos.cn>

[ Upstream commit e07f6bb73efb484043e7fc2ec6d7d6220d1977f7 ]

In fcg_read_stats(), the memset() that zeroes the output @stats array
sits after the calloc() failure check. When calloc() fails, the
function returns without writing @stats.

The caller in main() declares acc_stats uninitialized, passes it as
the @stats argument, and then reads it unconditionally:

    __u64 acc_stats[FCG_NR_STATS];
    fcg_read_stats(skel, acc_stats);
    stats[i] = acc_stats[i] - last_stats[i];   // reads garbage

Because fcg_read_stats() returns void, the caller cannot detect the
failure. Reading the uninitialized array is undefined behavior, and
the garbage is further copied into last_stats via memcpy(), corrupting
the baseline used by the next interval.

This regression was introduced by commit cabd76bbc036 ("tools/sched_ext:
scx_flatcg: fix potential stack overflow from VLA in fcg_read_stats"),
which replaced the VLA with calloc() and inserted the failure check
before the existing memset().

Move the memset() above the calloc() failure check so @stats is always
zeroed regardless of allocation outcome.

Fixes: cabd76bbc036 ("tools/sched_ext: scx_flatcg: fix potential stack overflow from VLA in fcg_read_stats")
Signed-off-by: Liang Luo <luoliang@kylinos.cn>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/sched_ext/scx_flatcg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/sched_ext/scx_flatcg.c b/tools/sched_ext/scx_flatcg.c
index de2bef86d64d6..7799782b76d18 100644
--- a/tools/sched_ext/scx_flatcg.c
+++ b/tools/sched_ext/scx_flatcg.c
@@ -105,12 +105,12 @@ static void fcg_read_stats(struct scx_flatcg *skel, __u64 *stats)
 	__u64 *cnts;
 	__u32 idx;
 
+	memset(stats, 0, sizeof(stats[0]) * FCG_NR_STATS);
+
 	cnts = calloc(skel->rodata->nr_cpus, sizeof(__u64));
 	if (!cnts)
 		return;
 
-	memset(stats, 0, sizeof(stats[0]) * FCG_NR_STATS);
-
 	for (idx = 0; idx < FCG_NR_STATS; idx++) {
 		int ret, cpu;
 
-- 
2.53.0



