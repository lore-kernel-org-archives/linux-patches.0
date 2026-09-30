Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6E33D8908;
	Wed, 30 Sep 2026 19:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795848; cv=none; b=roJriUB/GX9DUuGelwS6tB0O8xNiJDZ26bslin9lukB2TFPlxToTaOzVwsdI0KLdNYhtPNya1ze4+v+1Fx/iID8lixFoJEoZ7qQoHGSUrxlJoe9ESu8+NTlGud5zIiHanfbTnhpwYjFnZHJV4mWQksnGipSwgVHOZzA63zoUC3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795848; c=relaxed/simple;
	bh=3Uj9tTPfxAwwDFzyvbDTnohAsDakUw2YNeH2pbwrW38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJPChbGMvxgL2PayeIlC97+KXky12yqU7xSkbMpxIfmqJ4Ah+ug4QDZ2Ng8lulniCSfPgT1HGtbOfyYeJ/Kw9QivYW3et+oLquNfkuHu4qddmeblrt5Igth9Zg0x16yM3Ql8Qdt+3DT+O/YTiCf/TZsPRsDlAUvYVrlS5HSeEYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CqraYTmW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CqraYTmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179F21F000FF;
	Wed, 30 Sep 2026 19:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795847;
	bh=0pNUTa5ioJWJENlV+W2u8Z00OqgJYz6ZmiOHOSnudg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CqraYTmWGxme704SPPQFhZqMSiXvUnMXUqlxSflyr69eor1/yAn9u7vlBZgoi/Vo8
	 9l/UDk4hAyLJP5VEGTpUVrO8b0mwnqwQPrPcgdR4dgojHIFxaD2xeSCfzSGbHBVLSE
	 JXSBxE/eH4OTzwHQghmgx62YSZqFLnpikdFMWyPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.6 0703/1193] netfilter: nft_set_pipapo_avx2: add missing vzeroupper
Date: Wed, 30 Sep 2026 17:23:07 +0200
Message-ID: <20260930152449.870255320@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 55dd20f0f4b1be5c9c8a0275d8d763c86563eac2 upstream.

Since pipapo_get_avx2() uses YMM registers, execute vzeroupper before
returning from it.  This is needed to avoid degrading the performance of
any later SSE code that may happen to be executed.

Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_pipapo_avx2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1261,6 +1261,7 @@ next_match:
 out:
 	if (i % 2)
 		scratch->map_index = !map_index;
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 	local_bh_enable();
 


