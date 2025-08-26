Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46702139C9;
	Tue, 26 Aug 2025 13:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215561; cv=none; b=jWp0dte2hlVr+7NcbFp07DEr0ti8vU21SFcv6MYif7S8x6GMQ4cPC/Cv//xRPbGlqMbN6GB8chLyauls+RYlLhLSPFks2KFTUqYLule0iU2H2nIbbfCpRNce1TBAibK+ppSjopGRzDz3wZ/NiSrvO2eu6IxwCtItHz/lueWk2gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215561; c=relaxed/simple;
	bh=MqJrrWzPvSPNq3fIoCYWKeXs2xTQfMuNOP0Ucsukddg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bY6xtopfEtngBw365H0YP1laFaba4mZJ4vTM5C3KbGYJ3q6Sgr1ChMv4Ms0xDPQVWAo3jSIFYpwHjf1119k7TUyI+wS2/HdCran6emnmwijMZCTy5qJqd8UZUDSulNP3XuD+k/r5/kXFsCMqbzU4rZmdNtCRvry9ZB91bQs4pQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gm0fs3TI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gm0fs3TI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36087C4CEF1;
	Tue, 26 Aug 2025 13:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215561;
	bh=MqJrrWzPvSPNq3fIoCYWKeXs2xTQfMuNOP0Ucsukddg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gm0fs3TI6Rur20/jJCrgChYFC/cXreQTku+VhedRvERe8wai7Sj1TnKA1Y9nVxYph
	 Tfo8PLOZad1A1GUkKEBR535PXVWUnCcVfC5LzZ4PO8Kp/FstN/vjSaqKle8onPaESi
	 yA2rJJilfzcCln9RxR+k1gGOET0Vu5eMja3YlnXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/644] regmap: fix potential memory leak of regmap_bus
Date: Tue, 26 Aug 2025 13:02:51 +0200
Message-ID: <20250826110948.480096770@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

From: Abdun Nihaal <abdun.nihaal@gmail.com>

[ Upstream commit c871c199accb39d0f4cb941ad0dccabfc21e9214 ]

When __regmap_init() is called from __regmap_init_i2c() and
__regmap_init_spi() (and their devm versions), the bus argument
obtained from regmap_get_i2c_bus() and regmap_get_spi_bus(), may be
allocated using kmemdup() to support quirks. In those cases, the
bus->free_on_exit field is set to true.

However, inside __regmap_init(), buf is not freed on any error path.
This could lead to a memory leak of regmap_bus when __regmap_init()
fails. Fix that by freeing bus on error path when free_on_exit is set.

Fixes: ea030ca68819 ("regmap-i2c: Set regmap max raw r/w from quirks")
Signed-off-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Link: https://patch.msgid.link/20250626172823.18725-1-abdun.nihaal@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 6d94ad8bf1eb7..ebddc69bc969c 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1264,6 +1264,8 @@ struct regmap *__regmap_init(struct device *dev,
 err_map:
 	kfree(map);
 err:
+	if (bus && bus->free_on_exit)
+		kfree(bus);
 	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(__regmap_init);
-- 
2.39.5



