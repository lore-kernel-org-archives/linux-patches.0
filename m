Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B70280A51;
	Tue, 27 May 2025 17:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368605; cv=none; b=RxuolygATI0xYljoCPk6vCdofIaS8r4et5VrtdcCCAnU2N+y1B0fYL0EJG6Spyw+6CSHbKRbYs+VgeJ91mr+4qa2J8heE/RhR9145rqcvsmJ9KHGRlTuvU1OmUldXmPJe9Enz00zdnQ0ODYjUa6PnruWm0Bo1K6GXMHXiRCxvYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368605; c=relaxed/simple;
	bh=zaNG+i1mDvMUuc5LtIlLIhyrQW/Pm2Y1tfJWCtZXcJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwQg98iwbN9/SMiLrflxkDeoO9GRiKcdYKBSzMMqK117U/ImVDGKfm1zF3c+pnvDobLwAJ7r1GJNhwgrP0wc5/IpQiCgdHiS4M/Voa3T+4gE+iVQBPFdpFWvlpfbH/d0u2hInCcEX4lRTxYENDmDimEYvb08VdwT4D3qo6HD2cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=shOa8YoP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="shOa8YoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31F5C4CEEA;
	Tue, 27 May 2025 17:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368605;
	bh=zaNG+i1mDvMUuc5LtIlLIhyrQW/Pm2Y1tfJWCtZXcJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=shOa8YoP3VUFHePB3Vbz48QwIKaBg6HT3U+HMxccRAcktZyWDlPY/JgRaGgm/GwSQ
	 Di4eRnbWVS1FNShBKUzKHeqFqE7nqiGNeKvhkDi27L0JSXz6ovGnkhztqR+Yyvw24t
	 G2jMsW9ysMRisIeK5f92T7aSb3oLtThEHdIKF3/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florent Revest <revest@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Borislav Betkov <bp@alien8.de>,
	Brendan Jackman <jackmanb@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thiago Jung Bauermann <thiago.bauermann@linaro.org>,
	Thomas Gleinxer <tglx@linutronix.de>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.14 760/783] mm: fix VM_UFFD_MINOR == VM_SHADOW_STACK on USERFAULTFD=y && ARM64_GCS=y
Date: Tue, 27 May 2025 18:29:17 +0200
Message-ID: <20250527162544.069333928@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florent Revest <revest@chromium.org>

commit 0f518255bde881d2a2605bbc080b438b532b6ab2 upstream.

On configs with CONFIG_ARM64_GCS=y, VM_SHADOW_STACK is bit 38.  On configs
with CONFIG_HAVE_ARCH_USERFAULTFD_MINOR=y (selected by CONFIG_ARM64 when
CONFIG_USERFAULTFD=y), VM_UFFD_MINOR is _also_ bit 38.

This bit being shared by two different VMA flags could lead to all sorts
of unintended behaviors.  Presumably, a process could maybe call into
userfaultfd in a way that disables the shadow stack vma flag.  I can't
think of any attack where this would help (presumably, if an attacker
tries to disable shadow stacks, they are trying to hijack control flow so
can't arbitrarily call into userfaultfd yet anyway) but this still feels
somewhat scary.

Link: https://lkml.kernel.org/r/20250507131000.1204175-2-revest@chromium.org
Fixes: ae80e1629aea ("mm: Define VM_SHADOW_STACK for arm64 when we support GCS")
Signed-off-by: Florent Revest <revest@chromium.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Florent Revest <revest@chromium.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -411,7 +411,7 @@ extern unsigned int kobjsize(const void
 #endif
 
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
-# define VM_UFFD_MINOR_BIT	38
+# define VM_UFFD_MINOR_BIT	41
 # define VM_UFFD_MINOR		BIT(VM_UFFD_MINOR_BIT)	/* UFFD minor faults */
 #else /* !CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
 # define VM_UFFD_MINOR		VM_NONE


