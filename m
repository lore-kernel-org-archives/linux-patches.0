Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1179E427F9C;
	Sat, 12 Sep 2026 10:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208145; cv=none; b=jadlohU9x+SDhn1Q4+Yz47QTvcNV6/Sl4lpBDKkK4sytHTSspEdr8jK3AYdxfaqLJbpoEQsmgR7AcVXkiOnXz86iq5OY/BsnNrmpeFeAy2uIPs2CSql1SnWNPSTY897yjKLqXEMN9I4noJft6CpLYE15Mlze/kvbLxUgTxg1RFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208145; c=relaxed/simple;
	bh=TbIOy9L/FrQRKmQGJnbT2VKTEhsIbmZQmbP8oNh+sAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVBf/zbQ0uoy1VNkPSgK7K/7s9TCClzNctQjWUsO7YneMQXiNe+shdD3zDK2kFU6sF7Ba1SuFOI/dVwP7N17r3xCaULpjXVOLQWGxswwYegW+56NQRq1sEr2p4ECJauNK85C6QONGEYnsxoUk9VLrBlzrJjhcjsvLZgADX1vx50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q9yO12BY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q9yO12BY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D684C1F000FF;
	Sat, 12 Sep 2026 10:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208144;
	bh=ei7lISBOhoDvgEKGeVaTqXnCGm+SeTP0iMWCO/9XkTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q9yO12BY4mAFzVLaxlLpBupIU/B4L9+1mQ76+/9HxbKkpF/QuK9cRD2O3OQvAVcAR
	 bpDVMxKSmJ6ljHQ8ax44vCo/n/oBByF7apSDigIJShfI2XoKYyWCzAfjRTUkQq26Gq
	 GIJbnaf6eM+HCWoP438OS/Y+OVlpvsY5AfLwYsss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0551/1518] firmware: arm_scmi: Roll back partial protocol table registration
Date: Sat, 12 Sep 2026 08:45:20 +0200
Message-ID: <20260912065635.904132503@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 150ea30d0481a..dabde487e7420 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -136,17 +136,6 @@ static int scmi_protocol_device_request(const struct scmi_device_id *id_table)
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
@@ -192,6 +181,26 @@ static void scmi_protocol_device_unrequest(const struct scmi_device_id *id_table
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



