Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1444FE2C8;
	Thu, 17 Sep 2026 16:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661337; cv=none; b=koq8ElbyY9x3AB6s6knZ8Mv4yrmlO45qZbJfkNNbiKLymCQJZMX1BR761vasPhDjFKGjpefekIIHpwPUmEkK7OjJ15uwUXh3/yGsD4Pe4yxEYGaIILDdqh17tX0ZI++s6p3rQ0kdPBqpJwHzwPM4FOUb4hZCH/zTPFWEZYBNTFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661337; c=relaxed/simple;
	bh=ge4Npb9/kW2yYxs3Gapo8KBjkRF/TfjvRL4Nuehwg6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwR4P2EG5UTlU0C5nj/I9RCnz2HwGIF4/qbL/a150mCdMGCRZtOmz5m2CbDEKYhYWsqXvYpu4HWO2fbCJNLgieK1E+ByNPYqCnsesLAlvS99a/poaS8QKJFJQBYuCz4jDP0AQ3rh+Cn+mhMKjE8LaRZO8RSKRSq5OyjwftVYGs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/kqY6TK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/kqY6TK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317521F000FF;
	Thu, 17 Sep 2026 16:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661335;
	bh=rAlIdaErD52Cu0FEgx9uYVE/KNOEen9tJ909j7AhanA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v/kqY6TKC5A5QQECFSZwCLGo3hayVrCIoTxTOI7swMXcN5JFVKyYNPp7oPFOw6Vzz
	 Q36piau3woSUMlx6HhryRLSUe36aMd+1mLxdYZlYC4/NyijVQyibqM3wA1/u22aRhB
	 lP1Sq9WQGWUni0mgI4xAKJ+tbvIkBG0Jc9EWReoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0160/1250] firmware: arm_scmi: Validate SENSOR_UPDATE payload size
Date: Thu, 17 Sep 2026 15:59:15 +0100
Message-ID: <20260917151556.419233362@linuxfoundation.org>
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
index 1be0f89fc2c4b..99233742714c9 100644
--- a/drivers/firmware/arm_scmi/sensors.c
+++ b/drivers/firmware/arm_scmi/sensors.c
@@ -1074,12 +1074,15 @@ scmi_sensor_fill_custom_report(const struct scmi_protocol_handle *ph,
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
@@ -1093,6 +1096,11 @@ scmi_sensor_fill_custom_report(const struct scmi_protocol_handle *ph,
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



