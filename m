Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C8246D56D;
	Tue, 21 Jul 2026 20:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664540; cv=none; b=PtdlLWyEOXAqmKz8IH2ohRgarRiQ1u0OQg5rilNhkaNNii+FuF9HMLUQ2Kj1rzC3y0rGuXs/wfqft25gx8dAVUl1K6QJOR1WUoHPTJPeE/YcUKqdMsiVLLaVeZmZt6sRA7u49ynm6d5rbWJLzHciBh9l3qgQF1Mzlzhqp7dzIc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664540; c=relaxed/simple;
	bh=BWh+HHpla7X5tdXX/cQwIiNrWYmZNO5dlhFBr+2jPNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T12Tjxnu7ej5YEKkWbyAqwtrNppnHmAZ++gxBtixOov92I9TlVtQyiRAAg/c/xGbhAywNgX82ejygAIoIWJEkHsVPIvG16J+dxqranjL/br472ygNVhCcNW2TEyRSeEBnysMzrySvLOhb8+mFjYugP0/0mlxYZ1VxcgG07w6rNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W12tCWKk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W12tCWKk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47CF1F00A3A;
	Tue, 21 Jul 2026 20:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664538;
	bh=YrRDRr7reA6WyGVDqTahcoL9MnC58OdPmS/jdiaRPlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W12tCWKkVU46wkhykunFh8bY2IaOcALr0IfsHAEsSLQO1W5UW2sdu0DHBZX36vBOt
	 cn6TC/i/2vbD5Ff9F7hATAiowrfB7GfKGIWeuWJwHWQGJ6xNVcJzHDYElVr5JCKTao
	 AF7G9goJ2qvrkLubS4GwL+PCUDLbRkG3tyImQ+M4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Richard Fitzgerald <rf@opensource.cirrus.com>
Subject: [PATCH 6.12 1237/1276] default_gfp(): avoid using the "newfangled" __VA_OPT__ trick
Date: Tue, 21 Jul 2026 17:28:00 +0200
Message-ID: <20260721152513.771865146@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -13,8 +13,8 @@ struct vm_area_struct;
 struct mempolicy;
 
 /* Helper macro to avoid gfp flags if they are the default one */
-#define __default_gfp(a,...) a
-#define default_gfp(...) __default_gfp(__VA_ARGS__ __VA_OPT__(,) GFP_KERNEL)
+#define __default_gfp(a,b,...) b
+#define default_gfp(...) __default_gfp(,##__VA_ARGS__,GFP_KERNEL)
 
 /* Convert GFP flags to their corresponding migrate type */
 #define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)


