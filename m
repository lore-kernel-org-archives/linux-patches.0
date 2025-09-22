Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E002F1FDD;
	Mon, 22 Sep 2025 19:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570047; cv=none; b=YArdGKLy/c/+uyfSYsKQcyKQ4KY+NBoXXhkRG9roTxraim6J+3IOSxUcZ2OgPtA9+F6PXDLJgMfB+Ii0UDgAcPWf4DnYC6czuEVhM2e5fDZyOSWhTW9eRCdFzo0Hvy9wOGghdyRyyf3+j0emYbE3fGQSkQXdY41dM9hF++yLFwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570047; c=relaxed/simple;
	bh=NEiCRgCvtDeqG/CjO+t3hL/TuZoaRI7BtGtIAnlups4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6/PtCFyvmngQdg1IDM1c3SnlNYSifCQhUAKenrHhDZ91f03ZzNAe4zs56Jy8P5AUK05wvRSFZS2CZ9UWcHHtHfcY20oQAb4Yc166UuwVUNA3JxhHLD8ihGxkrwsErPvedi+gy38LKpnnZ0Y1a3k8vOAvqU0hCRle7cnTCo4Hfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HMsMaWQP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HMsMaWQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2D4C4CEF0;
	Mon, 22 Sep 2025 19:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570047;
	bh=NEiCRgCvtDeqG/CjO+t3hL/TuZoaRI7BtGtIAnlups4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HMsMaWQPpqn1oHnAoODebbGvQN9l/P62gkkyGqtnicp5HI5vLxMJ13xIOJ0hDZYu1
	 qd7LftchLOpM/GsxUkySyTxWZ8Q9zhJ8F81Qi64CwA+F2EfNE1mLG84MJ9ep+JgIKw
	 QaqaxG+8lsBLY6SWd/yUIzBmt232i5rDxrc9yt7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight@aculab.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Arnd Bergmann <arnd@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jens Axboe <axboe@kernel.dk>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Pedro Falcato <pedro.falcato@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eliav Farber <farbere@amazon.com>
Subject: [PATCH 6.12 102/105] minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()
Date: Mon, 22 Sep 2025 21:30:25 +0200
Message-ID: <20250922192411.532482714@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit a5743f32baec4728711bbc01d6ac2b33d4c67040 ]

Use BUILD_BUG_ON_MSG(statically_true(ulo > uhi), ...) for the sanity check
of the bounds in clamp().  Gives better error coverage and one less
expansion of the arguments.

Link: https://lkml.kernel.org/r/34d53778977747f19cce2abb287bb3e6@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -106,8 +106,7 @@
 	__auto_type uval = (val);						\
 	__auto_type ulo = (lo);							\
 	__auto_type uhi = (hi);							\
-	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
-			(lo) <= (hi), true),					\
+	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
 	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
 		"clamp("#val", "#lo", "#hi") signedness error");		\


