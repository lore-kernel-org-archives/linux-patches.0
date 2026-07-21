Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEEB4F7987;
	Tue, 21 Jul 2026 15:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648569; cv=none; b=r8gBo7AZPP1U/G0g0LgyAD3fo12Rr3C4hDRF4xTl4IYxKmA4mLuySDgSCFgQ5buk0c/7bxTz0ylJKE1Bfx9wMEbe1mSmOZ2gzUc4Z4LRmhiLqUQrb6USog5R1Z5phfbSgSpz1WgFEXTFsdfgURyPWUnOGhVAjasE2in+nQEaXMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648569; c=relaxed/simple;
	bh=3V2SL0NxEOnwVqN50rVTeW6Ikk66j90YZXcN0RWPCnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQax4Sdfk5FjpDf5cJjZQhoa1waytNtn0eiy4kthLEwcbrak7i5IRFT+xSabX5pFMg70w+sBqXP5bk107X4OhHU/XQYrKI1c1aZNd8QzZefsoKBZCQQlh29r7apnicxkNW5oDhsW2sV6RC2CWKan8KvO/e/WTERvaKarr0kkUeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7xqd+6Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7xqd+6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207EE1F00A3A;
	Tue, 21 Jul 2026 15:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648568;
	bh=5/x/7m7auOhpQh0UmmMYyn6um2u3Q5OQhBCbACJTdfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7xqd+6QCs54cWpoOIHNOkvMHdPHGAuO5lWVc3z8B72Fm1pW6rAH+pKNwKNYh5M++
	 V1hz17rLr8W/vI/AdsW4L3mswlpVBMcHeFfOSBZlsAr6I60nRvgOQoplFzUCAKjAJL
	 k4LSrsdaDRUExBver6MKjYDLJMsH2RYoXGlCiRHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0249/2077] firmware: arm_scmi: Read sensor config as 32-bit value
Date: Tue, 21 Jul 2026 16:58:42 +0200
Message-ID: <20260721152558.554009550@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit f6fe7c3c007df18afd289ff2d98c692fae9ab085 ]

The SENSOR_CONFIG_GET response contains a 32-bit sensor_config field,
and the xfer is initialized with a 4-byte RX buffer. Reading it with
get_unaligned_le64() can consume bytes past the returned payload.

Use get_unaligned_le32() to match the protocol layout and the allocated
response size.

Fixes: 7b83c5f41088 ("firmware: arm_scmi: Add SCMI v3.0 sensor configuration support")
Link: https://patch.msgid.link/20260517-scmi_fixes-v1-1-d86daec4defd@kernel.org
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/sensors.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/sensors.c b/drivers/firmware/arm_scmi/sensors.c
index 882d55f987d227..836c294a9f42ae 100644
--- a/drivers/firmware/arm_scmi/sensors.c
+++ b/drivers/firmware/arm_scmi/sensors.c
@@ -793,7 +793,7 @@ static int scmi_sensor_config_get(const struct scmi_protocol_handle *ph,
 	if (!ret) {
 		struct scmi_sensor_info *s = si->sensors + sensor_id;
 
-		*sensor_config = get_unaligned_le64(t->rx.buf);
+		*sensor_config = get_unaligned_le32(t->rx.buf);
 		s->sensor_config = *sensor_config;
 	}
 
-- 
2.53.0



