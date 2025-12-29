Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEA7331208;
	Mon, 29 Dec 2025 16:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025161; cv=none; b=orgCc4+gUVnuj9R7OY9Sy+4A71psW5XtFxJlpf7cGpXcYwo5S0IMdqn997BQzeJ711YyF8rmIXMalNvB+8ZDA/euj9XORdTf5vtOg5dch2qLRzNWqQXhQJfkEOm+6KP6ZgNF8ASj11wwVjH2jtDJhS+T9ru8yhbGyXrrFAsqld4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025161; c=relaxed/simple;
	bh=RN5nfaTVzFTwKnpoemKKoKuWOJYs7eRxXh0b7Jq1Ui0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fu5twyO08QdRu06V8o8kgTGUpvdsZiTP4B5uY9/ygauXWBHnTrQ1YlxqdxWV7zmx04dXt1f9Rdwbaukr9bWHj1PJNtkgQ/DVJ4071kK/cpvZGe8md/ohEcglgUrZKr36LfO0eKG6h+pLLv8Un9/aX+24AOwDUrIAyXIWl27S2OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xo5y+cuO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xo5y+cuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BA9C4CEF7;
	Mon, 29 Dec 2025 16:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025161;
	bh=RN5nfaTVzFTwKnpoemKKoKuWOJYs7eRxXh0b7Jq1Ui0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xo5y+cuO1FvF0NO1k9ID7zv0QSlL9MaNXz9Qy3qkVaiSrVlheG5CKKG38n0K10UH6
	 Yg/XIh/whq0FL+QqSKnO8x+dWOEpbooftVfLeJdyXQJ0kGamB159WjF5B8ZDXTQBw4
	 MMcu2lZ96Ke0fQXy2hfJ75iANGlWhHz8t7VJAoe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 115/430] spi: mpfs: Fix an error handling path in mpfs_spi_probe()
Date: Mon, 29 Dec 2025 17:08:37 +0100
Message-ID: <20251229160728.600315294@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit a8a313612af7a55083ba5720f14f1835319debee ]

mpfs_spi_init() calls mpfs_spi_enable_ints(), so mpfs_spi_disable_ints()
should be called if an error occurs after calling mpfs_spi_init(), as
already done in the remove function.

Fixes: 9ac8d17694b6 ("spi: add support for microchip fpga spi controllers")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://patch.msgid.link/eb35f168517cc402ef7e78f26da02863e2f45c03.1765612110.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mpfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-mpfs.c b/drivers/spi/spi-mpfs.c
index 9a14d1732a15..7e9e64d8e6c8 100644
--- a/drivers/spi/spi-mpfs.c
+++ b/drivers/spi/spi-mpfs.c
@@ -577,6 +577,7 @@ static int mpfs_spi_probe(struct platform_device *pdev)
 
 	ret = devm_spi_register_controller(&pdev->dev, host);
 	if (ret) {
+		mpfs_spi_disable_ints(spi);
 		mpfs_spi_disable(spi);
 		return dev_err_probe(&pdev->dev, ret,
 				     "unable to register host for SPI controller\n");
-- 
2.51.0



