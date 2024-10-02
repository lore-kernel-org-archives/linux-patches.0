Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E441D0493;
	Wed,  2 Oct 2024 14:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879440; cv=none; b=qasadYR0VzrQPXQlIaNLi904/IZQ5DrOmEdanpdwv0EK49b2mZ26u6VpZ75xpyEjn5Q0EWwastXkEnePHFpEyhTFvwTqbJhkxV0GyBwGYd1n/DbzUYrLP6PziZmE7RIz9CoGGIC8lzlpIq5baITDH+i4Qbbih/I469xFqpEznQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879440; c=relaxed/simple;
	bh=Ldy1VtWrHE0TVOQY/nFfZoTX224+46yOJcLXggGKWno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzRIIzfRfK/Chbn/ekboQ7BvqaJUUf/B0Cxh7HrW0Y6TSfaWL+3tF2QbJpUMCyfHNYZDiLzfICJnuCwuGvMpjvEzKd5vMWBHF7Mz17kEAf797Ki8Plv9jeNYD1l0a8ECWlUI8ThuIv097pw7Pui6WRwHMC1zdfflLHxc8OCTtGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PhWAMYBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PhWAMYBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6381CC4CEC2;
	Wed,  2 Oct 2024 14:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879439;
	bh=Ldy1VtWrHE0TVOQY/nFfZoTX224+46yOJcLXggGKWno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PhWAMYBkiVD0QT8NX2OrFX3yt4nhB3v7RWuNQTA87IABR/gFMT5wIrl3rhPPwyI5m
	 Sa4nnatqcnsLbyhu4OILcYfmBKGU2yPs5VT1V5ll3SEtfEMBKlZ4Tb9RlNfkMoM1s7
	 EzPIZQsz1916D/l3b37jzjzHZ9Kt6/3GuLvs55Uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	tangbin <tangbin@cmss.chinamobile.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/538] ASoC: loongson: fix error release
Date: Wed,  2 Oct 2024 14:55:58 +0200
Message-ID: <20241002125756.943877737@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 406ee8db1a3c5..8cc54aedd0024 100644
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



