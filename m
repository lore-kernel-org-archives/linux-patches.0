Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036702;
	b=eUGtCAL6PUyTxgOfv0sg4Ki/CxKpH2CiXM6p7EScFBAn0Hmz4tGm+NhEOAKBEncGFkxS
	 9Q4OxohBEz2/mos8pd/XvvyW7hOIBmGRlaKGGbYn01vsHz42GnE0929MVJVp3sR7JRV1c
	 C1AAQdJMKAb2i0PMLvTdm4y2OuQclQmZ4fhb5y5qyqKyJhrAKQDo9Rca9lZXk9b6LI1Or
	 eM6CWAsXtqmToKAO6x3ZLPcOowyHFizhGIlv9SiOXR2lh7n3leYC2YDhAqkicBGjpzAcV
	 HJw7YfbbWX5EvGNumIeR6K2lKonENnw7MvPR8c3/h3ryCofow1WEAWN8ExrsL4aOeJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036702;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6aI39wSlzW6E6I5S5EdbS4o4y4CgCkujt34YE46DCR8=;
	b=v9Vo/Rt4f8r5hRLSoXuXxJdjKyNYeS/8kaCriodBDjUbrOHYf6XBnaUl/JyNv9logpFz
	 GN0OB9BcTCifiXoX7vKCzhgB1ANbQYwF1QEHePSmsLY3eDU2R8ZRh5hu3kY3dZpQMWwqy
	 w4puUzAb/NxAmLztTLWDq6Sbn3l1bea5FCpM6BDiQMVpQRhphCWkWbdeg9kG+FAWL5sS1
	 K1XauZ4Titu15mYaV4PIsnrRR41czqIxgsdWMiuaRacxp12r4N0dBl3b7/9Z2WHXX3eHU
	 aOjLf9VfqMHFiZq/CWHF7vLZbASCkd9bsJ6B+tsXF1SmRUpUzYkgiF4boOcTEoeXBFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZMKY4woo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A7C606A320;
	Wed, 18 Nov 2026 21:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZMKY4woo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5191F000C4;
	Wed, 18 Nov 2026 21:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036702;
	bh=6aI39wSlzW6E6I5S5EdbS4o4y4CgCkujt34YE46DCR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZMKY4wooeACfSY+rV4WsGlPcCZWxXEK4M/GkWZuBRYFMttuOPUFydD2AMAnMcDb0a
	 rRXb8fOdKzfFiUHhlUD//DCJcQ4eNqhDiQKrZD2SBMMhW7WmSHLTytFxPJkJfxyV1U
	 c3J1Icz+9IAIqgVOTPnwl6PE1jo2/ZMHZVWg6Izk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1152/3318] alpha: invalidate the local context in flush_icache_user_page()
Date: Wed, 18 Nov 2026 15:29:34 +0100
Message-ID: <20261118150354.654214629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit 4244c555ac440a445cc168f860b2677099d761f9 ]

flush_icache_user_page() has the same caller-CPU omission that the
previous patch fixed in flush_tlb_mm(): when the target mm is not the
calling CPU's active_mm nothing happens locally, and smp_call_function()
handles only the other CPUs, so this CPU may later reuse the old ASN
together with the translations it still holds.

This matters here in particular because the function exists for
operating on another process's mappings: the comment above it describes
setting breakpoints through ptrace, and access_remote_vm() reaches it
through copy_to_user_page(). The calling CPU is therefore often running
something other than the target mm.

As in flush_tlb_mm(), the uniprocessor implementation in
asm/cacheflush.h already has the missing case.

No imb() is needed, here or in ipi_flush_icache_page(). Alpha's
user-space I-cache flush works by allocating a new ASN rather than by
invalidating the I-cache: the entries stay, but they are tagged with the
old ASN and can no longer match. An imb() is only required when the ASN
space wraps and numbers are reused, and __get_new_mm_context() already
does one in that case.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010142533.974797-9-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/smp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 354a188fc2770..42c33f6ca514d 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -762,6 +762,9 @@ flush_icache_user_page(struct vm_area_struct *vma, struct page *page,
 			preempt_enable();
 			return;
 		}
+	} else {
+		/* smp_call_function() does not call back into this CPU.  */
+		flush_tlb_other(mm);
 	}
 
 	smp_call_function(ipi_flush_icache_page, mm, 1);
-- 
2.53.0



