Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF873BB9F4;
	Thu, 15 Jan 2026 17:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496827; cv=none; b=cguSiwE+pzor4yu9u34EP6FirbnWdmWWQZ4cgw0RGu9Az9Yxl1L4z9jl7WRiF3ByVfy1ZSKgQWXF8Z5f7DD/xzJzzpJ6Gx6HxCn17DXDh80BAk2MVKkWyHpSQ9HYvxuOfG223Kj5RXNNx3+75lGYm2X2mpnUndNc8MJUdO44LrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496827; c=relaxed/simple;
	bh=/RwHM9lte/Xjb3olM7Mn8JMfa0B3h6VDLg7KM/fMIIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NgwgH4DCncVdyvmvvenhaUdEvx9WvgLfhwkbOjwrBOkaMNQ+wfQKAfw3yVKLBsdjr9dGB5uXi+ZG8XYhm7hGXosx8K0D0csDRg9g7mISN667eUCV6RxqxFsQWQsTCchu4n2YD8wzvNbLSOOwNHAbTgOd1Gt17haktWnK8WH6tcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvfEHrkD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvfEHrkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8D6C116D0;
	Thu, 15 Jan 2026 17:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496827;
	bh=/RwHM9lte/Xjb3olM7Mn8JMfa0B3h6VDLg7KM/fMIIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvfEHrkDYqbVWZtW6KnySZCMOtfNSv2KOkxxAh/8ZLUqp7Q1CaQxyhrTimVTokzq4
	 bo3m/2Co8wH8LbUatodKGUpTltGtCdTpD2a29JRQ4WPcPGwz0I2VAdCKPQuvmASWQ2
	 s/E8Jtu7VepPtW4lqfeDyJ//jZLsTDiODDLwxWoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 29/88] ARM: 9461/1: Disable HIGHPTE on PREEMPT_RT kernels
Date: Thu, 15 Jan 2026 17:48:12 +0100
Message-ID: <20260115164147.367851909@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 57c0448d017a1..be3b0f83eee57 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1308,7 +1308,7 @@ config HIGHMEM
 
 config HIGHPTE
 	bool "Allocate 2nd-level pagetables from highmem" if EXPERT
-	depends on HIGHMEM
+	depends on HIGHMEM && !PREEMPT_RT
 	default y
 	help
 	  The VM uses one page of physical memory for each page table.
-- 
2.51.0



