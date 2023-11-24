Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC06321AD;
	Fri, 24 Nov 2023 18:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDEcnT8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A3DC433C7;
	Fri, 24 Nov 2023 18:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850921;
	bh=OWNNPsI3j9xXi6YBaCD5nAp/E953/AjJo00TMqjHxmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDEcnT8YkCW/snA7I77amFz0tZVWes+7uBPUBlCTgiPpKTQ4o65WrWSYbI/CkL4MN
	 02RuWfzD1VOGCJYdzdqHMZRKnE3hN+LUkT6zlhdaRvIrMcshterQtu+Q4OstDkQldM
	 j1jECo56+Qp/P8SjFrnQbLDWd1P3FTr8AQsrpOBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Wen <puwen@hygon.cn>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.5 241/491] x86/cpu/hygon: Fix the CPU topology evaluation for real
Date: Fri, 24 Nov 2023 17:47:57 +0000
Message-ID: <20231124172031.801067101@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

From: Pu Wen <puwen@hygon.cn>

commit ee545b94d39a00c93dc98b1dbcbcf731d2eadeb4 upstream.

Hygon processors with a model ID > 3 have CPUID leaf 0xB correctly
populated and don't need the fixed package ID shift workaround. The fixup
is also incorrect when running in a guest.

Fixes: e0ceeae708ce ("x86/CPU/hygon: Fix phys_proc_id calculation logic for multi-die processors")
Signed-off-by: Pu Wen <puwen@hygon.cn>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/tencent_594804A808BD93A4EBF50A994F228E3A7F07@qq.com
Link: https://lore.kernel.org/r/20230814085112.089607918@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/hygon.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/hygon.c
+++ b/arch/x86/kernel/cpu/hygon.c
@@ -86,8 +86,12 @@ static void hygon_get_topology(struct cp
 		if (!err)
 			c->x86_coreid_bits = get_count_order(c->x86_max_cores);
 
-		/* Socket ID is ApicId[6] for these processors. */
-		c->phys_proc_id = c->apicid >> APICID_SOCKET_ID_BIT;
+		/*
+		 * Socket ID is ApicId[6] for the processors with model <= 0x3
+		 * when running on host.
+		 */
+		if (!boot_cpu_has(X86_FEATURE_HYPERVISOR) && c->x86_model <= 0x3)
+			c->phys_proc_id = c->apicid >> APICID_SOCKET_ID_BIT;
 
 		cacheinfo_hygon_init_llc_id(c, cpu);
 	} else if (cpu_has(c, X86_FEATURE_NODEID_MSR)) {


