Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014982D6E64;
	Wed, 23 Sep 2026 14:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172771; cv=none; b=qKxLkvDvam3IWrRrVsqw2NjIDxt7/tfgyhitgXVZF/XZTSNK5jUESh0eu5ki3plBxpWLtNSl1TMpbA9u5iOge6w9GMntVfcHXru/25GpffBCqTIOUZQ5tJAfPSAsnlCcDkadN+vjDZ4vyV4vTgpZ7AxOQKG3kkRchLu+64vIjLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172771; c=relaxed/simple;
	bh=nY6+yUnBMLqyIZSjUXGZcB3ptFTl1DQYCEaKUYuuzlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqbLKhjgkjSYPXfiE/15XYRJrsMpogA3yEVKqRnUSWEiEO0xfl6MhUYIVONH3Uqp0q9RphNvWa1mXNpkMwgwP+dfGrX8Y272g/ltZ/5r5/QndW/qdzfz0wP5OumviOiwp7cXZkMkgjcrqL0jiNySzit8qSygoy5U8ko9HcuAVbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0/grZ7C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0/grZ7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2B81F000FF;
	Wed, 23 Sep 2026 14:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172769;
	bh=CswqvaRThtH8BiEUjSR0bxgIMY+PqMUZyvA0eKmRh38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O0/grZ7C2hhtew4kZ+kBh2EjzTq30tEu8pbhi+umwRJwdcHZCnYeHjW03xJEvYc5l
	 MznC89XjZlzScRieZV+bYa4fdwhUhBKF+s2JplcQJKzUltFq3kG+H13MadpY4B+bpf
	 yOfyRnqZjETjvjwX7JtzdaKlsgGUIo4uBT1d4C7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Julian Braha <julianbraha@gmail.com>,
	Caleb James DeLisle <cjd@cjdns.fr>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 057/438] mips: econet: fix unmet dependencies for ECONET
Date: Wed, 23 Sep 2026 16:01:18 +0200
Message-ID: <20260923140646.264884974@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Braha <julianbraha@gmail.com>

[ Upstream commit fb5a08026a68be0ec5f660588311fb1091bf5d58 ]

ECONET selects EARLY_PRINTK_8250, SERIAL_OF_PLATFORM, and SERIAL_8250
without ensuring their dependencies, EARLY_PRINTK and TTY are met. This
causes unmet dependencies:

WARNING: unmet direct dependencies detected for SERIAL_8250
  Depends on [n]: TTY [=n] && HAS_IOMEM [=y] && !S390
  Selected by [y]:
  - ECONET [=y]

WARNING: unmet direct dependencies detected for EARLY_PRINTK_8250
  Depends on [n]: EARLY_PRINTK [=n] && USE_GENERIC_EARLY_PRINTK_8250 [=y]
  Selected by [y]:
  - ECONET [=y]

WARNING: unmet direct dependencies detected for SERIAL_OF_PLATFORM
  Depends on [n]: TTY [=n] && HAS_IOMEM [=y] && SERIAL_8250 [=y] && OF [=y]
  Selected by [y]:
  - ECONET [=y]

However, in the discussion of v1 of this patch, Arnd pointed out that these
selects don't belong here in the first place. [1]
Let's remove them to resolve the unmet dependencies.

These unmet dependencies were found by kconfirm, a static analysis tool for
Kconfig.

Fixes: 79ee1d20e37c ("mips: econet: Fix incorrect Kconfig dependencies")
Fixes: 35fb26f94dfa ("mips: Add EcoNet MIPS platform support")
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Julian Braha <julianbraha@gmail.com>
Tested-by: Caleb James DeLisle <cjd@cjdns.fr>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 8555bbf47c633..4a1e665bf012a 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -397,10 +397,7 @@ config ECONET
 	select BOOT_RAW
 	select CPU_BIG_ENDIAN
 	select DEBUG_ZBOOT if DEBUG_KERNEL
-	select EARLY_PRINTK_8250
 	select ECONET_EN751221_TIMER
-	select SERIAL_8250
-	select SERIAL_OF_PLATFORM
 	select SYS_SUPPORTS_BIG_ENDIAN
 	select SYS_HAS_CPU_MIPS32_R1
 	select SYS_HAS_CPU_MIPS32_R2
-- 
2.53.0



