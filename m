Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6ACC3D8114;
	Tue, 31 Mar 2026 16:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975380; cv=none; b=hCh09ARHCXGs9+bhAVg74QhZ48hcmNkGTBzuRlUL7yOC3C/fBPy/81MTrCVQ0aOxA5JNXUg6KRoF03N8ATk7cLFWhQ7sjaJVaKJmZHvVDDZWqJqFzqVDGWsUL9v3ZxtCYhgTbA3MFrE+7D4CXYPiepbAEhj76N/ZsDKoi5Dbk+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975380; c=relaxed/simple;
	bh=NXa6kHneol3oxCylksTIj9D5U9Cq84ueUgXE569TYhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnjfyIF/pq690OKpu4vJbkq1fA0LO8ebuPFMgZflpzTaFIZH+/uJ14lH6r78WsCUVlJLDTYAko2rRQNKHShGGG7uUwWS4IvnMtrTTyqQlz9B7WgrLPB6ageTCja9wOQvVa9RIEgm3FaQefWRPXJjEFAcRdm6aTtw2eCXYnUBK6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G1bQ3qFS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G1bQ3qFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B37BC19423;
	Tue, 31 Mar 2026 16:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975380;
	bh=NXa6kHneol3oxCylksTIj9D5U9Cq84ueUgXE569TYhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G1bQ3qFSVezKeUiOT2JIITDVOct5wGsEF+HesWbSdv6HQnOXoGWgM4CDIfiGctGEK
	 waX+SUdzztDtfGVH66ohfJQZIzPNu647BEcpOITS+9nkU7/rpaK0sNqsjtiFEmIIf8
	 eTbv+bt7lkahEYQrLdQxwXH+TVtZOfkL9ItIidbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.19 240/342] x86/cpu: Remove X86_CR4_FRED from the CR4 pinned bits mask
Date: Tue, 31 Mar 2026 18:21:13 +0200
Message-ID: <20260331161807.794921018@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

commit 411df123c017169922cc767affce76282b8e6c85 upstream.

Commit in Fixes added the FRED CR4 bit to the CR4 pinned bits mask so
that whenever something else modifies CR4, that bit remains set. Which
in itself is a perfectly fine idea.

However, there's an issue when during boot FRED is initialized: first on
the BSP and later on the APs. Thus, there's a window in time when
exceptions cannot be handled.

This becomes particularly nasty when running as SEV-{ES,SNP} or TDX
guests which, when they manage to trigger exceptions during that short
window described above, triple fault due to FRED MSRs not being set up
yet.

See Link tag below for a much more detailed explanation of the
situation.

So, as a result, the commit in that Link URL tried to address this
shortcoming by temporarily disabling CR4 pinning when an AP is not
online yet.

However, that is a problem in itself because in this case, an attack on
the kernel needs to only modify the online bit - a single bit in RW
memory - and then disable CR4 pinning and then disable SM*P, leading to
more and worse things to happen to the system.

So, instead, remove the FRED bit from the CR4 pinning mask, thus
obviating the need to temporarily disable CR4 pinning.

If someone manages to disable FRED when poking at CR4, then
idt_invalidate() would make sure the system would crash'n'burn on the
first exception triggered, which is a much better outcome security-wise.

Fixes: ff45746fbf00 ("x86/cpu: Add X86_CR4_FRED macro")
Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org> # 6.12+
Link: https://lore.kernel.org/r/177385987098.1647592.3381141860481415647.tip-bot2@tip-bot2
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -433,7 +433,7 @@ static __always_inline void setup_lass(s
 
 /* These bits should not change their value after CPU init is finished. */
 static const unsigned long cr4_pinned_mask = X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP |
-					     X86_CR4_FSGSBASE | X86_CR4_CET | X86_CR4_FRED;
+					     X86_CR4_FSGSBASE | X86_CR4_CET;
 static DEFINE_STATIC_KEY_FALSE_RO(cr_pinning);
 static unsigned long cr4_pinned_bits __ro_after_init;
 


