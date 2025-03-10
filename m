Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71A2374EA;
	Mon, 10 Mar 2025 18:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630810; cv=none; b=Bn4+2Y9Sdsfh+5p7S5IepORufuiYyhXtnmOyW+jvgb40y7uOvgpPgiIcUMM0yd5zulHHKuJfWGngrbJsvbFPyBHVIAdD/h94wltGV2m013E2lENADy3xocu4DBYvbUmmweZMgNQihwMorbTLtbWnekdzUda/5aiD/xxMw+J31I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630810; c=relaxed/simple;
	bh=OuR/vTnmgZFRLDbAUFD1Qv9bZ5bNebbTc5VHdk4dv98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tmFpjTyt5DvbbRc2t/cGjDe1pLZntbs5jFRtEzNIMb2AC2WsAdkH/mXDkbLx0OZkEUCgC/i532QSnXoqCRyi+EWL3WUcitkt6UxI1aOlLqW8bQiYrPoKXEJEXACLG4LAqzUyZi3yLcp/zZMEdZdynj2RdQkL/U9tGIcGNxp1v5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJoiM1Pt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJoiM1Pt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CFFC4CEE5;
	Mon, 10 Mar 2025 18:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630809;
	bh=OuR/vTnmgZFRLDbAUFD1Qv9bZ5bNebbTc5VHdk4dv98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJoiM1PtrdhDNgXx9jSPA/rZQPOndEU9FfwhbNidSYeQALnVNRJajBtdRul+dI47+
	 pB6ya1iZ3xZdxeamvlAsHYgLB3KLIEAYW1xJBhXFThBYvYvKOB6spIYkzMXnl1IL9f
	 W0j7PBTF8HeVOgiFYvPp6dr/L4obCpoeto4gmp7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ahmed S. Darwish" <darwi@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	stable@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 542/620] x86/cpu: Validate CPUID leaf 0x2 EDX output
Date: Mon, 10 Mar 2025 18:06:28 +0100
Message-ID: <20250310170606.942244500@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -913,7 +913,7 @@ static void intel_detect_tlb(struct cpui
 		cpuid(2, &regs[0], &regs[1], &regs[2], &regs[3]);
 
 		/* If bit 31 is set, this is an unknown format */
-		for (j = 0 ; j < 3 ; j++)
+		for (j = 0 ; j < 4 ; j++)
 			if (regs[j] & (1 << 31))
 				regs[j] = 0;
 


