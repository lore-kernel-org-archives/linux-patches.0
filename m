Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286B622D9F7;
	Thu, 15 Jan 2026 17:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498682; cv=none; b=IEHami5gvXjDFv/UsP+kS2Nhy10TpnQKEQ0LQFqsGainh5u5EZhK4EYatlBi1uWB2tIPAWGkTKtbyjq4W5IwJ4YaULej/vKwyYHanbwb45IouOq7FA5vucjALugvrjuX+4q9wUY2kycckdzgvvhjbEDqluh3ZZuVbm3YWto/Jsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498682; c=relaxed/simple;
	bh=sfh73MwTubifGp0qjps2S7Y7NUbKrE+7vjJqtgYTDJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUcvb1cozwi0WYduTGqaw3+FiPhYKgUiCSfdk2pmUiWEEox91J278ZUOSeyAk1XRsMA9MK5vRWrg2YmAARYUUaO1E7tm2MN2PsUGYhxK50SZRfgim6O5poh1DVqY+l9t5sNqbJKOdFuN/fLCE/0dQWZ10dbZgaEj/5BSVZu4Iug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hcaq3HUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hcaq3HUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FAEC116D0;
	Thu, 15 Jan 2026 17:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498682;
	bh=sfh73MwTubifGp0qjps2S7Y7NUbKrE+7vjJqtgYTDJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hcaq3HUPnxWDgPqGtcKWn6NtxiUyr3Uiuj3X1g1Zxl75+RieywWf8fCl2BWFZx2q/
	 hyg1G4Hq9cZW+m3dTccObm2bVy4Ra1UvdMh27epOdN/yVCclQz4dKvX0Vk+dJYTU2Q
	 v7F2tIJnwg/dsxtfSbqXo2r2SyeGVENikcJmj+cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 517/554] ARM: 9461/1: Disable HIGHPTE on PREEMPT_RT kernels
Date: Thu, 15 Jan 2026 17:49:43 +0100
Message-ID: <20260115164305.040655808@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f2fbb170d813c..74357ce8967b4 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1473,7 +1473,7 @@ config HIGHMEM
 
 config HIGHPTE
 	bool "Allocate 2nd-level pagetables from highmem" if EXPERT
-	depends on HIGHMEM
+	depends on HIGHMEM && !PREEMPT_RT
 	default y
 	help
 	  The VM uses one page of physical memory for each page table.
-- 
2.51.0



