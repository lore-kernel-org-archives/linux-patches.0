Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13DB1C68BD;
	Tue, 27 Aug 2024 14:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770128; cv=none; b=qc5aULvWw4zX1fF7/3u/7HdTWRafopTMrRu0p/7oYD2wfM1CX24BWjm0vKXiv0yNXCMGccjLTp42pLbW3yRuEm4OJrZYI48IXzrVBOnZ1os6PjPnc4Q5oNgYz21/sbbgLS7RLUoVidKOItvKwgJPgud0GuHmU87UWtH/1cpeum0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770128; c=relaxed/simple;
	bh=xn8N+jSjdXQdsFl4PRDnhSM74sio84qfAN/nkWTZd9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2sHZu1dm2e6D8wx2a73wku4PYnbZnrPHlSS6UUwfCi5ZgcOTZTehyFqhRhQcq9DAOr59OiFehPsEewVHJpqdre5Oun5HRn8R2PgB11xvZRMHRpYGG2IXKZmIp0/GHr0vD37i8ZHwG0xm8AUBn8+zs7tOj4nFxArYVQ2vborJI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TW4fexY0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TW4fexY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1B1C61047;
	Tue, 27 Aug 2024 14:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770127;
	bh=xn8N+jSjdXQdsFl4PRDnhSM74sio84qfAN/nkWTZd9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TW4fexY0c4m75TbubveYCUO1WuvxUh0fjngQYZBXS775DSLl0uzIAo2Tw2eYj7jL/
	 WHmPDnl8hEYOd99HkajMob7HmH6C+Woz8COOCuS9IS5uCvkmS7TcF/6/0LkZoukk/1
	 1p41YOawzWGjQJtUyNB0t98hYOqIZPA01WyHvuAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	"Nysal Jan K.A" <nysal@linux.ibm.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 136/341] cpu/SMT: Enable SMT only if a core is online
Date: Tue, 27 Aug 2024 16:36:07 +0200
Message-ID: <20240827143848.594190440@linuxfoundation.org>
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

[ Upstream commit 6c17ea1f3eaa330d445ac14a9428402ce4e3055e ]

If a core is offline then enabling SMT should not online CPUs of
this core. By enabling SMT, what is intended is either changing the SMT
value from "off" to "on" or setting the SMT level (threads per core) from a
lower to higher value.

On PowerPC the ppc64_cpu utility can be used, among other things, to
perform the following functions:

ppc64_cpu --cores-on                # Get the number of online cores
ppc64_cpu --cores-on=X              # Put exactly X cores online
ppc64_cpu --offline-cores=X[,Y,...] # Put specified cores offline
ppc64_cpu --smt={on|off|value}      # Enable, disable or change SMT level

If the user has decided to offline certain cores, enabling SMT should
not online CPUs in those cores. This patch fixes the issue and changes
the behaviour as described, by introducing an arch specific function
topology_is_core_online(). It is currently implemented only for PowerPC.

Fixes: 73c58e7e1412 ("powerpc: Add HOTPLUG_SMT support")
Reported-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Closes: https://groups.google.com/g/powerpc-utils-devel/c/wrwVzAAnRlI/m/5KJSoqP4BAAJ
Signed-off-by: Nysal Jan K.A <nysal@linux.ibm.com>
Reviewed-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240731030126.956210-2-nysal@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |  3 ++-
 kernel/cpu.c                                       | 12 +++++++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 34b6f6ab47422..657bdee28d845 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -565,7 +565,8 @@ Description:	Control Symmetric Multi Threading (SMT)
 			 ================ =========================================
 
 			 If control status is "forceoff" or "notsupported" writes
-			 are rejected.
+			 are rejected. Note that enabling SMT on PowerPC skips
+			 offline cores.
 
 What:		/sys/devices/system/cpu/cpuX/power/energy_perf_bias
 Date:		March 2019
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 874bfb952e6e8..0c72b94ed076a 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -2728,6 +2728,16 @@ int cpuhp_smt_disable(enum cpuhp_smt_control ctrlval)
 	return ret;
 }
 
+/**
+ * Check if the core a CPU belongs to is online
+ */
+#if !defined(topology_is_core_online)
+static inline bool topology_is_core_online(unsigned int cpu)
+{
+	return true;
+}
+#endif
+
 int cpuhp_smt_enable(void)
 {
 	int cpu, ret = 0;
@@ -2738,7 +2748,7 @@ int cpuhp_smt_enable(void)
 		/* Skip online CPUs and CPUs on offline nodes */
 		if (cpu_online(cpu) || !node_online(cpu_to_node(cpu)))
 			continue;
-		if (!cpu_smt_thread_allowed(cpu))
+		if (!cpu_smt_thread_allowed(cpu) || !topology_is_core_online(cpu))
 			continue;
 		ret = _cpu_up(cpu, 0, CPUHP_ONLINE);
 		if (ret)
-- 
2.43.0



