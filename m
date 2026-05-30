Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC613403F3;
	Sat, 30 May 2026 16:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159902; cv=none; b=N/GpgcX9747ZQ7ThO39vXEe2G6JLvX5dpcJKrjJyiauUTIH6FE5j4mOJPQ14uAxS1Wao+jLp5dB5hM2W+bWmmIJBnEKIer+BHZwqlvzcUm3WLtkcwIDEF6LivI3UtRPhP/kzsFVYsXVtlUGr+gBehiwZJp5JsaTp2vonLBDycO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159902; c=relaxed/simple;
	bh=Rtkk95fpc8RAWCNL6L3IJWQTgBAD+u4541ZQi4gvd4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPRz8Qff1vS+C1Spl+NcraVBiHzWum6u4NerWcKx0EGGuK6o4rS3SVr35cwzvFClV1/uHQvAYDZWVqqwKAMp5T+4PjPo45EomPgKQE6xIHjXwJA7UihHlNqUPAVIX87BuMCfMuW2+dQYLb89Y1uH/MaS2gtkNkESdnB5bLkg/bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJNRKGyK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJNRKGyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E071F00893;
	Sat, 30 May 2026 16:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159901;
	bh=pisgsx44NhPwChF5DdasIN+95JiDopbcjzvfrRtr5jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zJNRKGyKA6Iyz9xCDQRZY66DQJUiNY5tPN+tbHbNJONqMy5uiDMmls1dCfMELUtXs
	 pT7JrvfnDD72M6oh8kiMAPXJrfgQ0zOapuT9k2KkMyMEt58zRExO2ufnmIYEUC1Awd
	 jvllU7A/irqMvx+UCXNVNm5dHJf6rIraMDV1dDaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 190/969] lib/ts_kmp: fix integer overflow in pattern length calculation
Date: Sat, 30 May 2026 17:55:14 +0200
Message-ID: <20260530160305.727108269@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


