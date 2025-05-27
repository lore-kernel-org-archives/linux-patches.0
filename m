Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D716B139579;
	Tue, 27 May 2025 17:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365841; cv=none; b=carlFmxL+nAGPAhk/dxSIXGaO166PuOJ8BV2OgFHs9o7hidXriJtSrDylMa0pnjJnWCpfjj0bn6ntz8Xpo5gdoXJrO6p2u0bBkQuUBstwep/SYJrozS2njeXm+Pi5uiaKe0N1p0Yz1rZ5S7kjrEQ4X566SINvgmrZvn9PteIFdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365841; c=relaxed/simple;
	bh=QL36vpgIej8PF9zmRbcj+oc1OUzUHcCfY+qY0yvuU7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvLIDbFfoOHtCwfrsfOV73d7cdZLH1j3wdL9OdAeHb1OLO2V9D+Ef7Naeiz98YIjvkfMMR+s4d+VF++7wnKoBBRY8CYQIS0fVmgsn9/v65SK9Wn29JUt9zcBunz9o/Mw/ERtv1IXl9xXGe7JKwHa7JCK4UwRQZoWzeYhWu5O+rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FjDgqsPZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FjDgqsPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66178C4CEE9;
	Tue, 27 May 2025 17:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365841;
	bh=QL36vpgIej8PF9zmRbcj+oc1OUzUHcCfY+qY0yvuU7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FjDgqsPZErTfqZpridk9sMfjOTkpCdCS0U8A2rhiTffdzj/5JxnNtyTDuzgpXWC6P
	 tad6+GcSsN1Jnt4b73stALPM+Bhwips+GYRtIbaUjv4QiaZ+ezJJCDUhAab7xMvbh4
	 rWeHRXJt1Vj1t42VNitXWbaw6EP6zwZGnWQQQANQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 505/626] ASoC: imx-card: Adjust over allocation of memory in imx_card_parse_of()
Date: Tue, 27 May 2025 18:26:38 +0200
Message-ID: <20250527162505.487195628@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit a9a69c3b38c89d7992fb53db4abb19104b531d32 ]

Incorrect types are used as sizeof() arguments in devm_kcalloc().
It should be sizeof(dai_link_data) for link_data instead of
sizeof(snd_soc_dai_link).

This is found by our static analysis tool.

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Link: https://patch.msgid.link/20250406210854.149316-1-chenyuan0y@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-card.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/imx-card.c b/sound/soc/fsl/imx-card.c
index 93dbe40008c00..e5ae435171d68 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -516,7 +516,7 @@ static int imx_card_parse_of(struct imx_card_data *data)
 	if (!card->dai_link)
 		return -ENOMEM;
 
-	data->link_data = devm_kcalloc(dev, num_links, sizeof(*link), GFP_KERNEL);
+	data->link_data = devm_kcalloc(dev, num_links, sizeof(*link_data), GFP_KERNEL);
 	if (!data->link_data)
 		return -ENOMEM;
 
-- 
2.39.5



