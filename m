Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E72235358;
	Sat, 12 Sep 2026 07:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199611; cv=none; b=cGdajE7Kp7AT+TgVZpSetYTsWMNAq2b1lEaYElT4Vt/lECaLXzk1Rb7obNyPuVhLKAs98LQ0w64KpcNwaqOxuZD4W4oa+JepQDt2UR/Ndjp/diM19y31N0qVGMek2Ko/5pUTA+duWvt9ZL/hQn0gsG1vKr4TQqIHG4sUlYyhrYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199611; c=relaxed/simple;
	bh=CgB6B4DmXasrpSQEMKwapJ+E4K3+gT2gaj+dJj9aeE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R08UdU7yORHESdHPZs1lLAMXjcq9M7qez8Fpd4gmA973pbb+6DdIFbo/KBk2d75cK4fX65sBH0hGChJQgoh01L6e1ROlk+mhiCkq0rOWTLLlXpsY1tgQdJ8G4knAad7z9CY0sQtXnw1FYWinzwt1mSsAdAGEM5u61gWz0oBhz7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/7cpY8h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/7cpY8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C612F1F000FF;
	Sat, 12 Sep 2026 07:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199609;
	bh=VeAFwHxY2AMSGinv1I+j67YIp3zUyWhoIJ0erLPkVBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s/7cpY8h67txSXtXX0iw7L59Q54Yi4L5bM8s/TGRtLTuPj/Q4uUl3pAvhg28BhxPh
	 otv4PF514L1nDpQ2AgrfCpv4Tz31oYBxk9fOtHKa95UZXFAh/ead+LlVcjox6jQycy
	 qxon9ym5fKgyf7MtOgEB7KD9DPm0Fo/WXHzm52k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0620/1815] firmware: arm_scmi: Roll back partial protocol table registration
Date: Sat, 12 Sep 2026 08:39:30 +0200
Message-ID: <20260912065703.435556433@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 2224b622260ba590ab56ea1585d6bf7610be25b2 ]

scmi_protocol_table_register() can leave earlier requests registered when
a later entry in the same ID table fails. Each request retains a pointer
to the driver's ID table, so a failed module load can leave a dangling
pointer after the module storage is released.

Unrequest only the successfully registered prefix, in reverse order,
before returning the failure. Leave the failed entry and the remaining
entries untouched because matching requests can be owned by another
driver.

Fixes: 2858f6e5f064 ("firmware: arm_scmi: Add multiple protocols registration support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260722173521.2184378-1-sudeep.holla@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/bus.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index cdaea09d96114..d520910eb2515 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -135,17 +135,6 @@ static int scmi_protocol_device_request(const struct scmi_device_id *id_table)
 	return ret;
 }
 
-static int scmi_protocol_table_register(const struct scmi_device_id *id_table)
-{
-	int ret = 0;
-	const struct scmi_device_id *entry;
-
-	for (entry = id_table; entry->name && ret == 0; entry++)
-		ret = scmi_protocol_device_request(entry);
-
-	return ret;
-}
-
 /**
  * scmi_protocol_device_unrequest  - Helper to unrequest a device
  *
@@ -191,6 +180,26 @@ static void scmi_protocol_device_unrequest(const struct scmi_device_id *id_table
 	}
 }
 
+static int scmi_protocol_table_register(const struct scmi_device_id *id_table)
+{
+	const struct scmi_device_id *entry;
+	int ret;
+
+	for (entry = id_table; entry->name; entry++) {
+		ret = scmi_protocol_device_request(entry);
+		if (ret)
+			goto err_unrequest;
+	}
+
+	return 0;
+
+err_unrequest:
+	while (entry != id_table)
+		scmi_protocol_device_unrequest(--entry);
+
+	return ret;
+}
+
 static void
 scmi_protocol_table_unregister(const struct scmi_device_id *id_table)
 {
-- 
2.53.0



