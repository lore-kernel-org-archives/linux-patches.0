Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428096FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACFDC433D2;
	Tue, 10 Jan 2023 18:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375458;
	bh=CUMgGoWEv/fIKw5LH1YZ+ApfpzABWsxf+yDgA/qAYCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YM3bpXixJGvthwhH6D6Zp3NES46hsZDKI4WI3pB3SBb0ixMIPogrxOtIP+l97RoCC
	 3MuwtzfHm65x6W7APASUaJ5MLRAz36k8FZPA9IGMnQfjVACqBdh1bOCIOcExTRq1GR
	 SFPdSAch+XAeGZJ5KK0sBGWKiugVEUTDhl3Jfisg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Ramalingam C <ramalingam.c@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 194/290] drm/i915/migrate: dont check the scratch page
Date: Tue, 10 Jan 2023 19:04:46 +0100
Message-Id: <20230110180038.648018881@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 8eb7fcce34d16f77ac8efa80e8dfecec2503e8c5 ]

The scratch page might not be allocated in LMEM(like on DG2), so instead
of using that as the deciding factor for where the paging structures
live, let's just query the pt before mapping it.

Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Ramalingam C <ramalingam.c@intel.com>
Reviewed-by: Ramalingam C <ramalingam.c@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211206112539.3149779-1-matthew.auld@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_migrate.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_migrate.c b/drivers/gpu/drm/i915/gt/intel_migrate.c
index 1dac21aa7e5c..aa05c26ff792 100644
--- a/drivers/gpu/drm/i915/gt/intel_migrate.c
+++ b/drivers/gpu/drm/i915/gt/intel_migrate.c
@@ -13,7 +13,6 @@
 
 struct insert_pte_data {
 	u64 offset;
-	bool is_lmem;
 };
 
 #define CHUNK_SZ SZ_8M /* ~1ms at 8GiB/s preemption delay */
@@ -40,7 +39,7 @@ static void insert_pte(struct i915_address_space *vm,
 	struct insert_pte_data *d = data;
 
 	vm->insert_page(vm, px_dma(pt), d->offset, I915_CACHE_NONE,
-			d->is_lmem ? PTE_LM : 0);
+			i915_gem_object_is_lmem(pt->base) ? PTE_LM : 0);
 	d->offset += PAGE_SIZE;
 }
 
@@ -134,7 +133,6 @@ static struct i915_address_space *migrate_vm(struct intel_gt *gt)
 			goto err_vm;
 
 		/* Now allow the GPU to rewrite the PTE via its own ppGTT */
-		d.is_lmem = i915_gem_object_is_lmem(vm->vm.scratch[0]);
 		vm->vm.foreach(&vm->vm, base, base + sz, insert_pte, &d);
 	}
 
-- 
2.35.1



