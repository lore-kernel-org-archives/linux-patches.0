Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CC8293B75;
	Wed, 30 Jul 2025 09:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868790; cv=none; b=Y8D/t8JtCi2Ordfv6A0WNeDsk/Iw/fHVpZmVFxEbAyT+/kgV153cgABuA1C266IG/CBtNDInl8DfofDL2/98j8E3Qy80lPgNB6/VYFz1hpKSYwQpDCh+sygdj5+zBzaTyC07/kCToZ0WniLeGIxo7nwNdWwdy8fa+FfgZEdLIkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868790; c=relaxed/simple;
	bh=Yg16AQsoVBakFk4Q9Av+KOwHGxkhDSaniSN3cDlr/Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9G5+uaWppDOEXzAu046DKphStdgD3aavh/XB9Uh6ILrCw2ycYHX9a+xDfx8JDAMM7MZDfN2lyJjXhWQJUdZ72HV8KwUWNNn98SLgmTSC2cAc7/8PxhwaiDBc8v698kCwfJ6L//YXK9c6CeVkuRkJjeQ5WCVzoEHEEw1yIMplfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6V8coqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6V8coqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A36C4CEF8;
	Wed, 30 Jul 2025 09:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868790;
	bh=Yg16AQsoVBakFk4Q9Av+KOwHGxkhDSaniSN3cDlr/Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C6V8coqPY/odlFFr2yFl6JFWW6JnwMIZ/cFOE4ttTcFx+UWTJS6q5uZ9Q9fMdNTno
	 wIu2l1vK+cG2ruKMXo8GzbM1RKumQIJ1DSwqKaYGwMCtiFyJfDX7njtRYd/ukY1o76
	 TDRd+P7s4CUDkX9WRqp39/yhgmm2sB9bBndCLevY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/117] crypto: powerpc/poly1305 - add depends on BROKEN for now
Date: Wed, 30 Jul 2025 11:35:45 +0200
Message-ID: <20250730093236.499636813@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit bc8169003b41e89fe7052e408cf9fdbecb4017fe ]

As discussed in the thread containing
https://lore.kernel.org/linux-crypto/20250510053308.GB505731@sol/, the
Power10-optimized Poly1305 code is currently not safe to call in softirq
context.  Disable it for now.  It can be re-enabled once it is fixed.

Fixes: ba8f8624fde2 ("crypto: poly1305-p10 - Glue code for optmized Poly1305 implementation for ppc64le")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ applied to arch/powerpc/crypto/Kconfig ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/crypto/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/crypto/Kconfig
+++ b/arch/powerpc/crypto/Kconfig
@@ -143,6 +143,7 @@ config CRYPTO_CHACHA20_P10
 config CRYPTO_POLY1305_P10
 	tristate "Hash functions: Poly1305 (P10 or later)"
 	depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
+	depends on BROKEN # Needs to be fixed to work in softirq context
 	select CRYPTO_HASH
 	select CRYPTO_LIB_POLY1305_GENERIC
 	help


