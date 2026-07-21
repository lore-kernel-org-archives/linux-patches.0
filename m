Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB09367B92;
	Tue, 21 Jul 2026 22:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673697; cv=none; b=cKuRTxq7ABK19x0IB2w1WNKZwmJ18NkfuMhrHe7yptPj/7x1sAuRE+O/ZVgxNqicWpXh2r+Yxt4aK2MUacWm3pn/yw0hbFako2rN5rywqDeOG5fNkahSBmzT/jJpQEVAdL5ZTy+6Q+fwc8jn/M4i55WQWIOLat9qZbf3nMwN7O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673697; c=relaxed/simple;
	bh=c0dxxsgQ8Tnve3LkCjZd//PzLedz3TZVwJYhIVuqDV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N69DNRB7qV1xcrTwVVvzh1Ti6S7lwQqIfv4Eh0TfS57o+3YB1wLh4oQyZc4ieZI41tgCWmlyF3xND4YNJx+QPz0L8eaBl0emGvOgWOjVuc0u0E0Egz4Z64LOynDqfMyFnADd0Ck0kzLEUkBLPXtr4SFqMIf1Qvpy/X1TwPnGN1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RAELoLRN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAELoLRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6561F000E9;
	Tue, 21 Jul 2026 22:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673695;
	bh=opKt6NHbrKjghqqHldfWeR/5HZoiRqdooG2Hf3477m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RAELoLRNgxDO1IX5NnoW7MpEkBajftypm0PTU5yPPfJyqjm2Jb58MWbqxoBCR2gZ8
	 wWsx7P8/nC/sSqk3f0s3bhO5305mwQZiTOOHEL1QKh3WQie59RwHcqChdKu30he51I
	 qYDoYQHhJUQWKJWgLwyofCUgl6YBQQqPpaebfTDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Donghyeon Lee <asd142513@gmail.com>,
	Munhui Chae <mochae@student.42seoul.kr>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 223/699] mm/fake-numa: fix under-allocation detection in uniform split
Date: Tue, 21 Jul 2026 17:19:42 +0200
Message-ID: <20260721152400.730587173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 arch/x86/mm/numa_emulation.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index 87d77cc52f86e0..de4dc033de6437 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -211,7 +211,7 @@ static u64 uniform_size(u64 max_addr, u64 base, u64 hole, int nr_nodes)
  * Sets up fake nodes of `size' interleaved over physical nodes ranging from
  * `addr' to `max_addr'.
  *
- * Returns zero on success or negative on error.
+ * Returns node ID of the next node on success or negative error code.
  */
 static int __init split_nodes_size_interleave_uniform(struct numa_meminfo *ei,
 					      struct numa_meminfo *pi,
@@ -395,7 +395,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 	if (strchr(emu_cmdline, 'U')) {
 		nodemask_t physnode_mask = numa_nodes_parsed;
 		unsigned long n;
-		int nid = 0;
+		int nid = 0, nr_created;
 
 		n = simple_strtoul(emu_cmdline, &emu_cmdline, 0);
 		ret = -1;
@@ -413,9 +413,18 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
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



