Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0E59460;
	Mon, 29 Dec 2025 16:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025301; cv=none; b=PAc7yEM4VsxnYzAoXGJyGcp7pq0gqWM/8GSYZ9lKhW6oYbYDQegokWelWpWH2g9cpeqv14vvhLxuMc59Jxo+4eX81YXb+lIQQvJIxd1h8ypEU3Yb/stIV8Ql1WnIygvJ4N0H1EyhBD0TdvvW186zh/m6IZ3BQZvjsBGVhzGvDMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025301; c=relaxed/simple;
	bh=pj1bYdqlP0/Mp/5HunAZXuTxdbeHXvf755cmOuFwu6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bgzy/GhNbXl74p7rRgT0ClT74/bS3f/6jMPtDSIrY+8gTBwX1kHCYi45PtG2aeFYGYHNszqLMJt9m1v8KrNiXVs4QcRdkcAYwvef0EZtze/TqsoShCxcPYTHb/K5IT/ZTwA8ve3sL14dK/LVLL+xf8d8Q20mdJDT3JO121CBPnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bKp9xT3g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bKp9xT3g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4995FC4CEF7;
	Mon, 29 Dec 2025 16:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025301;
	bh=pj1bYdqlP0/Mp/5HunAZXuTxdbeHXvf755cmOuFwu6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bKp9xT3gRU4AgCR7d6xsHzUfFMSiF0WrQxbfVfKQnV3SD+kN9aG87XjMza7TLfPHe
	 fGDixjG+X7ZoJZmXj0RpmxDNTtoaHxbK8AuIjLXxlL+gj0kCg9J0UKYmHii21ufRmd
	 XQjh/Vx23QbZl1u1ohViqtIF1GoOsGKdVBquOlkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Uros Bizjak <ubizjak@gmail.com>,
	stable@kernel.org,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.18 164/430] x86/bug: Fix old GCC compile fails
Date: Mon, 29 Dec 2025 17:09:26 +0100
Message-ID: <20251229160730.398752455@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit c56a12c71ad38f381105f6e5036dede64ad2dfee upstream.

For some mysterious reasons the GCC 8 and 9 preprocessor manages to
sporadically fumble _ASM_BYTES(0x0f, 0x0b):

$ grep ".byte[ ]*0x0f" defconfig-build/drivers/net/wireless/realtek/rtlwifi/base.s
        1:       .byte0x0f,0x0b ;
        1:       .byte 0x0f,0x0b ;

which makes the assembler upset and all that. While there are more
_ASM_BYTES() users (notably the NOP instructions), those don't seem
affected. Therefore replace the offending ASM_UD2 with one using the
ud2 mnemonic.

Reported-by: Jean Delvare <jdelvare@suse.de>
Suggested-by: Uros Bizjak <ubizjak@gmail.com>
Fixes: 85a2d4a890dc ("x86,ibt: Use UDB instead of 0xEA")
Cc: stable@kernel.org
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20251218104659.GT3911114@noisy.programming.kicks-ass.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/bug.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -10,7 +10,7 @@
 /*
  * Despite that some emulators terminate on UD2, we use it for WARN().
  */
-#define ASM_UD2		_ASM_BYTES(0x0f, 0x0b)
+#define ASM_UD2		__ASM_FORM(ud2)
 #define INSN_UD2	0x0b0f
 #define LEN_UD2		2
 


