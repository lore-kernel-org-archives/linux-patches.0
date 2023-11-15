Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F7E364CB
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrLmAwIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175E5C433C8;
	Wed, 15 Nov 2023 19:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076018;
	bh=qlEIbPSQHe4V67F/5QnoDyBsSala6i1RTtcx7nCkP+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RrLmAwIiKVD2fc8S3vhgI2youynIga4rTDP/YXiRS82lvK6yfTQsy0P2FPu7WANYe
	 YoVihcFa5isE3yU2Jfo+WaCj4UWr9hNhprKlv6MVP/RIhdwa+4ZvYHaZ7nfqi0WQti
	 +et0X2PLlN9OjG4+zwAuynAxMA7TGhQfKZPWuwUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Dufour <ldufour@linux.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Zhang Rui <rui.zhang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 023/550] cpu/hotplug: Remove dependancy against cpu_primary_thread_mask
Date: Wed, 15 Nov 2023 14:10:07 -0500
Message-ID: <20231115191602.329055517@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Dufour <ldufour@linux.ibm.com>

[ Upstream commit 7a4dcb4a5de1214c4a59448a759e2e264c2c4473 ]

The commit 18415f33e2ac ("cpu/hotplug: Allow "parallel" bringup up to
CPUHP_BP_KICK_AP_STATE") introduce a dependancy against a global variable
cpu_primary_thread_mask exported by the X86 code. This variable is only
used when CONFIG_HOTPLUG_PARALLEL is set.

Since cpuhp_get_primary_thread_mask() and cpuhp_smt_aware() are only used
when CONFIG_HOTPLUG_PARALLEL is set, don't define them when it is not set.

No functional change.

Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Zhang Rui <rui.zhang@intel.com>
Link: https://lore.kernel.org/r/20230705145143.40545-2-ldufour@linux.ibm.com
Stable-dep-of: d91bdd96b55c ("cpu/SMT: Make SMT control more robust against enumeration failures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cpu.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 9628ae3c2825b..dd59ffeacff2e 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -650,22 +650,8 @@ bool cpu_smt_possible(void)
 }
 EXPORT_SYMBOL_GPL(cpu_smt_possible);
 
-static inline bool cpuhp_smt_aware(void)
-{
-	return topology_smt_supported();
-}
-
-static inline const struct cpumask *cpuhp_get_primary_thread_mask(void)
-{
-	return cpu_primary_thread_mask;
-}
 #else
 static inline bool cpu_smt_allowed(unsigned int cpu) { return true; }
-static inline bool cpuhp_smt_aware(void) { return false; }
-static inline const struct cpumask *cpuhp_get_primary_thread_mask(void)
-{
-	return cpu_present_mask;
-}
 #endif
 
 static inline enum cpuhp_state
@@ -1815,6 +1801,16 @@ static int __init parallel_bringup_parse_param(char *arg)
 }
 early_param("cpuhp.parallel", parallel_bringup_parse_param);
 
+static inline bool cpuhp_smt_aware(void)
+{
+	return topology_smt_supported();
+}
+
+static inline const struct cpumask *cpuhp_get_primary_thread_mask(void)
+{
+	return cpu_primary_thread_mask;
+}
+
 /*
  * On architectures which have enabled parallel bringup this invokes all BP
  * prepare states for each of the to be onlined APs first. The last state
-- 
2.42.0



