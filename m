Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063486;
	b=VqbI6BSGjLpV9Z2zTkI5WF/eUQ4VwGq9XUX395S8RZXeBxNfmqQRUjr7nu1UwbrB5JG6
	 vMa/YLh6yHbhYbucq7Oc6uIj5f5JPc3RSia269gkYPTP9q6mIL7phCievB9MEIfh0VObt
	 zJKpVuvuPucBZWiq4AoJAcd130gHvZTM0NPcbTxJxVqLaELxPAQcClVcY5sg9tkIA3CkY
	 Wboqs57aHkEexhTumkjxr1EVbiNnj2fRup2mfkzHv9N6IVUK0auDIa4O02g/XQPloQQ/6
	 xhaP6CYK4S/16JpdpdHYlzZrehJJ5dTAae4UP+oa8VWyh74s+lnldWiRdE17XRU8W1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g6LEm15Hai7UVRIwRzAUpAE/jPH5RU8uN9fV6yaGwd8=;
	b=oyh1jW+qjLDgwGeYTtQiTwUt9APGGR/ykgWqkBMeyFTAWgqlhGx7YLzTYBV7WQjSVzRt
	 TwvXZucjAx29snHGlmz04xxt8b8NINhQHJFQ/KRFDubgn35xANEQ2e7tOhYXT7m3uBjGV
	 v1cxdeTXx5DZaDwZ46vsgj/5WpdT/xO+c/1HpkTWNql8RnrcUomWd9djhOrIbch9VfOEn
	 TbalrXLHfnoLqnGsVvagFoFtkdITXFOKuAvIcn0cRY8/deco7ECZtzBDLDP8Iendj7nph
	 RECGtJZ6KKCDGFT1Gh8ZFaszRxjFeIDHGiUQ3cNHrnuKiiwjdoWlaGma+eJFo/x7sVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cISzWovo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37CD606A9EF;
	Sat,  7 Nov 2026 14:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cISzWovo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9AD1F008A3;
	Sat,  7 Nov 2026 14:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063485;
	bh=g6LEm15Hai7UVRIwRzAUpAE/jPH5RU8uN9fV6yaGwd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cISzWovoWYFPRc8LHDubXiWWGz/E2LoNeYyjnhJiCRvnx2fqulQB9cttme+EjRNyd
	 oQXPWvM48l2/a5ncePSex/nRy0RL4r3lP5MY0ZJUNUhevOl7AbfQldXJdlhYANW98g
	 eF5r7npSs156iRCtdZ1gkQCmhDt/c7CxlGSri+1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 632/869] alpha: invalidate the local context in flush_icache_user_page()
Date: Sat,  7 Nov 2026 08:55:14 -0500
Message-ID: <20261107134914.397381124@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 988e397b0b8a7..e21bc3920bece 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -758,6 +758,9 @@ flush_icache_user_page(struct vm_area_struct *vma, struct page *page,
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



