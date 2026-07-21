Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2638D3B6C17;
	Tue, 21 Jul 2026 22:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673644; cv=none; b=kVVIMA5sTJXWf9Plk9FYbBw7rv2xhncwcTkDvqiPvpKHJuB4hRKnUjsp1hY0Rue6JP0m3CIu6z+4W49zyovhkrnkHG08En0lLqMeekfJ4PxOs4frae1wBaO+CfV+T3TNfuGKPnmKsUytdXXh2Jutygko7kvIym+CHNP1Rrg+m9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673644; c=relaxed/simple;
	bh=/Jx5Zn1MfKJ2StLbWcuw1OOv06074Fuc7f+tAws1iJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLVpAR0YuVcc7z8EDVWdf+jaj0RxrQxp4XLa+LNS3yFv0iQ31hoFYUT5M+tDER8Gh2jPwCwimhj4DKw+Gnc2MShczAk3PZBCRaN7b3SluPs5V6ZEJsSTMr9oyH261YWMPH0Pzg0lU4mzWtEd04Rv/WyX+FfX5Bi2x2k0UZN4iHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JURHuxKN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JURHuxKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC4F1F000E9;
	Tue, 21 Jul 2026 22:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673643;
	bh=qWx5A8pnmR5LkdjtuoO2LGtrozeC1aar1DJIpgrbwms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JURHuxKNvzE0sdxjLJq97yvZGuwF8QlzKuYnZbD2dbrqAUutJOiHQ7rMSYclPfBp+
	 ffnhSxwqOHZpcUQS60Eq7bBiqzHIeRg9XwujMiZlQPmfCB8LZOk/O8cbCs/XWCnmBy
	 GDbENLx65zEsc4O5o1WuV8/uJY0ILbCv7MEZcu6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 240/699] spi: ep93xx: fix double-free of zeropage on DMA setup failure
Date: Tue, 21 Jul 2026 17:19:59 +0200
Message-ID: <20260721152401.111126692@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index aa676559d2738b..b78495f4020960 100644
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



