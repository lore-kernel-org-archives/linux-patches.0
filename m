Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F95233150;
	Mon, 10 Mar 2025 17:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627973; cv=none; b=NmzOpYyulVLYJxuenyvKvn3+tIk7HOxKgF0hnbUjEMf7CFt5k1EXyBLfEGjxZGzYsdPDKl0vO2ZSP3z0nzx6YY9g4KnxBcXnmw2G0M2kMMcCHwdsI9ghDkqs+FSjiShk0tkqWsMowrHA+bt/Qc4MNRKFAidGD9o2wHz5TWXouYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627973; c=relaxed/simple;
	bh=2H25ZCCGDqOthYJZyot5P+yPA7BTQHXjtH40qw+XsZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMDM8UxFWkw/I+eR4ISuV+AzUaMohNrIxIbRzb04s9b7xpPkqc5w2DQutMdbX7cXeVl57en9HemaTjR8BmMSqRmlwHrhDHjz7fSwSPpk4uutEvVFj2+6e2LSUH16wyygsgK+vuxCarWgf8NgDooRgSIPxtui+5yvwcDINrmOYHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Znb2sIMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Znb2sIMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9558DC4CEE5;
	Mon, 10 Mar 2025 17:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627973;
	bh=2H25ZCCGDqOthYJZyot5P+yPA7BTQHXjtH40qw+XsZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Znb2sIMoVlWSvO8HeEdKwI5bYOxBjczvmqhIfPrgNIlBveDeK8Tm+fTXtPUUC05mN
	 63KPo5w6mUALHmTQQ843B7cV3z+GBHpJH0LcwrGMjWwcvduOqJD9AtAfib9p/uJZw8
	 cjP9h+54jGFxW//zks8zgZVJKTxb7SvPOhJ6h87A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ahmed S. Darwish" <darwi@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	stable@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.6 044/145] x86/cpu: Validate CPUID leaf 0x2 EDX output
Date: Mon, 10 Mar 2025 18:05:38 +0100
Message-ID: <20250310170436.513249442@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -912,7 +912,7 @@ static void intel_detect_tlb(struct cpui
 		cpuid(2, &regs[0], &regs[1], &regs[2], &regs[3]);
 
 		/* If bit 31 is set, this is an unknown format */
-		for (j = 0 ; j < 3 ; j++)
+		for (j = 0 ; j < 4 ; j++)
 			if (regs[j] & (1 << 31))
 				regs[j] = 0;
 


