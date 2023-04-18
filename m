Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EADAFC3
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 18:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681841033; x=1713377033;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Oaq26ABOZr9aDlblEsU+PBJXtAHzJdihwnBKzQqvi3Q=;
  b=FApDeS3LPNihuAA16VA3nrVbXpHxFueM2i9GJ3OgXnCrae3Fxi3JjRqy
   LEDgid/ItqB43QmkwrEAwevylu/6+PsWglBsAeOs3yvfygWGMXlkf4Ysm
   AuwGoy4M0JO5oQmMoxZgvasN+ZHBTUQYdMpTRNqV3IFWKbuC0jL7busty
   PfvVqvdLqdq+sBqn07kO1GlXBFfZLtAbCXRyD0IE8WaTKeMAPLgQM5zmH
   k7aDD4AKOhtLJJihHmbkWajTkIvyYs23OZdgOieKnZNNcdENmw6jv8Vks
   RymSH/XmMDOYKl2ED+uN1GjiC9+sWZ9uFQ6uqhMNGNsnqpqGTX5l9zHea
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="347098317"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="347098317"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 11:03:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="1020876838"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="1020876838"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 11:03:52 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Yazen Ghannam <yazen.ghannam@amd.com>,
	x86@kernel.org,
	linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2] x86/mce: Always call memory_failure() when there is a valid address
Date: Tue, 18 Apr 2023 11:03:43 -0700
Message-Id: <20230418180343.19167-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <a5d0c575-ba4f-1120-c7ee-bc37e8d40402@amd.com>
References: <a5d0c575-ba4f-1120-c7ee-bc37e8d40402@amd.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Linux should always take poisoned pages offline when there is an error
report with a valid physcal address.

Note1: that call_me_maybe() will correctly handle the case currently
covered by the test of "kill_current_task" that is deleted by this
change because it will set the MF_MUST_KILL flag when p->mce_ripv is
not set.

Note2: This also provides defense against the case where the logged
error doesn't provide a physical address.

Suggested-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mce/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 2eec60f50057..f72c97860524 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1533,7 +1533,7 @@ noinstr void do_machine_check(struct pt_regs *regs)
 		/* If this triggers there is no way to recover. Die hard. */
 		BUG_ON(!on_thread_stack() || !user_mode(regs));
 
-		if (kill_current_task)
+		if (mce_usable_address(&m))
 			queue_task_work(&m, msg, kill_me_now);
 		else
 			queue_task_work(&m, msg, kill_me_maybe);
-- 
2.39.2

