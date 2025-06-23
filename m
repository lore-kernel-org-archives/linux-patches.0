Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551BB3FB1B;
	Mon, 23 Jun 2025 22:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716233; cv=none; b=E8E5qL6ckp2vM7qjn9K/zaupwTVBFtJRZhV+gQ5rmb+EYVG8Htn+70LrNwalnWpVgGDLDFA0YOGfVfbd8nKOHP4/YCBF2moPAitPsQRcsiW+HUboYLZDyKK5YvCzqvjgmqjCl5SqcISXTirpbgksfAPKhXXxfkB1i35/jOpHJvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716233; c=relaxed/simple;
	bh=2e+e/huyhHwhP8C5bknvZ8EUrczBp9LFppbddcY4ybc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ofp0k4IfC9I9h/iV7IO7HsG5FgAz2pJvqsve2Nfw0YJZfnMwoVVdQ/8FJn1RayeBcq6LWjkIMn/4CvAj5DLZC6cbeMRIFdOwph1mgP84e41b3nPDztjxsm1o87MLgGpAonw0hNy1Vzn/jj+Rij2VBEtpV5psCgklGj2XZeckHwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GbP/BNQE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GbP/BNQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D42C4CEEA;
	Mon, 23 Jun 2025 22:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716233;
	bh=2e+e/huyhHwhP8C5bknvZ8EUrczBp9LFppbddcY4ybc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GbP/BNQE3JPYdssntLnZPbTXOtP8O9qmH0lkK709de9ZlSzNXasEirdlrWrG3G3YB
	 wCDARXX/5in5A0fmbpA/exR8UgjaxT2Xs+PJt8dxYqmahGJnQ6s7nWGbbLI/ohIhRi
	 KVtzPta/ysc34UHUuYe0fo2hKWeiSH0EMXWE1754=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eliav Farber <farbere@amazon.com>
Subject: [PATCH 5.10 336/355] net/ipv4: fix type mismatch in inet_ehash_locks_alloc() causing build failure
Date: Mon, 23 Jun 2025 15:08:57 +0200
Message-ID: <20250623130636.843013233@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliav Farber <farbere@amazon.com>

Fix compilation warning:

In file included from ./include/linux/kernel.h:15,
                 from ./include/linux/list.h:9,
                 from ./include/linux/module.h:12,
                 from net/ipv4/inet_hashtables.c:12:
net/ipv4/inet_hashtables.c: In function ‘inet_ehash_locks_alloc’:
./include/linux/minmax.h:20:35: warning: comparison of distinct pointer types lacks a cast
   20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
      |                                   ^~
./include/linux/minmax.h:26:18: note: in expansion of macro ‘__typecheck’
   26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
      |                  ^~~~~~~~~~~
./include/linux/minmax.h:36:31: note: in expansion of macro ‘__safe_cmp’
   36 |         __builtin_choose_expr(__safe_cmp(x, y), \
      |                               ^~~~~~~~~~
./include/linux/minmax.h:52:25: note: in expansion of macro ‘__careful_cmp’
   52 | #define max(x, y)       __careful_cmp(x, y, >)
      |                         ^~~~~~~~~~~~~
net/ipv4/inet_hashtables.c:946:19: note: in expansion of macro ‘max’
  946 |         nblocks = max(nblocks, num_online_nodes() * PAGE_SIZE / locksz);
      |                   ^~~
  CC      block/badblocks.o

When warnings are treated as errors, this causes the build to fail.

The issue is a type mismatch between the operands passed to the max()
macro. Here, nblocks is an unsigned int, while the expression
num_online_nodes() * PAGE_SIZE / locksz is promoted to unsigned long.

This happens because:
 - num_online_nodes() returns int
 - PAGE_SIZE is typically defined as an unsigned long (depending on the
   architecture)
 - locksz is unsigned int

The resulting arithmetic expression is promoted to unsigned long.

Thus, the max() macro compares values of different types: unsigned int
vs unsigned long.

This issue was introduced in commit f8ece40786c9 ("tcp: bring back NUMA
dispersion in inet_ehash_locks_alloc()") during the update from kernel
v5.10.237 to v5.10.238.

It does not exist in newer kernel branches (e.g., v5.15.185 and all 6.x
branches), because they include commit d03eba99f5bf ("minmax: allow
min()/max()/clamp() if the arguments have the same signedness.")

Fix the issue by using max_t(unsigned int, ...) to explicitly cast both
operands to the same type, avoiding the type mismatch and ensuring
correctness.

Fixes: f8ece40786c9 ("tcp: bring back NUMA dispersion in inet_ehash_locks_alloc()")
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_hashtables.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -943,7 +943,7 @@ int inet_ehash_locks_alloc(struct inet_h
 	nblocks = max(2U * L1_CACHE_BYTES / locksz, 1U) * num_possible_cpus();
 
 	/* At least one page per NUMA node. */
-	nblocks = max(nblocks, num_online_nodes() * PAGE_SIZE / locksz);
+	nblocks = max_t(unsigned int, nblocks, num_online_nodes() * PAGE_SIZE / locksz);
 
 	nblocks = roundup_pow_of_two(nblocks);
 


