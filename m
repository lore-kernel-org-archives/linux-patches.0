Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA611E520;
	Tue, 27 Aug 2024 15:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771358; cv=none; b=T3jGPs5AozHx7dkgr6l4DoSpNrhsBUgkNI3/mpHR5emVhPqqTAz6waod5XU+/496+jSU33qIMtlvG5SCgNc3xmFyiwFcg4Sv1bcyIGq7uF1rhNnRFj/J2NTMC168I/SZPfGf6IxcRg582oqDzj/F52V9YY+8q4q0gNHZgn4/0NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771358; c=relaxed/simple;
	bh=oQnwyuPlnbEmh0ttdNxfJNGcB+v4CQdJKbIq/sM8vuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjxE/HLXSSCdB6awAbFB0HgjPCPY80j4vHb7Pz0W631KrHueO02awDQ0KdRSaX0aqFkxymdDVabUoPo7BHvt5l4g3PrgwvhqzZ+BzVAqYgHfQSC13QxJFhtlVvtULIsIxMWRMyc9kWufgfpq6/bio7rOBC9i0kOp5LTDe8xEcqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qRFuoVwY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qRFuoVwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B26C4AF18;
	Tue, 27 Aug 2024 15:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771358;
	bh=oQnwyuPlnbEmh0ttdNxfJNGcB+v4CQdJKbIq/sM8vuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qRFuoVwYbMpjjEAgzV2y4vh+HXYSu0a7ICwLaGolecHo5QwNt9uXGa7fvGLDtsh8p
	 dFlmBQ34T5+C0+uaYCukP4FvGn45UU5v8AkK5L1eTP2bx0sDPg5gW3hnArPfzJ6R6i
	 EVD7ALpMH8+LfPGLOsPnqFJzdyskS2b4RiZcRDk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nysal Jan K.A" <nysal@linux.ibm.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 133/273] powerpc/topology: Check if a core is online
Date: Tue, 27 Aug 2024 16:37:37 +0200
Message-ID: <20240827143838.465062583@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



