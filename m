Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F5A134A5
	for <patches@lists.linux.dev>; Thu, 29 Jun 2023 18:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE138C433CA;
	Thu, 29 Jun 2023 18:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688064427;
	bh=nWgWPGv8CBwLY98GMC+Y6sSczCH5PlqgIQz6Ff4XSPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ys6N7kbObyNWVxIe86fycFNOK4dvXRVIFD12QhRWLs+D3O/efw4h3jdGiaGrU4ceb
	 hc5HwZ6vMo87083EgB91GOYyqNRhLzx6WdBbx9plnrRw10h/GxTe6NcsP6O8dpN9Os
	 uQomjNzhaL++a2Xh1y44XVNDeC8nS8gCUQwkMnFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.3 06/29] x86/smp: Remove pointless wmb()s from native_stop_other_cpus()
Date: Thu, 29 Jun 2023 20:43:36 +0200
Message-ID: <20230629184152.003115510@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230629184151.705870770@linuxfoundation.org>
References: <20230629184151.705870770@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Gleixner <tglx@linutronix.de>

commit 2affa6d6db28855e6340b060b809c23477aa546e upstream.

The wmb()s before sending the IPIs are not synchronizing anything.

If at all then the apic IPI functions have to provide or act as appropriate
barriers.

Remove these cargo cult barriers which have no explanation of what they are
synchronizing.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230615193330.378358382@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/smp.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -184,9 +184,6 @@ static void native_stop_other_cpus(int w
 	cpumask_clear_cpu(cpu, &cpus_stop_mask);
 
 	if (!cpumask_empty(&cpus_stop_mask)) {
-		/* sync above data before sending IRQ */
-		wmb();
-
 		apic_send_IPI_allbutself(REBOOT_VECTOR);
 
 		/*
@@ -208,9 +205,6 @@ static void native_stop_other_cpus(int w
 		 * CPUs to stop.
 		 */
 		if (!smp_no_nmi_ipi && !register_stop_handler()) {
-			/* Sync above data before sending IRQ */
-			wmb();
-
 			pr_emerg("Shutting down cpus with NMI\n");
 
 			for_each_cpu(cpu, &cpus_stop_mask)


