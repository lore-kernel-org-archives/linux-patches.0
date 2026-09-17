Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26624B44D0;
	Thu, 17 Sep 2026 18:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668123; cv=none; b=DRrSkTUKoCfMjunbojvpHGrSKmQh6hZz1Jhz7oeN30MwK+PZ4d2szf36lO5zFnNGTEaehN3Hfs5vbhadIIOD01dHhQyXuB5DQxKQmQPt3zLHbdr5tROsMF3fRkFPg87Oojxxfa2jjtzDnTREmfnwKf/zcl5hOkGMvYHMFLhGpWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668123; c=relaxed/simple;
	bh=YGZ3Uj78geNP6QvxxeSbxvD7lEWXzk52EdKseTk805I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRHBYV2q/jy8Q69Z/xM2CT7fsosFTXeqfSFqiXOYPtGL8q9wg2K/0Ru3pmaYCLlyajIlRPXtGN7DwZM+oo/+QxDUgf6/hfotE41ib4LmvWu58aai8qVfTevEQecvPQoCbhGUDJzQi8F+eF1THEJgzVvGIiEUMjbBX53/wlZocls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tG6gG2Mh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tG6gG2Mh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385B61F000FF;
	Thu, 17 Sep 2026 18:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668122;
	bh=JVW0Bw2TMhY3ar4ZDuqyXNG52lKLdq70rrXbbyAerr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tG6gG2MhmeARmHs9eNUDLeT/qrkcom3Y7wzUVGfqlnztnRPTwewyR3Jne06MpaBrF
	 Vx79zSqy4HvFs8UiHFUtBxzXzPvPTKyFjpwfd/TxlWkvxpbq6wygtlgoB1UK1Krv1K
	 /9d31tcleKosg60p0zyeOmQiFiIgvcTawGxH+hv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	guoqi0226 <guoqi0226@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0320/1102] spi: Add NULL check for spi_get_device_id() in spi_get_device_match_data()
Date: Thu, 17 Sep 2026 16:04:23 +0100
Message-ID: <20260917151547.661539331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: guoqi0226 <guoqi0226@163.com>

[ Upstream commit f1b061b4d4c6cbf861319ba954caa80145cf018f ]

Prevent NULL pointer dereference when spi_get_device_id() returns NULL,
which can happen when using driver_override without matching SPI ID entry.

Signed-off-by: guoqi0226 <guoqi0226@163.com>
Link: https://patch.msgid.link/20260616103018.105612-3-guoqi0226@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index caf445d4a435f..9374c057f7ccb 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -357,12 +357,16 @@ EXPORT_SYMBOL_GPL(spi_get_device_id);
 const void *spi_get_device_match_data(const struct spi_device *sdev)
 {
 	const void *match;
+	const struct spi_device_id *id;
 
 	match = device_get_match_data(&sdev->dev);
 	if (match)
 		return match;
 
-	return (const void *)spi_get_device_id(sdev)->driver_data;
+	id = spi_get_device_id(sdev);
+	if (!id)
+		return NULL;
+	return (const void *)id->driver_data;
 }
 EXPORT_SYMBOL_GPL(spi_get_device_match_data);
 
-- 
2.53.0



