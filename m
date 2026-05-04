Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583583D9029;
	Mon,  4 May 2026 14:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903336; cv=none; b=HZCYKt6xCH3Z0M5ureq/1IQxqla03/IRUjr6mDh5wirsIoFgMJi/LOlG010kzzbEVuaKZmXqNCgF+kovK7zd7qme65UKW9iE+4byhMDg/YwizIqXe3+UV4tyNrE8GwJude1ChXsaLV/cowf8PxeLLa0pfezo+qvAV014n+ndkVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903336; c=relaxed/simple;
	bh=rPGSoYuSgfNSmFANEn+zjQOsLsqY4lny+s8zYn9+No4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkGonQrgA4zrfb6jaSNSiZ4tq4UAQ7qjsgKpcG0bJbLI6mAMokzk3FgjozXojcLQ4EZ2CqMgD29WEuTejvTNDkmRg8f/1iuWVQMrZY4BQqjlnRy/3qttWyldSnDA1rgZnKljG9eZSNiNkN4DSjZ+Gz7k7JdGT04woud067PTHEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2TfWVWrf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2TfWVWrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B7EC2BCB8;
	Mon,  4 May 2026 14:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903336;
	bh=rPGSoYuSgfNSmFANEn+zjQOsLsqY4lny+s8zYn9+No4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2TfWVWrfZrz33IknAzUcWd5eQFL8TGqZ2+zwcwwkCWEkd+8Cju3WW1RG5aql8m0Vh
	 vbI3N75Z9DNDecBOa1+QQdAsOjGWG+ALOC5XzRkanniHYXocAh4qOoZUm1sQvlQOo1
	 YB5pT0YxO6Y8CJco+8nCTjQv9fBVK9UhY8ilH4SE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 194/307] mm/damon/core: validate damos_quota_goal->nid for node_mem_{used,free}_bp
Date: Mon,  4 May 2026 15:51:19 +0200
Message-ID: <20260504135150.182474405@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 40250b2dded0604a112be605f3828700d80ad7c2 upstream.

Patch series "mm/damon/core: validate damos_quota_goal->nid".

node_mem[cg]_{used,free}_bp DAMOS quota goals receive the node id.  The
node id is used for si_meminfo_node() and NODE_DATA() without proper
validation.  As a result, privileged users can trigger an out of bounds
memory access using DAMON_SYSFS.  Fix the issues.

The issue was originally reported [1] with a fix by another author.  The
original author announced [2] that they will stop working including the
fix that was still in the review stage.  Hence I'm restarting this.


This patch (of 2):

Users can set damos_quota_goal->nid with arbitrary value for
node_mem_{used,free}_bp.  But DAMON core is using those for
si_meminfo_node() without the validation of the value.  This can result in
out of bounds memory access.  The issue can actually triggered using DAMON
user-space tool (damo), like below.

    $ sudo ./damo start --damos_action stat \
    	--damos_quota_goal node_mem_used_bp 50% -1 \
    	--damos_quota_interval 1s
    $ sudo dmesg
    [...]
    [   65.565986] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000098

Fix this issue by adding the validation of the given node.  If an invalid
node id is given, it returns 0% for used memory ratio, and 100% for free
memory ratio.

Link: https://lore.kernel.org/20260329043902.46163-2-sj@kernel.org
Link: https://lore.kernel.org/20260325073034.140353-1-objecting@objecting.org [1]
Link: https://lore.kernel.org/20260327040924.68553-1-sj@kernel.org [2]
Fixes: 0e1c773b501f ("mm/damon/core: introduce damos quota goal metrics for memory node utilization")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2078,12 +2078,24 @@ static inline u64 damos_get_some_mem_psi
 #endif	/* CONFIG_PSI */
 
 #ifdef CONFIG_NUMA
+static bool invalid_mem_node(int nid)
+{
+	return nid < 0 || nid >= MAX_NUMNODES || !node_state(nid, N_MEMORY);
+}
+
 static __kernel_ulong_t damos_get_node_mem_bp(
 		struct damos_quota_goal *goal)
 {
 	struct sysinfo i;
 	__kernel_ulong_t numerator;
 
+	if (invalid_mem_node(goal->nid)) {
+		if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
+			return 0;
+		else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
+			return 10000;
+	}
+
 	si_meminfo_node(&i, goal->nid);
 	if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
 		numerator = i.totalram - i.freeram;


