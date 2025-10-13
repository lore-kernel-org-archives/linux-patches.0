Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD30318144;
	Mon, 13 Oct 2025 15:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369282; cv=none; b=Lg/9e/KZ+XqQD9z/x3SP0XEIDw66/2i4Vv8P04G0aB/PE8CHxzaxqhkHyr77MJLX7qfn0HhR65g8/JdnOV5Qptchge0DIIs0dM22PRFuzjTJF8V9MPSQv0MhLydQ5rGr4E+vMYtpIBufow+qcjGKhAU7+He4N8G3akSA+VvunqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369282; c=relaxed/simple;
	bh=GFwMyrWxiZbW4Lq/lhCMvSXjcay59XAdPilzVDwnrbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAjP2CX8z9+LAjFLZ532P8KEKwxMe+hxDgoSOWmShjpGgEHxn7xV6jyMor0ou9n0Zau33lLY0TvOqOI1vH/C6LejW7PkqhAtUrNGD43AVSPdiQBsrT3LpGVd0BhvlB9VTXbkxbzEOQNWGlsrzgO6/xAd0GjZWuS2BkuQgCheFG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oRIQfOca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oRIQfOca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D53C116B1;
	Mon, 13 Oct 2025 15:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369281;
	bh=GFwMyrWxiZbW4Lq/lhCMvSXjcay59XAdPilzVDwnrbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oRIQfOcaCBAMuMtAVxJhSmMZxRuyKBkHHbjb89UlrUJ94sIediODDAFR5JUA+DSYO
	 qrqg/XIO83VJz5e+P5llBK9FnIskWB96H/t1wTT95w6qUmwjo/F4vMQ1j19EhPCrdU
	 EPgISUEqZ6WAhqTR7i1+kEEFzRzuslQn7/0MYqXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 190/563] spi: fix return code when spi device has too many chipselects
Date: Mon, 13 Oct 2025 16:40:51 +0200
Message-ID: <20251013144418.166515898@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 188f63235bcdd207646773a8739387d85347ed76 ]

Don't return a positive value when there are too many chipselects.

Fixes: 4d8ff6b0991d ("spi: Add multi-cs memories support in SPI core")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://patch.msgid.link/20250915183725.219473-2-jonas.gorski@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index a388f372b27a7..19c2a6eb9922a 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2449,7 +2449,7 @@ static int of_spi_parse_dt(struct spi_controller *ctlr, struct spi_device *spi,
 	if (rc > ctlr->num_chipselect) {
 		dev_err(&ctlr->dev, "%pOF has number of CS > ctlr->num_chipselect (%d)\n",
 			nc, rc);
-		return rc;
+		return -EINVAL;
 	}
 	if ((of_property_present(nc, "parallel-memories")) &&
 	    (!(ctlr->flags & SPI_CONTROLLER_MULTI_CS))) {
-- 
2.51.0



