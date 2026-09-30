Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B2F51B16A;
	Wed, 30 Sep 2026 17:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791024; cv=none; b=RcQVliqksL+Ux3H34Vqf+f2732qsRgE4jKXEJPvFLHnYsSkkqi5G9EDrQxBLxu9WlYcvi3oi0C8XBuHhdPtIjIioUmmFopfFqZ9fn+SmXgGOpnKqMRobVauXONDOBuS+Dfl8bUNQeW+aeEd3CwZy2tB8LxCi9mO5dD5KPyEFeug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791024; c=relaxed/simple;
	bh=Z3PdgXrrdg86kL5rKAAuf2FwO4Wb1uxV0fNV5FR5djY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=han0/yaWYgMuqTMuaMuCHevQTnqHOld+m1MtoYJTEDb4DggDKuUq0JawJeFRAiE8xB1OomfkBryuPVufYvK23IruN9CkaD2OaFJkfu1TyoPNL8SNiHH11O8xM2fRoRB9nz7utY8gSbUNpxJyMq68qEnQa2T6ADRTqevyznNs4z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xCV7uBs4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xCV7uBs4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC921F000FF;
	Wed, 30 Sep 2026 17:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791022;
	bh=ISXErJ5PLHsh5+8FQJrfjhCDLsFb8u5dhjr4QqfXVy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xCV7uBs4UiCp/HGJNbPTyxM0exwuhelgYbPBWkmnX3DwXzo6ojwjg4n4tUApT+s2g
	 +bSLOW1Ss99MABcyFe27lsVIgW0UgKSW21WS9LrW8ozBNn/4EEszgPCF3K4x+gYTvx
	 gR8+dpNKQU3cJV9vTAhxICg0HC3fKDHNs5B7C3wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	guoqi0226 <guoqi0226@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 157/752] spi: Add NULL check for spi_get_device_id() in spi_get_device_match_data()
Date: Wed, 30 Sep 2026 17:20:27 +0200
Message-ID: <20260930152401.588275659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0ecd5ed3232b3..962598f2b109f 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -338,12 +338,16 @@ EXPORT_SYMBOL_GPL(spi_get_device_id);
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



