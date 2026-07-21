Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACEA436BC6;
	Tue, 21 Jul 2026 19:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661618; cv=none; b=P9UXoYm19YqdlNK2xLlI5bS9PtLtPG/K8OyoL1iNe6ZiGMbK3FH4d7+8WAzHL+kFhsAk7vYuD5gcI3BAQh4CMv/Jwf9SvdnejdO4NIwE7hOsyVuTEUlR9F13ua2ymkxeRplf7W9c6s4lLbX6DuPHpmWoZpq3sFayTw1PQZlyPGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661618; c=relaxed/simple;
	bh=1Gtbo9TP5lgSVXJpggroh+pE5AUt9TR6rSeT25NghxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrRUgCsQbxGejSEybXHItq11B133DVK4dPqfa4+oSJSuRAMz5Xv83NuGL11clRQozsrljKlMHB0GRSSr7aD8n5fXHWykHfHa4TIr8AkfaS/ioqJQS2cvc5k2qNcTy9vp2ns/Nf01ybNpq5QnFfXYGdvUaqnFW+Om768wPxoeAxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2RFfDt7g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2RFfDt7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CD61F000E9;
	Tue, 21 Jul 2026 19:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661616;
	bh=hiXIS3JEzAmWnU0/tMXdzUh5fX2RvvTAIOgfLgU2CYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2RFfDt7gq3FOENmqP0QRw64L2w5UgaEMgftb7zO+n0q+G9NU0bO9pIGnXA4+XxTZZ
	 I2uP3MZcleGGnD2Z85M3kbIUHWj32lp9xaEfr/g4dnmbYtrRnvwQ0Z+ERbWi/nq8fw
	 2gh17+4pFMQJO5jCOC/bOz3536uM0seuG2bXzdP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0132/1276] firmware: arm_scmi: Read sensor config as 32-bit value
Date: Tue, 21 Jul 2026 17:09:35 +0200
Message-ID: <20260721152449.056562743@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 791efd0f82d737..1be0f89fc2c4b1 100644
--- a/drivers/firmware/arm_scmi/sensors.c
+++ b/drivers/firmware/arm_scmi/sensors.c
@@ -795,7 +795,7 @@ static int scmi_sensor_config_get(const struct scmi_protocol_handle *ph,
 	if (!ret) {
 		struct scmi_sensor_info *s = si->sensors + sensor_id;
 
-		*sensor_config = get_unaligned_le64(t->rx.buf);
+		*sensor_config = get_unaligned_le32(t->rx.buf);
 		s->sensor_config = *sensor_config;
 	}
 
-- 
2.53.0



