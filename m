Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394334E324D;
	Wed, 30 Sep 2026 16:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784165; cv=none; b=iHaX+jDfXpH3wdl9swpdmAVDk9udaHv8xMGMOERcAdxdrW4nU9V7cpX8sqb6xI/VOpR7n0pDSijlm+ZzKd0uEiIZodnRKGvFk2PR5ZYFYmwnIHyCkdPKHllhRVcQ9RO4uoZvZ88kkukH6ceLjkaXHXT52EaTDd6MwFNL8jV4CEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784165; c=relaxed/simple;
	bh=4/5O29CRxDfBZQTGCZHJYKPop2mgC8FAAGzC4gLmwXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rM4V677y2TwImsoCHwTFZdTnQS970w6HXlN0CyXalH1nodHFnKC9GSAvLuyG4ns1dKxHlI+EZDEIUyCNielzKyaBvqE51a5yzIpR4byJBYW8GFq3I00WJj/4JA/mwgzdmkf+33KxpfZ0mdXrFXxOghNEl8kZyofSpn/I2Vsf2XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JeDU+KvI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JeDU+KvI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D9F1F00893;
	Wed, 30 Sep 2026 16:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784162;
	bh=o5zH/w6IbZ4lt6895nvrmqC7p9gkRq10PAtm8SwGHjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JeDU+KvIo5FoiJdi7CZ2X/qym2eABtBD6139ozTm0JwVg9/KMG81HOymnBp/531jT
	 cgcFQN+FGBgp31phkIeCGyztlsBamWxKMOYwR16kQgQaIL7BnTFQOPnTEHV6rXkSJW
	 gQHN653yzE+XgjGoldvA5cbz3T/wbRPAZeqL6QMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/982] firmware: arm_scmi: Validate SENSOR_UPDATE payload size
Date: Wed, 30 Sep 2026 17:13:13 +0200
Message-ID: <20260930152418.018658147@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 32bc5496b48174dbca1f187f710955ee4d9527a1 ]

SENSOR_UPDATE carries one or more sensor readings after the fixed
notification header. The parser derives the expected reading count
from the sensor description, but it did not verify that the received
payload contains those entries before parsing them.

Reject truncated update notifications before reading the variable
array.

Link: https://patch.msgid.link/20260517-scmi_fixes-v1-3-d86daec4defd@kernel.org
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/sensors.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/sensors.c b/drivers/firmware/arm_scmi/sensors.c
index 4e3e937cb92c1..900ee86a2c662 100644
--- a/drivers/firmware/arm_scmi/sensors.c
+++ b/drivers/firmware/arm_scmi/sensors.c
@@ -1037,12 +1037,15 @@ scmi_sensor_fill_custom_report(const struct scmi_protocol_handle *ph,
 	case SCMI_EVENT_SENSOR_UPDATE:
 	{
 		int i;
+		size_t expected_sz;
 		struct scmi_sensor_info *s;
 		const struct scmi_sensor_update_notify_payld *p = payld;
 		struct scmi_sensor_update_report *r = report;
 		struct sensors_info *sinfo = ph->get_priv(ph);
 
-		/* payld_sz is variable for this event */
+		if (payld_sz < sizeof(*p))
+			break;
+
 		r->sensor_id = le32_to_cpu(p->sensor_id);
 		if (r->sensor_id >= sinfo->num_sensors)
 			break;
@@ -1056,6 +1059,11 @@ scmi_sensor_fill_custom_report(const struct scmi_protocol_handle *ph,
 		 * readings defined for this sensor or 1 for scalar sensors.
 		 */
 		r->readings_count = s->num_axis ?: 1;
+		expected_sz = sizeof(*p) + r->readings_count *
+			      sizeof(p->readings[0]);
+		if (payld_sz < expected_sz)
+			break;
+
 		for (i = 0; i < r->readings_count; i++)
 			scmi_parse_sensor_readings(&r->readings[i],
 						   &p->readings[i]);
-- 
2.53.0



