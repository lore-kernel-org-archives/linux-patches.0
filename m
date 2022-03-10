Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CC56469
	for <patches@lists.linux.dev>; Thu, 10 Mar 2022 20:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646945344; x=1678481344;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XBV/vhSpOQFq3ItxNWH3aLVfSt1M13WXm1fnUUqRboI=;
  b=hldX8pAeP0K1I43J88784YQRZYfmy6NHpXv3Ikd4sdQAJoqR7q0RQgCM
   xKSjU8fovtZxLCxBGrRGFORlLa3wEYhrB3ak7ZL7OQwmk1v7D05KBtU09
   0/ZqQUJ3FEVZ7l848LioH5ftalOVKjzNL3I+XFqIitjGQJB/5sl/SjtId
   wfuEKtrhYgSSMqbq4b3oBvrDIa5WwBAWaPDnBZQnlcI/hN+e/zwF1TSgH
   IXpdafRXSsbQCrFyPsBHe99wrZQ5fyUfQcDZ0SnHGWtlTsBpuFEUqcIe3
   QYN0uJgX4qAqUIaYCwrvwpNwmh8df1NP/0Nyl83xgxOS1MKBK2ZdX5P4f
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10282"; a="280117469"
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="280117469"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 12:49:03 -0800
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="554843291"
Received: from agluck-desk3.sc.intel.com ([172.25.222.60])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 12:49:02 -0800
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2 0/2] Make life miserable for split lockers
Date: Thu, 10 Mar 2022 12:48:52 -0800
Message-Id: <20220310204854.31752-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220217012721.9694-1-tony.luck@intel.com>
References: <20220217012721.9694-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

See part 0001 commit message for what & why.

Changes since v1(RFC) based on feedback from Thomas:

1) No longer implemented as new sub-option of split_lock_detect boot
   option.  Just update the existing (default) "warn" mode.
2) Use the (more appropriate) "schedule_delayed_work_on() instead of
   schedule_delayed_work() to re-enable split lock detection.
3) Add msleep for extra misery before disabling split lock detection
   on a core.

Next two aren't from Thomas.
4) Drop the TIF_SLD bit and associated code. No longer needed. This
   part is done as clean up in patch 0002.
5) Add a bit in task structure to make sure each split-locking task
   only tries to print a warn message to the console once. Need this
   to preserve existing behavior that was previously controlled by the
   TIF_SLD bit.

Testing notes. I checked this out by running 2,000 processes that
each looped executing 10,000 split locks. System remains very
responsive while this test is running (compared with unusable
without these patches). When each process gets the semaphore
and two jiffies of time to execute split locks it manages to
complete ~430 before the delayed work thread re-enables detection.

The semaphore gives nice round-robin access to the 2,000 tasks.
So each ends up blocking for 24ish seconds while the other 1,999
task take their turn.

Tony Luck (2):
  x86/split_lock: Make life miserable for split lockers
  x86/split-lock: Remove unused TIF_SLD bit

 arch/x86/include/asm/cpu.h         |  2 -
 arch/x86/include/asm/thread_info.h |  4 +-
 arch/x86/kernel/cpu/intel.c        | 77 +++++++++++++++++++++---------
 arch/x86/kernel/process.c          |  3 --
 include/linux/sched.h              |  3 ++
 kernel/fork.c                      |  5 ++
 6 files changed, 64 insertions(+), 30 deletions(-)

-- 
2.35.1

