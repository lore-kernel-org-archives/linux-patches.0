Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3347E22ACDC;
	Mon, 10 Mar 2025 17:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628326; cv=none; b=bRyFKhhgZ6dda89/H9KEfui910vGn/MEgTLXoENe5nRJu4tTWTraYu5DUaHvvjW/URvJzcB4rmY3ip99OlCFdI0cErBaL/efSqLnYFwR4NsDlkwiNKuknCKXewFn85y5/3y8yluNkMOSMS7i+cVEUmRUjBqhB2C2QQR+fDuau00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628326; c=relaxed/simple;
	bh=dUW73rSm6UYz24fCbFMuxlJhzzui7O26U1GjSur+Xms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuXZUOraLeJB/QDxno92pzn2Klh6pYE3KNeeP1bfZm4UqAWCdGmPqtTszY8ZTaCpubCGgDt/jk21Cz2UubMewRnPDGAkhxY/Groui0u8LUmxVmjDzqckDFwXC+i93q5UJMfPGwxyQdPjsI6Kq5hVWgq+IVVQRtEZXukK7W9+RtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ofpYHRSo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ofpYHRSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D26C4CEE5;
	Mon, 10 Mar 2025 17:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628326;
	bh=dUW73rSm6UYz24fCbFMuxlJhzzui7O26U1GjSur+Xms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ofpYHRSoZx5zzZ4KED3ADBSiEpENnMKg/Rwm/um48Y7+yRxHVy5OGPI5nHly4F0yH
	 HKt9n/xL/QYDZKxBWOZYuHskDWlDfTRVXSUujAdp1pLvekInHj5B+ost2kMo/3dxiQ
	 a74WgK6TLck1oZEowBPOpYlTShz0Z72PQpVTNeRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Waiman Long <longman@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/109] x86/speculation: Add __update_spec_ctrl() helper
Date: Mon, 10 Mar 2025 18:05:50 +0100
Message-ID: <20250310170427.800026279@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit e3e3bab1844d448a239cd57ebf618839e26b4157 ]

Add a new __update_spec_ctrl() helper which is a variant of
update_spec_ctrl() that can be used in a noinstr function.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20230727184600.26768-2-longman@redhat.com
Stable-dep-of: c157d351460b ("intel_idle: Handle older CPUs, which stop the TSC in deeper C states, correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/spec-ctrl.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/include/asm/spec-ctrl.h b/arch/x86/include/asm/spec-ctrl.h
index cb0386fc4dc3b..c648502e45357 100644
--- a/arch/x86/include/asm/spec-ctrl.h
+++ b/arch/x86/include/asm/spec-ctrl.h
@@ -4,6 +4,7 @@
 
 #include <linux/thread_info.h>
 #include <asm/nospec-branch.h>
+#include <asm/msr.h>
 
 /*
  * On VMENTER we must preserve whatever view of the SPEC_CTRL MSR
@@ -76,6 +77,16 @@ static inline u64 ssbd_tif_to_amd_ls_cfg(u64 tifn)
 	return (tifn & _TIF_SSBD) ? x86_amd_ls_cfg_ssbd_mask : 0ULL;
 }
 
+/*
+ * This can be used in noinstr functions & should only be called in bare
+ * metal context.
+ */
+static __always_inline void __update_spec_ctrl(u64 val)
+{
+	__this_cpu_write(x86_spec_ctrl_current, val);
+	native_wrmsrl(MSR_IA32_SPEC_CTRL, val);
+}
+
 #ifdef CONFIG_SMP
 extern void speculative_store_bypass_ht_init(void);
 #else
-- 
2.39.5



