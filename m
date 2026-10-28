Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216263;
	b=sYFn7M2OAlNLTjgLwzzlWIqC5pLrmZWtifbMDxPFU68kxIga9PKPd+PmB5idYEUu5hZp
	 mlgGoX8Dx19feb/z3zpwMO41bsC0wQC4LWcpsqjCaLH6vKMqYKPgYHmOaSkQzVLDGhXKn
	 TIpMrBjlXNJZw65axpGfPP0NmaVRmRJmX9bIBlOGirJMXg7aKqGaAM2b11OkJTH4bkrAE
	 LpA/KlqkMlOnGi8XKSvYV7WIKuTbB0w+Wojtj02Yym+melP95JieoLrhpHsbRYovjk7r3
	 /mzzY9HYsORIiGfXZiUzXz7niiMkmHEV/ZRKhyHRg+t71d4A06FHaykIx7hvnTUeETg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=usMPjI43EB8304cRKh28+oJ0JVB4k7oIbk1CaeBFfUs=;
	b=DWvQLf8opmK1gxsEma1iYZvVc0ZEtlfY0yqDyme4vgigpKlphhOgmJ552JVYx1L6VNks
	 SphGmEt+qFAglcRxo/8WhETP5us/gcne6qIf6ZCwduKIT5Ph79QD3HRTa17U99siFdQcd
	 kw2/9INlTmD3kR9d69N6ZK8C/e+Q8UWO3kCGmfQihajZu84E8ZeTq4PhoOw7hX8FWvfZf
	 2sEXe90yl0wuLvEMYJmwe7SPEvX9Id+F0kgUfkMyi/zKEHtcIAjhDBzAcGFuUIBqfC6Ab
	 DaALaE48+Fymaz7m3I6TTFY6mvFHwgxz+lergFJP2d96yw8SCLRskN4nlU4z2Jowo1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ILeIq4cO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5567606A33D;
	Wed, 28 Oct 2026 19:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ILeIq4cO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFB91F01828;
	Wed, 28 Oct 2026 19:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216262;
	bh=usMPjI43EB8304cRKh28+oJ0JVB4k7oIbk1CaeBFfUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ILeIq4cO2pheUq2mmw0ZhG/BjLAVJufZBYpRPTbQw1RqGKOhPypwNvc+5tPvFmtFS
	 6a1YEbv591iIdTO7j7uOvEw+HfADgYI0phR/DENTS8J3S/OfEuI+DJmoCLgLhdO2s+
	 IyCryxm/BqFjbKz+WKfQdefCoJWkFRyqsVK6J4ZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1496/1887] ASoC: hdac_hda: Fix hlink refcount leak on component registration failure
Date: Wed, 28 Oct 2026 17:59:52 +0100
Message-ID: <20261028170533.500327368@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit 6ad4892c4f5cb437a928a02f5b7d37d496aa9268 ]

hdac_hda_dev_probe() gets the HDA link with snd_hdac_ext_bus_link_get()
before registering the ASoC component. If component registration fails,
the function returns without dropping the link reference.

Always call snd_hdac_ext_bus_link_put() after the registration attempt so
the reference taken during probe is balanced on both success and failure.

Fixes: 6bae5ea94989 ("ASoC: hdac_hda: add asoc extension for legacy HDA codec drivers")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Link: https://patch.msgid.link/20260622145645.1184986-1-haoxiang_li2024@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdac_hda.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/hdac_hda.c b/sound/soc/codecs/hdac_hda.c
index 21a00c86a1398..4dcb4eb04ec25 100644
--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -612,10 +612,8 @@ static int hdac_hda_dev_probe(struct hdac_device *hdev)
 						&hdac_hda_codec, hdac_hda_dais,
 						ARRAY_SIZE(hdac_hda_dais));
 
-	if (ret < 0) {
+	if (ret < 0)
 		dev_err(&hdev->dev, "failed to register HDA codec %d\n", ret);
-		return ret;
-	}
 
 	snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 
-- 
2.53.0



