Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774683;
	b=LUh0+ybCBWE+OCuofZ8bDbP9pLdnWl1eFwlqWKZA6aQ5hb6+y/PlPBRGhPjTdlC6gSU0
	 ZLXnHx4ExEcbgcH4Q+25fX4XY8PIKJ0PJouXgW6tnWgyS5DzXSlpHEKJAwYk1w15rZbwW
	 CZgLdQY+jv6O91JXITOrsM4bA/uQrCb5Jry8pHBVIzdgxN/XqQPNHWM2x84RCbOKAbtgS
	 uQvI9FH4tXN+tdgCOWiisuj/RZiuCsewyis5NQNSgKidYDrKC6JUpz30lUmMPyet/vbFM
	 A/cmy4AvN5xg2QkRXDAXLxQP5V74g1tWMRDKSO4b+nXqU77i+4jM58yhq+FINIT4t8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kiqtS73pl7RZxWFAP0InNqRri4XI/5gE86BtTJkaB6A=;
	b=OmYhzA92A05sLLpMIHHeZvyprq0ZfKTMA94g01inLLUyLj9oU6x3y1wPdvYtMrcW8707
	 X7fbC+FRWrgpsKrEUmr+UZkcJ5twn/usKjAlIAzUINfnDwnt+4dGNnMXzEr160JTuGItg
	 19fw7tpL+NuDtbz2BtfIRm1bwoxnOydB5KlmuI6rGrLkTMwumBgOsRoDjM3Z+8oFjGexr
	 5Wu1UKzNPeEYAzYR+lkGpcHFAXSndVWbiEcjQL32zMKyvM3Vq8XpmSxqPm4oAoZmcQYV3
	 gp5iRtiFiTYDPvIysEyMl4r5c0zF7itqHFViUbivTLQXS7en9mYTFvM/wVc/ToVLiCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mt2grxeU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100CC606A31A;
	Fri, 23 Oct 2026 16:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mt2grxeU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E711F01825;
	Fri, 23 Oct 2026 16:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774682;
	bh=kiqtS73pl7RZxWFAP0InNqRri4XI/5gE86BtTJkaB6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mt2grxeUy3406Zme/woPYSidYo8JRsGLiCAYem08Lr1S/t3JpumO33mnBN/0dpvCq
	 9731xb6NPt1Gl7TD3hSAxDizLsZ479NfGaweAIrFC1rigXT0GirR79wp7TdS15H6ip
	 YI6DRjk72vHdDhIEFJSIB4UXjYaQcV+xlrTnaevo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 7.2 122/242] lib/crypto: poly1305: Use memzero_explicit() in poly1305_final()
Date: Fri, 23 Oct 2026 18:39:24 +0200
Message-ID: <20261023163716.666719504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit da619121a5d271e78ec709a1f9a3c5f99b9e10ad upstream.

Use memzero_explicit() instead of a plain struct assignment to guarantee
zeroization of the 'struct poly1305_desc_ctx'.

Note that dead store elimination was only theoretically possible with
link-time optimization here.  But it's still worth fixing.

Fixes: a1d93064094c ("crypto: poly1305 - expose init/update/final library interface")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-c3a6bd76-f6ab-4203-892a-cd06f7aa0c34
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://patch.msgid.link/20261006083432.16328-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/crypto/poly1305.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/crypto/poly1305.c
+++ b/lib/crypto/poly1305.c
@@ -78,7 +78,7 @@ void poly1305_final(struct poly1305_desc
 	}
 
 	poly1305_emit(&desc->state.h, dst, desc->s);
-	*desc = (struct poly1305_desc_ctx){};
+	memzero_explicit(desc, sizeof(*desc));
 }
 EXPORT_SYMBOL(poly1305_final);
 


