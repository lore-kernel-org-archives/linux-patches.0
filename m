Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26383AD58;
	Wed, 19 Jun 2024 13:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802990; cv=none; b=hjNiDzOu2qy9lyp5y1p37DCS6hnmCb64NAA98glCHyWQGxYa0cUFzl9JR0f9FOXPSYIVixQ3L5HG4E01rq6Atua8ZR0wdRXvPSYtkpmfa6XrhHm0hZJJYcNYJHcqoV7yfMydwRducrpZQO84fsnp/oTKOQf6WNDSngxsNbkGxTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802990; c=relaxed/simple;
	bh=7TC2TwH90Gchz71t9Ahnnoja4+kua/Jneo5payEt0A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRGk/XBBhX+eZgtcbVhKTTcZczwj/Uow1vX6mobnnn9OchmagtRXkk1KQYJWYWDMHKzoZpBpcTTT0fNPiOSxDHFwx0HvoiY+kQBfC9bqp14xxMi0DC33Qf8eMcG34L0sfk5bEK/4St0cLHj259CeYYYLXucqcmpcYl0KDwKk/pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8RflkR5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8RflkR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34EAC2BBFC;
	Wed, 19 Jun 2024 13:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802990;
	bh=7TC2TwH90Gchz71t9Ahnnoja4+kua/Jneo5payEt0A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8RflkR5Ujx4tBkiKLAqDYljtHrzcTPBwMmLrUoZrHAnL4V6H9o0Qniv2VrGUDbO/
	 kfzAoKsNQKdVCBbbIj6IphnAsfM2J52fOBTB2tVvnnml3yeszsYv0SMIGbDt4sFcho
	 bI5ojRNLlI0VwpZsCrUBEUIX5t6H9J9gvOim8+OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 074/281] x86/cpu: Get rid of an unnecessary local variable in get_cpu_address_sizes()
Date: Wed, 19 Jun 2024 14:53:53 +0200
Message-ID: <20240619125612.689560201@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

[ Upstream commit 95bfb35269b2e85cff0dd2c957b2d42ebf95ae5f ]

Drop 'vp_bits_from_cpuid' as it is not really needed.

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20240316120706.4352-1-bp@alien8.de
Stable-dep-of: 2a38e4ca3022 ("x86/cpu: Provide default cache line size if not enumerated")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/common.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index ae987a26f26e4..d636991536a5f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1053,18 +1053,9 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 void get_cpu_address_sizes(struct cpuinfo_x86 *c)
 {
 	u32 eax, ebx, ecx, edx;
-	bool vp_bits_from_cpuid = true;
 
 	if (!cpu_has(c, X86_FEATURE_CPUID) ||
-	    (c->extended_cpuid_level < 0x80000008))
-		vp_bits_from_cpuid = false;
-
-	if (vp_bits_from_cpuid) {
-		cpuid(0x80000008, &eax, &ebx, &ecx, &edx);
-
-		c->x86_virt_bits = (eax >> 8) & 0xff;
-		c->x86_phys_bits = eax & 0xff;
-	} else {
+	    (c->extended_cpuid_level < 0x80000008)) {
 		if (IS_ENABLED(CONFIG_X86_64)) {
 			c->x86_clflush_size = 64;
 			c->x86_phys_bits = 36;
@@ -1078,7 +1069,13 @@ void get_cpu_address_sizes(struct cpuinfo_x86 *c)
 			    cpu_has(c, X86_FEATURE_PSE36))
 				c->x86_phys_bits = 36;
 		}
+	} else {
+		cpuid(0x80000008, &eax, &ebx, &ecx, &edx);
+
+		c->x86_virt_bits = (eax >> 8) & 0xff;
+		c->x86_phys_bits = eax & 0xff;
 	}
+
 	c->x86_cache_bits = c->x86_phys_bits;
 	c->x86_cache_alignment = c->x86_clflush_size;
 }
-- 
2.43.0



