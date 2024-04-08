Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669797D06E;
	Mon,  8 Apr 2024 13:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582495; cv=none; b=PlcPe/d5X190w3h7Ao0Y3VaHIXTzkxj1UWQyY+lFcGr3lEYZHITfKPtFl8DGpF1C6zE4Wkn9SK+D9cAQjcYcNLZrNc0iWs5UIB13622yb9WbcbLDVknedf76gfvvCQZRrz0eICug4/6doqbq2EaubkLK/7Noevbp61WUNwbbO8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582495; c=relaxed/simple;
	bh=hpzS3z/rs1c2Xfcb4ZpnLI9k4ARl/IrSj21qmoNMdac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+MXeKvSrC+jH0Q9IRe2cWusExA+qi2no5daJDdlxYFTDLk0FB4SEo4Y4aOC3/a4joMZacvwchRtdxhMsRSOO9aBiiGgaoHnY2LImmYIcfOO66FkX67vhaZzwWgXut8qCFPhmRes96NpPBVAALWYIHXf8TRwi/dD6yw8AGkTRL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MP1Zn1Hh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MP1Zn1Hh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DAF2C433F1;
	Mon,  8 Apr 2024 13:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582494;
	bh=hpzS3z/rs1c2Xfcb4ZpnLI9k4ARl/IrSj21qmoNMdac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MP1Zn1Hh/bvy5NG1zwezKFxpHCKLdgYGffHOetKfoIMr3BHxnialtUWDqfSk0MrCW
	 /Nlfj0gFZD6Z9+xtHoEoz3lltjdQ+VPKLG1g9aZnNZdRcJ+pDcJEYqonuS1icOUolw
	 wlryUk/XQgZtp71wxtOrGi5XXRPBFEfEUTk+dVcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"H. Peter Anvin (Intel)" <hpa@zytor.com>,
	Borislav Petkov <bp@suse.de>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 5.15 150/690] x86/asm: Add _ASM_RIP() macro for x86-64 (%rip) suffix
Date: Mon,  8 Apr 2024 14:50:16 +0200
Message-ID: <20240408125404.956618983@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

commit f87bc8dc7a7c438c70f97b4e51c76a183313272e upstream.

Add a macro _ASM_RIP() to add a (%rip) suffix on 64 bits only. This is
useful for immediate memory references where one doesn't want gcc
to possibly use a register indirection as it may in the case of an "m"
constraint.

  [ pawan: resolved merged conflict for __ASM_REGPFX ]

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Link: https://lkml.kernel.org/r/20210910195910.2542662-3-hpa@zytor.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/asm.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -6,11 +6,13 @@
 # define __ASM_FORM(x, ...)		x,## __VA_ARGS__
 # define __ASM_FORM_RAW(x, ...)		x,## __VA_ARGS__
 # define __ASM_FORM_COMMA(x, ...)	x,## __VA_ARGS__,
+# define __ASM_REGPFX			%
 #else
 #include <linux/stringify.h>
 # define __ASM_FORM(x, ...)		" " __stringify(x,##__VA_ARGS__) " "
 # define __ASM_FORM_RAW(x, ...)		    __stringify(x,##__VA_ARGS__)
 # define __ASM_FORM_COMMA(x, ...)	" " __stringify(x,##__VA_ARGS__) ","
+# define __ASM_REGPFX			%%
 #endif
 
 #define _ASM_BYTES(x, ...)	__ASM_FORM(.byte x,##__VA_ARGS__ ;)
@@ -49,6 +51,9 @@
 #define _ASM_SI		__ASM_REG(si)
 #define _ASM_DI		__ASM_REG(di)
 
+/* Adds a (%rip) suffix on 64 bits only; for immediate memory references */
+#define _ASM_RIP(x)	__ASM_SEL_RAW(x, x (__ASM_REGPFX rip))
+
 #ifndef __x86_64__
 /* 32 bit */
 


