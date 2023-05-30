Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E219C1EA76;
	Tue, 30 May 2023 18:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E97C4339B;
	Tue, 30 May 2023 18:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685471111;
	bh=VmL0B498WZtZEUKPXA6hoQdYba2NyQU/o+jprbyH8AU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ZJyXV66AvjE0t107ogjn5M3q9TiuL4akjPneuMN4PzDvea2O5DLNWg+M1BvZYXxfE
	 fNqx3lkAcJxjnh2KzW+hxNt87zhUIJn0M+ZDkjjbPlPbVgEOXCno/AjQRB2T/npJiw
	 zIuLMsl9BNFUFHorFBi50z1LuRE3t6aewzGg69jPebh0ZSM4mVH4U7rNsEwoup002S
	 nDWiHbPbYgzyY0ox0c2HMBOfjOU7BLm12GS9LRi+u6JucA3lmwLqzindsXunipBayN
	 i7UeEcJVO8m1wvUTDvld0366kRUa5ZqBd994+RrEGjeliuv+0Yqm9zU5uosCpYMhLS
	 zVZsQm4N0j6mg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 30 May 2023 11:24:39 -0700
Subject: [PATCH 2/2] drm/i915/gt: Fix parameter in
 gmch_ggtt_insert_{entries,page}()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230530-i915-gt-cache_level-wincompatible-function-pointer-types-strict-v1-2-54501d598229@kernel.org>
References: <20230530-i915-gt-cache_level-wincompatible-function-pointer-types-strict-v1-0-54501d598229@kernel.org>
In-Reply-To: <20230530-i915-gt-cache_level-wincompatible-function-pointer-types-strict-v1-0-54501d598229@kernel.org>
To: jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com, 
 rodrigo.vivi@intel.com, tvrtko.ursulin@linux.intel.com
Cc: ndesaulniers@google.com, trix@redhat.com, andi.shyti@linux.intel.com, 
 fei.yang@intel.com, intel-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3464; i=nathan@kernel.org;
 h=from:subject:message-id; bh=VmL0B498WZtZEUKPXA6hoQdYba2NyQU/o+jprbyH8AU=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCll9i3RLZy5js0hS9/IuoT8T9HZePeOQrLCzgOPPjzbE
 3R6vaheRykLgxgHg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZhIyFdGhk9l0+17TArOT9rW
 2f1W60DKZbUfEXq2BqZKPeeMTywv+sTIMFWuxSj3+myRDPtf0w9b2ttvvLzeI+KGNU+wsZ9D7ZW
 NXAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building with clang's -Wincompatible-function-pointer-types-strict,
the following warnings occur:

  drivers/gpu/drm/i915/gt/intel_ggtt_gmch.c:102:23: error: incompatible function pointer types assigning to 'void (*)(struct i915_address_space *, dma_addr_t, u64, unsigned int, u32)' (aka 'void (*)(struct i915_address_space *, unsigned int, unsigned long long, unsigned int, unsigned int)') from 'void (struct i915_address_space *, dma_addr_t, u64, enum i915_cache_level, u32)' (aka 'void (struct i915_address_space *, unsigned int, unsigned long long, enum i915_cache_level, unsigned int)') [-Werror,-Wincompatible-function-pointer-types-strict]
          ggtt->vm.insert_page = gmch_ggtt_insert_page;
                               ^ ~~~~~~~~~~~~~~~~~~~~~
  drivers/gpu/drm/i915/gt/intel_ggtt_gmch.c:103:26: error: incompatible function pointer types assigning to 'void (*)(struct i915_address_space *, struct i915_vma_resource *, unsigned int, u32)' (aka 'void (*)(struct i915_address_space *, struct i915_vma_resource *, unsigned int, unsigned int)') from 'void (struct i915_address_space *, struct i915_vma_resource *, enum i915_cache_level, u32)' (aka 'void (struct i915_address_space *, struct i915_vma_resource *, enum i915_cache_level, unsigned int)') [-Werror, -Wincompatible-function-pointer-types-strict]
          ggtt->vm.insert_entries = gmch_ggtt_insert_entries;
                                  ^ ~~~~~~~~~~~~~~~~~~~~~~~~
  2 errors generated.

The warning is pointing out that while 'enum i915_cache_level' and
'unsigned int' are ABI compatible, these indirect calls will fail
clang's kernel Control Flow Integrity (kCFI) checks, as the callback's
signature does not exactly match the prototype's signature.

To fix this, replace the cache_level parameter with pat_index, as was
done in other places within i915 where there is no difference between
cache_level and pat_index on certain generations.

Fixes: 9275277d5324 ("drm/i915: use pat_index instead of cache_level")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_ggtt_gmch.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_ggtt_gmch.c b/drivers/gpu/drm/i915/gt/intel_ggtt_gmch.c
index d6a74ae2527b..866c416afb73 100644
--- a/drivers/gpu/drm/i915/gt/intel_ggtt_gmch.c
+++ b/drivers/gpu/drm/i915/gt/intel_ggtt_gmch.c
@@ -18,10 +18,10 @@
 static void gmch_ggtt_insert_page(struct i915_address_space *vm,
 				  dma_addr_t addr,
 				  u64 offset,
-				  enum i915_cache_level cache_level,
+				  unsigned int pat_index,
 				  u32 unused)
 {
-	unsigned int flags = (cache_level == I915_CACHE_NONE) ?
+	unsigned int flags = (pat_index == I915_CACHE_NONE) ?
 		AGP_USER_MEMORY : AGP_USER_CACHED_MEMORY;
 
 	intel_gmch_gtt_insert_page(addr, offset >> PAGE_SHIFT, flags);
@@ -29,10 +29,10 @@ static void gmch_ggtt_insert_page(struct i915_address_space *vm,
 
 static void gmch_ggtt_insert_entries(struct i915_address_space *vm,
 				     struct i915_vma_resource *vma_res,
-				     enum i915_cache_level cache_level,
+				     unsigned int pat_index,
 				     u32 unused)
 {
-	unsigned int flags = (cache_level == I915_CACHE_NONE) ?
+	unsigned int flags = (pat_index == I915_CACHE_NONE) ?
 		AGP_USER_MEMORY : AGP_USER_CACHED_MEMORY;
 
 	intel_gmch_gtt_insert_sg_entries(vma_res->bi.pages, vma_res->start >> PAGE_SHIFT,

-- 
2.40.1

