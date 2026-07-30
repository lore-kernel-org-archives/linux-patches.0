Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0805043E097;
	Thu, 30 Jul 2026 14:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421169; cv=none; b=lhrww2u62je3ajUIhE3CPiXHR++iV6XPAiNRKbVSYZvdAzPooSTMnFebJ15JFnzP3VwTp/609UNthJm5xro3lNjY7AcGzloSiFrO4RQhbp1sT7yjmHgHL+vwnrEyxiXr7svzlgvvqUkP2/DqRZPj8WaNP3r45yCzRC3m094MXUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421169; c=relaxed/simple;
	bh=2/oBI4uBjiCi6tmoyVwnhV6bDwV3kF7d0jScKHNw83s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eo+AfIG5HWGUHurOt/T5Jwb5DdS0iXxi8dxTSgAnF1XnjqwrXR19mRdsg76foW3j/7Y5SObubnwBHsS2wd9A+qf6Evm8oa+QCca2z4ZfDhAkqVUE7nPqdrCnM7J/KG9Gi70af4N5sw0GAHNqzBaQMKxO4qMawg6tojIvmsZcmfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEYrxCTw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEYrxCTw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B60D1F00A3D;
	Thu, 30 Jul 2026 14:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421167;
	bh=q1DfDc80jmWo5TLFyWLN/Eif4D3vOA692XMGmYQvSog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GEYrxCTw45SBhhLOdvKjbEaJ3alHXtLRwAdjLHDoCyPnp9SWeHMWp7RW2Njdjd+5l
	 CVS4tNJpN3cB9I/vYK8Tg9bywBkMsMGdwuSyiEnPE/TV0+zai+jiqo2dyOM4M8wq45
	 5oFwH8yQ9eS6TEqrsRtoGBm/smrT0s1jDbtFBn0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 014/744] sched_ext: Annotate ksyncs with __rcu in alloc/free_kick_syncs()
Date: Thu, 30 Jul 2026 16:04:47 +0200
Message-ID: <20260730141444.585911808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 115d1ce989747045bd7745c7ab020982660c7e42 ]

scx_kick_syncs is a per-CPU __rcu pointer, so per_cpu_ptr() returns struct
scx_kick_syncs __rcu **. alloc_kick_syncs() and free_kick_syncs() stored it
in a plain struct scx_kick_syncs **ksyncs, which sparse flags as an __rcu
address-space mismatch. Annotate ksyncs to match. Its accesses already go
through rcu_*_pointer().

Fixes: 987e00035c0e ("sched_ext: Rename pnt_seq to kick_sync")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606122315.pbnDHP0n-lkp@intel.com/
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 8429bebc21a19a..0e13139a7f27b9 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -5615,7 +5615,7 @@ static void free_kick_syncs(void)
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
-		struct scx_kick_syncs **ksyncs = per_cpu_ptr(&scx_kick_syncs, cpu);
+		struct scx_kick_syncs __rcu **ksyncs = per_cpu_ptr(&scx_kick_syncs, cpu);
 		struct scx_kick_syncs *to_free;
 
 		to_free = rcu_replace_pointer(*ksyncs, NULL, true);
@@ -6538,7 +6538,7 @@ static int alloc_kick_syncs(void)
 	 * can exceed percpu allocator limits on large machines.
 	 */
 	for_each_possible_cpu(cpu) {
-		struct scx_kick_syncs **ksyncs = per_cpu_ptr(&scx_kick_syncs, cpu);
+		struct scx_kick_syncs __rcu **ksyncs = per_cpu_ptr(&scx_kick_syncs, cpu);
 		struct scx_kick_syncs *new_ksyncs;
 
 		WARN_ON_ONCE(rcu_access_pointer(*ksyncs));
-- 
2.53.0



