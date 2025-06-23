Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD97C4C7F;
	Mon, 23 Jun 2025 13:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684697; cv=none; b=bcojK92k0u3TGdzLbcOzxs8BxtIZiZsU3xCOEBFq3gjGezPvTbNBtgmqba6FMnG2jQzkGzeXJaE1D7vemUSGpRx0qx2RcZD+yfwIswinSMgGyJWYYyTsK/jI5b2pomVqhmTcWPnK61GBmhxP16bbPJcEkl/NnZFquuotyNkGCvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684697; c=relaxed/simple;
	bh=O8TO5JDxkuBFz4XkXtuKxpwAxJI10zUJ3uHvW3YlySo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OymvxeMb2Zor9rJUeSzlIiwmdNChQbL3qS8xVZ4NYufNxvxXSdxps8ALrz0hYCEBYWufVPisZiwOiM9UTmIPoiRzhgMIZXflup4G3WP6AwItYwieJOPc6jpQnem2zM2xpOEYNKX4mj9l0g7jVDAqjDovZNs3/VV/qHne7uT6I/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2F8y6S0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2F8y6S0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F219BC4CEF0;
	Mon, 23 Jun 2025 13:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684697;
	bh=O8TO5JDxkuBFz4XkXtuKxpwAxJI10zUJ3uHvW3YlySo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x2F8y6S0jQWM0z16mqPHHgyVZbiAuZsZ3tm2vv1bDawASY+rlfaVkkCbdr77VXAC8
	 tmJMlMqsZmU0RWxaBb0pws0+u+FbGHkvlAeSTivNYqK6/5QI9QiWN8nzeAG1mf/mUk
	 cRdZ5vKtveW57kz7qgfaBmUommZPDSkYGPcEWfyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ahmed S. Darwish" <darwi@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	John Ogness <john.ogness@linutronix.de>,
	x86-cpuid@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/222] x86/cpu: Sanitize CPUID(0x80000000) output
Date: Mon, 23 Jun 2025 15:05:46 +0200
Message-ID: <20250623130612.236444502@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmed S. Darwish <darwi@linutronix.de>

[ Upstream commit cc663ba3fe383a628a812f893cc98aafff39ab04 ]

CPUID(0x80000000).EAX returns the max extended CPUID leaf available.  On
x86-32 machines without an extended CPUID range, a CPUID(0x80000000)
query will just repeat the output of the last valid standard CPUID leaf
on the CPU; i.e., a garbage values.  Current tip:x86/cpu code protects against
this by doing:

	eax = cpuid_eax(0x80000000);
	c->extended_cpuid_level = eax;

	if ((eax & 0xffff0000) == 0x80000000) {
		// CPU has an extended CPUID range. Check for 0x80000001
		if (eax >= 0x80000001) {
			cpuid(0x80000001, ...);
		}
	}

This is correct so far.  Afterwards though, the same possibly broken EAX
value is used to check the availability of other extended CPUID leaves:

	if (c->extended_cpuid_level >= 0x80000007)
		...
	if (c->extended_cpuid_level >= 0x80000008)
		...
	if (c->extended_cpuid_level >= 0x8000000a)
		...
	if (c->extended_cpuid_level >= 0x8000001f)
		...

which is invalid.  Fix this by immediately setting the CPU's max extended
CPUID leaf to zero if CPUID(0x80000000).EAX doesn't indicate a valid
CPUID extended range.

While at it, add a comment, similar to kernel/head_32.S, clarifying the
CPUID(0x80000000) sanity check.

References: 8a50e5135af0 ("x86-32: Use symbolic constants, safer CPUID when enabling EFER.NX")
Fixes: 3da99c977637 ("x86: make (early)_identify_cpu more the same between 32bit and 64 bit")
Signed-off-by: Ahmed S. Darwish <darwi@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: x86-cpuid@lists.linux.dev
Link: https://lore.kernel.org/r/20250506050437.10264-3-darwi@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/common.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index ae9d8aa3ae48e..bd29a436e87e8 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -934,17 +934,18 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 		c->x86_capability[CPUID_D_1_EAX] = eax;
 	}
 
-	/* AMD-defined flags: level 0x80000001 */
+	/*
+	 * Check if extended CPUID leaves are implemented: Max extended
+	 * CPUID leaf must be in the 0x80000001-0x8000ffff range.
+	 */
 	eax = cpuid_eax(0x80000000);
-	c->extended_cpuid_level = eax;
+	c->extended_cpuid_level = ((eax & 0xffff0000) == 0x80000000) ? eax : 0;
 
-	if ((eax & 0xffff0000) == 0x80000000) {
-		if (eax >= 0x80000001) {
-			cpuid(0x80000001, &eax, &ebx, &ecx, &edx);
+	if (c->extended_cpuid_level >= 0x80000001) {
+		cpuid(0x80000001, &eax, &ebx, &ecx, &edx);
 
-			c->x86_capability[CPUID_8000_0001_ECX] = ecx;
-			c->x86_capability[CPUID_8000_0001_EDX] = edx;
-		}
+		c->x86_capability[CPUID_8000_0001_ECX] = ecx;
+		c->x86_capability[CPUID_8000_0001_EDX] = edx;
 	}
 
 	if (c->extended_cpuid_level >= 0x80000007) {
-- 
2.39.5



