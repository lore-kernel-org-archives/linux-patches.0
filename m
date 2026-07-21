Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED01E366DA5;
	Tue, 21 Jul 2026 15:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649064; cv=none; b=LRF/Bl+0dqqbsTYyhzJo0FjRpm6cXIl4LgFt3fE6XqtgN7nKGrdHBOBs9MvkpsOpHna290vVHh6RroVTa9lQZvwLz3vBfX+wlITSBLqEEmcF7h4rGa4sQsm7sQIaOvMhc4AY/9n2uZlgO/ANcyvF2quldL0FEktu1ZyYEYVkFPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649064; c=relaxed/simple;
	bh=dStFXtmMaA2V+L2H6qmFs3nG/IcScMy1N2wVzh/uxo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfZvlzjQI7n7wJUsQCyl9GeZK+caYinFsHi5Bi4eygzXny5PXjXDWrhP1pQ2RB1MTyZH2oO1uYDLKwqmSWICEtRsFHtomdVVzV2ZIs1iZyrjyk1i8TNYllz91bzo4lSIpLyUlngnUdgws9ZCZyqu2PyLSdfVkci42UNUO4P8P7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMQhldvv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMQhldvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9271F000E9;
	Tue, 21 Jul 2026 15:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649062;
	bh=o1YERSOpu8COJ62GYN53XlArQ5X3uTcA1BoMNB8/0Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JMQhldvvhuzwISn9QAgzPWb+gWQm7x7bv6NUHFFPdhHeFYlMiDaO2pawHqY+Kl187
	 VqM8svlsPu1ilf5ONvdMKM+GDlzy/s74GUEoneS7UOO00ldJ+uLon2lItY7ZmXAyoT
	 V5S2Mc74RrBe05v6dcvJisUf413/pkRQjPJaq8/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Donghyeon Lee <asd142513@gmail.com>,
	Munhui Chae <mochae@student.42seoul.kr>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0436/2077] mm/fake-numa: fix under-allocation detection in uniform split
Date: Tue, 21 Jul 2026 17:01:49 +0200
Message-ID: <20260721152603.038018388@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Sang-Heon Jeon <ekffu200098@gmail.com>

[ Upstream commit 3a3fc1dfd6a958615ebaab8fb251e89fc2b3f2f2 ]

When splitting NUMA node uniformly, split_nodes_size_interleave_uniform()
returns the next absolute node ID, not the number of nodes created.

The existing under-allocation detection logic compares next absolute node
ID (ret) and request count (n), which only works when nid starts at 0.

For example, on a system with 2 physical NUMA nodes (node 0: 2GB, node
1: 128MB) and numa=fake=8U, 8 fake nodes are successfully created from
node 0 and split_nodes_size_interleave_uniform() returns 8. For node 1,
fake node nid starts at 8, but only 4 fake nodes are created due to
current FAKE_NODE_MIN_SIZE being 32MB, and
split_nodes_size_interleave_uniform() returns 12. By existing
under-allocation detection logic, "ret < n" (12 < 8) is false, so the
under-allocation will not be detected.

Fix under-allocation detection logic to compare the number of actually
created nodes (ret - nid) against the request count (n). Also skip
under-allocation detection logic for memoryless physical nodes where no
fake nodes are created.

Also, fix the outdated comment describing
split_nodes_size_interleave_uniform() to match the actual return value.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reported-by: Donghyeon Lee <asd142513@gmail.com>
Reported-by: Munhui Chae <mochae@student.42seoul.kr>
Fixes: cc9aec03e58f ("x86/numa_emulation: Introduce uniform split capability") # 4.19
Link: https://patch.msgid.link/20260417135805.1758378-1-ekffu200098@gmail.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/numa_emulation.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
index 703c8fa0504801..55f26b22bb0be2 100644
--- a/mm/numa_emulation.c
+++ b/mm/numa_emulation.c
@@ -214,7 +214,7 @@ static u64 uniform_size(u64 max_addr, u64 base, u64 hole, int nr_nodes)
  * Sets up fake nodes of `size' interleaved over physical nodes ranging from
  * `addr' to `max_addr'.
  *
- * Returns zero on success or negative on error.
+ * Returns node ID of the next node on success or negative error code.
  */
 static int __init split_nodes_size_interleave_uniform(struct numa_meminfo *ei,
 					      struct numa_meminfo *pi,
@@ -398,7 +398,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 	 */
 	if (strchr(emu_cmdline, 'U')) {
 		unsigned long n;
-		int nid = 0;
+		int nid = 0, nr_created;
 
 		n = simple_strtoul(emu_cmdline, &emu_cmdline, 0);
 		ret = -1;
@@ -416,9 +416,18 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 					n, &pi.blk[0], nid);
 			if (ret < 0)
 				break;
-			if (ret < n) {
+
+			/*
+			 * If no memory was found for this physical node,
+			 * skip the under-allocation check.
+			 */
+			if (ret == nid)
+				continue;
+
+			nr_created = ret - nid;
+			if (nr_created < n) {
 				pr_info("%s: phys: %d only got %d of %ld nodes, failing\n",
-						__func__, i, ret, n);
+						__func__, i, nr_created, n);
 				ret = -1;
 				break;
 			}
-- 
2.53.0



