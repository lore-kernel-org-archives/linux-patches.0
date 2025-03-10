Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2B41B3927;
	Mon, 10 Mar 2025 17:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627373; cv=none; b=cn3PgmwYwygirkc66hHxgPar2WUqYay/WyyDfCsgR6yP0r7YQx4Jk/Ly9mrqXP75NfPrg6biPDEC+Ao6kh/Y1NvhqumgN9XBSLYoaC8mufh2d52LZbDtu/ewftee4wufAMF+Q1NcxFBvZBNv47AkcuWGbWf3Dv2x3cY7Yte9E/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627373; c=relaxed/simple;
	bh=mpZAVOQoE8KsAcUnzXd9NOFX6MEX/qi2WVvYFtoX814=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KklL4u99Rg3Hch7LlKd5peIzSLiGM5rDWiigfb5+YpkDKV45/KP0w9lGMrQPWl3OCMPpYqQrMDgUw0ookJtttpUHm69BveeBrnfSixAX2S3LzkqTnb3OfMIi57IqOvYkgB67EF0Ezv2yyKB59g9qtBA7MkGcygB3sv5QiVtljbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=us/N6+4w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="us/N6+4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAAEDC4CEE5;
	Mon, 10 Mar 2025 17:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627373;
	bh=mpZAVOQoE8KsAcUnzXd9NOFX6MEX/qi2WVvYFtoX814=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=us/N6+4weiy2ctcIEhVy99+T1McsVvaCvZ2SsASdezy9yPXJOEByRSSKQbhUG48cT
	 OCUwnZg1D5vSxgLTJKb3KvHGeMVeGATcAkE1UW7pC5SNCKhhUFjq56PYvDhV6MolkG
	 TxKxE9N7bVapgImH29/jq0LMYiUpkwlndDMDxFXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ahmed S. Darwish" <darwi@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.12 106/269] x86/cacheinfo: Validate CPUID leaf 0x2 EDX output
Date: Mon, 10 Mar 2025 18:04:19 +0100
Message-ID: <20250310170501.937342001@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -808,7 +808,7 @@ void init_intel_cacheinfo(struct cpuinfo
 			cpuid(2, &regs[0], &regs[1], &regs[2], &regs[3]);
 
 			/* If bit 31 is set, this is an unknown format */
-			for (j = 0 ; j < 3 ; j++)
+			for (j = 0 ; j < 4 ; j++)
 				if (regs[j] & (1 << 31))
 					regs[j] = 0;
 


