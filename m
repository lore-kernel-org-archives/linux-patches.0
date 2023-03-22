Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F7C10E5
	for <patches@lists.linux.dev>; Wed, 22 Mar 2023 00:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679446304; x=1710982304;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=B9PpiLYBjsH8WiDosu/yBXR5Y3A1fdmmZghUTR96/7g=;
  b=Ct9eNdAUYxQvCU9U3Pm1cTi6tgLkLRQSm0Trhd1Ib1YWJyCstfIXxHlf
   vplMTa4X4dg6WkPYM8LmBvA5kLN5iaTW0ax6HwbRpOGtbVZR7ZVtwL5JV
   5mDk0DxBUMVY/1cKAst6qhCW7SQy3Np+QDMUDPOsci62eSYLZVJDeAnP4
   iizWsIsMd/RN4WVEfbKmU+9QhAMH36f3uQokofrI/M3OKovAnjsmFJBxF
   SMu4do4DAh7PMA8tzBLbMbd5orh0HmRL+i4v8qLv08XItVkufYDs5xEEf
   +bp61Aa039GgNDX12SSvqpZWwa+H3a+CxdeZrjKJDNHISs3hsPKemSXUg
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="336602270"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="336602270"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 17:51:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="681711889"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="681711889"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 17:51:41 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-edac@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/mce: Check that memory address is usable for recovery
Date: Tue, 21 Mar 2023 17:51:31 -0700
Message-Id: <20230322005131.174499-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

uc_decode_notifier() includes a check that "struct mce"
contains a valid address for recovery. But the machine
check recovery code does not include a similar check.

Use mce_usable_address() to check that there is a valid
address.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mce/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 2eec60f50057..fa28b3f7d945 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1533,7 +1533,7 @@ noinstr void do_machine_check(struct pt_regs *regs)
 		/* If this triggers there is no way to recover. Die hard. */
 		BUG_ON(!on_thread_stack() || !user_mode(regs));
 
-		if (kill_current_task)
+		if (kill_current_task || !mce_usable_address(&m))
 			queue_task_work(&m, msg, kill_me_now);
 		else
 			queue_task_work(&m, msg, kill_me_maybe);
-- 
2.39.2

