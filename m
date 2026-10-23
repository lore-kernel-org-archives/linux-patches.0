Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773994;
	b=sUjcW1dUb3dXhBE1NkfEYtG1W146TAQvm1iC/6dWGH7mmhRJJem1SLYrVYYUsp+9Ez7P
	 grQIYWh+sFo20D/sWSRpqLFRgFFXOyRGSUnxfVM7Y2kue09FE7hNMdhyo0rJPRlBolU0F
	 DDTU3aVGi1XAswMOBZS/hUSHRJDI1ZtIa+Du+KuomPq329uKIY9maUgjav0263W1xilN6
	 Nehc5ReivIslNUrEkpfUp2xNZ4P/3R9mC5ozSs5BXztcQ3Y3Hk6Xi7ZZLGstqdghf1Pg0
	 t6Ks/pyRT35oUeSNIf2D1EexAmZP+W7Puh5QRcgpI0OVxUe/86lYTJnod6a2/WJpSNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qq+ZSh0XnxN7sPnJpO3BvgLjtJx/xUPmC28By7FGdFw=;
	b=JEQ1BqvXnkn3+CSBpfplHN9gSwLrZFmVVuZFpo0fQ5SdeJlXDnSDSU6hh31stscp97Tz
	 dQyoaUeZCar/HbPh7dB0y24vYaTi/IMg00HnwwY7Ih39Tztf6Hbl9UufOVbdIRl3CMYfg
	 rEvCpCEIm2tiPDEAITbbA+clAN1JiNtqcWzY9/Pf5reK1Jv1zh8TLJC6CaugDAEkprhWV
	 Efqjo1OfimltMfXzhqP9ujODsNBjCvnbc4EXz899LL09Id5blcjwqPcjCB1DH7eWJcI6Z
	 QVaIqQgrUpH6k9qfjSPXxOPWI1z/9w6cY7YzDjKhX0nSs8PHuwOOlYjeIRvcjhtPxiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jhw0Cvmw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9573C606A326;
	Fri, 23 Oct 2026 16:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jhw0Cvmw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6AD1F031E6;
	Fri, 23 Oct 2026 16:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773994;
	bh=qq+ZSh0XnxN7sPnJpO3BvgLjtJx/xUPmC28By7FGdFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jhw0Cvmwrvama4gZmYn6diC8fp0PHLn3UoapOPzChYC6PHCjjZII9XZaR6DxSbKY7
	 9S3BB1nutebwoyDe9L/PM1WPJ2mhQDVfnALmFFJcCpazZ0YO3xMMt/kzSCPkg4THbz
	 nTDsHsx+RJvDdHOBSG8HotZNF6MndQuREuSRLPTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 084/193] lib/crypto: poly1305: Use memzero_explicit() in poly1305_final()
Date: Fri, 23 Oct 2026 18:36:01 +0200
Message-ID: <20261023163716.193980033@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


