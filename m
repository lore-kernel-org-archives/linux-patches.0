Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4943D23645D;
	Fri, 13 Feb 2026 13:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990819; cv=none; b=YMfSC2H4hh/FSWIKuGkbnQnd2j46wQM34NHTSWrsDxAX/Wb9fT3ZVhUrnDX50vv9SzMP0cUWA3DGr1mMR5t0kx41rHRWzxQU8LN6lBTbck5nI2uG7s4qzb6DV03qBQk8B/cn8WlN6kTix7C6rQHKAYi3Rm53nBaa4iTtkDG42gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990819; c=relaxed/simple;
	bh=emZ0d8tpxH/Os2iIGEE1uzhsw08tuCfWFNtQibX329M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nRxK6cG9B50GfIU19xwZLum5PL1baOJp1KFGTEEYMpSbRzTZQd1gu/leqGzp8UD9XjFZv3z77muYEuFAVZbyHMq7NjfrFZWEJjoT7lb9WBwPjS1H8jI3idsuPtD6cJXTMAtKmChCe0LLajoBgvCzvG8bTxc4fUaG3fdbqhLSPsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wu1JL2xr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wu1JL2xr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D60AC116C6;
	Fri, 13 Feb 2026 13:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990818;
	bh=emZ0d8tpxH/Os2iIGEE1uzhsw08tuCfWFNtQibX329M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wu1JL2xr5zxBINkZ2EAhiZHKtm93n0P8tNM1czLhTD4jCoCF4hCuGvQ34LIc6S9+E
	 kumw1IPSibEwv5VifiGR/EJSP1iAvP+QqR/WTJ3aGLE2Swmz5e1YF3by1t4eT0JBXK
	 UEvQ2kg0BaCbmuQZ+p2NG0WjTZkfVlq7hoYE0VC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.18 32/49] crypto: omap - Allocate OMAP_CRYPTO_FORCE_COPY scatterlists correctly
Date: Fri, 13 Feb 2026 14:48:16 +0100
Message-ID: <20260213134710.056173843@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
References: <20260213134708.885500854@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

commit 1562b1fb7e17c1b3addb15e125c718b2be7f5512 upstream.

The existing allocation of scatterlists in omap_crypto_copy_sg_lists()
was allocating an array of scatterlist pointers, not scatterlist objects,
resulting in a 4x too small allocation.

Use sizeof(*new_sg) to get the correct object size.

Fixes: 74ed87e7e7f7 ("crypto: omap - add base support library for common routines")
Signed-off-by: Kees Cook <kees@kernel.org>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/omap-crypto.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/omap-crypto.c
+++ b/drivers/crypto/omap-crypto.c
@@ -21,7 +21,7 @@ static int omap_crypto_copy_sg_lists(int
 	struct scatterlist *tmp;
 
 	if (!(flags & OMAP_CRYPTO_FORCE_SINGLE_ENTRY)) {
-		new_sg = kmalloc_array(n, sizeof(*sg), GFP_KERNEL);
+		new_sg = kmalloc_array(n, sizeof(*new_sg), GFP_KERNEL);
 		if (!new_sg)
 			return -ENOMEM;
 


