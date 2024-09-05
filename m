Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAC4194A45;
	Thu,  5 Sep 2024 09:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530264; cv=none; b=QieJLr5qcbzwg39GQhoXH7/1chzva5AZ9eCRuParGBi2QJy0A+BbP4RhEO8dntgYJyADlT/RJeaLAaMDFSaEpjmyC79AkC36pk4Tija0Txf9TB1P1PqawTaYVl2izH8nHvTqc1/VEB2SE4J0OG0IlxKIFuJavm4qvqVChqhiHxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530264; c=relaxed/simple;
	bh=FuO+tHYegSfaV9rSOjeMwnFD/uGlnXWPA2xmQIJGEVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eoV+iihYwk1uFh5qs7cKPhWFIViNK0DU2Zj1FbcFn1JyQpxvaulz7hfT444t5eClb/pa0KBB0nkpVtkUwIM+N1mns1+tJ4MK4ZLyF+K7zPaGSnDVVwsZe8yjX3nglRFhXz0/HTPEoYnFTsizCwmy/WJdEw9v1lztimoNjFOBjSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a1qUqdry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a1qUqdry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087C2C4CEC3;
	Thu,  5 Sep 2024 09:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530264;
	bh=FuO+tHYegSfaV9rSOjeMwnFD/uGlnXWPA2xmQIJGEVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a1qUqdryGCzQefT7byVtP3bliQAIvvW+BPUxGrr48QhwnQqc2yjPzMu3g7p3lN9lE
	 yZAzVTEsqAk+AFkkJ4wOEUyXAhqlbQlS9QdNdsTI0oVnvsoCTfNfzwzY5SBMEUz0hJ
	 rXTFps8D5MfvH5SpZqmWBXQl2qEIsv55UlZ/onc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/132] regmap: spi: Fix potential off-by-one when calculating reserved size
Date: Thu,  5 Sep 2024 11:41:32 +0200
Message-ID: <20240905093726.318196138@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

From: Andy Shevchenko <andy.shevchenko@gmail.com>

[ Upstream commit d4ea1d504d2701ba04412f98dc00d45a104c52ab ]

If we ever meet a hardware that uses weird register bits and padding,
we may end up in off-by-one error since x/8 + y/8 might not be equal
to (x + y)/8 in some cases.

bits    pad   x/8+y/8 (x+y)/8
4..7    0..3    0       0 // x + y from 4 up to 7
4..7    4..7    0       1 // x + y from 8 up to 11
4..7    8..11   1       1 // x + y from 12 up to 15
8..15   0..7    1       1 // x + y from 8 up to 15
8..15   8..15   2       2 // x + y from 16 up to 23

Fix this by using (x+y)/8.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://msgid.link/r/20240605205315.19132-1-andy.shevchenko@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-spi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap-spi.c b/drivers/base/regmap/regmap-spi.c
index 37ab23a9d034..7f14c5ed1e22 100644
--- a/drivers/base/regmap/regmap-spi.c
+++ b/drivers/base/regmap/regmap-spi.c
@@ -122,8 +122,7 @@ static const struct regmap_bus *regmap_get_spi_bus(struct spi_device *spi,
 			return ERR_PTR(-ENOMEM);
 
 		max_msg_size = spi_max_message_size(spi);
-		reg_reserve_size = config->reg_bits / BITS_PER_BYTE
-				 + config->pad_bits / BITS_PER_BYTE;
+		reg_reserve_size = (config->reg_bits + config->pad_bits) / BITS_PER_BYTE;
 		if (max_size + reg_reserve_size > max_msg_size)
 			max_size -= reg_reserve_size;
 
-- 
2.43.0



