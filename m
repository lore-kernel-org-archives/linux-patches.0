Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2BA3B3BE1;
	Wed, 30 Sep 2026 18:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794626; cv=none; b=uCjQ8Mf+8XedHjaZC/ssLNCCOzrq0LfECr6Us3Qe6lL8pd0JLl+7SmUM3OPJfHarcuRiTK5KQVGVh2Z88MMYoZ8PO1orSqnh4DYbEUa0FOrY8sjB2eSYRVJRoGRX6LoloG60cC4mB+k/ou//iQNDp0zTsxdp+1fcpC4gVLcPyR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794626; c=relaxed/simple;
	bh=cDs7zogHuR0ZV1agfmFbYBcUnFK146QuK8Sp4lXWS5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CBF+9JNgP4GJX7LNUPxMHtmKca9TjbMakkmgGCrFySjsNjWUXBpMWK5+nI4rW5DQrYmd9U1y9oTnA79H5AadHGb50MnhVbA7tqW7iEabptTaXvf6j9NEUMvJ34kCAPy88rREkLZamYEcz086yagixtOMVNzAAv0efrmQ3LxW9RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ICoHXX+7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ICoHXX+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BEC1F000FF;
	Wed, 30 Sep 2026 18:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794625;
	bh=ZeAYUS0pSfJIgCkh8PkS1pADLGS+i8gxUIx2+31Tsz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ICoHXX+797YptO4DkxUEjSlGyy7f21qi8+lj/CCQVUVS95ZCavkPn7s9Bf4U5Klil
	 EvlsCM5mI+MnX1NMSremtNGRxuB0iP/fwB4AKBkQWNxYd54ocmY3clqaqRpHMyBWn6
	 l64bZGT2aXfUDRZIoAWn+ZPyIpRKK0DJIWWg8mhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	guoqi0226 <guoqi0226@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0232/1193] spi: Add NULL check for spi_get_device_id() in spi_get_device_match_data()
Date: Wed, 30 Sep 2026 17:15:16 +0200
Message-ID: <20260930152439.349897350@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index da2ef6b1f7c89..0b9cdd966c0a1 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -366,12 +366,16 @@ EXPORT_SYMBOL_GPL(spi_get_device_id);
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



