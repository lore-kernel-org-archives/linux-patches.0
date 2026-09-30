Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FD1533588;
	Wed, 30 Sep 2026 17:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790689; cv=none; b=cnK32FDm9gkSELG8hvI/M25V3GZfKEiqnzZx4S/9T8G/k3IqKx0UXHM+I9iBVTz/pqtqyG9pdWl98DCW4w5d4ktud0CK7bKbMabgqFzWQQ4CFDavx6avouiNnwVskIVXN0vuIPWOT5B+3Kig2yum7rSPHHKD1fMKnQCVwbkWcbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790689; c=relaxed/simple;
	bh=8vEauiBGaOKVjQSKc8fVnhV204hFqmlb5UbBhJQss/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxP1pDY/+8cTd6ZPC3vPAnMZPMwe/ppg7KyPgvReJbtVmNkRfRNaY2UowjRWp7wlozYoElRILwoxLMdTnt96+lTNFhdbtkuA0705OI4X4XRT4ff0hnWO0mBWUH9PleePRC6hD1xsMiu+CzDuCqnZ6wlt1twyXqGwkOOJyHuNcmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZuTPFqcb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZuTPFqcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74DA91F000FF;
	Wed, 30 Sep 2026 17:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790688;
	bh=4fbroLN4V9Bi4q5oSTOygB5kfaKD155Ft6OY5MIBSpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZuTPFqcbUiwRshMM1ufQXum50LiPiE5spKDypgnk5jHMbVfwVb/XZtcuUHKajicma
	 JFXSPHFlWF0RASDAd59qH7898SrJKcDpADQXnMrDiby0pff7Bpa4SI4wT10nVz7EGf
	 961RUhz4YLIVru4HeAKFqkXKXfQVAc9ZT9m+KT+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/752] firmware: arm_scmi: Validate SENSOR_UPDATE payload size
Date: Wed, 30 Sep 2026 17:18:30 +0200
Message-ID: <20260930152359.021076221@linuxfoundation.org>
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
index 3ce1f8349e3ef..c65c3411442d1 100644
--- a/drivers/firmware/arm_scmi/sensors.c
+++ b/drivers/firmware/arm_scmi/sensors.c
@@ -906,12 +906,15 @@ scmi_sensor_fill_custom_report(const struct scmi_protocol_handle *ph,
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
@@ -925,6 +928,11 @@ scmi_sensor_fill_custom_report(const struct scmi_protocol_handle *ph,
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



