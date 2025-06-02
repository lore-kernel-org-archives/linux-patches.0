Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D8C1CBA18;
	Mon,  2 Jun 2025 14:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873918; cv=none; b=ReARnZ+b4aj2GyeGHVCe3+Dwqp29hzqhxkK75y9CSbZYVvtTa7xmXPbgaexCj4FdpqAMrjUqjdMl/wrjIZ+GTMaVHoS/z5pmwq7mOTCnSboQbV5XAca2WwOHIxBpoo0fJ6+8L3/thGZJ9mN9AqRu+/zPWlxlUFa0NBBCrJIB/tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873918; c=relaxed/simple;
	bh=dRVAUvhAk2CFux79QZePhVv0V1+k6KW7NCFaZRwMHuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLYSvfyzU1yZuVCdTuAQmp1LANjou/Y/r11+8ACKx37bWXmE1Hm1fbXJdcvVINbv6Qj/ZZVQrfP4HpTlu8pjJbI1vnaYbAik+MkqunLeY6qvsmA5R9rKO4DRYQSnMOBodKlo/Mqx06jbo1qHoRWLQXkcvE7QsgHXp4Nnr56/pvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWhelObU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWhelObU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83079C4CEEB;
	Mon,  2 Jun 2025 14:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873917;
	bh=dRVAUvhAk2CFux79QZePhVv0V1+k6KW7NCFaZRwMHuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWhelObUVrmR/pmhVl++CSkWc6B2PPK/TjZ4BQEGqDdJm0ZKb5HQSGdt5Rcz2hfy2
	 CP989fFwnycZbOtixBNiUYE8X34FtF6Xf2WkvZxdSKpyzKQgfppSC95oFQIq5ftp3i
	 +tXORUNz4COUBnpoAf6GtcuWhrZRK8qOfFI2+glI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhruva Gole <d-gole@ti.com>,
	Peng Fan <peng.fan@nxp.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 296/444] firmware: arm_scmi: Relax duplicate name constraint across protocol ids
Date: Mon,  2 Jun 2025 15:46:00 +0200
Message-ID: <20250602134352.964860971@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 21ee965267bcbdd733be0f35344fa0f0226d7861 ]

Currently in scmi_protocol_device_request(), no duplicate scmi device
name is allowed across any protocol. However scmi_dev_match_id() first
matches the protocol id and then the name. So, there is no strict
requirement to keep this scmi device name unique across all the protocols.

Relax the constraint on the duplicate name across the protocols and
inhibit only within the same protocol id.

Message-Id: <20250131141822.514342-1-sudeep.holla@arm.com>
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/bus.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index 51eeaf14367da..e1b949aedf9e0 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -42,7 +42,7 @@ static atomic_t scmi_syspower_registered = ATOMIC_INIT(0);
  * This helper let an SCMI driver request specific devices identified by the
  * @id_table to be created for each active SCMI instance.
  *
- * The requested device name MUST NOT be already existent for any protocol;
+ * The requested device name MUST NOT be already existent for this protocol;
  * at first the freshly requested @id_table is annotated in the IDR table
  * @scmi_requested_devices and then the requested device is advertised to any
  * registered party via the @scmi_requested_devices_nh notification chain.
@@ -52,7 +52,6 @@ static atomic_t scmi_syspower_registered = ATOMIC_INIT(0);
 static int scmi_protocol_device_request(const struct scmi_device_id *id_table)
 {
 	int ret = 0;
-	unsigned int id = 0;
 	struct list_head *head, *phead = NULL;
 	struct scmi_requested_dev *rdev;
 
@@ -67,19 +66,13 @@ static int scmi_protocol_device_request(const struct scmi_device_id *id_table)
 	}
 
 	/*
-	 * Search for the matching protocol rdev list and then search
-	 * of any existent equally named device...fails if any duplicate found.
+	 * Find the matching protocol rdev list and then search of any
+	 * existent equally named device...fails if any duplicate found.
 	 */
 	mutex_lock(&scmi_requested_devices_mtx);
-	idr_for_each_entry(&scmi_requested_devices, head, id) {
-		if (!phead) {
-			/* A list found registered in the IDR is never empty */
-			rdev = list_first_entry(head, struct scmi_requested_dev,
-						node);
-			if (rdev->id_table->protocol_id ==
-			    id_table->protocol_id)
-				phead = head;
-		}
+	phead = idr_find(&scmi_requested_devices, id_table->protocol_id);
+	if (phead) {
+		head = phead;
 		list_for_each_entry(rdev, head, node) {
 			if (!strcmp(rdev->id_table->name, id_table->name)) {
 				pr_err("Ignoring duplicate request [%d] %s\n",
-- 
2.39.5



