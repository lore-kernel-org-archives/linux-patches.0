Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56931146592;
	Tue, 25 Jun 2024 10:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309783; cv=none; b=sED8O231MhzpUkbS7s22AOv3+zb/T8IOAEJLuI4IBrkau/5Zs5hBeMvthwffmhXLwC0DQLs2E3S4gcW6P6T/Cm86hOv1R/IqFCqPZtWuGa8KHcEaZO5XiU95x5qU/0TXWq1FkjpqhT/1LaeqOqzN2AMDAup2cSiKTmBLr1Cpcnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309783; c=relaxed/simple;
	bh=gqO00KeIfAcS9jzvaOPrEU/I7nBxOA5QoFqShBM1+I0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5fJSbsirNabxipZ0PpbKbJGCoHjQIZ3N2wYr+NzqTy3d8OrqslZOWNyF1l6jDkI1a3VKRdGnmxigE+aaOWYcj8Mr86Fl2A2Jnid2wzr8P18Xe4LQni1ZiKohxlTNWXYyQnjS7XK0HVG25epazdol9io914fuOOh3d7/bHr+ejk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dB3SD23B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dB3SD23B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E41C32781;
	Tue, 25 Jun 2024 10:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309783;
	bh=gqO00KeIfAcS9jzvaOPrEU/I7nBxOA5QoFqShBM1+I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dB3SD23BpiC0Q6lTFKOaCKZafJGaacT3CGnXkRzoWKl8ERB3VCXUs9nsfJFV+KEhV
	 cndtmlmUSLHfbpv8ozB1pS5AnpgdhIVeZyTa7CjegNdQmsIc/IIdYD/4ZNMrbGFyul
	 cqQ35GU5vu/gmNpfTilSjikwuepYy48s5Dz/3zq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Aquini <aquini@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 131/131] Revert "mm: mmap: allow for the maximum number of bits for randomizing mmap_base by default"
Date: Tue, 25 Jun 2024 11:34:46 +0200
Message-ID: <20240625085530.915234193@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 14d7c92f8df9c0964ae6f8b813c1b3ac38120825 upstream.

This reverts commit 3afb76a66b5559a7b595155803ce23801558a7a9.

This was a wrongheaded workaround for an issue that had already been
fixed much better by commit 4ef9ad19e176 ("mm: huge_memory: don't force
huge page alignment on 32 bit").

Asking users questions at kernel compile time that they can't make sense
of is not a viable strategy.  And the fact that even the kernel VM
maintainers apparently didn't catch that this "fix" is not a fix any
more pretty much proves the point that people can't be expected to
understand the implications of the question.

It may well be the case that we could improve things further, and that
__thp_get_unmapped_area() should take the mapping randomization into
account even for 64-bit kernels.  Maybe we should not be so eager to use
THP mappings.

But in no case should this be a kernel config option.

Cc: Rafael Aquini <aquini@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/Kconfig |   12 ------------
 1 file changed, 12 deletions(-)

--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -981,21 +981,10 @@ config ARCH_MMAP_RND_BITS_MAX
 config ARCH_MMAP_RND_BITS_DEFAULT
 	int
 
-config FORCE_MAX_MMAP_RND_BITS
-	bool "Force maximum number of bits to use for ASLR of mmap base address"
-	default y if !64BIT
-	help
-	  ARCH_MMAP_RND_BITS and ARCH_MMAP_RND_COMPAT_BITS represent the number
-	  of bits to use for ASLR and if no custom value is assigned (EXPERT)
-	  then the architecture's lower bound (minimum) value is assumed.
-	  This toggle changes that default assumption to assume the arch upper
-	  bound (maximum) value instead.
-
 config ARCH_MMAP_RND_BITS
 	int "Number of bits to use for ASLR of mmap base address" if EXPERT
 	range ARCH_MMAP_RND_BITS_MIN ARCH_MMAP_RND_BITS_MAX
 	default ARCH_MMAP_RND_BITS_DEFAULT if ARCH_MMAP_RND_BITS_DEFAULT
-	default ARCH_MMAP_RND_BITS_MAX if FORCE_MAX_MMAP_RND_BITS
 	default ARCH_MMAP_RND_BITS_MIN
 	depends on HAVE_ARCH_MMAP_RND_BITS
 	help
@@ -1030,7 +1019,6 @@ config ARCH_MMAP_RND_COMPAT_BITS
 	int "Number of bits to use for ASLR of mmap base address for compatible applications" if EXPERT
 	range ARCH_MMAP_RND_COMPAT_BITS_MIN ARCH_MMAP_RND_COMPAT_BITS_MAX
 	default ARCH_MMAP_RND_COMPAT_BITS_DEFAULT if ARCH_MMAP_RND_COMPAT_BITS_DEFAULT
-	default ARCH_MMAP_RND_COMPAT_BITS_MAX if FORCE_MAX_MMAP_RND_BITS
 	default ARCH_MMAP_RND_COMPAT_BITS_MIN
 	depends on HAVE_ARCH_MMAP_RND_COMPAT_BITS
 	help


