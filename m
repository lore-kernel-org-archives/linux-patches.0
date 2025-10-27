Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2887F326D69;
	Mon, 27 Oct 2025 18:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591495; cv=none; b=pzOpZmkz+8cvS3s0mBZ0kykMfhQ0SI684lr/83B97xOGVhebWdqbR6olZXq3HXb2AQTg7vS7chIE1t64yqbVPtV+XAUqoLBvlUGcxVGCi47hXqbIrDF0kv9pslPz/PhrDR043LDcIYZ6IPKBqr90jpdfzNcQIer76HaUAg2+Umg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591495; c=relaxed/simple;
	bh=Rn6qcdOGIFCGZZKQiV9vKsYa5sYuFY7JMJb1wHdLu2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dm8Cwblsayce2mnNZ9K0o43+FALtitmvgU71qE/UJSh+eFJZWe9HLDzQ0kWFwIcfIK0axlZzluNRufAUxXmlizODuPoUxSq6bA/UZBYiU9wQve76pwQmjF6SXOH7ahvUJCvuuLdQV8qbIqR9RG1lJ8o7Yg9FVzaWTDBvBvxHkBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDW1+L1b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDW1+L1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34850C4CEF1;
	Mon, 27 Oct 2025 18:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591494;
	bh=Rn6qcdOGIFCGZZKQiV9vKsYa5sYuFY7JMJb1wHdLu2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDW1+L1b57yjI1m4NVXajBSQdWoYZy3Ct+X1qXadHPc2q76nm8fECFTBck1c1rBSE
	 K51ghtkeeVb/6F4g/oXNRbIClCeODNgvP91RjFBttlgH3k05ll8je2JeIy3EVYgcZ9
	 28JdLXwE86vRo1lk7dmFWDiMdqGkxdyECquNozak=
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
Subject: [PATCH 5.10 217/332] minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()
Date: Mon, 27 Oct 2025 19:34:30 +0100
Message-ID: <20251027183530.494634000@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


