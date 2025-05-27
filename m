Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEFB27C149;
	Tue, 27 May 2025 17:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368344; cv=none; b=MD/pLpE0SVbkOX9TZJzVFOo3350ZJIX0V1VrpfI3VbmbIs1ChZTBa6bdO8RzsTIEdNIc7a2R4EX0escXnEE9iq9xiAD8pCOqRlS2CDXahBY2NQcR8+x4zptj6ejpQL5jzI22TkpfRukFYSQn4RgsSElc6NJXo8/tPTubN0t9YVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368344; c=relaxed/simple;
	bh=gM6aozdsqjiz3uVECtWtVhDJZf4zmrhUivh1I/rgN9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2W5oaxXFsW+/iaTkGlMF7JY86OO8AKk6DCAfc80zQOmka6l20Axx3zNVCwo13aI+xRgpAOJU4WfqwdgpOprp4g4I7CWevFmofZrEqN7Kzi0KiBE7IIiiHnpjNx8UkgTwulJdP4Q61O6/XAU7mBGaj75nLjMrBKCXV+HzC2EuE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wXgbv9YP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wXgbv9YP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735C9C4CEE9;
	Tue, 27 May 2025 17:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368343;
	bh=gM6aozdsqjiz3uVECtWtVhDJZf4zmrhUivh1I/rgN9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wXgbv9YPkDeQPsqIaeqaH9Bc++kkoJKpCPoDCmP83uAc+QWxmnWGlZFDu7+Y+L6Mb
	 ShyaG6ELENhYeapAzi5gJ1/aclfM6dqHwYOfuInyHOHcYCQCC0ASkjUf/8NFU88m9n
	 vvjLP+pzgOIVyEPLqEMuUbsmNxinNDDmmk3T3RF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 647/783] ASoC: imx-card: Adjust over allocation of memory in imx_card_parse_of()
Date: Tue, 27 May 2025 18:27:24 +0200
Message-ID: <20250527162539.486149986@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 21f617f6f9fa8..566214cb3d60c 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -543,7 +543,7 @@ static int imx_card_parse_of(struct imx_card_data *data)
 	if (!card->dai_link)
 		return -ENOMEM;
 
-	data->link_data = devm_kcalloc(dev, num_links, sizeof(*link), GFP_KERNEL);
+	data->link_data = devm_kcalloc(dev, num_links, sizeof(*link_data), GFP_KERNEL);
 	if (!data->link_data)
 		return -ENOMEM;
 
-- 
2.39.5



