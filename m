Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED82B267B65;
	Tue,  8 Apr 2025 10:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109798; cv=none; b=Mqqczlyd8SCt487NQoAuCcJTl8TawcYiqXdvyQVtk9isUQV6k9rd6DJSBks+b1mLyHDUw9LSBqfhIkVfXGmKGaSg8bFOVYnm6t1IxjpOdktmIWAYPAxr6Pvnbx/4WMwejGq0skxO4molYDlEpfL81/rViHqg4hBFCHcqJwybGrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109798; c=relaxed/simple;
	bh=/E2Z01D+DUWhsl5XFzEAPEsrL7cKyrbygSWiFXtprvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMstfplw/B9+rNB9Vcd2VE2UyraJy1H0POj40MBN2vBCzPK+lHDaqyduijhllFaVy4Qdqq3cqZXbSINnvAc2QyllbjcM9PDkax0yXIO42KbrbV4y//aQyJJWgWv0t8CM8z7rbB2x2fLItb3nG7o/O0kAKw2so+UtlxMuOx+92sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K9gaPUAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K9gaPUAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC88C4CEE5;
	Tue,  8 Apr 2025 10:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109797;
	bh=/E2Z01D+DUWhsl5XFzEAPEsrL7cKyrbygSWiFXtprvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9gaPUAvAM8JTAfF+mFohAjwkIjEGW7vlfTtb+7h1dA3J/ZMPgLOsq3+PkxoVZLwM
	 VXhe7Nekpru87qPRiDxMmZ3pq/p82oaqYi//AJwFdLu92UjYrHiaw6pXk/kuQYQiOr
	 0E8+Rzlq29dID5/rXJ4v1UTMLs5DehNEBUh7sCP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/227] ASoC: codecs: wm0010: Fix error handling path in wm0010_spi_probe()
Date: Tue,  8 Apr 2025 12:47:15 +0200
Message-ID: <20250408104822.110993970@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit ed92bc5264c4357d4fca292c769ea9967cd3d3b6 ]

Free some resources in the error handling path of the probe, as already
done in the remove function.

Fixes: e3523e01869d ("ASoC: wm0010: Add initial wm0010 DSP driver")
Fixes: fd8b96574456 ("ASoC: wm0010: Clear IRQ as wake source and include missing header")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/5139ba1ab8c4c157ce04e56096a0f54a1683195c.1741549792.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm0010.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm0010.c b/sound/soc/codecs/wm0010.c
index 28b4656c4e149..b2f87af1bfc87 100644
--- a/sound/soc/codecs/wm0010.c
+++ b/sound/soc/codecs/wm0010.c
@@ -952,7 +952,7 @@ static int wm0010_spi_probe(struct spi_device *spi)
 	if (ret) {
 		dev_err(wm0010->dev, "Failed to set IRQ %d as wake source: %d\n",
 			irq, ret);
-		return ret;
+		goto free_irq;
 	}
 
 	if (spi->max_speed_hz)
@@ -964,9 +964,18 @@ static int wm0010_spi_probe(struct spi_device *spi)
 				     &soc_component_dev_wm0010, wm0010_dai,
 				     ARRAY_SIZE(wm0010_dai));
 	if (ret < 0)
-		return ret;
+		goto disable_irq_wake;
 
 	return 0;
+
+disable_irq_wake:
+	irq_set_irq_wake(wm0010->irq, 0);
+
+free_irq:
+	if (wm0010->irq)
+		free_irq(wm0010->irq, wm0010);
+
+	return ret;
 }
 
 static int wm0010_spi_remove(struct spi_device *spi)
-- 
2.39.5



