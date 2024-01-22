Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955794F207;
	Tue, 23 Jan 2024 00:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970474; cv=none; b=NlKOh6bCkCmaUS8K0mD/s0buNPK7CsJdUXyERi5YoxmHBf4loaBJsDRHz74JO/DU+DX/kpQHoIMxjalNdxYThooNR1fE11v9XWiSNGT0Dh1R6Qem8rmFsNo402qLCA4mnq0s8rRtkGtx6QFKdIk82pY7nvo9KlFCgWFIGyxCCAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970474; c=relaxed/simple;
	bh=L4RUCyaF19iV+KuwN4rQXOBlqvTpV4rZn6bswK6beO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxHuo+ZG+gzCXjDdvCGDiRsfiwpbKE0u5bpbjKgKdQgdRRMua0KTUx22PJ3HdxUWxGt59xjzxzZs9USoEgqnv0IBhEaNgytzP82cvBcyeKlGv0cIjilxTczmq3acX5kVgwzELVLYNcg2sItOtKzA04BbC0iTGYsg2kMewyCJVvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6dCZwtf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6dCZwtf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7265C433C7;
	Tue, 23 Jan 2024 00:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970474;
	bh=L4RUCyaF19iV+KuwN4rQXOBlqvTpV4rZn6bswK6beO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6dCZwtf92w0Cc0qvnwMkaexLNvMla181A+GFWgNMhN9m8jpklTcNs1rTQgW5RYNX
	 cpJ+ABjIyKN53l1gZ+cgLddJEpAV4qNq/zuZo7eP59WdhjQM6fIxWdh+I2dk205Cm8
	 vycFO1YZOwkD7PfiL9W+ts7RjE9nYUvKsH4sueOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/417] powerpc/pseries/memhp: Fix access beyond end of drmem array
Date: Mon, 22 Jan 2024 15:52:55 -0800
Message-ID: <20240122235751.744510799@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit bd68ffce69f6cf8ddd3a3c32549d1d2275e49fc5 ]

dlpar_memory_remove_by_index() may access beyond the bounds of the
drmem lmb array when the LMB lookup fails to match an entry with the
given DRC index. When the search fails, the cursor is left pointing to
&drmem_info->lmbs[drmem_info->n_lmbs], which is one element past the
last valid entry in the array. The debug message at the end of the
function then dereferences this pointer:

        pr_debug("Failed to hot-remove memory at %llx\n",
                 lmb->base_addr);

This was found by inspection and confirmed with KASAN:

  pseries-hotplug-mem: Attempting to hot-remove LMB, drc index 1234
  ==================================================================
  BUG: KASAN: slab-out-of-bounds in dlpar_memory+0x298/0x1658
  Read of size 8 at addr c000000364e97fd0 by task bash/949

  dump_stack_lvl+0xa4/0xfc (unreliable)
  print_report+0x214/0x63c
  kasan_report+0x140/0x2e0
  __asan_load8+0xa8/0xe0
  dlpar_memory+0x298/0x1658
  handle_dlpar_errorlog+0x130/0x1d0
  dlpar_store+0x18c/0x3e0
  kobj_attr_store+0x68/0xa0
  sysfs_kf_write+0xc4/0x110
  kernfs_fop_write_iter+0x26c/0x390
  vfs_write+0x2d4/0x4e0
  ksys_write+0xac/0x1a0
  system_call_exception+0x268/0x530
  system_call_vectored_common+0x15c/0x2ec

  Allocated by task 1:
   kasan_save_stack+0x48/0x80
   kasan_set_track+0x34/0x50
   kasan_save_alloc_info+0x34/0x50
   __kasan_kmalloc+0xd0/0x120
   __kmalloc+0x8c/0x320
   kmalloc_array.constprop.0+0x48/0x5c
   drmem_init+0x2a0/0x41c
   do_one_initcall+0xe0/0x5c0
   kernel_init_freeable+0x4ec/0x5a0
   kernel_init+0x30/0x1e0
   ret_from_kernel_user_thread+0x14/0x1c

  The buggy address belongs to the object at c000000364e80000
   which belongs to the cache kmalloc-128k of size 131072
  The buggy address is located 0 bytes to the right of
   allocated 98256-byte region [c000000364e80000, c000000364e97fd0)

  ==================================================================
  pseries-hotplug-mem: Failed to hot-remove memory at 0

Log failed lookups with a separate message and dereference the
cursor only when it points to a valid entry.

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Fixes: 51925fb3c5c9 ("powerpc/pseries: Implement memory hotplug remove in the kernel")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231114-pseries-memhp-fixes-v1-1-fb8f2bb7c557@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/hotplug-memory.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
index 2e3a317722a8..051a777ba1b2 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -500,14 +500,15 @@ static int dlpar_memory_remove_by_index(u32 drc_index)
 		}
 	}
 
-	if (!lmb_found)
+	if (!lmb_found) {
+		pr_debug("Failed to look up LMB for drc index %x\n", drc_index);
 		rc = -EINVAL;
-
-	if (rc)
+	} else if (rc) {
 		pr_debug("Failed to hot-remove memory at %llx\n",
 			 lmb->base_addr);
-	else
+	} else {
 		pr_debug("Memory at %llx was hot-removed\n", lmb->base_addr);
+	}
 
 	return rc;
 }
-- 
2.43.0



