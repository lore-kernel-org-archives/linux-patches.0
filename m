Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59ED4466B70;
	Tue, 16 Jun 2026 17:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631875; cv=none; b=AJRrn3T5gObM+e03Q1p/EoFcNPD5pzvelZvlO2xQd+4qCJxgTEUBVAfIU/R5Qi+i0Xny5R+ybUj0k8412hVEjLFKxtHVXfyWq6Lnmq7EhaFtGLF+JQf51K1FF2egIGsCMpO4f8fNuaJVG5VT4jSGLVJmq/Y2jGyX77KZ3GrPtTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631875; c=relaxed/simple;
	bh=0Ov/ZaitxeYxL/Ijaaa+rKbeOVxgPrY54CCO1vzPpLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmC04cL3GOvFRtMZ0tQUxMrYNeX3FOsErn6PoXnmxd6HKLnpOVnvQVOyr0jAyS3Phw7a12GJV27G7IR5fL9b389JtGnCz6Ng72J5VvPvvxrwQXup4ySEyGudpAGn2luYhO02/c7LNQDxf2ct/KmAKlRDMwnH08LakTiRqinwpQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zelujaXW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zelujaXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607791F000E9;
	Tue, 16 Jun 2026 17:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631874;
	bh=ub9oCk+ueGXnsqcazqnjel3bRtnMb6TxaJ+6t9WbPSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zelujaXWp0Uju/4u3xT0Al+Q4swj3jpLfoBNSDFeERlszLPsM//m1ip1uOZMixG1c
	 gZZ4LF+W+Z5AI9bT1GNJ3QlQf3HeIW2M1xkYQs9jsoAIOhE5OYPTQ/c5RFdT+8I3lc
	 hIWyaDgVskMGfAb+wfRwX6HCbE/NGgR78B4Y2AEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.1 284/522] ARM: 9475/1: entry: use byte load for KASAN VMAP stack shadow
Date: Tue, 16 Jun 2026 20:27:11 +0530
Message-ID: <20260616145139.230402799@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -793,7 +793,7 @@ ENTRY(__switch_to)
 	@ are using KASAN
 	mov_l	r2, KASAN_SHADOW_OFFSET
 	add	r2, r2, ip, lsr #KASAN_SHADOW_SCALE_SHIFT
-	ldr	r2, [r2]
+	ldrb	r2, [r2]
 #endif
 #endif
 


