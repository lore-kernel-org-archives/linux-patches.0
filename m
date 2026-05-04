Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354AC35A3AD;
	Mon,  4 May 2026 14:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904296; cv=none; b=L6gU2eAdCgQEY9NW5G7GEnZfnnHYrb/8OG+IePXG6NkQPYAJpGjNbJ4P7qVBLi0nHu87jLBbKFuzwuFfkoShmT/c03TSrEHWYgvBbCw4B9xzsTPAA1na9pZjvoERpJn4A1uGN/Po8tjXrUJXcvFKHFpBAaW0Kqw/gfdPlk8VhRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904296; c=relaxed/simple;
	bh=ZG1kpPpxue3FvgotWAugZ1ajNm885dNEi8kFYQKUf34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tyxYi9qst9lan8TR6+xI1/iC/JTSoHLl4O8CbwCMSY2Gm4L+mv3qWnyo1HVgysE/VL7z7Egp08In6tOBB1hbdFrR70x2oRMMQFz9DhBh6nyNgbM7IQvGmCNa8tlYpTvb8GltLA2kGVtwXHkgQvQoHlAChFqXF+I26NywQaoA4x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FixCPa0c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FixCPa0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C8CC2BCB8;
	Mon,  4 May 2026 14:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904295;
	bh=ZG1kpPpxue3FvgotWAugZ1ajNm885dNEi8kFYQKUf34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FixCPa0cQ82UD+XEJHr8+qDIyg8+4ZidMUnDU3NwhJD4wBhYvosLgawzNUuFjbV1C
	 JDMemLkROplgb9BqibrVGv60w9QODWtwsfP8ZiGbsPW4zCGo+LjQlnvQy4Yxg5fmp9
	 L3RQ57jWYNulDnwDaG2OB4JvaxLM07pcwtnnfc9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 232/275] crypto: nx - Fix packed layout in struct nx842_crypto_header
Date: Mon,  4 May 2026 15:52:52 +0200
Message-ID: <20260504135151.673423813@linuxfoundation.org>
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

From: Gustavo A. R. Silva <gustavoars@kernel.org>

commit b0bfa49c03e3c65737eafa73d8a698eaf55379a6 upstream.

struct nx842_crypto_header is declared with the __packed attribute,
however	the fields grouped with struct_group_tagged() were not packed.
This caused the grouped header portion of the structure to lose the
packed layout guarantees of the containing structure.

Fix this by replacing struct_group_tagged() with __struct_group(...,
..., __packed, ...) so the grouped fields are packed, and the original
layout is preserved, restoring the intended packed layout of the
structure.

Before changes:
struct nx842_crypto_header {
	union {
		struct {
			__be16     magic;                /*     0     2 */
			__be16     ignore;               /*     2     2 */
			u8         groups;               /*     4     1 */
		};                                       /*     0     6 */
		struct nx842_crypto_header_hdr hdr;      /*     0     6 */
	};                                               /*     0     6 */
	struct nx842_crypto_header_group group[];        /*     6     0 */

	/* size: 6, cachelines: 1, members: 2 */
	/* last cacheline: 6 bytes */
} __attribute__((__packed__));

After changes:
struct nx842_crypto_header {
	union {
		struct {
			__be16     magic;                /*     0     2 */
			__be16     ignore;               /*     2     2 */
			u8         groups;               /*     4     1 */
		} __attribute__((__packed__));           /*     0     5 */
		struct nx842_crypto_header_hdr hdr;      /*     0     5 */
	};                                               /*     0     5 */
	struct nx842_crypto_header_group group[];        /*     5     0 */

	/* size: 5, cachelines: 1, members: 2 */
	/* last cacheline: 5 bytes */
} __attribute__((__packed__));

Fixes: 1e6b251ce175 ("crypto: nx - Avoid -Wflex-array-member-not-at-end warning")
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/nx/nx-842.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/nx/nx-842.h
+++ b/drivers/crypto/nx/nx-842.h
@@ -159,7 +159,7 @@ struct nx842_crypto_header_group {
 
 struct nx842_crypto_header {
 	/* New members MUST be added within the struct_group() macro below. */
-	struct_group_tagged(nx842_crypto_header_hdr, hdr,
+	__struct_group(nx842_crypto_header_hdr, hdr, __packed,
 		__be16 magic;		/* NX842_CRYPTO_MAGIC */
 		__be16 ignore;		/* decompressed end bytes to ignore */
 		u8 groups;		/* total groups in this header */
@@ -167,7 +167,7 @@ struct nx842_crypto_header {
 	struct nx842_crypto_header_group group[];
 } __packed;
 static_assert(offsetof(struct nx842_crypto_header, group) == sizeof(struct nx842_crypto_header_hdr),
-	      "struct member likely outside of struct_group_tagged()");
+	      "struct member likely outside of __struct_group()");
 
 #define NX842_CRYPTO_GROUP_MAX	(0x20)
 


