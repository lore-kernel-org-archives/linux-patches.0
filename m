Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED0A185924;
	Fri, 15 Nov 2024 06:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653502; cv=none; b=me75CyFLKcIhiRboKH7GaAeBf5eyt6sF3nrv/fLlJ/m70GgINdWif1yK6la1UyLQ5YvYnvatxaLIk5ZEVQ7peTC9CqhV3zmnIcGTD1+Zzj3uTDsMjHzPcapK6SNeJbvonMVRMkH7Rgx7Nrk94GBiQRoiSV3OLHT4swkkOdzzejk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653502; c=relaxed/simple;
	bh=kgYwg87ZauiUbAyDrxgDO4Uy3EkMvxU+7TlymGOYEyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFa0cUiOM69vCcNzwteHA75fY+Gafj1r1TtUtK1aJThgQh0dYsBiwueMzFVWawFCus9R0YTP2YBdDQuHmPiFXV27C3310DEMQIq8EaECBg1FfSJ15qwSJ83xBoU8imAXvXuBigQD53m9OCQ2d+++mqvgLqOz200l9zDCb08w6Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JLL2MCHA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JLL2MCHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E28C4CECF;
	Fri, 15 Nov 2024 06:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653501;
	bh=kgYwg87ZauiUbAyDrxgDO4Uy3EkMvxU+7TlymGOYEyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JLL2MCHAvjdggnwpCE+OLWCwA1OOXKS21xYW6vzDeA6LJgGXwleX1UqK+VtOiMeN+
	 C6+eRA+J9YrKNL2j9FCcnYwAgOYVm6B/N7HVWZzcGptelZmafbvVXKe3gbbRguk1fd
	 iyv71fNRTDAsZH/zPObv/fDr+5m4jOb7IXAemVTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qun-Wei Lin <qun-wei.lin@mediatek.com>,
	David Rientjes <rientjes@google.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.6 41/48] mm: krealloc: Fix MTE false alarm in __do_krealloc
Date: Fri, 15 Nov 2024 07:38:30 +0100
Message-ID: <20241115063724.445520202@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qun-Wei Lin <qun-wei.lin@mediatek.com>

commit 704573851b51808b45dae2d62059d1d8189138a2 upstream.

This patch addresses an issue introduced by commit 1a83a716ec233 ("mm:
krealloc: consider spare memory for __GFP_ZERO") which causes MTE
(Memory Tagging Extension) to falsely report a slab-out-of-bounds error.

The problem occurs when zeroing out spare memory in __do_krealloc. The
original code only considered software-based KASAN and did not account
for MTE. It does not reset the KASAN tag before calling memset, leading
to a mismatch between the pointer tag and the memory tag, resulting
in a false positive.

Example of the error:
==================================================================
swapper/0: BUG: KASAN: slab-out-of-bounds in __memset+0x84/0x188
swapper/0: Write at addr f4ffff8005f0fdf0 by task swapper/0/1
swapper/0: Pointer tag: [f4], memory tag: [fe]
swapper/0:
swapper/0: CPU: 4 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.12.
swapper/0: Hardware name: MT6991(ENG) (DT)
swapper/0: Call trace:
swapper/0:  dump_backtrace+0xfc/0x17c
swapper/0:  show_stack+0x18/0x28
swapper/0:  dump_stack_lvl+0x40/0xa0
swapper/0:  print_report+0x1b8/0x71c
swapper/0:  kasan_report+0xec/0x14c
swapper/0:  __do_kernel_fault+0x60/0x29c
swapper/0:  do_bad_area+0x30/0xdc
swapper/0:  do_tag_check_fault+0x20/0x34
swapper/0:  do_mem_abort+0x58/0x104
swapper/0:  el1_abort+0x3c/0x5c
swapper/0:  el1h_64_sync_handler+0x80/0xcc
swapper/0:  el1h_64_sync+0x68/0x6c
swapper/0:  __memset+0x84/0x188
swapper/0:  btf_populate_kfunc_set+0x280/0x3d8
swapper/0:  __register_btf_kfunc_id_set+0x43c/0x468
swapper/0:  register_btf_kfunc_id_set+0x48/0x60
swapper/0:  register_nf_nat_bpf+0x1c/0x40
swapper/0:  nf_nat_init+0xc0/0x128
swapper/0:  do_one_initcall+0x184/0x464
swapper/0:  do_initcall_level+0xdc/0x1b0
swapper/0:  do_initcalls+0x70/0xc0
swapper/0:  do_basic_setup+0x1c/0x28
swapper/0:  kernel_init_freeable+0x144/0x1b8
swapper/0:  kernel_init+0x20/0x1a8
swapper/0:  ret_from_fork+0x10/0x20
==================================================================

Fixes: 1a83a716ec233 ("mm: krealloc: consider spare memory for __GFP_ZERO")
Signed-off-by: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slab_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1391,7 +1391,7 @@ __do_krealloc(const void *p, size_t new_
 		/* Zero out spare memory. */
 		if (want_init_on_alloc(flags)) {
 			kasan_disable_current();
-			memset((void *)p + new_size, 0, ks - new_size);
+			memset(kasan_reset_tag(p) + new_size, 0, ks - new_size);
 			kasan_enable_current();
 		}
 


