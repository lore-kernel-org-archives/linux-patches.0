Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32F74CDDDE;
	Thu, 17 Sep 2026 15:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658715; cv=none; b=ANs5qIOnIeDLS5B/5AyuKtYGUD8D9u2+yTBiDNX1po9ntxlWviLnS3svdEQZm6wHdKdP6XvIC+iz/xZ5n7f5M6+iRqhqRU+EtCDJ7wSHVRQRLWbGCRw8wpXU059LrW/XYyMxirEQG3e7d1t0Jd0Co5Q+hHDDpBo/vzJHV0Aa6tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658715; c=relaxed/simple;
	bh=14Ke7cXYsVVNOi1kOvUD8b7mBtTvWxlWmoBLTYYpCVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBnqYSqLpBLZ6S1gYRcuMwxqjHqnbz9UCStPotrfVEtSy07ZYo215xQHTo1GQpxH5dVOWRniFOL1gaLIsmuioTfAxWyEKhY5YWh7gC+iWUTRYuQFJRW1G+pDF3g+1Gh8UFJCLEqzj94i9VaEiUGN+RMpBtOCn5DTt3iWnxZ2qGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mks2e7dz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mks2e7dz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904861F00898;
	Thu, 17 Sep 2026 15:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658710;
	bh=2qBuLwkdxDDpYSCa/ou3dR72t+LGjF78PbfRk7mOrWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mks2e7dztcK07qTkDs1RC+OanLa0M0WJmnhqrpZg389KzQ4EV1QlRns7XdTVdCHqX
	 6i5jKIG2+Eql8eD0vFmpEHvZ2XFgQXBYQTM225yu3tVEyyNnqft92JOqe5XhW4A8pL
	 rRB7ttQx2N38/zjYkTktvKXojW12ZPFbr/p4ElDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruikai Peng <ruikai@pwno.io>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 014/733] accel/qaic: Address potential out-of-bounds read in resp_worker()
Date: Thu, 17 Sep 2026 16:05:22 +0100
Message-ID: <20260917151351.019790322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>

[ Upstream commit ab243f74ab4084ca5c8dec608cb5b0deb27db067 ]

Although 'commit 2feec5ae5df7 ("accel/qaic: Handle DBC deactivation if the
owner went away")' fixes the scenario it was intended for by walking the
message and only decoding QAIC_TRANS_DEACTIVATE_FROM_DEV, if present, it
skipped over the bounds checking code that is included in decode_message().
This could lead to issues such as reading past the slab allocation's end,
infinite loops or kernel panics. For those issues to happen, a malformed
wire message is needed to be sent from the device.

Instead of duplicating the bounds checking code already present in
decode_message(), use the function inside resp_worker().

Reported-by: Ruikai Peng <ruikai@pwno.io>
Fixes: 2feec5ae5df7 ("accel/qaic: Handle DBC deactivation if the owner went away")
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
Signed-off-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Link: https://patch.msgid.link/20260731152344.1905882-1-youssef.abdulrahman@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/qaic_control.c | 46 ++++++++++++++++---------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/accel/qaic/qaic_control.c b/drivers/accel/qaic/qaic_control.c
index 50bf3340e49ce..2ccc55486aac0 100644
--- a/drivers/accel/qaic/qaic_control.c
+++ b/drivers/accel/qaic/qaic_control.c
@@ -963,11 +963,13 @@ static int decode_status(struct qaic_device *qdev, void *trans, struct manage_ms
 
 static int decode_message(struct qaic_device *qdev, struct manage_msg *user_msg,
 			  struct wire_msg *msg, struct ioctl_resources *resources,
-			  struct qaic_user *usr)
+			  struct qaic_user *usr, bool orphaned_deactivate)
 {
+	u32 msg_hdr_count = le32_to_cpu(msg->hdr.count);
 	u32 msg_hdr_len = le32_to_cpu(msg->hdr.len);
 	struct wire_trans_hdr *trans_hdr;
 	u32 msg_len = 0;
+	int trans_type;
 	int ret;
 	int i;
 
@@ -975,10 +977,12 @@ static int decode_message(struct qaic_device *qdev, struct manage_msg *user_msg,
 	    msg_hdr_len > QAIC_MANAGE_MAX_MSG_LENGTH)
 		return -EINVAL;
 
-	user_msg->len = 0;
-	user_msg->count = le32_to_cpu(msg->hdr.count);
+	if (user_msg) {
+		user_msg->len = 0;
+		user_msg->count = msg_hdr_count;
+	}
 
-	for (i = 0; i < user_msg->count; ++i) {
+	for (i = 0; i < msg_hdr_count; ++i) {
 		u32 hdr_len;
 
 		if (msg_len > msg_hdr_len - sizeof(*trans_hdr))
@@ -990,7 +994,20 @@ static int decode_message(struct qaic_device *qdev, struct manage_msg *user_msg,
 		    size_add(msg_len, hdr_len) > msg_hdr_len)
 			return -EINVAL;
 
-		switch (le32_to_cpu(trans_hdr->type)) {
+		trans_type = le32_to_cpu(trans_hdr->type);
+		/*
+		 * orphaned_deactivate is the case where a deactivate response
+		 * is received from the device after the user owning the DBC,
+		 * and the message requesting deactivation, has gone away.
+		 * In this case, only process QAIC_TRANS_DEACTIVATE_FROM_DEV
+		 * transaction and skip the others.
+		 */
+		if (orphaned_deactivate && trans_type != QAIC_TRANS_DEACTIVATE_FROM_DEV) {
+			msg_len += hdr_len;
+			continue;
+		}
+
+		switch (trans_type) {
 		case QAIC_TRANS_PASSTHROUGH_FROM_DEV:
 			ret = decode_passthrough(qdev, trans_hdr, user_msg, &msg_len);
 			break;
@@ -1281,7 +1298,7 @@ static int qaic_manage(struct qaic_device *qdev, struct qaic_user *usr, struct m
 		goto dma_cont_failed;
 	}
 
-	ret = decode_message(qdev, user_msg, rsp, &resources, usr);
+	ret = decode_message(qdev, user_msg, rsp, &resources, usr, false);
 
 dma_cont_failed:
 	free_dbc_buf(qdev, &resources);
@@ -1446,22 +1463,7 @@ static void resp_worker(struct work_struct *work)
 		 * response to the QAIC_TRANS_TERMINATE_TO_DEV transaction,
 		 * otherwise, the user can issue an soc_reset to the device.
 		 */
-		u32 msg_count = le32_to_cpu(msg->hdr.count);
-		u32 msg_len = le32_to_cpu(msg->hdr.len);
-		u32 len = 0;
-		int j;
-
-		for (j = 0; j < msg_count && len < msg_len; ++j) {
-			struct wire_trans_hdr *trans_hdr;
-
-			trans_hdr = (struct wire_trans_hdr *)(msg->data + len);
-			if (le32_to_cpu(trans_hdr->type) == QAIC_TRANS_DEACTIVATE_FROM_DEV) {
-				if (decode_deactivate(qdev, trans_hdr, &len, NULL))
-					len += le32_to_cpu(trans_hdr->len);
-			} else {
-				len += le32_to_cpu(trans_hdr->len);
-			}
-		}
+		decode_message(qdev, NULL, msg, NULL, NULL, true);
 		/* request must have timed out, drop packet */
 		kfree(msg);
 	}
-- 
2.53.0



