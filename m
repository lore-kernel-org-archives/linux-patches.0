Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555DA234977;
	Mon, 10 Mar 2025 17:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627469; cv=none; b=HzR+4zCpTeUZ/ybLQeU3b4TFVS3F3dPa/HM6oHgWF8nbdB7OIK21WJLltUqBylyhsCKRtX5IWEyGt7gHC4QfJTpMSFzDJogT46KAE+SCpq77xWDPbb62DGaq8NQGC2l55qu8xlkRoVNK8/UVqD3tmvoCSHL8KP6KdDqydfHT5u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627469; c=relaxed/simple;
	bh=uFeH47ADimgyR6YZNR47lf7T/LuOkiPoWyUTAw9dV7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBAKxVzuRCegOYRhhjUE2/r2Vx2qx1XTxjP9w7lmLz3ijsgamDbLqEw2HXg95D+1Rgl8+X8ZY0Yw8U0EKL3UETqzMnkCdbOAnGD7gtCCxL25NlJwKxnRzsM0fBuUOEr1BCwumRFQ6PNvRQO93EjzmVtLAG3Rzc/yWiWv78vaLwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ALrNedfn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ALrNedfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C4AC4CEE5;
	Mon, 10 Mar 2025 17:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627469;
	bh=uFeH47ADimgyR6YZNR47lf7T/LuOkiPoWyUTAw9dV7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ALrNedfnk1VRmNcvNSeUhWRij0zH3MJzaVrxgGG60FKhV6CF3NGJUAEy4dEjCBdao
	 3fGZFmNUg07cQWiG/nBMEfwAwBzC9QiahlkgiflTFWDZWPwm4+FD72jauW9TpBc8Zg
	 HTPT5ZrSzOok+hZhvtJtW1igfbGozx7iamNuDAKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Wupeng <mawupeng1@huawei.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@suse.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 139/269] hwpoison, memory_hotplug: lock folio before unmap hwpoisoned folio
Date: Mon, 10 Mar 2025 18:04:52 +0100
Message-ID: <20250310170503.262982156@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Wupeng <mawupeng1@huawei.com>

commit af288a426c3e3552b62595c6138ec6371a17dbba upstream.

Commit b15c87263a69 ("hwpoison, memory_hotplug: allow hwpoisoned pages to
be offlined) add page poison checks in do_migrate_range in order to make
offline hwpoisoned page possible by introducing isolate_lru_page and
try_to_unmap for hwpoisoned page.  However folio lock must be held before
calling try_to_unmap.  Add it to fix this problem.

Warning will be produced if folio is not locked during unmap:

  ------------[ cut here ]------------
  kernel BUG at ./include/linux/swapops.h:400!
  Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
  Modules linked in:
  CPU: 4 UID: 0 PID: 411 Comm: bash Tainted: G        W          6.13.0-rc1-00016-g3c434c7ee82a-dirty #41
  Tainted: [W]=WARN
  Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
  pstate: 40400005 (nZcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : try_to_unmap_one+0xb08/0xd3c
  lr : try_to_unmap_one+0x3dc/0xd3c
  Call trace:
   try_to_unmap_one+0xb08/0xd3c (P)
   try_to_unmap_one+0x3dc/0xd3c (L)
   rmap_walk_anon+0xdc/0x1f8
   rmap_walk+0x3c/0x58
   try_to_unmap+0x88/0x90
   unmap_poisoned_folio+0x30/0xa8
   do_migrate_range+0x4a0/0x568
   offline_pages+0x5a4/0x670
   memory_block_action+0x17c/0x374
   memory_subsys_offline+0x3c/0x78
   device_offline+0xa4/0xd0
   state_store+0x8c/0xf0
   dev_attr_store+0x18/0x2c
   sysfs_kf_write+0x44/0x54
   kernfs_fop_write_iter+0x118/0x1a8
   vfs_write+0x3a8/0x4bc
   ksys_write+0x6c/0xf8
   __arm64_sys_write+0x1c/0x28
   invoke_syscall+0x44/0x100
   el0_svc_common.constprop.0+0x40/0xe0
   do_el0_svc+0x1c/0x28
   el0_svc+0x30/0xd0
   el0t_64_sync_handler+0xc8/0xcc
   el0t_64_sync+0x198/0x19c
  Code: f9407be0 b5fff320 d4210000 17ffff97 (d4210000)
  ---[ end trace 0000000000000000 ]---

Link: https://lkml.kernel.org/r/20250217014329.3610326-4-mawupeng1@huawei.com
Fixes: b15c87263a69 ("hwpoison, memory_hotplug: allow hwpoisoned pages to be offlined")
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory_hotplug.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1805,8 +1805,11 @@ static void do_migrate_range(unsigned lo
 		    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio))) {
 			if (WARN_ON(folio_test_lru(folio)))
 				folio_isolate_lru(folio);
-			if (folio_mapped(folio))
+			if (folio_mapped(folio)) {
+				folio_lock(folio);
 				unmap_poisoned_folio(folio, pfn, false);
+				folio_unlock(folio);
+			}
 
 			continue;
 		}


