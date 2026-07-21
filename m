Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B9444AB62;
	Tue, 21 Jul 2026 21:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669028; cv=none; b=JM244zYVT+krKDNU8uU/yYmEbLFtwc7PdnTwPRDO0UEKT/hG6VqpVbQZmG1b30/8KFLV8vDbbPvmCVyVw1mKIKR+cs0lMN74enz4TJs2WH9yFEY6XQmlljl385Ne7V59lqkxVXCt+6IrtQJ3W7gE53wyDef+RruyFSVqoSOvscU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669028; c=relaxed/simple;
	bh=i8Qp5JkKvVp6RBWErYcfFrG8bRYPYjdDkJ2vwPLSijk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8GoIniQSYbGXv9v7I14Iejw6iZHpWUApWKwqQdn/dsSznvKGHW3Xme8coCc38/+gbC0EZp1x1ajgbIXGABLD37SRL8NlsUdfhHxXkeVBusWOklm2ymbAzF7vvS6et+iv7MzZEY3s1gCheOSMUO4Eb/ybckR/kDcVkOA6MKqXC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNC54gSe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNC54gSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C0F1F000E9;
	Tue, 21 Jul 2026 21:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669026;
	bh=wsg63mlzSGJNRbZZOBpOr7X7TBXZj6XHaD20XHyTlZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNC54gSeNNCmSo0WkKn/eGLgyG6YVRqnGbUUgOFKvN0O3ffU1A3vbtugXtVCTZMzK
	 dWrGubZ37VVFUrGIeNPBbcssIKD92Zekw1BH7f8ZlDnvGzY/oOkWNj1Gm5q60TjQJt
	 z4FAaWswNn2I/D43NFFZwXvnjT+53xcrr3rwzJCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0399/1067] spi: ep93xx: fix double-free of zeropage on DMA setup failure
Date: Tue, 21 Jul 2026 17:16:40 +0200
Message-ID: <20260721152433.557163199@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 7886054b06f762f62054957a8f6de0f14e6b7541 ]

If DMA setup fails after allocating the zeropage, the error path frees
the page but leaves espi->zeropage dangling. A subsequent call to
ep93xx_spi_release_dma() sees the non-NULL pointer and frees the page
again.

Clear the pointer after freeing in the error path of
ep93xx_spi_setup_dma().

Fixes: 626a96db1169 ("spi/ep93xx: add DMA support")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260529-ep93xx-v1-1-9185070ca1fc@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ep93xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index 5896a7b2fade0c..9b694cd5361d93 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -625,6 +625,7 @@ static int ep93xx_spi_setup_dma(struct ep93xx_spi *espi)
 	espi->dma_rx = NULL;
 fail_free_page:
 	free_page((unsigned long)espi->zeropage);
+	espi->zeropage = NULL;
 
 	return ret;
 }
-- 
2.53.0



