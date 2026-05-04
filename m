Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA0B40DFD4;
	Mon,  4 May 2026 14:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903858; cv=none; b=aUfaO1gmWs9mbnBL8jA214OWW6izXVaZn3UdSWTOsvD2cKcOgeqjbcEI8IWb5VCDwxYSQZKSGSWGC/oSuPZHyBHvabydulbkkXUIPyabbAJme5BX/II+sZ77C/vzv3D/KGL1w0qkYzt3XqPLYVhuhjqW86kMeKsjeO4zBZ+l/dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903858; c=relaxed/simple;
	bh=DiQmgTqJNs1H+BxWZ6upDBoS2Qv5AUrCHV/Ymq/qMFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFCh9IaNLJrKIjBws4sSjto3aNhulw3MpBFYSY6V3Iuq0exPBJRC73QmWP/R2hFaYJqNPQrOEGb/rGgC2mrdu+VeTzvtPJK36Hngbe3VwRLKRe0zXMzlPOjtV7WFOQk2ET/INrAO+jhdItgy7xpYR516AVwbdnscObgmQryqSjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1kf0aAFH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1kf0aAFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428FFC2BCB8;
	Mon,  4 May 2026 14:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903858;
	bh=DiQmgTqJNs1H+BxWZ6upDBoS2Qv5AUrCHV/Ymq/qMFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1kf0aAFH3i08xUcViTaPdMJSUcdRs+cHkrw5fYCOjyAFfB/hU6rcdaZCZdECMufEr
	 OHI2GYF8Z/f2Q6Ep/CQ96hiK2kzZCymkUzgp3pzEpT+5pQPdMRUWGLo9CPaTFstlTb
	 FvEWi/cRSL+ki0DV9kjiYA+h5sgbLOc/U6v/N6ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 056/275] lib/ts_kmp: fix integer overflow in pattern length calculation
Date: Mon,  4 May 2026 15:49:56 +0200
Message-ID: <20260504135145.017083393@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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


