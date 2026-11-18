Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036559;
	b=EX4mt88xsE2h2/RTOzp2TZMu1VlXtkUtTUQPKLDekoV0pvWRFmHr+yd+ePJgs2LN2KAx
	 eEKQLgm8aan024uHMmJtWHO+Hd1TimIZAnBc7GzqP01tkA2ZoIT+7GL/KSgPGJ7acH+vo
	 DQHC+8WEWuilz7Yj7wt3khaK9NLWJy0TouJiJ9SSTL6kyCbMV+lNifHOA2Rcyfyc9Jzq4
	 ZWJ/4HHZlIrB0vVocz3G2pRlYaPv+9YHpMa+dgFxbJyf/4F07WjwjFkOfCe8pDsRGfzft
	 kVGmyk7htxGiMsXXp/VZGDF1anofaIbwogTqUB0YDg2IgWZt6QQIn6sTqiBuHkFs9Ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sr4wrBq2SsqAZJsea2gLkhOLGhH1TpwkQOPQMnFY5sk=;
	b=ABvUf9IYgT9DNr3v6jZ2/qPIXU4GOIomAn9KBP1QHO1TOKcuf2gwTIJvFKmGOXeG87b1
	 o5xAkHajc/gG06dVG8nNTiR3k4NtS4VvKVlOVpoy4TKlUIzorQ7BIcGZG+pdT7BbCqP2m
	 JAxSPCVYA0JGI86tftSrDzm01pC4Qz6RbicyPSTEylaI91fPyvXIGKBlwLEDJpJwr6rTO
	 k8Fc6VIbrDsvg4ErCC9415ZlYX2AQ/fUnCV6tW4IiPv/yh/IqCz1tDndJfPJl9Alke/B7
	 4a49fA06GAI2rMkhXFSH+AEKhhetUT/0buaaeuRja9Ja2QVA8c+TP53RtU3xDzG4qUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S1E9wwCs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AB260A2600;
	Wed, 18 Nov 2026 21:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S1E9wwCs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0361F000C4;
	Wed, 18 Nov 2026 21:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036558;
	bh=sr4wrBq2SsqAZJsea2gLkhOLGhH1TpwkQOPQMnFY5sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S1E9wwCsGbJ1WSElBpAR1588zaGGUThh0jBP9q51Yz9NEPVIKbDsGmIwC2Rwav7ie
	 31FTWFGQAsLiuGqJuZrpeHBGRu8bDl2A697W3RS00knhI9YpSYRTKc16jn5jz1+ux0
	 62W2FCzZtSQDoTxDcTYYf2Ds4Z3v3kHcBPVo/cRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alain Knaff <alain@knaff.lu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1101/3318] lib: decompress_bunzip2: fix integer overflow in run-length decoding
Date: Wed, 18 Nov 2026 15:28:43 +0100
Message-ID: <20261118150353.016029594@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aamir Ahmed <elb12345@hotmail.co.uk>

[ Upstream commit b822ad8d702df0be9fe3f24f71caeb0522d72319 ]

The RUNA/RUNB decoder in get_next_block() accumulates a run length into
the signed int t with no bound.  runPos doubles per symbol, so t grows as
at least 2^n-1 and reaches INT_MAX after 31 RUNA symbols.  The guard that
follows, dbufCount+t >= dbufSize, is itself a signed addition, and as the
kernel builds with -fno-strict-overflow it wraps negative once dbufCount
is nonzero, so the guard is skipped.  while (t--) dbuf[dbufCount++] = uc
then writes INT_MAX entries into a buffer holding at most 900000.  One
literal symbol ahead of the run is enough to make dbufCount nonzero.

Bound t to the block size as it is accumulated.  t only grows within a
run, so the value tested never exceeds the final run length; any stream
that decodes today satisfies dbufCount+t < dbufSize at the flush, hence t
< dbufSize throughout, and no such stream is rejected.  Because t grows as
at least 2^n-1 the bound trips by the 20th symbol, leaving runPos at most
2^19, so the following runPos <<= 1 cannot overflow either.

Link: https://lore.kernel.org/AS8P251MB00010FE5E38D253CF98A652AC8B92@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
Fixes: bc22c17e12c1 ("bzip2/lzma: library support for gzip, bzip2 and lzma decompression")
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Alain Knaff <alain@knaff.lu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/decompress_bunzip2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index 4f98cdea7e0b3..b8fb40ed06d22 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -428,6 +428,10 @@ static int INIT get_next_block(struct bunzip_data *bd)
 			t += (runPos << nextSym);
 			/* +runPos if RUNA; +2*runPos if RUNB */
 
+			/* Bound the run so t and runPos cannot overflow. */
+			if (t >= dbufSize)
+				return RETVAL_DATA_ERROR;
+
 			runPos <<= 1;
 			continue;
 		}
-- 
2.53.0



