Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B856F224B09;
	Mon,  2 Jun 2025 14:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874051; cv=none; b=sayzm1gYwrbw0r5hK0Fy7FUFLBYTV6Mjmif5nRVUyeQivhIUkXEqVjh58QtuhZo+y+vjC+N8S/UZ0OA2UjVhbMatjp9Rl4NwPJvfti+XwRFmMPuQNjK2sWSl8X+Dy6gW3kBRTAucx985D1gdHgTP+IEj2TTCdJ9Ee6PAwXJWtUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874051; c=relaxed/simple;
	bh=dURlkI1fO5YqfzdPNMaadd/IQzsLBJlA0ONTRMR5ENE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVT4pAdJSQy6X/jBScgRFZBmdmQoyiG8bti3A95NJcL43YJGRfKGft1+YnTo+qGvDsZ2RnyRzrrMjug61jhdyNxN4PuXOSidUHxktNWCE1sMASsjxvLpRxtYWjafju/LeIKweX9MIFNRz7oxIbAK8hBfAYtHJS9fG+O2nBL6Zso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYlO9Jo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYlO9Jo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44499C4CEEB;
	Mon,  2 Jun 2025 14:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874051;
	bh=dURlkI1fO5YqfzdPNMaadd/IQzsLBJlA0ONTRMR5ENE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYlO9Jo1nkIPxFKRe8EW8ODyzJmp1+O0hQL0DO5+e6XeUNLdXm3YCcrF9ZoUscGMk
	 cHcVPR3/vVN+BRDVCqArx0zehYsnPdXy4OpkQ03ZVeYg+DKRxe/kNX8/2AKkSK43cp
	 2DzNG/7Sy8qGvn3UFke0fIlKIOCkQmMIORSg3b8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 312/444] ASoC: imx-card: Adjust over allocation of memory in imx_card_parse_of()
Date: Mon,  2 Jun 2025 15:46:16 +0200
Message-ID: <20250602134353.603939823@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7128bcf3a743e..bb304de5cc38a 100644
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



