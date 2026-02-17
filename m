Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E85236F431;
	Tue, 17 Feb 2026 20:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361028; cv=none; b=L21xjqCSKZG4VmN9pdr8lfFAnNJAvpHtKEHowP+rshuCdSpslxdziwhS9DVYDAnbBtLK5sjPMJySi8am/h+vrjyAY3LJBS3gJ9c6B1cJeF3N1Ztg0GFPhbtTH7n6Vxy/ZxUhVi2H3zRMMk3fs8RQupJD6itO30A8yCtbjacqNoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361028; c=relaxed/simple;
	bh=K7XgP+XlkzkQHza2DKGySMpVxrmlAg6EpbH/WFCBVP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5Gu/ZJXyx+NBrOYiL8HQE7mWf8+nLs1ykjAPxrsTGS/UU//CBfGqxBQp4S5nKIR4V4Jhpm1b8bD4/xssIzdRxFo+UTmm7WbayRVVz88AKoswPe19fnkbxk4FKhnMKvNkxtxcebfWaAdpUQ9pxPm7laXpEHaBUrw148l3JUDOxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EVbXwQ18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EVbXwQ18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0C1C4CEF7;
	Tue, 17 Feb 2026 20:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361028;
	bh=K7XgP+XlkzkQHza2DKGySMpVxrmlAg6EpbH/WFCBVP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVbXwQ18ouC7e4ASrSugeQdpxLaXqJZfx/cnekd/NOFrDNCi0XPpyMAm9viKq3SMz
	 M9kNxBen1c3C0S7kYBMl1a4sAvutjACX4Xud5Ey2JJbG0d9QQd2Q5zYeMfVgcvZ2ip
	 eNqKoxhYYz/XevDiA9GPAuCGKdbDXnxs/KxSu5gE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 02/39] crypto: omap - Allocate OMAP_CRYPTO_FORCE_COPY scatterlists correctly
Date: Tue, 17 Feb 2026 21:31:11 +0100
Message-ID: <20260217200003.024701449@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200002.929083107@linuxfoundation.org>
References: <20260217200002.929083107@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


