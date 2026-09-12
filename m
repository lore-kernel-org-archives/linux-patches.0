Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA8932B108;
	Sat, 12 Sep 2026 15:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226556; cv=none; b=F8VUtXv34qPsqvrpAWQ7TMNathJgg5SxQ0Ra2kIeO0nOFF4TAp2bdPo3pRoCQSSZmS2alfC634X73Mj0msQy822kx0W2k8XytuuD+Ce4RvWlW2vwYH/AVU/s61ad4ufRJqQimeNrnm/UtyfbVFTgnrsz4f92TOXr1L6ZxziNbxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226556; c=relaxed/simple;
	bh=zAsRc5YgckDtVUEgX1bG76eSTT0VotehbAdL+jCWLFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVGxh2vsMZtriXh16/Yyod4AGDQ4fZTJwUJofruzSuXu70oiFmld9Q3lg05zzl/rnAYnftIKaNU0c2/l7iZ3WqysZ7jR+Wc+T6oeMg1n+N5Ig29zJxO1HsTTOK1XodLwANxfJ9/4sBr9iLVKCumB6wfMkWxW8CRm9pXnay8LoAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8kXzMfd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8kXzMfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620AE1F000FF;
	Sat, 12 Sep 2026 15:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226555;
	bh=z1X5kKz8lPw4N8stoPc/hEIMqKRGX58glW38GEq5VnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y8kXzMfd/S+FFypl+u6mRbyZrdBohUusOP10CqxurMiDkIKghJ22S6vrc4ZCXv2i1
	 EennAxQJEmPH7Ijob6Ho0PpvWPvGzEsx2FW7CQjHu/wYv9yPD6iL0JBQjXJd6G+Q45
	 GWZk5d/hFMS3cjhdlqWR+Wbk7n3uyN7kDw9X5ATg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1413/1424] firmware: arm_scmi: Roll back partial protocol table registration
Date: Sat, 12 Sep 2026 09:04:05 +0200
Message-ID: <20260912065638.904016975@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 8d7f90594ee72..22e5ed1f73202 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -134,17 +134,6 @@ static int scmi_protocol_device_request(const struct scmi_device_id *id_table)
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
@@ -190,6 +179,26 @@ static void scmi_protocol_device_unrequest(const struct scmi_device_id *id_table
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



