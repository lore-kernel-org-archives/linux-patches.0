Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D2F50EBE5;
	Wed, 30 Sep 2026 16:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784577; cv=none; b=QE+P4mPI4k8YY7745Z7lVrdfyGvLgcCEK8A3y74u++xorNbdJQdSZbiwm5fnigHl44ijb3Zcvee1AOs6qqiiLSCSu32opcNiu6S3ygr/hkg9WbINV/BM9JMJg76LEhRA203owii7bDttEQbVu25u899GtrhPnuO9shhioCHBCZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784577; c=relaxed/simple;
	bh=6PWH2gaxGXZWBIz/1xGrWK+tFR5APT82w5ebZtkmv9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2ubUWBqOpJ535GrX6xUURQw8GYtRESEwcwmGZmoFx12R/P8qi0a3Jt44m+Ck3oMw/o4t6VOI+EGFOFMgvwFhYam7UtOGg7LT57Le+nkQlg/4KrdUEZ/aIjvrfsSYZySU1nEhZnkx8+4RpeOOG6P1w7zZDr+w4CZQRNGT++IBe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGL3mHoO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGL3mHoO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3BC1F0089B;
	Wed, 30 Sep 2026 16:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784569;
	bh=5MQKjIw0WhUAPdEh/ZPYySz2jiV/5RHWByGNinabQVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cGL3mHoO3DH9DORp0PEeODhDWfxXMsoN+BNybGaSgOMlOitUNAdJDjPre0XPKMVYD
	 oigyFm0EIqj4rZ+RnFI4UTpGdupGD/AzRWQlf12J1GfUJKgFx8Ud+3ZI9gkla49k5y
	 xIARXEcsw2MGA2LhHy67AXrQinweRy/okvkztyoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	guoqi0226 <guoqi0226@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 201/982] spi: Add NULL check for spi_get_device_id() in spi_get_device_match_data()
Date: Wed, 30 Sep 2026 17:15:37 +0200
Message-ID: <20260930152421.129696470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index 4fbf5925bdb89..e1eabb959c515 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -365,12 +365,16 @@ EXPORT_SYMBOL_GPL(spi_get_device_id);
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



