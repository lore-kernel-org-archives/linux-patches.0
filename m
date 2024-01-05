Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37A428DDA;
	Fri,  5 Jan 2024 14:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ViJAVyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D03C433C7;
	Fri,  5 Jan 2024 14:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704465857;
	bh=ZT5HcMLyNihuz8u+qVfZhRGN5j4dHh3SE8Cs7whMEbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ViJAVywpdGUh7rNrP3oABgylcxrn21h5DDqdcfEu7Up8qIAYWfYxMhUIQWwCuNsm
	 akiXdVZTcouSCMuLV4M1HkW6hQMMlcvtx0o1qwLolziR26haXDVr9WRj400g99uJQ0
	 K1TSAEQWPiY27T/7YlsM98Z8DoPILlTdqR8hjlGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	stable@kernel.org
Subject: [PATCH 5.4 41/47] x86/alternatives: Sync core before enabling interrupts
Date: Fri,  5 Jan 2024 15:39:28 +0100
Message-ID: <20240105143817.216157617@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240105143815.541462991@linuxfoundation.org>
References: <20240105143815.541462991@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 3ea1704a92967834bf0e64ca1205db4680d04048 upstream.

text_poke_early() does:

   local_irq_save(flags);
   memcpy(addr, opcode, len);
   local_irq_restore(flags);
   sync_core();

That's not really correct because the synchronization should happen before
interrupts are re-enabled to ensure that a pending interrupt observes the
complete update of the opcodes.

It's not entirely clear whether the interrupt entry provides enough
serialization already, but moving the sync_core() invocation into interrupt
disabled region does no harm and is obviously correct.

Fixes: 6fffacb30349 ("x86/alternatives, jumplabel: Use text_poke_early() before mm_init()")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/ZT6narvE%2BLxX%2B7Be@windriver.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/alternative.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -772,8 +772,8 @@ void __init_or_module text_poke_early(vo
 	} else {
 		local_irq_save(flags);
 		memcpy(addr, opcode, len);
-		local_irq_restore(flags);
 		sync_core();
+		local_irq_restore(flags);
 
 		/*
 		 * Could also do a CLFLUSH here to speed up CPU recovery; but


