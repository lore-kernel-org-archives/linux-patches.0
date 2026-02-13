Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04D81684BE;
	Fri, 13 Feb 2026 13:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990979; cv=none; b=ghlBEBk1A00tG2vOxk4R4MTqZCFCir0MnBPyk+Lt1dl/dPZa/YdLDDlxO/rO94LdSyUPvSvgukU9q50a0P5pxLv9Cmf0zCLA4CmHaPFTqW36LkJqLeNlqFBfRa7WGq1E85LGRAGOaqSBzMaGFFrveV8VCrHdUqWX9Jj896QYQtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990979; c=relaxed/simple;
	bh=biuTzwrUNuefADv9Fmc4npa2aI/m/rvv13QTe7pY8Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjNOrhYliaPkD5Hxo4NbajzfptJOCRgjrfB8iuWaj7Tls0PFZy1OOV570oPm4yD2uxrSgZ0skqr1WH9eaWC32CxCrSIzdtlnY+umkMC5H+r/TTx1ocJm81utoQQtvdNyiT/aIRs8WOymplBShobD9HBXebAVnTgc3SPphBwmYlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mwFPHgyN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mwFPHgyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796E4C116C6;
	Fri, 13 Feb 2026 13:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990978;
	bh=biuTzwrUNuefADv9Fmc4npa2aI/m/rvv13QTe7pY8Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mwFPHgyNpBxamDW0M4A/aT5u+Ws67GI+iPRms5Ju4LUxiXnIqFAx9uWcpHAZtVneY
	 h4FjOYaXVbwWy6wOY/AW3coIN+tirVU14ya3ODQMyPFgXSOgxVM6nBcYQU+qpI71Pm
	 RUhcMRYbytXJ93yUwLB38DXxNVqwHQtHcfLZBdSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.12 08/24] crypto: omap - Allocate OMAP_CRYPTO_FORCE_COPY scatterlists correctly
Date: Fri, 13 Feb 2026 14:48:27 +0100
Message-ID: <20260213134705.035269738@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134704.728003077@linuxfoundation.org>
References: <20260213134704.728003077@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


