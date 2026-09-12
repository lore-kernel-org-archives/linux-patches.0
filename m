Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C186125B0AA;
	Sat, 12 Sep 2026 10:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207967; cv=none; b=MQrtlOT1elu9pluzRt0t3/bb1Qs0FoDJwDFvj1zex/+RUpauMmfzroxNJDPcdRS54vGyE4rE/LOHfMrp+JmB+1hByXLHxKK7Lbb1bv/ap3fBSIrBLIUFWcgnTlnFu/mVf5o7lHaV6ow+z+piSWjYzFXhJs7ak4W/PU0sheafDSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207967; c=relaxed/simple;
	bh=WjDd/e/AKNvYAkJvilfeiS9Z5M6oslt0es9E0pZ+Ogo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cc9NkCuq/JjnVbT+Pi0139K7OUSaoVfIX69HMkNJbV8w0/SLT22mjglr09rTvuWWU5VhG51q545zbImRudDlHYlTysHhqo5slb1tcBlT8V2I8G9c+YS339zW39by9Cdoayb4oSgDy3m1eXgIYXOKFxktVj6LPvoYQgCwxFA0vuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdYubd26; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdYubd26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9702F1F000FF;
	Sat, 12 Sep 2026 10:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207966;
	bh=yxUdI7fGrN5KgD77VMR44GGWiKatVsqhaRCug4aKN8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EdYubd26PeFgdZRYpeG93hmjK5/MdCBpG+Mj2JsCEj8+olSNMe1R/e2A+jd0Yt1Og
	 IU+89U793o2+Jv/tnRlvC0idwlH/mgaDNyXOgVes5/2Ej4TyYLB7ejyQVRl2aARZeD
	 QO8SPSy9eHWJJZ3RE5gu4JzjVJqw2i/vFXyXx1Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0522/1518] firmware: arm_scmi: Fix requested device removal race
Date: Sat, 12 Sep 2026 08:44:51 +0200
Message-ID: <20260912065635.254616535@linuxfoundation.org>
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
index e5e4975b2120d..150ea30d0481a 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -159,6 +159,7 @@ static int scmi_protocol_table_register(const struct scmi_device_id *id_table)
  */
 static void scmi_protocol_device_unrequest(const struct scmi_device_id *id_table)
 {
+	struct scmi_requested_dev *rdev, *victim = NULL;
 	struct list_head *phead;
 
 	pr_debug("Unrequesting SCMI device (%s) for protocol %x\n",
@@ -167,29 +168,28 @@ static void scmi_protocol_device_unrequest(const struct scmi_device_id *id_table
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



