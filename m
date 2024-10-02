Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4BC16F84F;
	Wed,  2 Oct 2024 13:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875637; cv=none; b=UnQSLjCn6IfDcAQOUUNttQsyfDoLxVklNhyHoPC3Af0awJXbRRRjULUmy0zJ/jqcWPH7cZ8a1R4g4eXbKYQ72QBYTSevnDxEQ4sp71XQ5KJMeQ8bIQG9Rvy+P885jbkjgP3U7juQuJ4hANjerLj5HCXaVQ9M7ibOSnI2CssqkH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875637; c=relaxed/simple;
	bh=K4pdssGvvT0MrhsnoZ7iZNED1fHD/rtTKMZ3qXmXT3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FG+vTh+hGvHm0zaHynF+NLmzo2lVEQM+NxwGQqoTNCxw7HX15JG7RZw1VjR9Go0d9GqnuMFNgVdXs7n62QppAZuMdz9f+2hV6Z5U7eA0WM6LKInZLZi8hGc5tu3raYgkxPrISniIrjnWqeqs3uStcJRHX+QzRwvHBUUwYDteAr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j+CRgPuY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j+CRgPuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FE2C4CEC5;
	Wed,  2 Oct 2024 13:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875637;
	bh=K4pdssGvvT0MrhsnoZ7iZNED1fHD/rtTKMZ3qXmXT3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+CRgPuYnXfON5UlYMSLjScvz//2zQisE7nIP5BfC0vzGHubi2KTZ/S/uKiYI34WT
	 IIr3eAK6jH86Yf71XIr24YAgT22WFj18Iet40VztJSIZvcchuv31Ypi30xoi12SfBJ
	 /EGgadW+ShHpQ4Onr+/EMoA49krAxKd94CLlpYx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	tangbin <tangbin@cmss.chinamobile.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 170/695] ASoC: loongson: fix error release
Date: Wed,  2 Oct 2024 14:52:48 +0200
Message-ID: <20241002125829.259162877@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: tangbin <tangbin@cmss.chinamobile.com>

[ Upstream commit 97688a9c5b1fd2b826c682cdfa36d411a5c99828 ]

In function loongson_card_parse_of(), when get device_node
'codec' failed, the function of_node_put(codec) should not
be invoked, thus fix error release.

Fixes: d24028606e76 ("ASoC: loongson: Add Loongson ASoC Sound Card Support")
Signed-off-by: tangbin <tangbin@cmss.chinamobile.com>
Link: https://patch.msgid.link/20240903090620.6276-1-tangbin@cmss.chinamobile.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/loongson/loongson_card.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/loongson/loongson_card.c b/sound/soc/loongson/loongson_card.c
index fae5e9312bf08..2c8dbdba27c5f 100644
--- a/sound/soc/loongson/loongson_card.c
+++ b/sound/soc/loongson/loongson_card.c
@@ -127,8 +127,8 @@ static int loongson_card_parse_of(struct loongson_card_data *data)
 	codec = of_get_child_by_name(dev->of_node, "codec");
 	if (!codec) {
 		dev_err(dev, "audio-codec property missing or invalid\n");
-		ret = -EINVAL;
-		goto err;
+		of_node_put(cpu);
+		return -EINVAL;
 	}
 
 	for (i = 0; i < card->num_links; i++) {
-- 
2.43.0



