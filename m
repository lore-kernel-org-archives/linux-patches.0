Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F219D3B9D9D;
	Tue, 21 Jul 2026 22:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671439; cv=none; b=QROeL/n++V0tLfg2yBA11/7c5Ykq8mY3aKVSGLRKnQfKpWmsnaX7q7KVUoT/oXTsBBbcHkb8le1ID2fV1c3xYhT0UWCLHDyxOrTcOy5dObR8fRWxdL38P+RcMdd/A2PT0OQDJiFCDf1YNrPAOW45R17MuWXlS+j9fM51M+dYOjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671439; c=relaxed/simple;
	bh=hbZ+4qgVCcI8DT1ZKSmvSr0o0qQsAeIBHXxt2vuDAIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ca4WCOboZYv7yC/58dQy8v/VrI2zzlvIJNzggjJ5+zKGmZ6Tb6E2T7vy0o/Tfu1KEQJArm30z2UNrF7kobUXcWcuq6ly0dQKOAmZxkP7SH38pISia0e9z9wM3Ev7Fp/gpgplAs/s95ZZxJdU9TxY+pL5T03p2IY6zLOrI+UFdgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=irkONB6Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="irkONB6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E50A1F000E9;
	Tue, 21 Jul 2026 22:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671437;
	bh=0ph6XZGH+fgi0+Xfrj0SnjCynIp4A2LbDztjbc6nMog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=irkONB6ZvG5IW5yKtAG3z2IEEkHFf9vivlPzVCvsPZkHyEOTcgBekbrGqRiYMq9Ye
	 9XHDtVE2jdgaS07ks34uEy4z+/CcvbF+96gD8rJ8pgRNbKe743yNqlvRDUCZrCwGDK
	 FNcWqiuU6klUhN92Z3iTnwl9cLQhZozeu8goV3uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 246/843] firmware: arm_scmi: Read sensor config as 32-bit value
Date: Tue, 21 Jul 2026 17:18:01 +0200
Message-ID: <20260721152411.551076371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
index 1ed66d13c06c44..3ce1f8349e3ef1 100644
--- a/drivers/firmware/arm_scmi/sensors.c
+++ b/drivers/firmware/arm_scmi/sensors.c
@@ -646,7 +646,7 @@ static int scmi_sensor_config_get(const struct scmi_protocol_handle *ph,
 	if (!ret) {
 		struct scmi_sensor_info *s = si->sensors + sensor_id;
 
-		*sensor_config = get_unaligned_le64(t->rx.buf);
+		*sensor_config = get_unaligned_le32(t->rx.buf);
 		s->sensor_config = *sensor_config;
 	}
 
-- 
2.53.0



