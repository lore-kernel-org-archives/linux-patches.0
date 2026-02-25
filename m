Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3614B21D596;
	Wed, 25 Feb 2026 01:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982970; cv=none; b=Uz9XV1R13Puc3GkLQSbzw5Bmmp/NXoSl/g1JmCKCIJmXmqFF6lz747FIqXzFCSGGi3hZ8BTkeWimwcnWnincJF7wyPrwGIKkkl6nlIhYwIMX++Hc7YovFlXtY1kTzm0oHu8ZRLyzXgMtStGjdSnuIaajwCJ0asdiNSWZWLj8xm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982970; c=relaxed/simple;
	bh=7KvoWp97cC0pfUKCRcUb4YX/UUn7JRMpj+p0Hc/bQq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFNhAzXnZEkM61ZAJ/OitlqhaG+ekz2j0NTeKlavdnmdhXc5HmmOqUMbHW7Qb5pGsYQxGS5yYwfqu5ueHx+f6+k/KNTE1Px2PTob6LqodthSgkQfU5bEAB6w43CdH8t7XHHg+htNP3iixEg3+6Wvzmc+H3NganJoPZAm9L7sAPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NIgfFVFq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIgfFVFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B02C116D0;
	Wed, 25 Feb 2026 01:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982969;
	bh=7KvoWp97cC0pfUKCRcUb4YX/UUn7JRMpj+p0Hc/bQq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NIgfFVFqCTcuUXKLcK/iuvTU99g+2kOFTQDjIR0LJzxwqdXTCwAGw9HL0PSNpdITx
	 rF/DOyStuOBwfQJwhmgEJCFy8NVESKwkevEUkBXVfLQLPTk/+CbAMu98bv5mi0LDIt
	 KBppceRCV6TEQ1uGHiscYEuyGTr/bOu1BbTCaEgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sourav Mohapatra <sourav.mohapatra@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 144/781] firmware: arm_ffa: Correct 32-bit response handling in NOTIFICATION_INFO_GET
Date: Tue, 24 Feb 2026 17:14:13 -0800
Message-ID: <20260225012403.196971448@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index c72ee47565856..c501c3104b3a4 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -981,10 +981,27 @@ static void __do_sched_recv_cb(u16 part_id, u16 vcpu, bool is_per_vcpu)
 	}
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
 
@@ -1001,6 +1018,7 @@ static void ffa_notification_info_get(void)
 		}
 
 		is_64b_resp = (ret.a0 == FFA_FN64_SUCCESS);
+		is_native_resp = (ret.a0 == FFA_FN_NATIVE(SUCCESS));
 
 		ids_processed = 0;
 		lists_cnt = FIELD_GET(NOTIFICATION_INFO_GET_ID_COUNT, ret.a2);
@@ -1017,12 +1035,16 @@ static void ffa_notification_info_get(void)
 
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
@@ -1034,7 +1056,10 @@ static void ffa_notification_info_get(void)
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



