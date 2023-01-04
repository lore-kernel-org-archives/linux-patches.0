Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED98AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D88C433D2;
	Wed,  4 Jan 2023 16:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849528;
	bh=WdZBzUqzHsSXtl/ImaD5Xx7b6UTjmMax8khZpOu+Gws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eVlgHnist0BZ3wdhhEhcyJU2BREaVedlNntMYyuuRdLnVrD0/gGBob622rUtSa+W3
	 OosUtHSKLuKXJPwCRbqrZH+0OfR8WVn+LrCldb9yRoxZ/4g62QaOZvogq3aDgQmIbX
	 k/3WLufnNb3U2ZSOcgopVMW5EYqm176KZfQlY880=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wilson <chris.p.wilson@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.1 203/207] drm/i915/migrate: Account for the reserved_space
Date: Wed,  4 Jan 2023 17:07:41 +0100
Message-Id: <20230104160518.348113678@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chris Wilson <chris.p.wilson@intel.com>

commit 31a2e6cbe8a4eb0d1650fff4b77872b744e14a62 upstream.

If the ring is nearly full when calling into emit_pte(), we might
incorrectly trample the reserved_space when constructing the packet to
emit the PTEs. This then triggers the GEM_BUG_ON(rq->reserved_space >
ring->space) when later submitting the request, since the request itself
doesn't have enough space left in the ring to emit things like
workarounds, breadcrumbs etc.

v2: Fix the whitespace errors

Testcase: igt@i915_selftests@live_emit_pte_full_ring
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/7535
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6889
Fixes: cf586021642d ("drm/i915/gt: Pipelined page migration")
Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Nirmoy Das <nirmoy.das@intel.com>
Cc: <stable@vger.kernel.org> # v5.15+
Tested-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221202122844.428006-1-matthew.auld@intel.com
(cherry picked from commit 35168a6c4ed53db4f786858bac23b1474fd7d0dc)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_migrate.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_migrate.c
+++ b/drivers/gpu/drm/i915/gt/intel_migrate.c
@@ -341,6 +341,16 @@ static int emit_no_arbitration(struct i9
 	return 0;
 }
 
+static int max_pte_pkt_size(struct i915_request *rq, int pkt)
+{
+	struct intel_ring *ring = rq->ring;
+
+	pkt = min_t(int, pkt, (ring->space - rq->reserved_space) / sizeof(u32) + 5);
+	pkt = min_t(int, pkt, (ring->size - ring->emit) / sizeof(u32) + 5);
+
+	return pkt;
+}
+
 static int emit_pte(struct i915_request *rq,
 		    struct sgt_dma *it,
 		    enum i915_cache_level cache_level,
@@ -387,8 +397,7 @@ static int emit_pte(struct i915_request
 		return PTR_ERR(cs);
 
 	/* Pack as many PTE updates as possible into a single MI command */
-	pkt = min_t(int, dword_length, ring->space / sizeof(u32) + 5);
-	pkt = min_t(int, pkt, (ring->size - ring->emit) / sizeof(u32) + 5);
+	pkt = max_pte_pkt_size(rq, dword_length);
 
 	hdr = cs;
 	*cs++ = MI_STORE_DATA_IMM | REG_BIT(21); /* as qword elements */
@@ -421,8 +430,7 @@ static int emit_pte(struct i915_request
 				}
 			}
 
-			pkt = min_t(int, dword_rem, ring->space / sizeof(u32) + 5);
-			pkt = min_t(int, pkt, (ring->size - ring->emit) / sizeof(u32) + 5);
+			pkt = max_pte_pkt_size(rq, dword_rem);
 
 			hdr = cs;
 			*cs++ = MI_STORE_DATA_IMM | REG_BIT(21);


