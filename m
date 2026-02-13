Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409D035F8B7;
	Fri, 13 Feb 2026 13:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990718; cv=none; b=Lv7Iw/Pd3iFEKIj4Mj5JK2AKRYgxtA3Xlk0b/2wUqfg4TCTBIBA9YshjhNl/QqvPdJ1Kcsx/NKNdfXLJciOWI8Eg6oiGlmmooRGRCbSo19e+k2IMnpLQVKgSrawtdMDyBPansR2doDQ4391xeqXCZWnuo6tXf95Hci/HR+uP8W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990718; c=relaxed/simple;
	bh=+a7WV+MJ3PuqK3Lwyj2QAWj8abqjjx5n7KIhqkA94oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SsbbkkuDo+/TLrPM+/c5/ZhGyFvV/dxG2bNiDVAvEp7kCee+Dg9IqM7ifiGgktlpV0lGyoZGKMnwCTqBxU189NUHuJxdUkjnJIqPevBIelMXHVpYOOeu3/AmAiy/96Ls6d+kKDtl+RKav+BYSWIVAYwJ4PX0l0tGLeismYTVFOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/4it3HF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/4it3HF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A664EC19423;
	Fri, 13 Feb 2026 13:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990718;
	bh=+a7WV+MJ3PuqK3Lwyj2QAWj8abqjjx5n7KIhqkA94oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/4it3HFz9mNR3j+I4D0jEpRNVRsvLT6/0tYX1A2h4/iFbYBzxw+P3Tg8Wc+ihOmg
	 kNnkz1pTZWaMcDIZDDlB8jpLt0RAnMrnPYrYDvxDJ+p69IkQm0PJjqbrNj55+Beedw
	 0E1tCX+VGNkPyoX7zgaDX4j8rBavzey8QxIhQjnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.19 32/49] crypto: omap - Allocate OMAP_CRYPTO_FORCE_COPY scatterlists correctly
Date: Fri, 13 Feb 2026 14:47:51 +0100
Message-ID: <20260213134709.903866185@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
References: <20260213134708.713126210@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
 


