Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AF9C8E5
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4728EC433C0;
	Mon, 26 Jun 2023 18:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687805036;
	bh=xwaMFTxE+0rNF/ysB/xVeAFVcoOLY/OOdTqDTfIJpms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iFepq/89xwaRc2hdpQ2qBSPMoeb/Y8YHog0DQWMO+ddGo81ENVvMq2ueem2n/poH6
	 3w5FINPla79pmm6/SEbmnnHqKZKKubVRFG3EHRT33niyzz4feQpSEnlPKtetP6PKsG
	 pH/ndNsrSRPyYFMDQfbUD15Rre0p87UFuVbXLwm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Lukas Middendorf <kernel@tuxforce.de>,
	Antti Palosaari <crope@iki.fi>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Iurii Zaikin <yzaikin@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mel Gorman <mgorman@techsingularity.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Zhang Yi <yi.zhang@huawei.com>,
	Fengfei Xi <xi.fengfei@h3c.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 28/81] mm/pagealloc: sysctl: change watermark_scale_factor max limit to 30%
Date: Mon, 26 Jun 2023 20:12:10 +0200
Message-ID: <20230626180745.627309055@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180744.453069285@linuxfoundation.org>
References: <20230626180744.453069285@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Suren Baghdasaryan <surenb@google.com>

[ Upstream commit 39c65a94cd9661532be150e88f8b02f4a6844a35 ]

For embedded systems with low total memory, having to run applications
with relatively large memory requirements, 10% max limitation for
watermark_scale_factor poses an issue of triggering direct reclaim every
time such application is started.  This results in slow application
startup times and bad end-user experience.

By increasing watermark_scale_factor max limit we allow vendors more
flexibility to choose the right level of kswapd aggressiveness for their
device and workload requirements.

Link: https://lkml.kernel.org/r/20211124193604.2758863-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Zhang Yi <yi.zhang@huawei.com>
Cc: Fengfei Xi <xi.fengfei@h3c.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 935d44acf621 ("memfd: check for non-NULL file_seals in memfd_create() syscall")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/sysctl/vm.rst | 2 +-
 kernel/sysctl.c                         | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 06027c6a233ab..ac852f93f8da5 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -948,7 +948,7 @@ how much memory needs to be free before kswapd goes back to sleep.
 
 The unit is in fractions of 10,000. The default value of 10 means the
 distances between watermarks are 0.1% of the available memory in the
-node/system. The maximum value is 1000, or 10% of memory.
+node/system. The maximum value is 3000, or 30% of memory.
 
 A high rate of threads entering direct reclaim (allocstall) or kswapd
 going to sleep prematurely (kswapd_low_wmark_hit_quickly) can indicate
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index d981abea0358d..953c021039704 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -120,6 +120,7 @@ static unsigned long long_max = LONG_MAX;
 static int one_hundred = 100;
 static int two_hundred = 200;
 static int one_thousand = 1000;
+static int three_thousand = 3000;
 #ifdef CONFIG_PRINTK
 static int ten_thousand = 10000;
 #endif
@@ -2987,7 +2988,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= watermark_scale_factor_sysctl_handler,
 		.extra1		= SYSCTL_ONE,
-		.extra2		= &one_thousand,
+		.extra2		= &three_thousand,
 	},
 	{
 		.procname	= "percpu_pagelist_fraction",
-- 
2.39.2



