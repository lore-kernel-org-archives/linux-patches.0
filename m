Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5F037647B;
	Tue, 21 Jul 2026 20:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665744; cv=none; b=Z/urCsXJ3SVFSBuJWaTFEsgaKFJ0HFhyW4d2cWg0PFmwu16HrFtxSV02k3adzujREORt7M3iMcgqLFlnWmc8Lupqg9gUVxuaThWtVSGnvhG89G7wcfYbMA8Yj7hOElgUKJ9Y/ruHB7ElDjo91yaZTDUsVhmyTVN0EDxgtdWdQKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665744; c=relaxed/simple;
	bh=UR9aESDyXpM7QK738Rg3Ih6qe0xNEXSexz3TPjMDWzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnzN6FB6UTYfTHw0KuLRPfyVqoSieOCqw8c1u9i6VGjAt25VwZuWWD4QnrlZWYAg4kUOYEUeyThBmU8iVZ2/DngMs0A5cF/uK+CpRTuIQ0ebYY9AKwEpOKMlNZgoGJIEzn6FqpKMb2V9DZ9yz53rqivX5p90nXIq/EP42M/OCQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A7AN0tYu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A7AN0tYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633EA1F000E9;
	Tue, 21 Jul 2026 20:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665742;
	bh=CbdQ7klW1csh8cRiX4JObU/uiTi4NVLAa1mEStCtKzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A7AN0tYuHssCY7pSO8Adt9MQU2IZ+A1UugAthvq0CYjJ6II8TKMyCSh6nQmHLIQXi
	 0NjQ/EDzd4Q/RcAMJcFz5IKUAHBgNUwTfrt9+T3OlCf2aK/tKu6/xyAaiQU+7OzDt+
	 SIZQTq6fgIAgHDwVyR/ifMsd2tkw3vbEmxPLvyTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0412/1266] firmware: arm_scmi: Read sensor config as 32-bit value
Date: Tue, 21 Jul 2026 17:14:09 +0200
Message-ID: <20260721152451.057963042@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index 0b5853fa9d874f..4e3e937cb92c18 100644
--- a/drivers/firmware/arm_scmi/sensors.c
+++ b/drivers/firmware/arm_scmi/sensors.c
@@ -777,7 +777,7 @@ static int scmi_sensor_config_get(const struct scmi_protocol_handle *ph,
 	if (!ret) {
 		struct scmi_sensor_info *s = si->sensors + sensor_id;
 
-		*sensor_config = get_unaligned_le64(t->rx.buf);
+		*sensor_config = get_unaligned_le32(t->rx.buf);
 		s->sensor_config = *sensor_config;
 	}
 
-- 
2.53.0



