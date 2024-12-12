Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3C313CA81;
	Thu, 12 Dec 2024 17:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025282; cv=none; b=Yb/VPaBp6MqeWhZ08yPE4ynFjWLuOd4l67MwcBBxvfwmUOk5hCFBYFN784SshNwRGt25L6T77VLh0K9nIqj+v4KFQY5LkhoPK0X01jpi2mGtT38EDWgEA+2bC/E6MrJmAW/Y70kK/31r4zRRNn79QSbn6Pe25TWC1eArmkta1s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025282; c=relaxed/simple;
	bh=EYd0wh+ocM+NGzhkBPxy+9vo8t8/rMBcSWgvCjmmLCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AjvXL8kWqxseP6CYeuyx8zy2ptmpcA/2rBMyr5TnNZi1i5jfBy0kjUm4KhF5nWgqUzFAfc0FLKXe1jI9g4LFm9aOk9ts3htOcwN9D9G3rKIwCnCq43Yw6mBxyQRnPy4bt9h5iGj+LLhIa9L/Txe/n5e/Y8D5uhyBnDqSWahxEEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hhJlrZfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hhJlrZfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B9DC4CECE;
	Thu, 12 Dec 2024 17:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025282;
	bh=EYd0wh+ocM+NGzhkBPxy+9vo8t8/rMBcSWgvCjmmLCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hhJlrZfs0W8vVLc4kzpzjjJrA1gRzQEg1w3TXPMDMdz/hPRGFCW8td+QIhzf4RayE
	 10maNQsvjJFGOyV9X3sqPm0N4Z9TBl36m2XdbBfzWy15pCXDlhgmP1wJEztmPXRSzw
	 8UZRnEF47RoKBKwwvRTZrNJojai/7J2AIfdGBfVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arun Kumar Neelakantam <aneela@codeaurora.org>,
	Deepak Kumar Singh <deesin@codeaurora.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 118/321] rpmsg: glink: Add TX_DATA_CONT command while sending
Date: Thu, 12 Dec 2024 16:00:36 +0100
Message-ID: <20241212144234.642514855@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arun Kumar Neelakantam <aneela@codeaurora.org>

[ Upstream commit 8956927faed366b60b0355f4a4317a10e281ced7 ]

With current design the transport can send packets of size upto
FIFO_SIZE which is 16k and return failure for all packets above 16k.

Add TX_DATA_CONT command to send packets greater than 16k by splitting
into 8K chunks.

Signed-off-by: Arun Kumar Neelakantam <aneela@codeaurora.org>
Signed-off-by: Deepak Kumar Singh <deesin@codeaurora.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/1596086296-28529-4-git-send-email-deesin@codeaurora.org
Stable-dep-of: 06c59d97f63c ("rpmsg: glink: use only lower 16-bits of param2 for CMD_OPEN name length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_glink_native.c | 38 +++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index 2dea1e7487bb4..421ed358ad9cd 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1276,6 +1276,8 @@ static int __qcom_glink_send(struct glink_channel *channel,
 	} __packed req;
 	int ret;
 	unsigned long flags;
+	int chunk_size = len;
+	int left_size = 0;
 
 	if (!glink->intentless) {
 		while (!intent) {
@@ -1309,18 +1311,46 @@ static int __qcom_glink_send(struct glink_channel *channel,
 		iid = intent->id;
 	}
 
+	if (wait && chunk_size > SZ_8K) {
+		chunk_size = SZ_8K;
+		left_size = len - chunk_size;
+	}
 	req.msg.cmd = cpu_to_le16(RPM_CMD_TX_DATA);
 	req.msg.param1 = cpu_to_le16(channel->lcid);
 	req.msg.param2 = cpu_to_le32(iid);
-	req.chunk_size = cpu_to_le32(len);
-	req.left_size = cpu_to_le32(0);
+	req.chunk_size = cpu_to_le32(chunk_size);
+	req.left_size = cpu_to_le32(left_size);
 
-	ret = qcom_glink_tx(glink, &req, sizeof(req), data, len, wait);
+	ret = qcom_glink_tx(glink, &req, sizeof(req), data, chunk_size, wait);
 
 	/* Mark intent available if we failed */
-	if (ret && intent)
+	if (ret && intent) {
 		intent->in_use = false;
+		return ret;
+	}
 
+	while (left_size > 0) {
+		data = (void *)((char *)data + chunk_size);
+		chunk_size = left_size;
+		if (chunk_size > SZ_8K)
+			chunk_size = SZ_8K;
+		left_size -= chunk_size;
+
+		req.msg.cmd = cpu_to_le16(RPM_CMD_TX_DATA_CONT);
+		req.msg.param1 = cpu_to_le16(channel->lcid);
+		req.msg.param2 = cpu_to_le32(iid);
+		req.chunk_size = cpu_to_le32(chunk_size);
+		req.left_size = cpu_to_le32(left_size);
+
+		ret = qcom_glink_tx(glink, &req, sizeof(req), data,
+				    chunk_size, wait);
+
+		/* Mark intent available if we failed */
+		if (ret && intent) {
+			intent->in_use = false;
+			break;
+		}
+	}
 	return ret;
 }
 
-- 
2.43.0



