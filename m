Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C55022ACF3;
	Mon,  2 Jun 2025 15:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876470; cv=none; b=gthEtQOxGy4gA0MABDQ+VT/HgDK0q2IIkRSc/IrjVNWcTJqs0zAWEuyQIM7iSZdl9m1mq0X9XOS/OQpbd4HNw6aioxyKslhycsGNHCDVDxHjIfqLbvuZms//Ek4GWcTS0aEpoqA8mZjX0QxDQHh4mXXJ2drzinxYKPWrHY90Qn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876470; c=relaxed/simple;
	bh=2/goVAt4FXQjzV0AV1o/nA/kUZR9SsK3/ys/StrqSO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8VhzXAVQfGilOZlIWfQ6i3U07hYMWUNHaCO9lzjpam7gGJllw/2gxsY+JHvSLApiXmL/5eCgUPrKa84mwz5gX2fqR8fLC1rTJ8g42jePR/mUW7AJOkixKBHCSAOQlIdsiKNwdF/NHVtuGi/OaIT4YIusVrm7OjOSt6Wz0xPXr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PiOtvGAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PiOtvGAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7604CC4CEEB;
	Mon,  2 Jun 2025 15:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876470;
	bh=2/goVAt4FXQjzV0AV1o/nA/kUZR9SsK3/ys/StrqSO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PiOtvGAsxd9/LW9tuxBK/evspqJyalQTAsLQ9I0w5E/uMR2htigQoLuMhyFseU/AH
	 aMNqS52lk5xsdzQYbexVNa86fmZ7Sw2LaUyu5kPVHfIizQEqlGmsjhiS/xUA6Q6GxY
	 aGkSYcDDwxLD9/U3socVh4idLuSFyTXvObG5ggjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 154/207] ASoC: imx-card: Adjust over allocation of memory in imx_card_parse_of()
Date: Mon,  2 Jun 2025 15:48:46 +0200
Message-ID: <20250602134304.755377642@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2b64c0384b6bb..9b14cda56b068 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -517,7 +517,7 @@ static int imx_card_parse_of(struct imx_card_data *data)
 	if (!card->dai_link)
 		return -ENOMEM;
 
-	data->link_data = devm_kcalloc(dev, num_links, sizeof(*link), GFP_KERNEL);
+	data->link_data = devm_kcalloc(dev, num_links, sizeof(*link_data), GFP_KERNEL);
 	if (!data->link_data)
 		return -ENOMEM;
 
-- 
2.39.5



