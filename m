Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C54378D9B;
	Tue, 17 Feb 2026 20:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360905; cv=none; b=QBgN+LJUG4agdNuwBh7k7RAtHDqk8JdyfaBbbeWQ2HZRiyvD9bcdGb9igVstGom63D6CfmRG9793Mryn/xS/fjZyGsn+qIsbUY0VcTrh030lic/9uIhX4j7cTODxmjdzdsYWSXE5tuik1Qu2lakDErVwbCgSMsyvYm6dVI38y8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360905; c=relaxed/simple;
	bh=U210NVv1GXc5bOxQPhZPN0R4NecCwGGHfZQuooMaUTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1akPP/fBMQHkyppoS3FvfFyVDPSZaRPvm/SYIWNg9F82d6M3zf5TnnODfGsi8MRBCVeDJl6rXfD8+TxytwYzQwrOYEnAnwYP43yBDtnSSZZ4LPhXLVCj9eVpTY4HUfVpd8u4iu7K9cp/9aaXyu6FFGrHZiOtQzMPRjWkrUB/NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lM4aYlB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lM4aYlB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6CEC19421;
	Tue, 17 Feb 2026 20:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360905;
	bh=U210NVv1GXc5bOxQPhZPN0R4NecCwGGHfZQuooMaUTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lM4aYlB25UfWWyWiP+bb/puzHXZiPgi0Wz6/d+ZptbP9Pw8AO+xhPgFG4NBbcEeDl
	 +lUa6pFbOAyIvY4M6Qw9jX1nCsX7SJNx/HDNXQyitU/+zE0BFOtRC3kyASi0wf+ezp
	 YKDLQfynpaEACa2zfWuvu4YXrju2suB2fY2jCGLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 02/24] crypto: omap - Allocate OMAP_CRYPTO_FORCE_COPY scatterlists correctly
Date: Tue, 17 Feb 2026 21:31:15 +0100
Message-ID: <20260217200000.806811132@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200000.708219618@linuxfoundation.org>
References: <20260217200000.708219618@linuxfoundation.org>
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
 


