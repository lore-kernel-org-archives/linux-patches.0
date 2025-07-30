Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674C0267733;
	Wed, 30 Jul 2025 09:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868999; cv=none; b=kXB1VDkd2eqze2JbzR2dkrvvNqftXpme9Dg4xnWRgpBeEf2cHEMv7cONIkUg/mId4Xiw3YM/NkkKDCPoQAIWlMyILXSCbn9i3sIPSTrgjo1fhdVv1DGmaoIBLK94hHbhJ/RfsZwDhlKHYciCvZteKqSm0//6zfGyB55IaYn5FHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868999; c=relaxed/simple;
	bh=359M4AtKHKcdqS47VEXOtEPwy95Jr3kmPiaJO6NNY98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HjKBJ2L2UiWp7J2eNoOK/dXh7YOpeUZaXsEurL31v/Uhlz2uIq57Qb0/N0Z2jURxmrtT/QU2bwD4BR/+cSDMV7ZqdQ8qJP9ZPqzEyL3PBsSpZTL5mAS1g3KrXR1fBpDVYBLTWFA/MuHSBMae1eG/FpjXmPc6Y4S4cb1tV+vbUZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=InTBKN2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="InTBKN2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D1CC4CEF5;
	Wed, 30 Jul 2025 09:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868999;
	bh=359M4AtKHKcdqS47VEXOtEPwy95Jr3kmPiaJO6NNY98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=InTBKN2nr1WNtWvCH2AHhoz0Ju1K6xlF4LrBLGKhI+xsTYrQBKhbbU7DgUvNL5pQQ
	 3TgyTp24U5PGaGGKfByU/0j3hhzYixU5d8rLAcc3acgccJO8Ar6AxwoiNT5q03PRkP
	 XocN6rPCEIJwptvhqqjlR2XDhLeYTURXWvcQdW9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 12/92] regmap: fix potential memory leak of regmap_bus
Date: Wed, 30 Jul 2025 11:35:20 +0200
Message-ID: <20250730093231.096852237@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index f2843f8146751..1f3f782a04ba2 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1173,6 +1173,8 @@ struct regmap *__regmap_init(struct device *dev,
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



