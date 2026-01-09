Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA28C339B30;
	Fri,  9 Jan 2026 11:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959089; cv=none; b=FXmWA3P0JZoyu6y8FKYwm4dbv6Tcq5MMBwbgBooJ5sjTCwXIVd2DwA2ISMmxeHJ0qxJJNwBNeTZXgrcwdhUBbBfuPqFRfumwrO0XPH9NZ51fketLcsdsA00Iwm3INWIsyhUyQIo3cSRvNoqaD9VdKTe/sdKI/dJRayVBrSr0X3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959089; c=relaxed/simple;
	bh=iI/iYo9QZmFZhF9Vxy2aIcjoS2KIanIr5RLsIVseZpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuBZo+bvMGLmuT/c6XB4N6szOpbjxkdA7O9SWHUOWBd1j6qlr1LYa94FqU+iBn8N2RyVKOZ18nR3QYAsnaUfSBev1dWMwfvmhxbBWpVN//2/WCjnGMap5ghVq3XaaFglJLMqqoh/if2wGewLAtQmMIL7CFOUrIgTaSL2ZJeCrrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5NrF8Da; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5NrF8Da"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD53C4CEF1;
	Fri,  9 Jan 2026 11:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959088;
	bh=iI/iYo9QZmFZhF9Vxy2aIcjoS2KIanIr5RLsIVseZpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b5NrF8DaYHSusL0ilCnQC8hBmBzMdccZJmcpkqid9bjS5BQ9QjbheqPk25HeggFJE
	 gfZ6GJO8I/3Org3in2gipRBwfV9ymJazeXnfzWWaR6EUBDr1p3nzW72ojKUHZ04t2n
	 BJa9YNYVauYOCtGT+5NW2tWPM80r+cbJlpJ6yeYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bijan Tabatabai <bijan311@gmail.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shivank Garg <shivankg@amd.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 04/16] mm: consider non-anon swap cache folios in folio_expected_ref_count()
Date: Fri,  9 Jan 2026 12:43:45 +0100
Message-ID: <20260109111951.586637085@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109111951.415522519@linuxfoundation.org>
References: <20260109111951.415522519@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Bijan Tabatabai <bijan311@gmail.com>

[ Upstream commit f183663901f21fe0fba8bd31ae894bc529709ee0 ]

Currently, folio_expected_ref_count() only adds references for the swap
cache if the folio is anonymous.  However, according to the comment above
the definition of PG_swapcache in enum pageflags, shmem folios can also
have PG_swapcache set.  This patch makes sure references for the swap
cache are added if folio_test_swapcache(folio) is true.

This issue was found when trying to hot-unplug memory in a QEMU/KVM
virtual machine.  When initiating hot-unplug when most of the guest memory
is allocated, hot-unplug hangs partway through removal due to migration
failures.  The following message would be printed several times, and would
be printed again about every five seconds:

[   49.641309] migrating pfn b12f25 failed ret:7
[   49.641310] page: refcount:2 mapcount:0 mapping:0000000033bd8fe2 index:0x7f404d925 pfn:0xb12f25
[   49.641311] aops:swap_aops
[   49.641313] flags: 0x300000000030508(uptodate|active|owner_priv_1|reclaim|swapbacked|node=0|zone=3)
[   49.641314] raw: 0300000000030508 ffffed312c4bc908 ffffed312c4bc9c8 0000000000000000
[   49.641315] raw: 00000007f404d925 00000000000c823b 00000002ffffffff 0000000000000000
[   49.641315] page dumped because: migration failure

When debugging this, I found that these migration failures were due to
__migrate_folio() returning -EAGAIN for a small set of folios because the
expected reference count it calculates via folio_expected_ref_count() is
one less than the actual reference count of the folios.  Furthermore, all
of the affected folios were not anonymous, but had the PG_swapcache flag
set, inspiring this patch.  After applying this patch, the memory
hot-unplug behaves as expected.

I tested this on a machine running Ubuntu 24.04 with kernel version
6.8.0-90-generic and 64GB of memory.  The guest VM is managed by libvirt
and runs Ubuntu 24.04 with kernel version 6.18 (though the head of the
mm-unstable branch as a Dec 16, 2025 was also tested and behaves the same)
and 48GB of memory.  The libvirt XML definition for the VM can be found at
[1].  CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_MOVABLE is set in the guest
kernel so the hot-pluggable memory is automatically onlined.

Below are the steps to reproduce this behavior:

1) Define and start and virtual machine
  host$ virsh -c qemu:///system define ./test_vm.xml # test_vm.xml from [1]
  host$ virsh -c qemu:///system start test_vm

2) Setup swap in the guest
  guest$ sudo fallocate -l 32G /swapfile
  guest$ sudo chmod 0600 /swapfile
  guest$ sudo mkswap /swapfile
  guest$ sudo swapon /swapfile

3) Use alloc_data [2] to allocate most of the remaining guest memory
  guest$ ./alloc_data 45

4) In a separate guest terminal, monitor the amount of used memory
  guest$ watch -n1 free -h

5) When alloc_data has finished allocating, initiate the memory
hot-unplug using the provided xml file [3]
  host$ virsh -c qemu:///system detach-device test_vm ./remove.xml --live

After initiating the memory hot-unplug, you should see the amount of
available memory in the guest decrease, and the amount of used swap data
increase.  If everything works as expected, when all of the memory is
unplugged, there should be around 8.5-9GB of data in swap.  If the
unplugging is unsuccessful, the amount of used swap data will settle below
that.  If that happens, you should be able to see log messages in dmesg
similar to the one posted above.

Link: https://lkml.kernel.org/r/20251216200727.2360228-1-bijan311@gmail.com
Link: https://github.com/BijanT/linux_patch_files/blob/main/test_vm.xml [1]
Link: https://github.com/BijanT/linux_patch_files/blob/main/alloc_data.c [2]
Link: https://github.com/BijanT/linux_patch_files/blob/main/remove.xml [3]
Fixes: 86ebd50224c0 ("mm: add folio_expected_ref_count() for reference count calculation")
Signed-off-by: Bijan Tabatabai <bijan311@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2241,10 +2241,10 @@ static inline int folio_expected_ref_cou
 	if (WARN_ON_ONCE(page_has_type(&folio->page) && !folio_test_hugetlb(folio)))
 		return 0;
 
-	if (folio_test_anon(folio)) {
-		/* One reference per page from the swapcache. */
-		ref_count += folio_test_swapcache(folio) << order;
-	} else {
+	/* One reference per page from the swapcache. */
+	ref_count += folio_test_swapcache(folio) << order;
+
+	if (!folio_test_anon(folio)) {
 		/* One reference per page from the pagecache. */
 		ref_count += !!folio->mapping << order;
 		/* One reference from PG_private. */


