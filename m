Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46449215762;
	Thu, 12 Dec 2024 17:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024163; cv=none; b=aLJnKQdVBhOmlZM/Le0RggLhc7Lp0H4HVkL8vY36+99Fd9kDBCCGuHJTcBkAAbcDjq3SF2WzEu8kS22fDqJ8UA9TNtxQ9/qTh3+zSmTpA/dsnaFzhBd7r+CkWrnuW3LHcoKTvINOpEYi+jWiPNss/1o79YXqTk6F9xOA6kgKdqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024163; c=relaxed/simple;
	bh=EabNSxVSTIYgRX0E10EYWHKxfSTGmkVpygtFD0UZumY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbiOG259NXGY/uTU5OTat/TT2eKVp3wi7xtlK/SThKOs8c6L1G8/aDraU9A0DVjOB3y2Z39dWi3cu8SYBqBovYga93oeNE3hV46X8lE1H1G6sOJWKvZPjMc5JrnQmbEMvCKyPiSu17d9e+P5aUhyf2+KpErWs0lyEX783MeLQBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJJL+wj/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJJL+wj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE8DC4CED3;
	Thu, 12 Dec 2024 17:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024163;
	bh=EabNSxVSTIYgRX0E10EYWHKxfSTGmkVpygtFD0UZumY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJJL+wj/0HR3WZEqo5t31dMNFIk+RZ4U0mPBFyEpgNsA2Mh3FAaAwqay3J7fDrys8
	 Tco6IdSN9e+hG63wkI7b8XJAnfLcgCdshGQ0q6uPZY5b8TssHWdE6KKsshxul1durB
	 7pN1Ehh9S6VdnwdwZs+iRvb2SbqOvgQuAqqwuMN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arun Kumar Neelakantam <aneela@codeaurora.org>,
	Deepak Kumar Singh <deesin@codeaurora.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 206/459] rpmsg: glink: Add TX_DATA_CONT command while sending
Date: Thu, 12 Dec 2024 15:59:04 +0100
Message-ID: <20241212144301.705944813@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 28b6ae0e1a2fd..a8486264f11f3 100644
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



