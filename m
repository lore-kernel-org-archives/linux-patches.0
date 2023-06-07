Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EBA3925A
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:21:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25110C433D2;
	Wed,  7 Jun 2023 20:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169271;
	bh=r2vBJmuPSiqnGNFd/mh0t1cCksRZm4Mq4et+X2Sv048=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hhW3UAjEX4OPOioOjTZWSsoWZYsqrBpdnK/5S5YUoSHAsqGtfnLWdXHQyeYnMQuWs
	 XlX9GsiSIQZA0J14HNUz+/SSxY1E1fFWog8Q/zmJRkFJFxOVcsQLqIH9AhDirkPqnW
	 8/ocj1/mtsKhSIPzJURXXlYIQsAIShzohLMJJgVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	syzbot+a6abcf08bad8b18fd198@syzkaller.appspotmail.com,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 018/286] crypto: x86/aria - Use 16 byte alignment for GFNI constant vectors
Date: Wed,  7 Jun 2023 22:11:57 +0200
Message-ID: <20230607200923.600616276@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 6ab39f99927eed605728b02d512438d828183c97 ]

The GFNI routines in the AVX version of the ARIA implementation now use
explicit VMOVDQA instructions to load the constant input vectors, which
means they must be 16 byte aligned. So ensure that this is the case, by
dropping the section split and the incorrect .align 8 directive, and
emitting the constants into the 16-byte aligned section instead.

Note that the AVX2 version of this code deviates from this pattern, and
does not require a similar fix, given that it loads these contants as
8-byte memory operands, for which AVX2 permits any alignment.

Cc: Taehee Yoo <ap420073@gmail.com>
Fixes: 8b84475318641c2b ("crypto: x86/aria-avx - Do not use avx2 instructions")
Reported-by: syzbot+a6abcf08bad8b18fd198@syzkaller.appspotmail.com
Tested-by: syzbot+a6abcf08bad8b18fd198@syzkaller.appspotmail.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/aria-aesni-avx-asm_64.S | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/crypto/aria-aesni-avx-asm_64.S b/arch/x86/crypto/aria-aesni-avx-asm_64.S
index 9243f6289d34b..ed6c22fb16720 100644
--- a/arch/x86/crypto/aria-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/aria-aesni-avx-asm_64.S
@@ -773,8 +773,6 @@
 	.octa 0x3F893781E95FE1576CDA64D2BA0CB204
 
 #ifdef CONFIG_AS_GFNI
-.section	.rodata.cst8, "aM", @progbits, 8
-.align 8
 /* AES affine: */
 #define tf_aff_const BV8(1, 1, 0, 0, 0, 1, 1, 0)
 .Ltf_aff_bitmatrix:
-- 
2.39.2



