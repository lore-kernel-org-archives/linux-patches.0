Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217257;
	b=3Vs61JloxZ4Ygzay27ACgPuXPD40ubaNiiBcT/YAK4CYBCDu1da+Wqvlip/abHjkaPYI
	 mLOPSok/ZuQsNvAhqqRVhTE0J4juv7pUZ7M6tG32prsfwycqDCEMjfipRijr/j8tlqYuH
	 38ebDgI4rVOGOAXfVTG88EAJ7y1Fol3SS205rRTGFtIsKzPySnsooFmPpjmiL//6dbdTt
	 G5WVd+GJk63pFzPcgj6rvPAKWzF3s4IHOHaAksI8RX7C4w9FSWDudl1pTpF10zbsXtOji
	 kgoMT4efEAPVqNiQw+PyNLaU1jqHzHRovsqgHBAhErjPQqKOe4wp6orQoOq/1DkAKAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217257;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N8fdsOaTanDc/8ghXwcHJaj7LmKeOSBb/hChKlcSras=;
	b=BsaVwLWSGDUOLRVs9s+TAZdGSWuBeSUayjTlfgiRNsfjDFMOD4MgdxwCnZcBfiIn9IVZ
	 1XahPEcbXs5u3wL+ccEQCR5uhMsIUDN3hqlS7WmMfGSlhJW+dn3NVFQQ+aJgp/19E0yvB
	 AiinaEU6Dte0A7TqPPWxgvzuFRZiuzAGaZ22r2QynSkQ8pURlirTzcKt/ZY6gdjAaIax+
	 SyzxvKN1E0cfsUoqBIUR8NIBgPEsSys9O52vuQ0hiaZBb2D7l/wCjnBo/gU6R+yYtcPOG
	 2/VpCf6jhY0os7yu7j7Apte3mDWNtoJDD1plfttWbleBnraH0AZohrWG95ZJJr6/HUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OPhUCYby;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7D9606A31A;
	Wed, 28 Oct 2026 19:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OPhUCYby
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793FA1F01825;
	Wed, 28 Oct 2026 19:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217257;
	bh=N8fdsOaTanDc/8ghXwcHJaj7LmKeOSBb/hChKlcSras=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OPhUCYbyJvjj5mQ0JgI9rmAH+nzSGdBMh6zf53M6m03GrCq2bK3PWyieUQT/KYzZl
	 axl6NqkSaPjbFHghgxZpk3uC0T0lIB/pnnIy0r5xmCgdt7/7rFhci2JTCpFZ2bRdS6
	 pX8IJvZrQ83phHUc3bG3hodX+Y9DN2X/HAafl9zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1842/1887] firmware: arm_scmi: Fix requested device removal race
Date: Wed, 28 Oct 2026 18:05:38 +0100
Message-ID: <20261028170541.367061817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 2c4097e6c4aed276c5e9ec2ab331ab397ea780bf ]

scmi_protocol_device_unrequest() drops scmi_requested_devices_mtx while
notifying listeners but continues to retain the per-protocol list head.
When two SCMI drivers for the same protocol unregister concurrently, one
thread can remove the final request and free the list head while the other
is running its notifier. The latter then dereferences the freed list head
after reacquiring the mutex and can free it a second time.

Complete the list and IDR updates, including freeing an empty list head,
before dropping the mutex. Keep the blocking notifier outside the critical
section and retain only the detached request across the callback.

Fixes: d3cd7c525fd2 ("firmware: arm_scmi: Refactor protocol device creation")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260722095250.2011630-1-sudeep.holla@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/bus.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index ca68cfa931b0b..ef70232511873 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -157,6 +157,7 @@ static int scmi_protocol_table_register(const struct scmi_device_id *id_table)
  */
 static void scmi_protocol_device_unrequest(const struct scmi_device_id *id_table)
 {
+	struct scmi_requested_dev *rdev, *victim = NULL;
 	struct list_head *phead;
 
 	pr_debug("Unrequesting SCMI device (%s) for protocol %x\n",
@@ -165,29 +166,28 @@ static void scmi_protocol_device_unrequest(const struct scmi_device_id *id_table
 	mutex_lock(&scmi_requested_devices_mtx);
 	phead = idr_find(&scmi_requested_devices, id_table->protocol_id);
 	if (phead) {
-		struct scmi_requested_dev *victim, *tmp;
-
-		list_for_each_entry_safe(victim, tmp, phead, node) {
-			if (!strcmp(victim->id_table->name, id_table->name)) {
-				list_del(&victim->node);
-
-				mutex_unlock(&scmi_requested_devices_mtx);
-				blocking_notifier_call_chain(&scmi_requested_devices_nh,
-							     SCMI_BUS_NOTIFY_DEVICE_UNREQUEST,
-							     (void *)victim->id_table);
-				kfree(victim);
-				mutex_lock(&scmi_requested_devices_mtx);
+		list_for_each_entry(rdev, phead, node) {
+			if (!strcmp(rdev->id_table->name, id_table->name)) {
+				victim = rdev;
+				list_del(&rdev->node);
 				break;
 			}
 		}
 
-		if (list_empty(phead)) {
+		if (victim && list_empty(phead)) {
 			idr_remove(&scmi_requested_devices,
 				   id_table->protocol_id);
 			kfree(phead);
 		}
 	}
 	mutex_unlock(&scmi_requested_devices_mtx);
+
+	if (victim) {
+		blocking_notifier_call_chain(&scmi_requested_devices_nh,
+					     SCMI_BUS_NOTIFY_DEVICE_UNREQUEST,
+					     (void *)victim->id_table);
+		kfree(victim);
+	}
 }
 
 static void
-- 
2.53.0



