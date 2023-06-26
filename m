Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CDF134CE
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D08C433C8;
	Mon, 26 Jun 2023 18:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803972;
	bh=sPLT7ECfxhFm2I/VJRs5KNOFWnQEE5rL1s88HmZWCpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=adTKGMET8K+np4EtaBnmGlYACajdI/SvMJ69BCwaNJizsoyxTI2pUbJ+13jnasMXB
	 jwdZfUaosF71RXjig2m6ycaMVK3UoYe8GNlyxPMoX8y6Zg3UbedMV5Iq06WVmA1cdW
	 YS2oEol7kk8++0oUdKfEEw/uXT2ZT05ATMCI2WRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Kishon Vijay Abraham I <kvijayab@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 40/41] x86/apic: Fix kernel panic when booting with intremap=off and x2apic_phys
Date: Mon, 26 Jun 2023 20:12:03 +0200
Message-ID: <20230626180737.753414340@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180736.243379844@linuxfoundation.org>
References: <20230626180736.243379844@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>

[ Upstream commit 85d38d5810e285d5aec7fb5283107d1da70c12a9 ]

When booting with "intremap=off" and "x2apic_phys" on the kernel command
line, the physical x2APIC driver ends up being used even when x2APIC
mode is disabled ("intremap=off" disables x2APIC mode). This happens
because the first compound condition check in x2apic_phys_probe() is
false due to x2apic_mode == 0 and so the following one returns true
after default_acpi_madt_oem_check() having already selected the physical
x2APIC driver.

This results in the following panic:

   kernel BUG at arch/x86/kernel/apic/io_apic.c:2409!
   invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
   CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.4.0-rc2-ver4.1rc2 #2
   Hardware name: Dell Inc. PowerEdge R6515/07PXPY, BIOS 2.3.6 07/06/2021
   RIP: 0010:setup_IO_APIC+0x9c/0xaf0
   Call Trace:
    <TASK>
    ? native_read_msr
    apic_intr_mode_init
    x86_late_time_init
    start_kernel
    x86_64_start_reservations
    x86_64_start_kernel
    secondary_startup_64_no_verify
    </TASK>

which is:

setup_IO_APIC:
  apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
  for_each_ioapic(ioapic)
  	BUG_ON(mp_irqdomain_create(ioapic));

Return 0 to denote that x2APIC has not been enabled when probing the
physical x2APIC driver.

  [ bp: Massage commit message heavily. ]

Fixes: 9ebd680bd029 ("x86, apic: Use probe routines to simplify apic selection")
Signed-off-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20230616212236.1389-1-dheerajkumar.srivastava@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/apic/x2apic_phys.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 8e70c2ba21b3d..fb17767552ef4 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -102,7 +102,10 @@ static void init_x2apic_ldr(void)
 
 static int x2apic_phys_probe(void)
 {
-	if (x2apic_mode && (x2apic_phys || x2apic_fadt_phys()))
+	if (!x2apic_mode)
+		return 0;
+
+	if (x2apic_phys || x2apic_fadt_phys())
 		return 1;
 
 	return apic == &apic_x2apic_phys;
-- 
2.39.2



