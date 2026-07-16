Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C333427F80;
	Thu, 16 Jul 2026 13:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209472; cv=none; b=Tf8go+9x8F5dpbjsUM7WtHA1sErpUZeyGiMN75VWnNrRwlurwi3C7sfBQGlvLNBb1ejlklbRowr/O+d1GYi+EtgGlLy4XVDvxD4/+OJe5r4sfH7LR/zX6f5xnD2a8prWpZB//2DisCAwW+r360e5qtFY54Hm+mIgc7aTGry3fCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209472; c=relaxed/simple;
	bh=7lGnnYZoBbVQNlMW5OIurAJ8Uqx/1ZNNWsnWxuUEAWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxW5sNtA8toPOWGd0vzQgYZJtyaAzeuEWHqp/fYhUS0hEmjqS88FcYtqPW4s5nNUOL+9oN4H9Tu2Au06Lra3kfr7YDFU2WL30oqa9jI+F6ycfJ35N1bqL9O9wMh52Z/hs4Sugag6fq0gUeiVVKrrxRa9A+q/E6BYZkvY+OFd5bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fBO+9FtZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fBO+9FtZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098A81F00A3D;
	Thu, 16 Jul 2026 13:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209468;
	bh=KbyP+3/Muy4mvdVusm024ezhMdujS/ROrrQex/x0Xok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fBO+9FtZxo92T9ge2Bb2zlRvwioGihPpN4WlNpE8XiK5sRKB9LXKuZbaVx6ptCE7E
	 sBF9V4LGusL2F5LOQeGGJZVdq1SWKmSSpMmeHK8UUXjr12ApFubl24X6wjRijpvZk/
	 FTkXOlYbOMKDUXTpIslsD2KnKHulDpHb09oL+Dbk=
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
Subject: [PATCH 7.1 196/518] mm/swap: add cond_resched() in swap_reclaim_full_clusters to prevent softlockup
Date: Thu, 16 Jul 2026 15:27:44 +0200
Message-ID: <20260716133052.116293186@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1054,6 +1054,7 @@ static void swap_reclaim_full_clusters(s
 		swap_cluster_unlock(ci);
 		if (to_scan <= 0)
 			break;
+		cond_resched();
 	}
 }
 


