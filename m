Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1180D27FB2A;
	Tue, 27 May 2025 17:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368088; cv=none; b=Peqxj5UvHnry186nQ56xeZgG2tm3YQZ2d32KqX1qdwFWqRKNlEdRCHXX2mQkos4Fp/IdFZVE6v426I+Y1Jej2vhBe/2b9edz51nKKrViU8+07Hl4SxYKqiJBmL7QP/kOmTQv6fEm4CDBfdqpWZO4RHiOdH4VFJWHqtKxVXauE3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368088; c=relaxed/simple;
	bh=3W3Scc8aodEHrzZ4q3r5IAHsQOoiE/7Qio3PpUDOXgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ip1S8f+h17DvUwpD+6nZxq2HX04eHr8a7C1MVhbkQQC9vTLelMK8x9VP9nEtdJrDrqpPTSuT4jWAI19xYW7R4iMdNvCer8kYLYLjsP3fOXaZGhDANOj8pYk3s/ioa4pJkNBM1t7naOQwGO4o7V+LA+q0DoVKR+J/SvuMV7qghCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V93iAJ+g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V93iAJ+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73913C4CEE9;
	Tue, 27 May 2025 17:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368087;
	bh=3W3Scc8aodEHrzZ4q3r5IAHsQOoiE/7Qio3PpUDOXgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V93iAJ+gFANaAsLxprQ47yU7C+TwFpSPEWG1e4J1lXPZP/o/2OsG8ohcfLP6QPCdq
	 yDKyMYRf3FpBxyAhG+A4SrKf378Im3f+p8PAcdk0VCyH18+BE+B7AlzsUkA8+fVG0x
	 hpGuJswRsP+arpmCDbc3cnAtaTube/rDVJl4H68k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhruva Gole <d-gole@ti.com>,
	Peng Fan <peng.fan@nxp.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 594/783] firmware: arm_scmi: Relax duplicate name constraint across protocol ids
Date: Tue, 27 May 2025 18:26:31 +0200
Message-ID: <20250527162537.321994547@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 7d7af2262c013..5d799f6626963 100644
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



