Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854D4DF40
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF59BC433D2;
	Mon, 15 May 2023 16:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168794;
	bh=b24/jxuW7WhvTldd3iDQErsqx6y3yEwslCuaJRJsrj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPIkiXiOpffvb6gR28WSBjkWFUw/ddh7M6JV1twZJjcH6SGL16mIX+IpKkGbs9GZM
	 ZIOw4BJ62K1zIqk+q3PgB3DFwyZrxUBRkl/J0iFK+4gQAg8BicHFtYG+NZmcHKS2jP
	 y12OV1FKxFqLvcmibuhMBx+6G6I3fro29TRl4iYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 043/191] x86/ioapic: Dont return 0 from arch_dynirq_lower_bound()
Date: Mon, 15 May 2023 18:24:40 +0200
Message-Id: <20230515161708.750921329@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Saurabh Sengar <ssengar@linux.microsoft.com>

[ Upstream commit 5af507bef93c09a94fb8f058213b489178f4cbe5 ]

arch_dynirq_lower_bound() is invoked by the core interrupt code to
retrieve the lowest possible Linux interrupt number for dynamically
allocated interrupts like MSI.

The x86 implementation uses this to exclude the IO/APIC GSI space.
This works correctly as long as there is an IO/APIC registered, but
returns 0 if not. This has been observed in VMs where the BIOS does
not advertise an IO/APIC.

0 is an invalid interrupt number except for the legacy timer interrupt
on x86. The return value is unchecked in the core code, so it ends up
to allocate interrupt number 0 which is subsequently considered to be
invalid by the caller, e.g. the MSI allocation code.

The function has already a check for 0 in the case that an IO/APIC is
registered, as ioapic_dynirq_base is 0 in case of device tree setups.

Consolidate this and zero check for both ioapic_dynirq_base and gsi_top,
which is used in the case that no IO/APIC is registered.

Fixes: 3e5bedc2c258 ("x86/apic: Fix arch_dynirq_lower_bound() bug for DT enabled machines")
Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/1679988604-20308-1-git-send-email-ssengar@linux.microsoft.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 677508baf95a0..af59aa9c55233 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2449,17 +2449,21 @@ static int io_apic_get_redir_entries(int ioapic)
 
 unsigned int arch_dynirq_lower_bound(unsigned int from)
 {
+	unsigned int ret;
+
 	/*
 	 * dmar_alloc_hwirq() may be called before setup_IO_APIC(), so use
 	 * gsi_top if ioapic_dynirq_base hasn't been initialized yet.
 	 */
-	if (!ioapic_initialized)
-		return gsi_top;
+	ret = ioapic_dynirq_base ? : gsi_top;
+
 	/*
-	 * For DT enabled machines ioapic_dynirq_base is irrelevant and not
-	 * updated. So simply return @from if ioapic_dynirq_base == 0.
+	 * For DT enabled machines ioapic_dynirq_base is irrelevant and
+	 * always 0. gsi_top can be 0 if there is no IO/APIC registered.
+	 * 0 is an invalid interrupt number for dynamic allocations. Return
+	 * @from instead.
 	 */
-	return ioapic_dynirq_base ? : from;
+	return ret ? : from;
 }
 
 #ifdef CONFIG_X86_32
-- 
2.39.2



