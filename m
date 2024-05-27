Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142D9168C4;
	Mon, 27 May 2024 19:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837730; cv=none; b=j5cuTJoiV4KtrIVpNgW27kOzAijvO1I63iRVrdriWh8oNTuVYfdxx6nrI71BQezl3agMh8Owdj6tXOevQcIby30cnWGXXS8kszoPsNvhOnrXkZWnqYcqxneqO4fcRGPrDYeL8LTX5Ta5Fx4hqLKbaURCRkBiAlRTo4JGP6er01U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837730; c=relaxed/simple;
	bh=k5mW1Wel9G3kb/rp56RTOPe2tQIDndG0P2C1ENsi+3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqDdXSixtgETFW24RY2hFm8/xaTSbST6+IhHFSAuKLZ6ylzLYQxzFfNKH0l8LEjiLjTqBuSCIaVLx+U9AUmWvTapum5VOAQ5xIuddUN1lSI3nD85isyz0IJSR8XCKetxgnBTW4KsGJXUN3MaPYyiv0Y72DO4JAzjtEVPCv18Z/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cyyymsij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cyyymsij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914C8C2BBFC;
	Mon, 27 May 2024 19:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837730;
	bh=k5mW1Wel9G3kb/rp56RTOPe2tQIDndG0P2C1ENsi+3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CyyymsijAoqJJvPKPFfbECIE07GmmWh/GoOPd2/plWbymJVkPy3RfrNT7l3g9cCf7
	 ZmwMDdiqYXig4xcT54JxDUzlyxAK1y19p8t40tOg6Cx/czOtIbOE+KJezpJDNjTRNI
	 o36xbpHoJsCCXDjIeAwf5RrpJANcEjwKyKWOgv4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 121/493] crypto: x86/sha512-avx2 - add missing vzeroupper
Date: Mon, 27 May 2024 20:52:03 +0200
Message-ID: <20240527185634.460206430@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 6a24fdfe1edbafacdacd53516654d99068f20eec ]

Since sha512_transform_rorx() uses ymm registers, execute vzeroupper
before returning from it.  This is necessary to avoid reducing the
performance of SSE code.

Fixes: e01d69cb0195 ("crypto: sha512 - Optimized SHA512 x86_64 assembly routine using AVX instructions.")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/sha512-avx2-asm.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/crypto/sha512-avx2-asm.S b/arch/x86/crypto/sha512-avx2-asm.S
index f08496cd68708..24973f42c43ff 100644
--- a/arch/x86/crypto/sha512-avx2-asm.S
+++ b/arch/x86/crypto/sha512-avx2-asm.S
@@ -680,6 +680,7 @@ SYM_TYPED_FUNC_START(sha512_transform_rorx)
 	pop	%r12
 	pop	%rbx
 
+	vzeroupper
 	RET
 SYM_FUNC_END(sha512_transform_rorx)
 
-- 
2.43.0



