Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17E722D799;
	Mon, 10 Mar 2025 17:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628427; cv=none; b=JJF35yfdDdXw3y8OZSGogWMkynWJ+Kyh4eDWu2tjxtvpncyA2sMX5ghum3JbZxDtpfg/vkXFpR7yykzA3aH7ZZPBQzvN+T9iClWZTOO2IoZc81nNi9cJJUrCn8/RJMAm5O8PdM7juwZd8yuCPH1U8yu1IH1g8twSKaWtFSpKhRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628427; c=relaxed/simple;
	bh=uVtbkal8FKMFA3Lc+UFmVV+cWdbvm72/9x48WJx9EPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnWhLVhHWEtIv/dGipBWRt1uT12IhIyzIXfPyPL1p7ys/rRLIFCE7IgLGqep4yIJD0NG6ueAeA+eyNvTqP392bsbVnOeyRAMXcGEmiG4K+5mB1iIvKEE7OvcrBBOLtYyvq6EMEA9HGIiWeIQ5dUbSnhIylrK02GgN55yhj+aY14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hidddK2O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hidddK2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696E0C4CEE5;
	Mon, 10 Mar 2025 17:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628426;
	bh=uVtbkal8FKMFA3Lc+UFmVV+cWdbvm72/9x48WJx9EPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hidddK2O0tfiT82B1h6Nqoj8ivZlKKRxHBuiayrWXP/LAIKSi8an3aAg4qrXD8Gzd
	 Qmxv9U3n7E42/GOqlUgGJaBF7Zsqk0pIRVWe//lL60dZyQqTGLjm5pr9Xhl3aTdSAJ
	 hTol60FU/03Ab3u43ASNc/HT9canNqnTzrNC72Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ahmed S. Darwish" <darwi@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	stable@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 023/109] x86/cpu: Validate CPUID leaf 0x2 EDX output
Date: Mon, 10 Mar 2025 18:06:07 +0100
Message-ID: <20250310170428.471552718@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmed S. Darwish <darwi@linutronix.de>

commit 1881148215c67151b146450fb89ec22fd92337a7 upstream.

CPUID leaf 0x2 emits one-byte descriptors in its four output registers
EAX, EBX, ECX, and EDX.  For these descriptors to be valid, the most
significant bit (MSB) of each register must be clear.

Leaf 0x2 parsing at intel.c only validated the MSBs of EAX, EBX, and
ECX, but left EDX unchecked.

Validate EDX's most-significant bit as well.

Fixes: e0ba94f14f74 ("x86/tlb_info: get last level TLB entry number of CPU")
Signed-off-by: Ahmed S. Darwish <darwi@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20250304085152.51092-3-darwi@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/intel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -948,7 +948,7 @@ static void intel_detect_tlb(struct cpui
 		cpuid(2, &regs[0], &regs[1], &regs[2], &regs[3]);
 
 		/* If bit 31 is set, this is an unknown format */
-		for (j = 0 ; j < 3 ; j++)
+		for (j = 0 ; j < 4 ; j++)
 			if (regs[j] & (1 << 31))
 				regs[j] = 0;
 


