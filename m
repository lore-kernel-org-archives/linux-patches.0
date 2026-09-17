Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489264F403A;
	Thu, 17 Sep 2026 17:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664601; cv=none; b=huW/gUDNgWE6axpMgTfCxscz4Af9DFj4hWBJzYitRWzdkQTDcIyxzWbNGp0xF5TqDcxnlmqy2cRzIGly/9Tt90lahQe9jqQt+KfzPsHPTYAFLUWlpYB9LbUL898x2GbG1ZNRkBAmXQUQES2OSVCiI9qcxCjE36Q8TD7lUSVa/yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664601; c=relaxed/simple;
	bh=ftFY6KrGpjOebxxvuj0rvrBbA1iMKnH7WgTvE1L41lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Orq5qqihVjdbUgll0NCayLOu/CsjPjvIdvdXBgH++hn6hxfc/58APHoV6FYzUmtB16ovtd+jZvy/24BGaalUAU8kUQ9CuEN+d6mNyYmXfBdbn+ITlA5VqYyo6UUtCy7NfOn1A2l1AxO3lrHH8Ci1dGZastR6mtDTVpGF9RM3MZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z8FyHJJ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8FyHJJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB7F1F000FF;
	Thu, 17 Sep 2026 17:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664600;
	bh=01o+BxcMac88Vb6X+m4sX01+ARSn6s1YjaXKT98JjeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z8FyHJJ/ni/pxXcXAcHgMBbd18NAxNBsfeNMyY5RzAlOZdlkGq8TGx86lgB/U4u4f
	 c2/VoPPgOr6EpTwslMEwPpvJA1XXQorYgJt0kliinyQZSF/DTlUrbr6AcfYoiW34iC
	 ZMZKbx8ALiA6tlZmIIfiDYPCl5xv/96eeVEiflXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	guoqi0226 <guoqi0226@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0425/1250] spi: Add NULL check for spi_get_device_id() in spi_get_device_match_data()
Date: Thu, 17 Sep 2026 16:03:40 +0100
Message-ID: <20260917151603.534704894@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 6900514e7329b..1be9dd4c89fe5 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -358,12 +358,16 @@ EXPORT_SYMBOL_GPL(spi_get_device_id);
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



