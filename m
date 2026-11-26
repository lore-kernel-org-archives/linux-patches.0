Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704119;
	b=z3X/6jQVhimnAp/VCbA2fjsbfIFHoyaSDnTBLIMdxJg4UAofwh1BViRlTNLWitti7bpK
	 MIKIFM9asMYZC1wvXBSE1rwf8WWbbcN5q4PkVAuTQhmT+MFzMAKKzmaIZtt2ESBfhY2v7
	 2sv21VnK/e+ZaKw5+2hxw97o/9v6npg2DTStEYIs4xL9k926szd/IIJrCO/SilZkU2zAW
	 9qCyto9YdIhKSlEx84aiQb4CpiFeClgdMXdZRPW6jIAkT3BRHwMgL91A+B/MXd1+fvQDM
	 ODGY+jv4BF4iIWpWcTb19LVe7LkQfwkGqCt/PcwYtUfB3c/BFo/sVNZmuT75Onei33w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T5G6inUwcNTFH/ei6zBVHv8940otMv1pzHpT8w0cuF0=;
	b=CJWTvkzagetm36YFsCrW0ZN7EnDuzPHCY6vhLhsN6mFQwFERT3/VCvtN9DWeGH+E2+e/
	 6RZxksT2I7mhN6EPAOkH9wgkYGWThpV8jjKYVbyXt2F7593HBx3ijGYKV2Hln72NPQcMQ
	 NAoFpYIRSjcU0LrNYMcgNcFwPAX3kVf82jeUAWK6lfKaPItTs6VdAa2sElp+NYVhsWztW
	 NOsTEbRxER+sUSfqmvno3dj7UjIaXBgrxJW8RRzDeHW+DJhWtT2vcD8NZG9/PXunI6By/
	 mmTsA/W+/go6BaPSDsZH/LE5HpS0abXuQrmPJWOXsWMaWK4v6V5gUt6mxEP7ZUhv0iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JM3lbnqh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E769C606A32A;
	Thu, 26 Nov 2026 14:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JM3lbnqh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32D31F000C6;
	Thu, 26 Nov 2026 14:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704118;
	bh=T5G6inUwcNTFH/ei6zBVHv8940otMv1pzHpT8w0cuF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JM3lbnqhu4qMGcnzlmY0v4U0UPf1OJU1DFOobf9rA0E1o8tkuvdm0IumHhMtnKpke
	 R5k7na+tWvthUphzbt7CVuwbD/dxyPz4Ov04KcgV0TXrmc/3FqjaGSco8h8wC6iLIa
	 YJHyCdXyovp0Nya1SiyAW2gqnkgvCg7mc/W1hjqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang He <windhl@126.com>,
	Mark Brown <broonie@kernel.org>,
	"Nobuhiro Iwamatsu (CIP)" <nobuhiro.iwamatsu.x90@mail.toshiba>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/265] ASoC: mt6359: Fix refcount leak bug
Date: Thu, 26 Nov 2026 15:35:43 +0100
Message-ID: <20261126143606.007253231@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liang He <windhl@126.com>

commit a8d5df69e2ec702d979f7d04ed519caf8691a032 upstream.

In mt6359_parse_dt() and mt6359_accdet_parse_dt(), we should call
of_node_put() for the reference returned by of_get_child_by_name()
which has increased the refcount.

Fixes: 683530285316 ("ASoC: mt6359: fix failed to parse DT properties")
Fixes: eef07b9e0925 ("ASoC: mediatek: mt6359: add MT6359 accdet jack driver")
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220713102013.367336-1-windhl@126.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[iwamatsu: Drop patch for sound/soc/codecs/mt6359-accdet.c]
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro.iwamatsu.x90@mail.toshiba>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/mt6359.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/mt6359.c b/sound/soc/codecs/mt6359.c
index 81aafb553bdd9..4eb199a190c90 100644
--- a/sound/soc/codecs/mt6359.c
+++ b/sound/soc/codecs/mt6359.c
@@ -2668,6 +2668,7 @@ static int mt6359_parse_dt(struct mt6359_priv *priv)
 
 	ret = of_property_read_u32(np, "mediatek,mic-type-2",
 				   &priv->mux_select[MUX_MIC_TYPE_2]);
+	of_node_put(np);
 	if (ret) {
 		dev_warn(priv->dev, "%s() failed to read mic-type-2\n",
 			 __func__);
-- 
2.53.0



