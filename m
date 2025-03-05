Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B323A250C1C;
	Wed,  5 Mar 2025 17:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197508; cv=none; b=MuP9T+oir3/Q3EwxZWcXbI+sj2ZEnzaRe0iezI1J81Wvj3S+KckLQfYYV0ASSYMliVBQeGzLSOL86r+MDezYrSAf4y2S0dazOJDlOsczPJN6D59LeSvvsWw+mwX+seQ8BR0iGp+Rk/4qTkM0MTzglzTs6tl5N5lUYcpoM8aUmVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197508; c=relaxed/simple;
	bh=hF7Noqln4G9ZBVxU+ZzFSI/vKq1lZyxMmRFwvbFD0Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jN1O6hYs8WwWvsD5d1SiAOA9oK8gVgnZk2E2aGIo23SuexdA9hSHLT/FYTRY8NGjGkKocJOtKDfx6yanEhAmb8Wt3mzkwAoiu0N6OCEvkoXCEuTAMuJGvd+xDII+NQxhW+8RA7+ixM0AKeFhTjB60MJ6Yw35X6aB72j31b6NEl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KP1cxKKg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KP1cxKKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C767DC4CEE0;
	Wed,  5 Mar 2025 17:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197508;
	bh=hF7Noqln4G9ZBVxU+ZzFSI/vKq1lZyxMmRFwvbFD0Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KP1cxKKgwCHoFz4oEuTBzcKaouVwpf5PU6vtkrBM5HmzBcUuZ2FqsLXiKtWDsSVQ8
	 cLEPWHpPVRiADTi2z46EJluJD5BAJkOPnuSFRh8EW3TOQ+WVkqhtMfOX7u09FjPUY+
	 9drX3K7nc7V8gl2f1ePp6IJh9cbu/25UgL+zR2xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Ruoyao <xry111@xry111.site>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 6.1 173/176] mm/memory: Use exception ip to search exception tables
Date: Wed,  5 Mar 2025 18:49:02 +0100
Message-ID: <20250305174512.382196302@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit 8fa5070833886268e4fb646daaca99f725b378e9 upstream.

On architectures with delay slot, instruction_pointer() may differ
from where exception was triggered.

Use exception_ip we just introduced to search exception tables to
get rid of the problem.

Fixes: 4bce37a68ff8 ("mips/mm: Convert to using lock_mm_and_find_vma()")
Reported-by: Xi Ruoyao <xry111@xry111.site>
Link: https://lore.kernel.org/r/75e9fd7b08562ad9b456a5bdaacb7cc220311cc9.camel@xry111.site/
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5323,7 +5323,7 @@ static inline bool get_mmap_lock_careful
 	}
 
 	if (regs && !user_mode(regs)) {
-		unsigned long ip = instruction_pointer(regs);
+		unsigned long ip = exception_ip(regs);
 		if (!search_exception_tables(ip))
 			return false;
 	}
@@ -5348,7 +5348,7 @@ static inline bool upgrade_mmap_lock_car
 {
 	mmap_read_unlock(mm);
 	if (regs && !user_mode(regs)) {
-		unsigned long ip = instruction_pointer(regs);
+		unsigned long ip = exception_ip(regs);
 		if (!search_exception_tables(ip))
 			return false;
 	}


