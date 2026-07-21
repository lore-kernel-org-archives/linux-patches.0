Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF97471411;
	Tue, 21 Jul 2026 20:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664182; cv=none; b=fjPSKzqdRyis7H6cxJQuXI/V6dSueRt/WLe9NHrf2IVbhymyJ2OUs5PhtSydkrzRwdZlPVsrXINqvw6+frkTNArpFoeUfovY6zcLaalHnR86nOvB7E1w4+YpPOEOCTMYgEwG4fvOYVPj4Bbzq/fYdKFtMnJWPYIHIfH/xi0aYIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664182; c=relaxed/simple;
	bh=qNGaHOR5g2WCn9tJoK6KeFvPBagbD4gF8n9YSzhj4W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ECHdDUSO8Rt9oEr3EIDObXCQnkZ8XO2AxI1IG57qZ9gEoqE17IfX08HbMHvdAvgP7i/0C6ZjK0N4y8HX3bebbomkvn/aff6CKAn8Fp4H5tgA3SppLRMMy3sL4aOsO0Z3ADyNi+ctetxiL4mcXZZLeoi0B7FcSv/cB99OijkN6Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IUXzazQs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUXzazQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86CCE1F000E9;
	Tue, 21 Jul 2026 20:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664181;
	bh=0R7UaCIgvDnjgJeko8ksyb65915tmZCpACIOQAJMkB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IUXzazQs9wN+Yscg8ym+2GIagGkzJICsDF+uj8aeJlFartJw/5H+4M7vS8St+iYP1
	 v6TqmzNjLI8FJ0eFXsqUi8WnweaBzocKizXtmrORrllEr9U6cNbB/gHx0vBpKS3/tE
	 RO1C4gBXi6Ls/uVb3Z9iqY32LgOVRlIygMOuNiOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Price <gourry@gourry.net>,
	Waiman Long <longman@redhat.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Zi Yan <ziy@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 6.12 1101/1276] cgroup/cpuset: rebind mm mempolicy to effective_mems, not mems_allowed
Date: Tue, 21 Jul 2026 17:25:44 +0200
Message-ID: <20260721152510.627882592@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Farhad Alemi <farhad.alemi@berkeley.edu>

commit b983c56426383e4a06fa5970c4e33cee879b1482 upstream.

Creating a child cpuset where cpuset.mems is never set leads to a div/0
when a VMA mempolicy with MPOL_F_RELATIVE_NODES rebinds in response to a
CPU hotplug event.

Reproduction steps:
 1) Create a cgroup w/ cpuset controls (do not set cpuset.mems)
 2) Move the task into the child cpuset
 3) Create a VMA mempolicy for that task with MPOL_F_RELATIVE_NODES
 4) unplug and hotplug a cpu
      echo 0 > /sys/devices/system/cpu/cpu1/online
      echo 1 > /sys/devices/system/cpu/cpu1/online
 5) mempolicy rebind does a div/0 in mpol_relative_nodemask on the
    call to __nodes_fold()

The cpuset code passes (cs->mems_allowed) which is not guaranteed to have
nodes to the rebind routine.  Use cs->effective_mems instead, which is
guaranteed to have a non-empty nodemask once we reach that code path.

Link: https://lore.kernel.org/all/CA+0ovCiEz6SP_sn3kN4Tb+_oC=eHMXy_Ffj=usV3wREdQrUtww@mail.gmail.com/
Fixes: ae1c802382f7 ("cpuset: apply cs->effective_{cpus,mems}")
Closes: https://lore.kernel.org/linux-mm/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/
Suggested-by: Gregory Price <gourry@gourry.net>
Suggested-by: Waiman Long <longman@redhat.com>
Acked-by: Waiman Long <longman@redhat.com>
Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Michal Koutný" <mkoutny@suse.com>
Cc: <stable@vger.kernel.org>
[ david: add a comment, slightly rephrase description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2586,7 +2586,12 @@ void cpuset_update_tasks_nodemask(struct
 
 		migrate = is_memory_migrate(cs);
 
-		mpol_rebind_mm(mm, &cs->mems_allowed);
+		/*
+		 * For v1 we can have empty effective_mems, but we cannot
+		 * attach any tasks (see cpuset_can_attach_check()). For v2,
+		 * effective_mems is guaranteed to not be empty.
+		 */
+		mpol_rebind_mm(mm, &cs->effective_mems);
 		if (migrate)
 			cpuset_migrate_mm(mm, &cs->old_mems_allowed, &newmems);
 		else


