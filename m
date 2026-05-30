Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189CC3C455B;
	Sat, 30 May 2026 18:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165702; cv=none; b=ZM7RGpiK/CV416pIOvGIjE0T/bu2sWW/hcIMQP8KA60ck/O4Yzof8dFnHIk9+kMbk/lL3X7XrX8aMzTwtVopg9ov9o/zyd3VjlSPlcTXG9w9qKf1nF2+jgb9xwI/ciQ4gk4J54U8yDHObgVWZRnB0TwSNDzCL9o2DDfRVXcgLj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165702; c=relaxed/simple;
	bh=WlvssRbRH7XABY/AFYLG2dqIzvbpukSvnEv/Xi7RYro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LM1jt3iedfiDK8grI9l13zQW0VVtPnWYWKabQ9qmjVXF6F63CAFjmDGvDBqASsgIWjh/+T/8PgvGhyMdGNawcluOSkj5rFduyadeJvLlGohOaOAyDbf5utSluVzP221ipSkUlhw6Q3f0RB9aXgJcBTT4SroouHrj4YYSANOF55I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJC0OeiT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJC0OeiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573B51F00899;
	Sat, 30 May 2026 18:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165701;
	bh=mWO9wYpzDsYxzUR3lGLp2BkKTvttqtSi7m3tV0w2ZYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mJC0OeiTxuGQSZr0TV0SVxzevPFqmz9i6IQ1qJjgd1tSI+XllMx82TKNApkEAau/8
	 kAqpHMAvv+9nWuLZzMxqSeInO6UtyaB6IHi6Oww1kgm1jIu896oSvC+HXPclXk9S2Y
	 DOU4/rUcuyP/JmB0POGodEFdX2QeO83vM5njLhlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 156/589] lib/ts_kmp: fix integer overflow in pattern length calculation
Date: Sat, 30 May 2026 18:00:37 +0200
Message-ID: <20260530160228.886204977@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Josh Law <objecting@objecting.org>

commit 8cdf30813ea8ce881cecc08664144416dbdb3e16 upstream.

The ts_kmp algorithm stores its prefix_tbl[] table and pattern in a single
allocation sized from the pattern length.  If the prefix_tbl[] size
calculation wraps, the resulting allocation can be too small and
subsequent pattern copies can overflow it.

Fix this by rejecting zero-length patterns and by using overflow helpers
before calculating the combined allocation size.


This fixes a potential heap overflow.  The pattern length calculation can
wrap during a size_t addition, leading to an undersized allocation.
Because the textsearch library is reachable from userspace via Netfilter's
xt_string module, this is a security risk that should be backported to LTS
kernels.

Link: https://lkml.kernel.org/r/20260308202028.2889285-2-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/ts_kmp.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/lib/ts_kmp.c
+++ b/lib/ts_kmp.c
@@ -94,8 +94,22 @@ static struct ts_config *kmp_init(const
 	struct ts_config *conf;
 	struct ts_kmp *kmp;
 	int i;
-	unsigned int prefix_tbl_len = len * sizeof(unsigned int);
-	size_t priv_size = sizeof(*kmp) + len + prefix_tbl_len;
+	unsigned int prefix_tbl_len;
+	size_t priv_size;
+
+	/* Zero-length patterns would make kmp_find() read beyond kmp->pattern. */
+	if (unlikely(!len))
+		return ERR_PTR(-EINVAL);
+
+	/*
+	 * kmp->pattern is stored immediately after the prefix_tbl[] table.
+	 * Reject lengths that would wrap while sizing either region.
+	 */
+	if (unlikely(check_mul_overflow(len, sizeof(*kmp->prefix_tbl),
+					&prefix_tbl_len) ||
+		     check_add_overflow(sizeof(*kmp), (size_t)len, &priv_size) ||
+		     check_add_overflow(priv_size, prefix_tbl_len, &priv_size)))
+		return ERR_PTR(-EINVAL);
 
 	conf = alloc_ts_config(priv_size, gfp_mask);
 	if (IS_ERR(conf))


