Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52335344D9A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301701; cv=none; b=QcATzt+LOoxGq66XwGp22ddwMdaZnwnhOlfOXbr+f9yNpHO9XbHsbuhvsGBwOd7w4IpKLzfa2gCv3pyIgf1zomnSVtsE9Sq1znctBIVbnDGgkfj+8OvS8QEn9SogmdZ+Bq0YfOJYY0gChiBuo7jtqD5tyaLCf/dhRxit4UQ0Epg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301701; c=relaxed/simple;
	bh=gphx1Q+J0xOn36Pc2fkxUBotTT1GWhhdQQ7pI16JVjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJHBiLwADWbzbLQY1k+f6nnbiw0oJL4M9Q9exHMmQL/ax2CjlYdvq9Ib6/GT051mAm2Xod8cs9qtxlRNCXxzWjX/Om4DbCFl6N6Y0LxGg0CDnTHyj35zWFsTewh76/oB+6sRk/II9psjqlM4MOtxLQikeAHaQHSaPEttZHyBVKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=igS6S74H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="igS6S74H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D20C19423;
	Sat, 28 Feb 2026 18:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301701;
	bh=gphx1Q+J0xOn36Pc2fkxUBotTT1GWhhdQQ7pI16JVjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igS6S74HefzA7yrEezXZzflkmXWo/ViYu6sVcFE7KJuM5eZ0g9a2j3HHemcpy5kIL
	 M2/KrtpMTG91Ogf2OIhTkmG9aWyiI+xM/UIxQw1TK6YiSakaOZoZO7uOQPdaHozQOD
	 Dmdz3mIqXufCBEH1dVwhv4eA2+xZ4hNjHMGcRDDY6ec7JXLEIqw796Y57TvObsq+7A
	 k2KTB6SPbHkSivfwrA+oixmb5Gb1Uw5n2cHNVmoM8YoBewLWU/EoK163vKt9cryFyR
	 xBM8PQVBYEitpuM4PK5C4S66oLWD4Y+0IGh/gEGZMLMLnZqIDPOZFMTf425paaMYnU
	 uxIKIngPtxoyg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sudeep Holla <sudeep.holla@arm.com>,
	Sourav Mohapatra <sourav.mohapatra@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/385] firmware: arm_ffa: Correct 32-bit response handling in NOTIFICATION_INFO_GET
Date: Sat, 28 Feb 2026 12:55:16 -0500
Message-ID: <20260228180011.1568201-94-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit be4d4543f78074fbebd530ba5109d39a2a34e668 ]

The FF-A specification allows NOTIFICATION_INFO_GET to return either a
64-bit (FFA_FN64_SUCCESS) or a 32-bit (FFA_SUCCESS) response, depending on
whether the firmware chooses the SMC64 or SMC32 calling convention.

The driver previously detected the response format by checking ret.a0, but
still interpreted the returned ID lists (x3..x17 or w3..w7) as if they always
followed the 64-bit SMC64 layout. In the SMC32 case, the upper 32 bits of
each argument register are undefined by the calling convention, meaning the
driver could read stale or garbage values when parsing notification IDs.

This resulted in incorrectly decoded partition/VCPU IDs whenever the FF-A
firmware used an SMC32 return path.

Fix the issue by:

- Introducing logic to map list indices to the correct u16 offsets,
  depending on whether the response width matches the kernel word size
  or is a 32-bit response on a 64-bit kernel.
- Ensuring that the packed ID list is parsed using the proper layout,
  avoiding reads from undefined upper halves in the SMC32 case.

With this change, NOTIFICATION_INFO_GET now correctly interprets ID list
entries regardless of the response width, aligning the driver with the FF-A
specification.

Fixes: 3522be48d82b ("firmware: arm_ffa: Implement the NOTIFICATION_INFO_GET interface")
Reported-by: Sourav Mohapatra <sourav.mohapatra@arm.com>
Message-Id: <20251218142001.2457111-1-sudeep.holla@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 33 +++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 9fdfccbc6479a..7e486e49d1eed 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -895,10 +895,27 @@ static void __do_sched_recv_cb(u16 part_id, u16 vcpu, bool is_per_vcpu)
 		callback(vcpu, is_per_vcpu, cb_data);
 }
 
+/*
+ * Map logical ID index to the u16 index within the packed ID list.
+ *
+ * For native responses (FF-A width == kernel word size), IDs are
+ * tightly packed: idx -> idx.
+ *
+ * For 32-bit responses on a 64-bit kernel, each 64-bit register
+ * contributes 4 x u16 values but only the lower 2 are defined; the
+ * upper 2 are garbage. This mapping skips those upper halves:
+ *   0,1,2,3,4,5,... -> 0,1,4,5,8,9,...
+ */
+static int list_idx_to_u16_idx(int idx, bool is_native_resp)
+{
+	return is_native_resp ? idx : idx + 2 * (idx >> 1);
+}
+
 static void ffa_notification_info_get(void)
 {
-	int idx, list, max_ids, lists_cnt, ids_processed, ids_count[MAX_IDS_64];
-	bool is_64b_resp;
+	int ids_processed, ids_count[MAX_IDS_64];
+	int idx, list, max_ids, lists_cnt;
+	bool is_64b_resp, is_native_resp;
 	ffa_value_t ret;
 	u64 id_list;
 
@@ -915,6 +932,7 @@ static void ffa_notification_info_get(void)
 		}
 
 		is_64b_resp = (ret.a0 == FFA_FN64_SUCCESS);
+		is_native_resp = (ret.a0 == FFA_FN_NATIVE(SUCCESS));
 
 		ids_processed = 0;
 		lists_cnt = FIELD_GET(NOTIFICATION_INFO_GET_ID_COUNT, ret.a2);
@@ -931,12 +949,16 @@ static void ffa_notification_info_get(void)
 
 		/* Process IDs */
 		for (list = 0; list < lists_cnt; list++) {
+			int u16_idx;
 			u16 vcpu_id, part_id, *packed_id_list = (u16 *)&ret.a3;
 
 			if (ids_processed >= max_ids - 1)
 				break;
 
-			part_id = packed_id_list[ids_processed++];
+			u16_idx = list_idx_to_u16_idx(ids_processed,
+						      is_native_resp);
+			part_id = packed_id_list[u16_idx];
+			ids_processed++;
 
 			if (ids_count[list] == 1) { /* Global Notification */
 				__do_sched_recv_cb(part_id, 0, false);
@@ -948,7 +970,10 @@ static void ffa_notification_info_get(void)
 				if (ids_processed >= max_ids - 1)
 					break;
 
-				vcpu_id = packed_id_list[ids_processed++];
+				u16_idx = list_idx_to_u16_idx(ids_processed,
+							      is_native_resp);
+				vcpu_id = packed_id_list[u16_idx];
+				ids_processed++;
 
 				__do_sched_recv_cb(part_id, vcpu_id, true);
 			}
-- 
2.51.0

