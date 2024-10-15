Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8401E6321;
	Tue, 15 Oct 2024 13:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997705; cv=none; b=pD6phZg7EngIBz7WI8Eh7wlObqHCzYYHOHVkMwbr8PuVsXBidWbc9bYJJ0AZwxyWo75UpZo0hcORkIOv2Xpc13u4kEc5A6OiRd4Z/a1lBIHhFrOxFotFqi0I7cGCDB8MG2V3VeLrSNvBDUhKpxgC1gEvkZkfimDYtgjagxh/OX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997705; c=relaxed/simple;
	bh=jcbpVEyth8SPWGERu3oZcOluGafSgQb0wO6PPERLGeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aThleIrdw7ygj/CEOp6JeKoRRwzPEVDYSie/V13PI9haVqvqec37yNmJxjRS0OO1iVP2dIPA/Pd93k4MZ/jxePp78aC+QulHD73YzGkaS5Q7/b4raS7n1+E7D8I9N8QSWR09b6G37LMILwLPGW2wFpJc9TZ4Vo8HbByCQ9xnePQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrBdnTud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrBdnTud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0056AC4CEC6;
	Tue, 15 Oct 2024 13:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997705;
	bh=jcbpVEyth8SPWGERu3oZcOluGafSgQb0wO6PPERLGeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrBdnTud8+NAyGokHZ9S0lMzdiVAd73eDwZyvx0FHdbGSwWLsMzzS+UuvhDgBtXE/
	 ukC5I1Nv+tfzI2qz6BazDTGyBqh9kOt+6HajDoU2I51OFaKhIUdVWZ7M5kwZP40IQv
	 QlLeJt69wWHiOoaQNvawF/349NUgpJ7HVCHNVWQY=
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
Subject: [PATCH 5.10 261/518] mm: only enforce minimum stack gap size if its sensible
Date: Tue, 15 Oct 2024 14:42:45 +0200
Message-ID: <20241015123927.067058112@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -418,7 +418,7 @@ static unsigned long mmap_base(unsigned
 	if (gap + pad > gap)
 		gap += pad;
 
-	if (gap < MIN_GAP)
+	if (gap < MIN_GAP && MIN_GAP < MAX_GAP)
 		gap = MIN_GAP;
 	else if (gap > MAX_GAP)
 		gap = MAX_GAP;


