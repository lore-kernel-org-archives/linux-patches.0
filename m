Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4321172A
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D516C433C8;
	Mon, 11 Sep 2023 14:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442636;
	bh=Qx4Ko2zLTen7TSlh8f0ILRjVMEANggugSShoim7qRtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1EKDzpQcVPj5n9qUMMa7O4EuuSqF/v2N+PSW+nRU116KuGFWVQqLJqIrcsjR9NTAR
	 bySQlIsbHYiAiUChDOgJN3+94bLrmBXWc2TnXhDLJZXSkc2Hsx0/HhCqIzKvLY8Z2M
	 WrXpbCcNeVlx8DCyqdffkM4mfD2/5tBFJs/J/hrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 057/737] x86/hyperv: add noop functions to x86_init mpparse functions
Date: Mon, 11 Sep 2023 15:38:36 +0200
Message-ID: <20230911134652.082161784@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saurabh Sengar <ssengar@linux.microsoft.com>

[ Upstream commit 9e2d0c336524706fb327e9b87477f5f3337ad7a6 ]

Hyper-V can run VMs at different privilege "levels" known as Virtual
Trust Levels (VTL). Sometimes, it chooses to run two different VMs
at different levels but they share some of their address space. In
such setups VTL2 (higher level VM) has visibility of all of the
VTL0 (level 0) memory space.

When the CONFIG_X86_MPPARSE is enabled for VTL2, the VTL2 kernel
performs a search within the low memory to locate MP tables. However,
in systems where VTL0 manages the low memory and may contain valid
tables, this scanning can result in incorrect MP table information
being provided to the VTL2 kernel, mistakenly considering VTL0's MP
table as its own

Add noop functions to avoid MP parse scan by VTL2.

Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/r/1687537688-5397-1-git-send-email-ssengar@linux.microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/hyperv/hv_vtl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/hyperv/hv_vtl.c b/arch/x86/hyperv/hv_vtl.c
index 85d38b9f35861..db5d2ea39fc0d 100644
--- a/arch/x86/hyperv/hv_vtl.c
+++ b/arch/x86/hyperv/hv_vtl.c
@@ -25,6 +25,10 @@ void __init hv_vtl_init_platform(void)
 	x86_init.irqs.pre_vector_init = x86_init_noop;
 	x86_init.timers.timer_init = x86_init_noop;
 
+	/* Avoid searching for BIOS MP tables */
+	x86_init.mpparse.find_smp_config = x86_init_noop;
+	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
+
 	x86_platform.get_wallclock = get_rtc_noop;
 	x86_platform.set_wallclock = set_rtc_noop;
 	x86_platform.get_nmi_reason = hv_get_nmi_reason;
-- 
2.40.1



