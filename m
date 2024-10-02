Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19AF29CE7;
	Wed,  2 Oct 2024 13:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877153; cv=none; b=oAhoJh+gb+5AeqCP+q0jj+jAcsZTXOUH/7SZ/z/ZOEX31kB3eAco7AJ3KiIoBwm6S/ZXd2U07DqX2e06R5695Pfw7KXfhDYhwYSZ6sTgR21VyS4eXOGMjkwbuJfmAdQIuYf1vA0p4KUY0GlS9CeH+2IJ1dR5pCZsTtjdXdjbXc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877153; c=relaxed/simple;
	bh=s12njMYHMWoHZ9152Sm6b/2/OVAG43nj8yoV1pE4c/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpAPEguA3humyZyVLU1eTVUGhY5pzlWA2dw06Go5ZcFvMLFG7OsVz6duOFPmu+CN6PNEL7wT7dr1QPY40e72UrnBoBfLvJrss2NHlMyjFh8VhPK+lu4uqCK2wg56vlKQ3f8SYlGfZX2pMWqTScxRu4NED2wknT9ENHlxOX8SKxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYIRVsrq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYIRVsrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27271C4CECE;
	Wed,  2 Oct 2024 13:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877153;
	bh=s12njMYHMWoHZ9152Sm6b/2/OVAG43nj8yoV1pE4c/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QYIRVsrq0xkT4Lm7tplWjTvgddbLMj4TVWZeciMOtyhKtWQvOa/XTOBEwUI09tQD0
	 vgfYZAWEnR3Ey1MTlf0s9UA0waHflk9hOWcT8FGuErRfY+YH8UwuCRb/myLF7ddhNB
	 m91V75fmc78KG/uTG+SB20DQObuabhAk8P6bpm2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <davidgow@google.com>,
	Kees Cook <kees@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Linus Walleij <linus.walleij@linaro.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Russell King <linux@armlinux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 682/695] mm: only enforce minimum stack gap size if its sensible
Date: Wed,  2 Oct 2024 15:01:20 +0200
Message-ID: <20241002125849.741863225@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Gow <davidgow@google.com>

commit 69b50d4351ed924f29e3d46b159e28f70dfc707f upstream.

The generic mmap_base code tries to leave a gap between the top of the
stack and the mmap base address, but enforces a minimum gap size (MIN_GAP)
of 128MB, which is too large on some setups.  In particular, on arm tasks
without ADDR_LIMIT_32BIT, the STACK_TOP value is less than 128MB, so it's
impossible to fit such a gap in.

Only enforce this minimum if MIN_GAP < MAX_GAP, as we'd prefer to honour
MAX_GAP, which is defined proportionally, so scales better and always
leaves us with both _some_ stack space and some room for mmap.

This fixes the usercopy KUnit test suite on 32-bit arm, as it doesn't set
any personality flags so gets the default (in this case 26-bit) task size.
This test can be run with: ./tools/testing/kunit/kunit.py run --arch arm
usercopy --make_options LLVM=1

Link: https://lkml.kernel.org/r/20240803074642.1849623-2-davidgow@google.com
Fixes: dba79c3df4a2 ("arm: use generic mmap top-down layout and brk randomization")
Signed-off-by: David Gow <davidgow@google.com>
Reviewed-by: Kees Cook <kees@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/util.c
+++ b/mm/util.c
@@ -463,7 +463,7 @@ static unsigned long mmap_base(unsigned
 	if (gap + pad > gap)
 		gap += pad;
 
-	if (gap < MIN_GAP)
+	if (gap < MIN_GAP && MIN_GAP < MAX_GAP)
 		gap = MIN_GAP;
 	else if (gap > MAX_GAP)
 		gap = MAX_GAP;


