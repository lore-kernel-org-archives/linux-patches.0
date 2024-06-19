Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EE714389C;
	Wed, 19 Jun 2024 13:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802892; cv=none; b=CzTu8yT5tIf9pyz88miTHMSIBx27ubh2jAmp0fYMkIeHX+vMKA25aUhggwKFLFsawQdP4pkfL+cjsEdRPsVwiu4L0WBQZi0DwAMEkEez6AaiE1+frAvlghdRCABBa/FhYhaj1Q9HrGvAtzEzlfE0zSY4taSwqWmsx58e0Y7EI74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802892; c=relaxed/simple;
	bh=rOJHZDUaBnN6l08/loOIJ2lABtalFRsNFOz3Q4YsROg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tng38CkeE/Gj4De5dzxq4vBEqq96ykcGEFCffg30qb5iMo6Vn1EyMgvsliGXY3Va5jKgmMV5roX/bF+4BGSKmvUtwYCqGfsrkzUQqXoJYLZTTS2PM/0LhBn+w+5T1XvlvjeuXnBdml5RDIzLZYEQTWukwqmz6byISk1tOPvZrI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZmATqTm7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZmATqTm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F323C2BBFC;
	Wed, 19 Jun 2024 13:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802892;
	bh=rOJHZDUaBnN6l08/loOIJ2lABtalFRsNFOz3Q4YsROg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZmATqTm7G/6SrGgYk5tNXF6YmsOhH2s8lwo1QOgRngrBfZV4cbA6hC4i79XCDojRi
	 4MAg2HQZDByWtGT13nGyjZQBkrYeES5p5cJ35+viPG2g1sAp/Wa58LQVKqCEvW1eOu
	 T6vDFe0+QEhVTW1OE7RgehluoL8EpG+1LmSzcGYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	=?UTF-8?q?J=C3=B6rn=20Heusipp?= <osmanx@heusipp.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 075/281] x86/cpu: Provide default cache line size if not enumerated
Date: Wed, 19 Jun 2024 14:53:54 +0200
Message-ID: <20240619125612.727612299@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Hansen <dave.hansen@linux.intel.com>

[ Upstream commit 2a38e4ca302280fdcce370ba2bee79bac16c4587 ]

tl;dr: CPUs with CPUID.80000008H but without CPUID.01H:EDX[CLFSH]
will end up reporting cache_line_size()==0 and bad things happen.
Fill in a default on those to avoid the problem.

Long Story:

The kernel dies a horrible death if c->x86_cache_alignment (aka.
cache_line_size() is 0.  Normally, this value is populated from
c->x86_clflush_size.

Right now the code is set up to get c->x86_clflush_size from two
places.  First, modern CPUs get it from CPUID.  Old CPUs that don't
have leaf 0x80000008 (or CPUID at all) just get some sane defaults
from the kernel in get_cpu_address_sizes().

The vast majority of CPUs that have leaf 0x80000008 also get
->x86_clflush_size from CPUID.  But there are oddballs.

Intel Quark CPUs[1] and others[2] have leaf 0x80000008 but don't set
CPUID.01H:EDX[CLFSH], so they skip over filling in ->x86_clflush_size:

	cpuid(0x00000001, &tfms, &misc, &junk, &cap0);
	if (cap0 & (1<<19))
		c->x86_clflush_size = ((misc >> 8) & 0xff) * 8;

So they: land in get_cpu_address_sizes() and see that CPUID has level
0x80000008 and jump into the side of the if() that does not fill in
c->x86_clflush_size.  That assigns a 0 to c->x86_cache_alignment, and
hilarity ensues in code like:

        buffer = kzalloc(ALIGN(sizeof(*buffer), cache_line_size()),
                         GFP_KERNEL);

To fix this, always provide a sane value for ->x86_clflush_size.

Big thanks to Andy Shevchenko for finding and reporting this and also
providing a first pass at a fix. But his fix was only partial and only
worked on the Quark CPUs.  It would not, for instance, have worked on
the QEMU config.

1. https://raw.githubusercontent.com/InstLatx64/InstLatx64/master/GenuineIntel/GenuineIntel0000590_Clanton_03_CPUID.txt
2. You can also get this behavior if you use "-cpu 486,+clzero"
   in QEMU.

[ dhansen: remove 'vp_bits_from_cpuid' reference in changelog
	   because bpetkov brutally murdered it recently. ]

Fixes: fbf6449f84bf ("x86/sev-es: Set x86_virt_bits to the correct value straight away, instead of a two-phase approach")
Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Jörn Heusipp <osmanx@heusipp.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240516173928.3960193-1-andriy.shevchenko@linux.intel.com/
Link: https://lore.kernel.org/lkml/5e31cad3-ad4d-493e-ab07-724cfbfaba44@heusipp.de/
Link: https://lore.kernel.org/all/20240517200534.8EC5F33E%40davehans-spike.ostc.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/common.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d636991536a5f..1982007828276 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1074,6 +1074,10 @@ void get_cpu_address_sizes(struct cpuinfo_x86 *c)
 
 		c->x86_virt_bits = (eax >> 8) & 0xff;
 		c->x86_phys_bits = eax & 0xff;
+
+		/* Provide a sane default if not enumerated: */
+		if (!c->x86_clflush_size)
+			c->x86_clflush_size = 32;
 	}
 
 	c->x86_cache_bits = c->x86_phys_bits;
-- 
2.43.0



