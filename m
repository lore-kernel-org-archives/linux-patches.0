Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E946259CBD;
	Tue, 17 Feb 2026 20:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361197; cv=none; b=Cl9Acr8/VAB/GlcVpgMiPe3pTE9v/SMfkg+8tG8ulXRtV886oJ9XTfI/Pp21VHZMtYGNNkr+IN6VjpNngUau0hCo3YBDNPKd1pDIsdIb+A0YnpDTHk053YCpg6pk3QTUuO1qBBCfXsfJhvf/Jo0ieGDUosSXJwh+z6G3fCHF3ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361197; c=relaxed/simple;
	bh=0qOIRA2CYx/bx8H5MFq6e26SoXg9vRQlvf7QipVPXLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eniiHE3gBkssUm4SaWfJfHswbA6OXtb0BnaB8SwJPGRq8asgfAJfEkLhs352ZDY/oM/39ppOXi0oUaDdT6d0bdcQnOLSx5NVu7pWNeaXr2bO2BXmpf2AfayE19LFLk158TYIJ34D3rBxRuX9HQW8na90DeYcmp98eKr8D5OqCkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JA1vvDI4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JA1vvDI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C940C4CEF7;
	Tue, 17 Feb 2026 20:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361196;
	bh=0qOIRA2CYx/bx8H5MFq6e26SoXg9vRQlvf7QipVPXLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JA1vvDI4hAXoOMk93ajfeCbdxEWj1YIq7HjZMwes3ATQ36vcCl12ro1jbKtplelPa
	 3c2uHdXpZBibRM4bNLnRe6QX/KhCfQO51RiUnn3VMtngR6gHeksPFdjafkVzdUgjbm
	 MWzg3hxGKWFrZK5xrcjnlN67OuH7zodW/m5Ypc/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 05/64] crypto: omap - Allocate OMAP_CRYPTO_FORCE_COPY scatterlists correctly
Date: Tue, 17 Feb 2026 21:31:01 +0100
Message-ID: <20260217200007.711939800@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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
 


