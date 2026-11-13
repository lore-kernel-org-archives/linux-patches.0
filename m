Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591029;
	b=QEQcnYimz/52GWHv/m7JxXzsuMaovugCH5WVxp0lupCTOSImSCy9NkRQ22RcmjV4EEPs
	 cMwLXjAkwK/WC0HBxnYCwwBmk5LSeF2lXPpPFWqHr7OYMd3jAcwUqcQZFbjebjhOnrEWO
	 s31Oeqeby6tUUzVAsNcH6Spq9LK3Snu8EtqI+VbMuM5d3UwsEx1BMzQSQn2pOq/Wvq7KM
	 8oRY8bGeQScot6eDT/G8TcRqsRDIr5zglfpRIrFgONo3rCJikH3wodvmA+l9xzMKKoXYo
	 NConmjLQr8YwVnWWNGFi9XshFpn1WCp4O0agpRGAL2Nsjcpvf94QQsNoTcYdaoy3NXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AxrobnMdDFV5XR21+xWmGQsY95+4jqmu3BEFkzueS/Y=;
	b=R+6p3eDEmu2r8P5/p/MwNpOV6G63xSLgI+NF9gOd5JqJ6llPUFNfYNwZT0SLmm5bBlhP
	 t5YIhR76hD5/gz+78Dkm7hldYIgPRrMdmNpzMkowf7VabhhpEkObpEjFQUcJdUCDPZp5q
	 Z8qQivDK1eTRl01FKopktDOXiS3Us4PRBWBqN3sUFMQSaGO+FHH7cywvv46BJgt1FpKHw
	 mx92Tg5V1HgfZSCcvw6KqbQ+fsjLfXfdqKA4RmEEQl7NZYaKCM86rqjCcagsxbemDwYGK
	 3DDB1HB7nBhSZpqw7i8xusbDG9Oloyp2OKpSBlB3vmay5hx6O5xxy6rf8qp34dzzJvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CPMsg2PD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F78606A8A6;
	Fri, 13 Nov 2026 17:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CPMsg2PD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF8B1F000C6;
	Fri, 13 Nov 2026 17:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591029;
	bh=AxrobnMdDFV5XR21+xWmGQsY95+4jqmu3BEFkzueS/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CPMsg2PDj6LRaCclojXwaannKiDFwtHtRaMWuq61H8p22D343giyc8R6YCW1FWEav
	 vFFCw0YfAw0E6MnNuM6+JirKxYvFoRFMII2bHaL8OD37tn5p+m2CPb0hCd9tI4oTDY
	 72LkKvwo/kSYnvKTQUA/WJpA62lvtP4fv5DK+Nzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Ridong Chen <chenridong@xiaomi.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Chris Down <chris@chrisdown.name>,
	David Hildenbrand <david@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 151/670] mm/page_counter: avoid integer overflow in effective_protection()
Date: Fri, 13 Nov 2026 10:45:15 -0500
Message-ID: <20261113153817.092466702@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ridong Chen <chenridong@xiaomi.com>

[ Upstream commit 7809ce47b05671e1fa6d74bead892d6ad6c1403b ]

Patch series "mm/mglru: fix ineffective memory protection for non-kswapd
reclaim", v4.

For MGLRU, memory.min/low is not honored during non-kswapd global reclaim
(global direct reclaim and root-level memory.reclaim), because these paths
shrink memcgs using stale protection (emin/elow).

Patch 2 is the actual fix.  Patch 1 is a prerequisite: an integer overflow
in effective_protection(), spotted by the sashiko review tool, which patch
2's new caller would also be exposed to.

This patch (of 2):

effective_protection() scales a parent's protection by a ratio of page
counts, e.g.  for recursive protection:

	(parent_effective - siblings_protected) * (usage - protected)
		/ (parent_usage - siblings_protected)

The multiply is done at unsigned long width before dividing.  On systems
with >= 16TB RAM the product can exceed 2^64 and wrap, giving a bogus
protection value and silently breaking memory.min/low enforcement.

Use mul_u64_u64_div_u64() to multiply in a 128-bit intermediate.  Because
usage and parent_usage are not read atomically (a child is charged before
its parent), usage - protected can briefly exceed the divisor, making the
quotient overflow 64 bits and trap (#DE on x86).  Cap it so the ratio
stays <= 1.

Reported by the sashiko review tool [1].

Link: https://lore.kernel.org/20260907025445.1836238-1-ridong.chen@linux.dev
Link: https://lore.kernel.org/20260907025445.1836238-2-ridong.chen@linux.dev
Link: https://sashiko.dev/#/patchset/20260826133054.88529-1-ridong.chen@linux.dev?part=1 [1]
Fixes: bc50bcc6e00b ("mm: memcontrol: clean up and document effective low/min calculations")
Fixes: 8a931f801340 ("mm: memcontrol: recursive memory.low protection")
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Claude:claude-opus-4-8
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_counter.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/mm/page_counter.c b/mm/page_counter.c
index b249d15af9dd8..9203b448e4f55 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -8,6 +8,7 @@
 #include <linux/page_counter.h>
 #include <linux/atomic.h>
 #include <linux/kernel.h>
+#include <linux/math64.h>
 #include <linux/string.h>
 #include <linux/sched.h>
 #include <linux/bug.h>
@@ -354,7 +355,8 @@ static unsigned long effective_protection(unsigned long usage,
 	 * otherwise get a smaller chunk than what they claimed.
 	 */
 	if (siblings_protected > parent_effective)
-		return protected * parent_effective / siblings_protected;
+		return mul_u64_u64_div_u64(protected, parent_effective,
+					   siblings_protected);
 
 	/*
 	 * Ok, utilized protection of all children is within what the
@@ -395,13 +397,20 @@ static unsigned long effective_protection(unsigned long usage,
 	if (parent_effective > siblings_protected &&
 	    parent_usage > siblings_protected &&
 	    usage > protected) {
-		unsigned long unclaimed;
+		unsigned long parent_unclaimed, parent_unprotected, unprotected;
 
-		unclaimed = parent_effective - siblings_protected;
-		unclaimed *= usage - protected;
-		unclaimed /= parent_usage - siblings_protected;
+		parent_unclaimed = parent_effective - siblings_protected;
+		parent_unprotected = parent_usage - siblings_protected;
 
-		ep += unclaimed;
+		/*
+		 * The usages aren't read atomically, so a child can transiently
+		 * appear to use more than its parent, making the ratio exceed 1
+		 * and the quotient overflow 64 bits (#DE on x86).  Cap it.
+		 */
+		unprotected = min(usage - protected, parent_unprotected);
+
+		ep += mul_u64_u64_div_u64(parent_unclaimed, unprotected,
+					  parent_unprotected);
 	}
 
 	return ep;
-- 
2.53.0



