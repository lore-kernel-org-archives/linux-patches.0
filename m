Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432A326B087;
	Thu, 13 Feb 2025 15:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460742; cv=none; b=iPuk+TCjxA7njrN1BxfNuEIqAwJBhYXSFHdtCQ6fBaYVMa1As3GBm+m+A/8DCbooZjyLTXOUEOJlgVPzPuo9M4zqT50IMNtYcJn8ipO7NLyXgyTIuoMtIfzbllc+LjwF1hpp/rXQ1VOpUL7DRPkSFQBGT9g8epgWMM4RVmr2878=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460742; c=relaxed/simple;
	bh=N5fEfiTDJZg4vsHH7l0Omb76T1b5D+3ZlsOpGbp/i/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJF/QibvQfaeXeiLfcXuYLCtbvDNqsKRAO6RVPQAh/TZTGi/EmqCuCj8umW4leigwydRuV+MOkIa0jR4OPajx+M7jiHLGpAof06vvA/B2dxrMomTr+f9jtigzzjgKmMsrnku1B1RVkduapFczMoEpjOYNNtWXnqLCF94MkJTDd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FzmrDWik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FzmrDWik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA454C4CED1;
	Thu, 13 Feb 2025 15:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460742;
	bh=N5fEfiTDJZg4vsHH7l0Omb76T1b5D+3ZlsOpGbp/i/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FzmrDWikvCohAT6+8BoQAU6XCqG78ruAkhcIDpc/tupEp2KzJx75SpZuNk1zRihjs
	 IUET2JTRL+dkipMJQVJDAWh220WXeLWrrmkGyh7wLL+O+ICrrZ1rsMxhvJ/c//TmkY
	 jeRo9v+hF7euLb/lONK5iPgIyxhGGA5fOFwKYddE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christoph Lameter <cl@linux.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitriy Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 198/273] kfence: skip __GFP_THISNODE allocations on NUMA systems
Date: Thu, 13 Feb 2025 15:29:30 +0100
Message-ID: <20250213142415.150523391@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Elver <elver@google.com>

commit e64f81946adf68cd75e2207dd9a51668348a4af8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kfence/core.c |    2 ++
 1 file changed, 2 insertions(+)

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
@@ -1065,6 +1066,7 @@ void *__kfence_alloc(struct kmem_cache *
 	 * properties (e.g. reside in DMAable memory).
 	 */
 	if ((flags & GFP_ZONEMASK) ||
+	    ((flags & __GFP_THISNODE) && num_online_nodes() > 1) ||
 	    (s->flags & (SLAB_CACHE_DMA | SLAB_CACHE_DMA32))) {
 		atomic_long_inc(&counters[KFENCE_COUNTER_SKIP_INCOMPAT]);
 		return NULL;


