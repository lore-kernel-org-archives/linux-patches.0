Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F6D1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:25:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A81C433C7;
	Mon, 11 Sep 2023 14:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442322;
	bh=t+/xVJTAEz+ptlDSXtEKd3GX3L/qMq8VzkN64hMidhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lt78wftRD8wRJS7x1uXDf7YjXLJUdWnBtqS8GsK3/Y7JIL6iRlgHC27TgqLrp0eIj
	 +QE49E6BJrbez5pMMKw2xrzqOM5JgnraEQaeOa+O1ZJwQRIWizWU+VZZ+6JFw/i7XM
	 oIGTTosjfT1E2qQkykW9C9ZkqG/twI55HmwXpHz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH 6.5 724/739] x86/smp: Dont send INIT to non-present and non-booted CPUs
Date: Mon, 11 Sep 2023 15:48:43 +0200
Message-ID: <20230911134711.300738950@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

commit 3f874c9b2aae8e30463efc1872bea4baa9ed25dc upstream.

Vasant reported that kexec() can hang or reset the machine when it tries to
park CPUs via INIT. This happens when the kernel is using extended APIC,
but the present mask has APIC IDs >= 0x100 enumerated.

As extended APIC can only handle 8 bit of APIC ID sending INIT to APIC ID
0x100 sends INIT to APIC ID 0x0. That's the boot CPU which is special on
x86 and INIT causes the system to hang or resets the machine.

Prevent this by sending INIT only to those CPUs which have been booted
once.

Fixes: 45e34c8af58f ("x86/smp: Put CPUs into INIT on shutdown if possible")
Reported-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Vasant Hegde <vasant.hegde@amd.com>
Link: https://lore.kernel.org/r/87cyzwjbff.ffs@tglx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/smpboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1356,7 +1356,7 @@ bool smp_park_other_cpus_in_init(void)
 	if (this_cpu)
 		return false;
 
-	for_each_present_cpu(cpu) {
+	for_each_cpu_and(cpu, &cpus_booted_once_mask, cpu_present_mask) {
 		if (cpu == this_cpu)
 			continue;
 		apicid = apic->cpu_present_to_apicid(cpu);


