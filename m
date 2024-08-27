Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E071A072D;
	Tue, 27 Aug 2024 14:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770134; cv=none; b=Cy0MVlzOjojcUppyltbV3dYV1Fhd4Iuukc482dVwOyf3pt20+xxwrPjaxjcRlA98dx6fmm2AoycYt1L5DLuP60loMXVKbfPR+BzdyzD7a9ft/Ryy3hBdZyiWY03LirHF6P/OrQ2C43JritXPN96GSbeVjCWG1yTrOsw6pbU8rLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770134; c=relaxed/simple;
	bh=mWQzw+6Cjc55awyIUeZjDfBNzp2vXedbv+/yZPqKOy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORiFW/HKAkrsVJ4IIFBMIYxYfJUDv2hK3yPUg1vSptHD/8aVDs0wxqBDQ4Jkgk0kHDYGjz9YSCSTaYMpNkKWHMiG5tgows/MbORpO6kBJCxsXzifA9UGD21ZWz1TPUETWMGkFQmvBjf1zhb0dMs4UfvhxdXr4s+Ns0MfS/3Xvkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lyl2ZQds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lyl2ZQds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231E4C6107F;
	Tue, 27 Aug 2024 14:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770134;
	bh=mWQzw+6Cjc55awyIUeZjDfBNzp2vXedbv+/yZPqKOy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lyl2ZQdsoyfRVZF3nMA3OUsqcP9qTntLO+QTeF2QSVr2FLlfIPPO4zN4KPpWsx4TH
	 wybsQ5TNE+0XrB9EMZuTaHkWb/SkEZIOk/PJbdrZGEqkS9MycF06YcWT+YnVI47+Ga
	 xV2DzxaT1rfXfV8pPWa54tro+JcxJARaUh/6E+Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nysal Jan K.A" <nysal@linux.ibm.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 137/341] powerpc/topology: Check if a core is online
Date: Tue, 27 Aug 2024 16:36:08 +0200
Message-ID: <20240827143848.632240108@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nysal Jan K.A <nysal@linux.ibm.com>

[ Upstream commit 227bbaabe64b6f9cd98aa051454c1d4a194a8c6a ]

topology_is_core_online() checks if the core a CPU belongs to
is online. The core is online if at least one of the sibling
CPUs is online. The first CPU of an online core is also online
in the common case, so this should be fairly quick.

Fixes: 73c58e7e1412 ("powerpc: Add HOTPLUG_SMT support")
Signed-off-by: Nysal Jan K.A <nysal@linux.ibm.com>
Reviewed-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240731030126.956210-3-nysal@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/topology.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
index f4e6f2dd04b73..16bacfe8c7a2c 100644
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -145,6 +145,7 @@ static inline int cpu_to_coregroup_id(int cpu)
 
 #ifdef CONFIG_HOTPLUG_SMT
 #include <linux/cpu_smt.h>
+#include <linux/cpumask.h>
 #include <asm/cputhreads.h>
 
 static inline bool topology_is_primary_thread(unsigned int cpu)
@@ -156,6 +157,18 @@ static inline bool topology_smt_thread_allowed(unsigned int cpu)
 {
 	return cpu_thread_in_core(cpu) < cpu_smt_num_threads;
 }
+
+#define topology_is_core_online topology_is_core_online
+static inline bool topology_is_core_online(unsigned int cpu)
+{
+	int i, first_cpu = cpu_first_thread_sibling(cpu);
+
+	for (i = first_cpu; i < first_cpu + threads_per_core; ++i) {
+		if (cpu_online(i))
+			return true;
+	}
+	return false;
+}
 #endif
 
 #endif /* __KERNEL__ */
-- 
2.43.0



