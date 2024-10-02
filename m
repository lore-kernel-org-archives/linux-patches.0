Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FBE1D0BAD;
	Wed,  2 Oct 2024 14:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877861; cv=none; b=uiLBko//yVYsbvEHTp+WcjsWP9N1BXghPIAmEvXJO1f17gudXAEhbtxeeaL5TAZVP53MJkDXP1/KqzJjbHBcFnhxsq/rkN+NlERssRO5vPvftXoZf2PHXcPQYWKo92GApgJuOtItUGjDdzEmvjprUN1CK2hjDeo07NvagJdRut4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877861; c=relaxed/simple;
	bh=aaSanO8HtZOYp8JNsaSJciOgi8e18u6RaYmzbn+jYDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZbUEmuvMb1HlNoVcvTUZEFHKKcJOJ1GLq9HsHZSL4oqm0XzcxCb+4pHRS4mcE3oOTbPTlsh0YDoVN0QsbgkVPKa/dwATtnEbI3BskHb2V0bjKOJZF3FFEVGqIkBZrvCp6RJqiFZKSIs9OrBxn9VCRV9DXAeUDzEGazs20tNIbEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y9iy40Qe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y9iy40Qe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5D8C4CEC2;
	Wed,  2 Oct 2024 14:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877860;
	bh=aaSanO8HtZOYp8JNsaSJciOgi8e18u6RaYmzbn+jYDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y9iy40QeFattsJN7doDrCX5AeGFa4NNP8xqUzY0xWSbEFTojddklNfgm2mhhnGm6e
	 2fD0gFVz2HywNsQ3PeEFeogKMQp0jca6dM/tcgdlrw0f2Zw14KWXOAq5WUxSFTKJsy
	 0drDy6eGbBHOCPmC4aRC7bzBv3P6fnrWi5P54+yI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <David.Laight@aculab.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 6.10 219/634] minmax: avoid overly complex min()/max() macro arguments in xen
Date: Wed,  2 Oct 2024 14:55:19 +0200
Message-ID: <20241002125819.746272085@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit e8432ac802a028eaee6b1e86383d7cd8e9fb8431 ]

We have some very fancy min/max macros that have tons of sanity checking
to warn about mixed signedness etc.

This is all things that a sane compiler should warn about, but there are
no sane compiler interfaces for this, and '-Wsign-compare' is broken [1]
and not useful.

So then we compensate (some would say over-compensate) by doing the
checks manually with some truly horrid macro games.

And no, we can't just use __builtin_types_compatible_p(), because the
whole question of "does it make sense to compare these two values" is a
lot more complicated than that.

For example, it makes a ton of sense to compare unsigned values with
simple constants like "5", even if that is indeed a signed type.  So we
have these very strange macros to try to make sensible type checking
decisions on the arguments to 'min()' and 'max()'.

But that can cause enormous code expansion if the min()/max() macros are
used with complicated expressions, and particularly if you nest these
things so that you get the first big expansion then expanded again.

The xen setup.c file ended up ballooning to over 50MB of preprocessed
noise that takes 15s to compile (obviously depending on the build host),
largely due to one single line.

So let's split that one single line to just be simpler.  I think it ends
up being more legible to humans too at the same time.  Now that single
file compiles in under a second.

Reported-and-reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Link: https://lore.kernel.org/all/c83c17bb-be75-4c67-979d-54eee38774c6@lucifer.local/
Link: https://staticthinking.wordpress.com/2023/07/25/wsign-compare-is-garbage/ [1]
Cc: David Laight <David.Laight@aculab.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: be35d91c8880 ("xen: tolerate ACPI NVS memory overlapping with Xen allocated memory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/setup.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index d44d6d8b33195..d2073df5c5624 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -691,6 +691,7 @@ char * __init xen_memory_setup(void)
 	struct xen_memory_map memmap;
 	unsigned long max_pages;
 	unsigned long extra_pages = 0;
+	unsigned long maxmem_pages;
 	int i;
 	int op;
 
@@ -762,8 +763,8 @@ char * __init xen_memory_setup(void)
 	 * Make sure we have no memory above max_pages, as this area
 	 * isn't handled by the p2m management.
 	 */
-	extra_pages = min3(EXTRA_MEM_RATIO * min(max_pfn, PFN_DOWN(MAXMEM)),
-			   extra_pages, max_pages - max_pfn);
+	maxmem_pages = EXTRA_MEM_RATIO * min(max_pfn, PFN_DOWN(MAXMEM));
+	extra_pages = min3(maxmem_pages, extra_pages, max_pages - max_pfn);
 	i = 0;
 	addr = xen_e820_table.entries[0].addr;
 	size = xen_e820_table.entries[0].size;
-- 
2.43.0



