Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC071A5BA4;
	Tue, 11 Mar 2025 15:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707454; cv=none; b=ODDJZSku3i4vJa+D8oklt/5z4p0/K90gv9BiJA+nti28qP6x03NyPPkHAJ4d/LEhtvkU5uheATEGjV4Lle+XW0WzU4M+NqBvsPj5lrX/P6E8vILoQNQJ+9wF3elgOXEvoio3x+NkgZJSRVo7GoHMW8hOMrNbQYNQsdnywIiffBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707454; c=relaxed/simple;
	bh=ijbP5nrQ+BTtdq6e2/mUZTUbzMxp5zI6nLyepDyh3Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8UzV0r764JxgcpdgmsGSEKxJf54veq4bZsuEeSdWrPjAS/WoMmcdaP8/VM9wPuaMOuN61Rrz2d+4F5WhXa2qsMHYkoiCDTMaVCDzg7UQ957zwDNF7nuMyb7pDJn4xPajU5uNc3osUwZw4ZOUu1hLkqwdzu1NIAUF39v8Kb+S2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AsAc5h3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AsAc5h3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34FFAC4CEE9;
	Tue, 11 Mar 2025 15:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707454;
	bh=ijbP5nrQ+BTtdq6e2/mUZTUbzMxp5zI6nLyepDyh3Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AsAc5h3stfb/bI/c5mSRjgaCAiFm1F8qFy1Rg04c5+PBMVerKxbMnbRFaDqqdtc9i
	 KBV026VmE6uLHCf2lL+Dpj2zA0RkLLSMSi9S6ZA3fpb3tVWnmm8AuCD5F3vj82k63/
	 TWnKAbPEIqnPobuzfyJVf5jd2YQISUF40vhjxHW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ahmed S. Darwish" <darwi@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 395/462] x86/cacheinfo: Validate CPUID leaf 0x2 EDX output
Date: Tue, 11 Mar 2025 16:01:01 +0100
Message-ID: <20250311145813.940708829@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmed S. Darwish <darwi@linutronix.de>

commit 8177c6bedb7013cf736137da586cf783922309dd upstream.

CPUID leaf 0x2 emits one-byte descriptors in its four output registers
EAX, EBX, ECX, and EDX.  For these descriptors to be valid, the most
significant bit (MSB) of each register must be clear.

The historical Git commit:

  019361a20f016 ("- pre6: Intel: start to add Pentium IV specific stuff (128-byte cacheline etc)...")

introduced leaf 0x2 output parsing.  It only validated the MSBs of EAX,
EBX, and ECX, but left EDX unchecked.

Validate EDX's most-significant bit.

Signed-off-by: Ahmed S. Darwish <darwi@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20250304085152.51092-2-darwi@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/cacheinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/cacheinfo.c
+++ b/arch/x86/kernel/cpu/cacheinfo.c
@@ -795,7 +795,7 @@ void init_intel_cacheinfo(struct cpuinfo
 			cpuid(2, &regs[0], &regs[1], &regs[2], &regs[3]);
 
 			/* If bit 31 is set, this is an unknown format */
-			for (j = 0 ; j < 3 ; j++)
+			for (j = 0 ; j < 4 ; j++)
 				if (regs[j] & (1 << 31))
 					regs[j] = 0;
 


