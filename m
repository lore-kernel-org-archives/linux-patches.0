Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DB915278E;
	Thu, 16 Jul 2026 13:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210385; cv=none; b=Vat6C4G81Ff1ni5AUtWPvqYVFdpAkCsUAW2LkHXpmywtiiV4kEmRi/FunBDQ0TYBDKGZHE6aE/nsBpa8ZRZI3kdZcV3pxHSQAIad+kcb44wn/Y9k6RpqdAbn66qYeUITfA/b3A53k4itdwcLFC8q04NXnmCHejQAD/L6Pva4oBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210385; c=relaxed/simple;
	bh=n06TGvu2pREJEOYSbCllbNOVU0N74hQZYsUPXSkgvw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DERIkqsp+cgYuByvxIfS+v303q7PasEur8JAHy/xFH92UBRENgIm7HRqRlNCJvJbPL6/hg8yipeFEaYgsQ5IQqYxPZ584W276zF/R4aVn2SLzTM++xcPmMUaeV3SxOMj3tmT2fnHnmzgu8aBslXkg8FvTSAO6zPGZbGvQvBmncM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tsMo1bUC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tsMo1bUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4181F000E9;
	Thu, 16 Jul 2026 13:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210384;
	bh=bd7aQeRpoRv4n9O01+1UAfHwSC4htfgC1lvroqh/Zjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tsMo1bUCyAbqhE/yFwj4gv820nzMUhasOfWDz5OV+pYBY6WG7TDCSTuK/mkFUAsS2
	 cijVt41GDdEADfg7eGlx/lQ3BcPclk2fmBtUGo9dEr4r4rF79ULR0Ci3J3iyzh3YT0
	 taLmzJNDSYXYrPtcL9nWGc9dNS45tki/zghD6gY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Richard Fitzgerald <rf@opensource.cirrus.com>
Subject: [PATCH 6.18 027/480] default_gfp(): avoid using the "newfangled" __VA_OPT__ trick
Date: Thu, 16 Jul 2026 15:26:14 +0200
Message-ID: <20260716133045.281547152@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 551d44200152cb26f75d2ef990aeb6185b7e37fd upstream.

The default_gfp() helper that I added is not wrong, but it turns out
that it causes unnecessary headaches for 'sparse' which doesn't support
the use of __VA_OPT__ (introduced in C++20 and C23, and supported by gcc
and clang for a long time).

We do already use __VA_OPT__ in some other cases in the kernel (drm/xe
and btrfs), but it has been fairly limited.  Now it triggers for pretty
much everything, and sparse ends up not working at all.

We can use the traditional gcc ',##__VA_ARGS__' syntax instead: it may
not be the "C standard" way and is slightly less natural in this
context, but it is the traditional model for this and avoids the sparse
problem.

Reported-and-tested-by: Ricardo Ribalda <ribalda@chromium.org>
Reported-and-tested-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Reported-by: Ben Dooks <ben.dooks@codethink.co.uk>
Fixes: e19e1b480ac7 ("add default_gfp() helper macro and use it in the new *alloc_obj() helpers")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/gfp.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -14,8 +14,8 @@ struct vm_area_struct;
 struct mempolicy;
 
 /* Helper macro to avoid gfp flags if they are the default one */
-#define __default_gfp(a,...) a
-#define default_gfp(...) __default_gfp(__VA_ARGS__ __VA_OPT__(,) GFP_KERNEL)
+#define __default_gfp(a,b,...) b
+#define default_gfp(...) __default_gfp(,##__VA_ARGS__,GFP_KERNEL)
 
 /* Convert GFP flags to their corresponding migrate type */
 #define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)


