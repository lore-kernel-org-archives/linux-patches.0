Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC85446F4B9;
	Tue, 21 Jul 2026 19:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660582; cv=none; b=MDzUB5eAHtvDxwkcElWn7HNFhPzvT9KO9DeODzKBM0tVRSIqdAI6yeD3kA6fP34UZSkx1wFBvcOBJ0I6sLbxK9PVy0lv+kHWqOl1AW0kNakScOYWCDePsHgG43mqa0G60/4lpCtfWAMR13cjhB0egPJL9iwafDmLdFp/IzrYkaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660582; c=relaxed/simple;
	bh=/aYd8O0nFTShNLZm/6jctUVO+FhHNIRQv56/J/2pwUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=geHTYmQU9BuqbMe4BsEmWEqzKifdm9e/cxFrtrgNw0nlTIuTWUpQwIsJkBMjkO9CtAHVeHo0mV7LSWky6DaqXucdkvITNHzE629dsPkDPLeNwKcqARzYatqT7zZPUT9EUeTVL6tBG2F61ZoumerJRZhAyUUHj6oi/32PnFLjXT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qnD80uoR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qnD80uoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951B41F00A3A;
	Tue, 21 Jul 2026 19:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660579;
	bh=kCsrA8rNk/4hvYN4qYVgOPCe5bsEJAEWoubDGkiDG/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qnD80uoRE0TQdvEmKRYKiwqeauKur6sjxZWpiHLS3yxjpE7OWWKL8KoJpMtktBDQh
	 F4eOm7bcdwveqq//cN1sOEWm9NlR1HVRaqnosBlLgg/O6vitZ8jnK4wDF/2nQAXwnz
	 vHLsMHlMTG4pI4leH+7YEjH23/7Zhm2XLQ9O/+fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1033/2077] sparc: Avoid -Wunused-but-set-parameter in clear_user_page()
Date: Tue, 21 Jul 2026 17:11:46 +0200
Message-ID: <20260721152617.179670636@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 9bc0bd9617964804dc02e6ee2413af42c4a50d6b ]

The loop in clear_user_pages() iterates over all pages and calls
clear_user_page() for each of them. During the loop "vaddr" is modified.
However on sparc clear_user() is a macro which does not use "vaddr".
The compiler sees a variable which is modified but never used and emits
a warning for that:

	include/linux/highmem.h: In function 'clear_user_pages':
	include/linux/highmem.h:234:63: warning: parameter 'vaddr' set but not used [-Wunused-but-set-parameter=]
		static inline void clear_user_pages(void *addr, unsigned long vaddr,

Other architectures use an inline function for clear_user_page() which
avoids the warning. This is not possible on sparc, as
sparc_flush_page_to_ram() is not yet declared where clear_user_page() is
defined. Including cacheflush_32.h will trigger recursive and lots of
other issues.

So hide the warning with a cast to (void) instead.

While we are here, do the same for copy_user_page().

Fixes: 62a9f5a85b98 ("mm: introduce clear_pages() and clear_user_pages()")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/include/asm/page_32.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sparc/include/asm/page_32.h b/arch/sparc/include/asm/page_32.h
index c1bccbedf567ec..9f0b54f709088f 100644
--- a/arch/sparc/include/asm/page_32.h
+++ b/arch/sparc/include/asm/page_32.h
@@ -20,10 +20,12 @@
 #define clear_user_page(addr, vaddr, page)	\
 	do { 	clear_page(addr);		\
 		sparc_flush_page_to_ram(page);	\
+		(void)(vaddr);			\
 	} while (0)
 #define copy_user_page(to, from, vaddr, page)	\
 	do {	copy_page(to, from);		\
 		sparc_flush_page_to_ram(page);	\
+		(void)(vaddr);			\
 	} while (0)
 
 /* The following structure is used to hold the physical
-- 
2.53.0



