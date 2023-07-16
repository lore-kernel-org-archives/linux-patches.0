Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A90D8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:18:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FFBC433C8;
	Sun, 16 Jul 2023 20:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538705;
	bh=RfDKITa1nnaMTcN1oWHI+85uzkvt0OTMZkTTBKyetrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0sXwrhBmNATNKDFV4wvHi/wwjxb4xK2r1Kp8fbB0/AR5yy8xIhZLZP9HGIh404St
	 YjQMfz0yyKHkFqs1yNiAR0IgxQYgl/5T3bqc9GF5pYFnNBAMZN7rXTJfVrPhLzjPGx
	 rnMVfjv4g+n0UPPcLfyfufjVcvt/wTQvK9BHmVuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nikl=C4=81vs=20Ko=C4=BCes=C5=86ikovs?= <pinkflames.linux@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 547/800] x86/efi: Make efi_set_virtual_address_map IBT safe
Date: Sun, 16 Jul 2023 21:46:40 +0200
Message-ID: <20230716195001.797319057@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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

[ Upstream commit 0303c9729afc4094ef53e552b7b8cff7436028d6 ]

Niklāvs reported a boot regression on an Alderlake machine and bisected it
to commit 9df9d2f0471b ("init: Invoke arch_cpu_finalize_init() earlier").

By moving the invocation of arch_cpu_finalize_init() further down he
identified that efi_enter_virtual_mode() is the function which causes the
boot hang.

The main difference of the earlier invocation is that the boot CPU is
already fully initialized and mitigations and alternatives are applied.

But the only really interesting change turned out to be IBT, which is now
enabled before efi_enter_virtual_mode(). "ibt=off" on the kernel command
line cured the problem.

Inspection of the involved calls in efi_enter_virtual_mode() unearthed that
efi_set_virtual_address_map() is the only place in the kernel which invokes
an EFI call without the IBT safe wrapper. This went obviously unnoticed so
far as IBT was enabled later.

Use arch_efi_call_virt() instead of efi_call() to cure that.

Fixes: fe379fa4d199 ("x86/ibt: Disable IBT around firmware")
Fixes: 9df9d2f0471b ("init: Invoke arch_cpu_finalize_init() earlier")
Reported-by: Niklāvs Koļesņikovs <pinkflames.linux@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217602
Link: https://lore.kernel.org/r/87jzvm12q0.ffs@tglx
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/platform/efi/efi_64.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 232acf418cfbe..77f7ac3668cb4 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -853,9 +853,9 @@ efi_set_virtual_address_map(unsigned long memory_map_size,
 
 	/* Disable interrupts around EFI calls: */
 	local_irq_save(flags);
-	status = efi_call(efi.runtime->set_virtual_address_map,
-			  memory_map_size, descriptor_size,
-			  descriptor_version, virtual_map);
+	status = arch_efi_call_virt(efi.runtime, set_virtual_address_map,
+				    memory_map_size, descriptor_size,
+				    descriptor_version, virtual_map);
 	local_irq_restore(flags);
 
 	efi_fpu_end();
-- 
2.39.2



