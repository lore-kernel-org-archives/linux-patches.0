Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B7B149C41;
	Tue, 25 Jun 2024 09:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309386; cv=none; b=PqZxkK1msgDxZ/KEy1R0qgmGcsd9FbBbq58wWDBJhqk+jh1FPjQz/m8UHFUVp7bm5mr9khN28zvMAwDi7SZzw3h2dHNeIiLILMGHhkbpTsYtp+HIybxsPeIxAW4iqfacacvnW8zAY8QfE7oCFkaXhjGA4b4owfVI5F4TljVXArw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309386; c=relaxed/simple;
	bh=w1ddiG5O5CZ6IB2Bb0ogaEncWxax/CrDkaJI738xUak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQ3oj6GqNKAflfadHA1KKPDCfrKmBP2bcjjrTfDl06cFrRFHT/z92N0pT8DXGK+vavHmNRx1CTLT030Bd/gPt1KmS6pcC7asvKTaadNgboizR/NzbW10OU6s5vnVr/95TtT2bzGKFncREeSesq++GPoWE4nkChSshU97nBKx+eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NI9na320; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NI9na320"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDAAC32781;
	Tue, 25 Jun 2024 09:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309386;
	bh=w1ddiG5O5CZ6IB2Bb0ogaEncWxax/CrDkaJI738xUak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NI9na320TIMk6Nk3LiJSZOWSERGxgRt+AEnw6FriJrJGG7qeKoPUj5XfDyOBsKeJJ
	 juitLWR/qAPO4Bzh9tKUqWVpShfe4MnMQEIAjV7x91pY71jX9ETQPlgkTY1rF1cnGF
	 SA6X3xZdpLXGi1LL6M3s9VSP+j78Axfs+0TlNuDo=
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
Subject: [PATCH 6.6 192/192] Revert "mm: mmap: allow for the maximum number of bits for randomizing mmap_base by default"
Date: Tue, 25 Jun 2024 11:34:24 +0200
Message-ID: <20240625085544.529686700@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1037,21 +1037,10 @@ config ARCH_MMAP_RND_BITS_MAX
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
@@ -1086,7 +1075,6 @@ config ARCH_MMAP_RND_COMPAT_BITS
 	int "Number of bits to use for ASLR of mmap base address for compatible applications" if EXPERT
 	range ARCH_MMAP_RND_COMPAT_BITS_MIN ARCH_MMAP_RND_COMPAT_BITS_MAX
 	default ARCH_MMAP_RND_COMPAT_BITS_DEFAULT if ARCH_MMAP_RND_COMPAT_BITS_DEFAULT
-	default ARCH_MMAP_RND_COMPAT_BITS_MAX if FORCE_MAX_MMAP_RND_BITS
 	default ARCH_MMAP_RND_COMPAT_BITS_MIN
 	depends on HAVE_ARCH_MMAP_RND_COMPAT_BITS
 	help


