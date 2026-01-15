Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC62F27BF7D;
	Thu, 15 Jan 2026 18:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500003; cv=none; b=jELyrflErsDozq3Nb8vDYVEeSfd5l9NRkkUmheXy4Dj+2ZDn48pPFUyX+DQ17QO9VE8F2U6wRwBzUHbtvJWQhlxaCInFwu2i8YRqJiHMTLAnWvlevAUrmqbvBh8AULAmye3SZXcUR3S+L/KU16YBFGvXlK5cmINzWALZ430+o7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500003; c=relaxed/simple;
	bh=TcTzYXqbkx+9VbHY6AuL/3tTjQTRPPRzUjd/0korILk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoKUA/s4YFQd/2fK9lSw38snFvZqWJZ9sfqlK2kChfzFFLJYvrkvJFQ7BWmRxfvn7Khb1ZkumY20tZl2t7HoZ/vF7WQPdobbBDzpNW3wCd5Yk+Jtu+JjZ7VZ+eSYb63Qscyz1U9muPsxxZqf/3BJ1u7fKQlIDGhPiEOeuHmxMog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGYEnJ7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGYEnJ7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B50C116D0;
	Thu, 15 Jan 2026 18:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768500003;
	bh=TcTzYXqbkx+9VbHY6AuL/3tTjQTRPPRzUjd/0korILk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGYEnJ7sSQ2QnivApRcLOACmbdp0p/+2OseKfwFGb/IH4XRC7fEGB9lOWG6wOmOkV
	 6SV4BAPVnGqf/bkRND22uMuFXwL7sbHkad8tR44P3paBcxybqlGW9c7AhZ4svfKdyG
	 Fujj5B07g3GM0I8aEaxawyfU2D6FNOGIK+uqPfWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 425/451] ARM: 9461/1: Disable HIGHPTE on PREEMPT_RT kernels
Date: Thu, 15 Jan 2026 17:50:26 +0100
Message-ID: <20260115164246.315471781@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit fedadc4137234c3d00c4785eeed3e747fe9036ae ]

gup_pgd_range() is invoked with disabled interrupts and invokes
__kmap_local_page_prot() via pte_offset_map(), gup_p4d_range().
With HIGHPTE enabled, __kmap_local_page_prot() invokes kmap_high_get()
which uses a spinlock_t via lock_kmap_any(). This leads to an
sleeping-while-atomic error on PREEMPT_RT because spinlock_t becomes a
sleeping lock and must not be acquired in atomic context.

The loop in map_new_virtual() uses wait_queue_head_t for wake up which
also is using a spinlock_t.

Since HIGHPTE is rarely needed at all, turn it off for PREEMPT_RT
to allow the use of get_user_pages_fast().

[arnd: rework patch to turn off HIGHPTE instead of HAVE_PAST_GUP]

Co-developed-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 335308aff6ce0..05fc9c6ee8c5b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1513,7 +1513,7 @@ config HIGHMEM
 
 config HIGHPTE
 	bool "Allocate 2nd-level pagetables from highmem" if EXPERT
-	depends on HIGHMEM
+	depends on HIGHMEM && !PREEMPT_RT
 	default y
 	help
 	  The VM uses one page of physical memory for each page table.
-- 
2.51.0



