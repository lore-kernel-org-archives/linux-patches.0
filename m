Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174CA4F218;
	Thu, 12 Dec 2024 16:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020495; cv=none; b=oQOb0bkVRtu/BF2oX6sgLrWDzGqFVqxzhwxsZA4G3RoH5ZiXjw+uBx3OXUKs93BY16ZwmAQBmoP8S/yKNFbuOhbnEoF/GAoPxqUk0ULOM31pbBpLGMqpcMY3esV1qRIghf15qOt5UutZ0nP+BDk5qOTk/oZ8qvKehyQKpovnvdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020495; c=relaxed/simple;
	bh=yd+thalTRgK4Jh09fgf5sXg2XyD4G98MiV9Xqsx82Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cn7XbwjDkK7ZcSz8trxshYVgNajmh4bkEFzFM3JqEqC0hrE1sR+KhBkOukyEWMc9ZGrxR8hKV3dGgEhHe0D8Zctijb1sH3LTL1PpcFDnHEG0CDVguo3LvpyEc7tjosDVRRujP9dvOA53IyTDsMxMwko8FJk+o1t1F+nFuE5CiGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oZtN2r/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oZtN2r/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597B9C4CECE;
	Thu, 12 Dec 2024 16:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020494;
	bh=yd+thalTRgK4Jh09fgf5sXg2XyD4G98MiV9Xqsx82Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oZtN2r/oBCfGegWoIV57nhIhFWCBFYKH8Gckq39971qg9H3uVk6gSLOU8J0eNk8Tr
	 cBhvzBXXcZ5g1FvhANnqFS8ZYWbjc6CKf7lR7glUz38h2fl2SoPmle1Ni5xIHI+GE8
	 yYcdgufizgdUTypS/U+H7eTPoj0dxyd1R7qiGMmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clement LE GOFFIC <clement.legoffic@foss.st.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.1 481/772] ARM: 9430/1: entry: Do a dummy read from VMAP shadow
Date: Thu, 12 Dec 2024 15:57:06 +0100
Message-ID: <20241212144409.810872514@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit 44e9a3bb76e5f2eecd374c8176b2c5163c8bb2e2 upstream.

When switching task, in addition to a dummy read from the new
VMAP stack, also do a dummy read from the VMAP stack's
corresponding KASAN shadow memory to sync things up in
the new MM context.

Cc: stable@vger.kernel.org
Fixes: a1c510d0adc6 ("ARM: implement support for vmap'ed stacks")
Link: https://lore.kernel.org/linux-arm-kernel/a1a1d062-f3a2-4d05-9836-3b098de9db6d@foss.st.com/
Reported-by: Clement LE GOFFIC <clement.legoffic@foss.st.com>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/kernel/entry-armv.S |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -25,6 +25,7 @@
 #include <asm/tls.h>
 #include <asm/system_info.h>
 #include <asm/uaccess-asm.h>
+#include <asm/kasan_def.h>
 
 #include "entry-header.S"
 #include <asm/probes.h>
@@ -787,6 +788,13 @@ ENTRY(__switch_to)
 	@ entries covering the vmalloc region.
 	@
 	ldr	r2, [ip]
+#ifdef CONFIG_KASAN_VMALLOC
+	@ Also dummy read from the KASAN shadow memory for the new stack if we
+	@ are using KASAN
+	mov_l	r2, KASAN_SHADOW_OFFSET
+	add	r2, r2, ip, lsr #KASAN_SHADOW_SCALE_SHIFT
+	ldr	r2, [r2]
+#endif
 #endif
 
 	@ When CONFIG_THREAD_INFO_IN_TASK=n, the update of SP itself is what


