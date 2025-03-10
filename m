Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC7623535D;
	Mon, 10 Mar 2025 18:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630540; cv=none; b=XjfN1fIbxhRr1xl+isbzfYYU3SmNfgLZPyQ9Gj34F9PK4rC3mhezVpWnD0u4AUOlKiIz+nq2ZIsC9pckvWlEJqa5buBkOShydcWG8MsewT7UXSoKIBvAzoSb2M0zKFygJ58TUFYq/caufOwsm+P9TBi2p94PV7I2e2p8MfHha4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630540; c=relaxed/simple;
	bh=N2xFR1EjNhEEmrqB+4G06evZyATe01NxpJrtqU/Wn+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxnL7IEnS/WJTT5PSsywTPCaD6r7+8H/uzsj6yDbLXaHduafgJyPo2ONasyZmdpoWmt6+hjbQjuBw4vJuFCc78CxkLhyAU1WgF/xwtFVEBOog0q/ipzET9qbYxM8aXs/ekMOIFA6PLJ3rbVhNB8rfB77efHXE65CxxRySupjTRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYDGsobS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYDGsobS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764AAC4CEE5;
	Mon, 10 Mar 2025 18:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630539;
	bh=N2xFR1EjNhEEmrqB+4G06evZyATe01NxpJrtqU/Wn+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jYDGsobS8f2XbJ1bOV+ky5anRyFPiyVelIGhxO+fg5egAmwlcFd2sGKfSwRqssssB
	 hcY8AZ6efysuFzwUrhthOyurtRmVxd+rvRWiB6BWtXOBi20u/opZq1AhBJpi4FCUJ0
	 PdCQOK5IsF1BflNt9gYy47JaHI5ypcoS5vbw42KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christoph Lameter <cl@linux.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitriy Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 448/620] kfence: skip __GFP_THISNODE allocations on NUMA systems
Date: Mon, 10 Mar 2025 18:04:54 +0100
Message-ID: <20250310170603.279306136@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Elver <elver@google.com>

[ Upstream commit e64f81946adf68cd75e2207dd9a51668348a4af8 ]

On NUMA systems, __GFP_THISNODE indicates that an allocation _must_ be on
a particular node, and failure to allocate on the desired node will result
in a failed allocation.

Skip __GFP_THISNODE allocations if we are running on a NUMA system, since
KFENCE can't guarantee which node its pool pages are allocated on.

Link: https://lkml.kernel.org/r/20250124120145.410066-1-elver@google.com
Fixes: 236e9f153852 ("kfence: skip all GFP_ZONEMASK allocations")
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Chistoph Lameter <cl@linux.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kfence/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 0d1a66811c32b..c49bc76b3a389 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -21,6 +21,7 @@
 #include <linux/log2.h>
 #include <linux/memblock.h>
 #include <linux/moduleparam.h>
+#include <linux/nodemask.h>
 #include <linux/notifier.h>
 #include <linux/panic_notifier.h>
 #include <linux/random.h>
@@ -906,6 +907,7 @@ void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
 	 * properties (e.g. reside in DMAable memory).
 	 */
 	if ((flags & GFP_ZONEMASK) ||
+	    ((flags & __GFP_THISNODE) && num_online_nodes() > 1) ||
 	    (s->flags & (SLAB_CACHE_DMA | SLAB_CACHE_DMA32))) {
 		atomic_long_inc(&counters[KFENCE_COUNTER_SKIP_INCOMPAT]);
 		return NULL;
-- 
2.39.5



