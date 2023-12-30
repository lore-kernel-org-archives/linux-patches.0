Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE8479DD;
	Sat, 30 Dec 2023 12:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t0vjERft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37364C433C8;
	Sat, 30 Dec 2023 12:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937826;
	bh=FcYscr2RqEUmLzqVPLmuz2MjfTKsfkiJY47cucKfTJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t0vjERftxWwBoMNmI3ya61KMbD8HYgC1mkcUqJvYb0SkvPTfFbRqkN2wBGw/cBbMJ
	 Ne8xtKRTmLD5w0wgiS4UsgQ/UviPpoSQMAIiDDUAprfKFHtqbYwh5SKcV4ve4MngRS
	 XHbtlksUdthDMPdco8GjjSvfudaxmKwYksWw0lBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Juergen Gross <jgross@suse.com>,
	Alyssa Ross <hi@alyssa.is>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/156] x86/xen: add CPU dependencies for 32-bit build
Date: Sat, 30 Dec 2023 11:58:51 +0000
Message-ID: <20231230115814.880668960@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 93cd0597649844a0fe7989839a3202735fb3ae67 ]

Xen only supports modern CPUs even when running a 32-bit kernel, and it now
requires a kernel built for a 64 byte (or larger) cache line:

In file included from <command-line>:
In function 'xen_vcpu_setup',
    inlined from 'xen_vcpu_setup_restore' at arch/x86/xen/enlighten.c:111:3,
    inlined from 'xen_vcpu_restore' at arch/x86/xen/enlighten.c:141:3:
include/linux/compiler_types.h:435:45: error: call to '__compiletime_assert_287' declared with attribute error: BUILD_BUG_ON failed: sizeof(*vcpup) > SMP_CACHE_BYTES
arch/x86/xen/enlighten.c:166:9: note: in expansion of macro 'BUILD_BUG_ON'
  166 |         BUILD_BUG_ON(sizeof(*vcpup) > SMP_CACHE_BYTES);
      |         ^~~~~~~~~~~~

Enforce the dependency with a whitelist of CPU configurations. In normal
distro kernels, CONFIG_X86_GENERIC is enabled, and this works fine. When this
is not set, still allow Xen to be built on kernels that target a 64-bit
capable CPU.

Fixes: db2832309a82 ("x86/xen: fix percpu vcpu_info allocation")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Tested-by: Alyssa Ross <hi@alyssa.is>
Link: https://lore.kernel.org/r/20231204084722.3789473-1-arnd@kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 9b1ec5d8c99c8..a65fc2ae15b49 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -9,6 +9,7 @@ config XEN
 	select PARAVIRT_CLOCK
 	select X86_HV_CALLBACK_VECTOR
 	depends on X86_64 || (X86_32 && X86_PAE)
+	depends on X86_64 || (X86_GENERIC || MPENTIUM4 || MCORE2 || MATOM || MK8)
 	depends on X86_LOCAL_APIC && X86_TSC
 	help
 	  This is the Linux Xen port.  Enabling this will allow the
-- 
2.43.0



