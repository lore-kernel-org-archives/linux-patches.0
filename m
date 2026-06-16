Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D3046AEDB;
	Tue, 16 Jun 2026 16:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627320; cv=none; b=Wi8/U5+KcMAbViVU5eoqN9QtYokm/eQV3JNrB9gOtpJBpbUPRrrg7s+clAwkvg7gvYtloCV1JYaWFmn6b1Vo5sv206DB5cnB0E9xPwlP7oPT7M9GU1Mp55+UNp4Rs6FkI18V56fEth2Ev3BxhxJWeoVFV9eHQlhJ5fJkxfw5hBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627320; c=relaxed/simple;
	bh=0EDSydluTAoyw72oaag/Y0v3Jv3apo5gIlxH1Sjl7+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQDh8k+kVLv0ZBEfaEUz4UOa/0q0dFC/ixxQt7ws7/XtAnd7Q5wrx5OSVaW6aJ9LhZ3he7b8DPuW/Lgiw+s7KXHKdPXa75bRwuxakqQThpXFdx7mKQexCDBNYH8AoVVn49RZcKn8jXRHqA5p0Aj5nknm9s7L+ihbIh+38bEhhAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sV6nm8K2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sV6nm8K2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B691F000E9;
	Tue, 16 Jun 2026 16:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627319;
	bh=Khyfcu2Ale2x8AoRny7zQa1GX5AdtoMuCppO75Dgfmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sV6nm8K2+ONcGJueqdKaETZuLJWZqtnsidrwNA6a2FOuuIbKVC0ITPjgLbRYWwYj5
	 LRZQVU+LEhI9jQ5+MVThasF7qJrW9VP+Wv5Npx4RYBYV8a6WC2tdWDeBTjIIsRWWHS
	 ABzvuXDSaDF/06F7suOn+MbXGIZYhMA28T3Q/3S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.12 155/261] ARM: 9475/1: entry: use byte load for KASAN VMAP stack shadow
Date: Tue, 16 Jun 2026 20:29:53 +0530
Message-ID: <20260616145052.261066618@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

commit 77a1f6883dc6e837bb2cb30b9b02e2f94338e2c6 upstream.

Commit 44e9a3bb76e5 ("ARM: 9430/1: entry: Do a dummy read from
VMAP shadow") added a dummy read from the KASAN VMAP stack shadow in
__switch_to(). The read uses ldr, but the KASAN shadow address is
byte-granular and is not guaranteed to be word aligned.

ARMv5 faults unaligned word loads. With CONFIG_KASAN_VMALLOC and
CONFIG_VMAP_STACK enabled, ARM926/VersatilePB crashes in __switch_to()
with an alignment exception before reaching init.

Use ldrb for the dummy shadow access. The code only needs to fault in the
shadow mapping if the stack shadow is missing, so a byte load is sufficient
and matches the granularity of KASAN shadow memory.

Fixes: 44e9a3bb76e5 ("ARM: 9430/1: entry: Do a dummy read from VMAP shadow")
Cc: stable@vger.kernel.org # v6.13+
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/kernel/entry-armv.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -567,7 +567,7 @@ ENTRY(__switch_to)
 	@ are using KASAN
 	mov_l	r2, KASAN_SHADOW_OFFSET
 	add	r2, r2, ip, lsr #KASAN_SHADOW_SCALE_SHIFT
-	ldr	r2, [r2]
+	ldrb	r2, [r2]
 #endif
 #endif
 


