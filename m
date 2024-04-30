Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC4712B176;
	Tue, 30 Apr 2024 10:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474208; cv=none; b=dcVrmEwFBtFZusXddwBEbuBbK3Fug02mDhi9GlczsM/OzTQPqaxUXZTDP5NMTRF4tGmLYuHa8l1Ks136myGmIKK+Oyc2B8uOwXkeVRIR3Aa/sqcYnm5GcFHvsny/2e6pRvfMeqfWyQ8IenTSkYXx1RGJhh5dA0hry27vwEcdYto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474208; c=relaxed/simple;
	bh=7qJCk5cYk0S6LgFEhDEtoXiuM0vxOOoAMMbK8YSspRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6SaSRxd8jaLzTnIY4MYClMLIlutanIMqWuhKHV8oEA+D7DGfttbTzDEcrcO6t6gjmvjlbO/G+ikvdNBElAFTrhIGaenZvh5Bn21ih0SVIFPvUZt1lQ7R4WL2DirW5RJ2D2kHSY1R6PtCCp2ZcLcqpRR44ZOSqpZBG50ZvwhS34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8LEkPHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8LEkPHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E48C2BBFC;
	Tue, 30 Apr 2024 10:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474208;
	bh=7qJCk5cYk0S6LgFEhDEtoXiuM0vxOOoAMMbK8YSspRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M8LEkPHaMqBJeJ/ulKOoBNKa/MqfdZeWkEexDw0dNB6UlG4Zc+C14xD45uLPwMJUD
	 lJ95j7naLmI+JoQb9PK5DqhMAjcWW3Mvx2QDPSMbvUnIZJ5LChyfJdcRd5TMgI7TDB
	 UGINfLodaEZn4H9gkVBV/61pDCu2n78y2EIadq/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 088/228] Bluetooth: MGMT: Fix failing to MGMT_OP_ADD_UUID/MGMT_OP_REMOVE_UUID
Date: Tue, 30 Apr 2024 12:37:46 +0200
Message-ID: <20240430103106.342777197@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 6eb5fcc416f127f220b9177a5c9ae751cac1cda8 ]

These commands don't require the adapter to be up and running so don't
use hci_cmd_sync_queue which would check that flag, instead use
hci_cmd_sync_submit which would ensure mgmt_class_complete is set
properly regardless if any command was actually run or not.

Link: https://github.com/bluez/bluez/issues/809
Fixes: d883a4669a1d ("Bluetooth: hci_sync: Only allow hci_cmd_sync_queue if running")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 0759975be6479..7e56cb3d377a1 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2616,7 +2616,11 @@ static int add_uuid(struct sock *sk, struct hci_dev *hdev, void *data, u16 len)
 		goto failed;
 	}
 
-	err = hci_cmd_sync_queue(hdev, add_uuid_sync, cmd, mgmt_class_complete);
+	/* MGMT_OP_ADD_UUID don't require adapter the UP/Running so use
+	 * hci_cmd_sync_submit instead of hci_cmd_sync_queue.
+	 */
+	err = hci_cmd_sync_submit(hdev, add_uuid_sync, cmd,
+				  mgmt_class_complete);
 	if (err < 0) {
 		mgmt_pending_free(cmd);
 		goto failed;
@@ -2710,8 +2714,11 @@ static int remove_uuid(struct sock *sk, struct hci_dev *hdev, void *data,
 		goto unlock;
 	}
 
-	err = hci_cmd_sync_queue(hdev, remove_uuid_sync, cmd,
-				 mgmt_class_complete);
+	/* MGMT_OP_REMOVE_UUID don't require adapter the UP/Running so use
+	 * hci_cmd_sync_submit instead of hci_cmd_sync_queue.
+	 */
+	err = hci_cmd_sync_submit(hdev, remove_uuid_sync, cmd,
+				  mgmt_class_complete);
 	if (err < 0)
 		mgmt_pending_free(cmd);
 
@@ -2777,8 +2784,11 @@ static int set_dev_class(struct sock *sk, struct hci_dev *hdev, void *data,
 		goto unlock;
 	}
 
-	err = hci_cmd_sync_queue(hdev, set_class_sync, cmd,
-				 mgmt_class_complete);
+	/* MGMT_OP_SET_DEV_CLASS don't require adapter the UP/Running so use
+	 * hci_cmd_sync_submit instead of hci_cmd_sync_queue.
+	 */
+	err = hci_cmd_sync_submit(hdev, set_class_sync, cmd,
+				  mgmt_class_complete);
 	if (err < 0)
 		mgmt_pending_free(cmd);
 
-- 
2.43.0



