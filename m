Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5E814A4E6;
	Tue, 20 Feb 2024 21:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464442; cv=none; b=HEZhQvYvRtiTiLX+EcMdTESfaYOgZKHjQ6Ns0aKA4UGcTgFbn7Yxq7ifu1PIjDQi7S0U5W3BpuNP8JQymwRfT7zOHlTj6St2h5nmh2H5BiUYcPPi0L0uXKRT7WlKdTPpYE+sAyWorfJOwkfoAKYiaUodHEWYazYJZHkzM9d0yCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464442; c=relaxed/simple;
	bh=PmrXVdgrpxkmYfof8n9HaKtqX0tIllbaULK0axRHWEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nH3lo5r7TzoBWozvkUtV82V4gb7HFNIKtNjjnTnEpp/PaoY3eAjY1CpoToLPl7q9yFhJps2C7Ci5/o064JwUyK0oejCxxGp2+22GvXLTDzph8o5jACgc7YyhFWp3C+17618cqQ80cpa53wgmfPvHnREojdJBK3GKa391H6035lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s0Vsy6YE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s0Vsy6YE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFB2C433F1;
	Tue, 20 Feb 2024 21:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464442;
	bh=PmrXVdgrpxkmYfof8n9HaKtqX0tIllbaULK0axRHWEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s0Vsy6YEV4jHKv+cJqJfq+BEQX1oXiOVCFu8xa6NdVD5BOD9QTmrAVrIYkdvLom3V
	 kCydUYy0Rg0TJ0esucNoacySAU9xrgXDD9+Qf73oV9GouOUCEEK5XcwJRaeigxw7PO
	 fRRCww6HImhYNAu+uiOOG5YLvZsN9owsSzIpNwmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Shi <yang@os.amperecomputing.com>,
	kernel test robot <oliver.sang@intel.com>,
	Yin Fengwei <fengwei.yin@intel.com>,
	Rik van Riel <riel@surriel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Christopher Lameter <cl@linux.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	stable@vger.kerenl.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Huang
Subject: [PATCH 6.7 004/309] mm: mmap: map MAP_STACK to VM_NOHUGEPAGE
Date: Tue, 20 Feb 2024 21:52:43 +0100
Message-ID: <20240220205633.254129878@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Shi <yang@os.amperecomputing.com>

commit c4608d1bf7c6536d1a3d233eb21e50678681564e upstream.

commit efa7df3e3bb5 ("mm: align larger anonymous mappings on THP
boundaries") incured regression for stress-ng pthread benchmark [1].  It
is because THP get allocated to pthread's stack area much more possible
than before.  Pthread's stack area is allocated by mmap without
VM_GROWSDOWN or VM_GROWSUP flag, so kernel can't tell whether it is a
stack area or not.

The MAP_STACK flag is used to mark the stack area, but it is a no-op on
Linux.  Mapping MAP_STACK to VM_NOHUGEPAGE to prevent from allocating THP
for such stack area.

With this change the stack area looks like:

fffd18e10000-fffd19610000 rw-p 00000000 00:00 0
Size:               8192 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Rss:                  12 kB
Pss:                  12 kB
Pss_Dirty:            12 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        12 kB
Referenced:           12 kB
Anonymous:            12 kB
KSM:                   0 kB
LazyFree:              0 kB
AnonHugePages:         0 kB
ShmemPmdMapped:        0 kB
FilePmdMapped:         0 kB
Shared_Hugetlb:        0 kB
Private_Hugetlb:       0 kB
Swap:                  0 kB
SwapPss:               0 kB
Locked:                0 kB
THPeligible:           0
VmFlags: rd wr mr mw me ac nh

The "nh" flag is set.

[1] https://lore.kernel.org/linux-mm/202312192310.56367035-oliver.sang@intel.com/

Link: https://lkml.kernel.org/r/20231221065943.2803551-2-shy828301@gmail.com
Fixes: efa7df3e3bb5 ("mm: align larger anonymous mappings on THP boundaries")
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Tested-by: Oliver Sang <oliver.sang@intel.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christopher Lameter <cl@linux.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: <stable@vger.kerenl.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mman.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/mman.h
+++ b/include/linux/mman.h
@@ -156,6 +156,7 @@ calc_vm_flag_bits(unsigned long flags)
 	return _calc_vm_trans(flags, MAP_GROWSDOWN,  VM_GROWSDOWN ) |
 	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    ) |
 	       _calc_vm_trans(flags, MAP_SYNC,	     VM_SYNC      ) |
+	       _calc_vm_trans(flags, MAP_STACK,	     VM_NOHUGEPAGE) |
 	       arch_calc_vm_flag_bits(flags);
 }
 


