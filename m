Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FED14A4F0;
	Fri,  6 Dec 2024 14:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496132; cv=none; b=Lwj1VAFJB3lSVpxlpfwwb+ziJsXfPMOPpggkjzadjq+CfuqfxV9msfSNS65roLMsuOBjGI/XmXy5udwqblZbSHW6GnCTdQXqsahOkopPBPzWDdj94vqZcSt8z+ye3a4UJtrl1TxhcRi86zDJv8hGaUZ6Ijtl7eHehv621gVny8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496132; c=relaxed/simple;
	bh=uRhCvDOP2lxvNHaOL8A6S7dHFfzNA2RhJHFUBEEDhAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhquIYX4UqP001UC7+ZWAM6xRhhlXx9y3H01wrnwxRUYfLkWp3O7QdRIkPNccnW5jSTpe8PqhdzMH8Ta1vIFJs/0QovYjZZ+bLO8O8m6raolQPgcJ7PdTW2o7KNnvT0fgaLmAoP/TaHfMRTPFFnu5b+MUyraKEnzRIgJ711Rn1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0MS6okGs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0MS6okGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF66C4CED1;
	Fri,  6 Dec 2024 14:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496132;
	bh=uRhCvDOP2lxvNHaOL8A6S7dHFfzNA2RhJHFUBEEDhAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0MS6okGsHCi6S8P57puTRu/DUvN+t4W1G0xheOEupwh938rHAeKKAgnrwo3IlxHT4
	 +CFh+7FWi40ClSqFi+1gmVLfggF/6pEmCduRFJr1wR+DqjI5B6qbYL93FB/fZT78EN
	 afUtQVTzF/VQpH6eHzlRpoJjhnsNPAhtSYVz8gPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clement LE GOFFIC <clement.legoffic@foss.st.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.12 061/146] ARM: 9430/1: entry: Do a dummy read from VMAP shadow
Date: Fri,  6 Dec 2024 15:36:32 +0100
Message-ID: <20241206143530.012830841@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -561,6 +562,13 @@ ENTRY(__switch_to)
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


