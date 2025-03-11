Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DBA3C0B;
	Tue, 11 Mar 2025 15:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707457; cv=none; b=QGi7T1QkgJS1WI52UrF8bY0N3rTLOibrbHAA8m3K7+98GVKNGMarQ4IrDSafafwZEeih2tDfJcrlmaOVykxNXwHHdQopFur0fiZr6jNUb4t8C7rYT9e0i4ZTXoxUB8HB0qvbYTETTo9gtdOd1gEPKUkXPEjCjYAyHD7DCoLp4kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707457; c=relaxed/simple;
	bh=X5VtVzBti04+ZzjIfw53YkCwuQgtUfodZNiPb0blIHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmVioQUyvPq8k6LFESSkBxjVibFI7m7eGSVNA4GP48IPBVMnhbZGt71FhvEx6MaNnc3zSM3XO/A19NLgGdaTzcv1ll/X5BFe+EXNDl/RCDQYbRn87d6B/HC94FN48VaS96GKmeFMRNrGvgIDUWpbCs0Gwye2Bemz9FavEJreCKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=edo+eD8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="edo+eD8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E82C4CEEA;
	Tue, 11 Mar 2025 15:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707457;
	bh=X5VtVzBti04+ZzjIfw53YkCwuQgtUfodZNiPb0blIHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=edo+eD8MGXgthC0TbRiJG0zF0bCC0jJIm2MxNVh32973YqODaOp31kd6FyMqe+alr
	 2ZgiGQCnZ4Rk0PSIg91GdcygvQQFyu4oTo8hyYqJx2kIzAIvugbck//OACgtUfsRZ/
	 N4afEKZt7hnm5xWOcmCutb/jh0e7HwIE9E/eeK1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ahmed S. Darwish" <darwi@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	stable@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 396/462] x86/cpu: Validate CPUID leaf 0x2 EDX output
Date: Tue, 11 Mar 2025 16:01:02 +0100
Message-ID: <20250311145813.979475506@linuxfoundation.org>
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
@@ -911,7 +911,7 @@ static void intel_detect_tlb(struct cpui
 		cpuid(2, &regs[0], &regs[1], &regs[2], &regs[3]);
 
 		/* If bit 31 is set, this is an unknown format */
-		for (j = 0 ; j < 3 ; j++)
+		for (j = 0 ; j < 4 ; j++)
 			if (regs[j] & (1 << 31))
 				regs[j] = 0;
 


