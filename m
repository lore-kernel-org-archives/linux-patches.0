Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409BB430CC0;
	Thu, 16 Jul 2026 14:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212031; cv=none; b=qHe532V90RSJmyvtmxiIhAFWnA4FCrZNxGn3k3hNZ4AO4tj5n1SB8ynliTYq1oggkyj+MB+L/+9CLXW4rwfCi+nDL1GuchfSzFZSL3iBS3MCVhZCNFAN+JjwXRDOEQ5Sdo1bm2vsXQtrlZ+EUtnkLP4Z5lwCJwONxFneZDfVzHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212031; c=relaxed/simple;
	bh=Y5lQbMsSsGrNEPF3r5ZShNrV8JJv4XuuVPdOKpebh/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiKxdOr2r6kAeJcIax3ts6uA6MObyGXbZCK8gnFE0g9eXaDyOlTe9fKsGh3bk7tuAKqrgu3BfsOFKBLSEzfyCrfxcvmuYRDeInRQQV+zo266le/4GGs4nRKwc81ccqUEHxapx7Qv31ix9xhsemtQgW2IB+2eGyYfFnmW26slQc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K2o0b0BP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K2o0b0BP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571461F000E9;
	Thu, 16 Jul 2026 14:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212028;
	bh=lr5rcd97tpimmLKzdkb5QPRJEIeVqKRj46wyFCkXFyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K2o0b0BPgnOwyNrGryvQUEJgEDgoP8gL6iq5PaE2ex96kEaUpPB6vkDfOzC/+FEX3
	 rNIjBeq2qwGGP9a9ipH3BoL1BH2GI21+e6GrkMYYeiyup6qF3iNTBHH3F9TnF4azz4
	 vy2gaNsaF/YL0r8YkIFgN7R/dnQyvLHsm/suMQXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijiang Huang <kerayhuang@tencent.com>,
	Kairui Song <kasong@tencent.com>,
	Hao Peng <flyingpeng@tencent.com>,
	albinwyang <albinwyang@tencent.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 145/349] mm/swap: add cond_resched() in swap_reclaim_full_clusters to prevent softlockup
Date: Thu, 16 Jul 2026 15:31:19 +0200
Message-ID: <20260716133036.617278260@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Zijiang Huang <huangzjsmile@gmail.com>

commit 66366d291f666ddeda5f8c84f253e308de3e6b55 upstream.

We hit a real softlockup in an internal stress test environment.  The
workload was LTP memory/swap stress on a large arm64 machine, with 320
CPUs, about 1TB memory and an 8.6GB swap device.  The system was under
heavy load and the swap device had a large number of full clusters.  The
softlockup was triggered during a stress test after about 3 days.

So, add periodic cond_resched() calls during large full_clusters
reclaim operations to prevent softlockup issues.

Detailed call trace as follow:

PID: 3817773  TASK: ffff0883bb28b780  CPU: 48   COMMAND: "kworker/48:7"
   #0 [ffff800080183d10] __crash_kexec at ffffa4c1361e5de4
   #1 [ffff800080183d90] panic at ffffa4c1360d5e9c
   #2 [ffff800080183e20] watchdog_timer_fn at ffffa4c136231fa8
   ...
  #16 [ffff8000c4ad3cb0] swap_cache_del_folio at ffffa4c1363e1614
  #17 [ffff8000c4ad3ce0] __try_to_reclaim_swap at ffffa4c1363e4bfc
  #18 [ffff8000c4ad3d40] swap_reclaim_full_clusters at ffffa4c1363e5474
  #19 [ffff8000c4ad3da0] swap_reclaim_work at ffffa4c1363e550c
  #20 [ffff8000c4ad3dc0] process_one_work at ffffa4c136102edc
  #21 [ffff8000c4ad3e10] worker_thread at ffffa4c136103398
  #22 [ffff8000c4ad3e70] kthread at ffffa4c13610d95c

Link: https://lore.kernel.org/20260506130919.2298807-1-kerayhuang@tencent.com
Fixes: 5168a68eb78f ("mm, swap: avoid over reclaim of full clusters")
Signed-off-by: Zijiang Huang <kerayhuang@tencent.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Reviewed-by: albinwyang <albinwyang@tencent.com>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/swapfile.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -774,6 +774,7 @@ static void swap_reclaim_full_clusters(s
 
 		if (to_scan <= 0)
 			break;
+		cond_resched();
 	}
 }
 


