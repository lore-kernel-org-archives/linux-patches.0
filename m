Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D4C23B633;
	Tue, 17 Jun 2025 15:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174423; cv=none; b=AlLMAAWm5SXPjt1lhkHU/GLl6vtsYdDJ1K/1+BtCYv/Z07SHXzVHE8hM5bi8BhmwmbQf0NnEwPDn2upj2DGKBMc8Xaa+VsRBzs0JoFJfO2TlRhGAeOeAJCTLefyaJmY3qy8zbkkCUynIG/FkmTF0GPM+XfIPMwMipBQ2NR/7xOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174423; c=relaxed/simple;
	bh=gUtbaNbhTv2u8upUwdOot7nxejNcPZcT/EUlOixRb+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nk0bGk7s8b/yF6H+6fwYDZDYN80iu8FHOP5oQPNG+jU0IcVKBcbHiFUO5ye/4W5z/LPpMH2Fdlqou2h2XrfZvvRjBi3unR237+j5Hf7dJeRGC0AcdW0WEWeVUfPy212ZwYQ/FXtqaRUsq9kQWD3+LwU2r9tsuUrTXYX1yN7R6D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dSOZYRlH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dSOZYRlH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4215AC4CEE3;
	Tue, 17 Jun 2025 15:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174423;
	bh=gUtbaNbhTv2u8upUwdOot7nxejNcPZcT/EUlOixRb+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dSOZYRlHxFpz8f6e9n87PKpAxRDmLe3YcLyZHgT8jpRqBrenMpUipIAeoCQv7PaAE
	 kymtGdldfVPbK0XGJMBgtK8nGpbHPmBr/mysViugQseCdxRoudon8yqQO57QT99pNI
	 QgdiUkyQsZLJI8/tL9nFHnFXJSw2cg+I5yWQHbME=
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
Subject: [PATCH 6.12 017/512] x86/cpu: Sanitize CPUID(0x80000000) output
Date: Tue, 17 Jun 2025 17:19:43 +0200
Message-ID: <20250617152420.222948429@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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
index 39e9ec3dea985..b487754455236 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1007,17 +1007,18 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
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



