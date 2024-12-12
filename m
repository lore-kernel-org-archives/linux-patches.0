Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED06520967D;
	Thu, 12 Dec 2024 16:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022609; cv=none; b=EW1PSD+yinpBiFTt77LkfQxBkvGywzKzLmVkuasXmoBqXWKxuojko+rj32Q6dhwmSILw+C6muOoK/U4xUy+vytDqVjmMy77laJuVULU5338lzmP2Jh/XIU5UiBEFXMCVqT/g4axrttt9vCLhNe2lvhnDUI69LDgsYyCnjmRcax0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022609; c=relaxed/simple;
	bh=kx0lY1XUchCJfx2EfFuR57zFYrDFVHvEF95ocRyBl0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdl52eHai5056ovaaw/iVSwUUQHoneomEpYfC1fZ7EVekrHYQQm/8TK+XYm42oSVcTegRBBCI0WZA/OHymVH9WMz8jTMl6bo9j9lW3jtNa4TfL7Fejo+GL+9wp4G/1BKcDzBcjwXRdLzWQcM4IpPn5XeGfY1zD6MI6KnoWYt9wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSQoN/5G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSQoN/5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522E6C4CECE;
	Thu, 12 Dec 2024 16:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022608;
	bh=kx0lY1XUchCJfx2EfFuR57zFYrDFVHvEF95ocRyBl0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSQoN/5GC86Jdt2kRQ3GweE2y1KBJ4i1fPzF/L6MSl8tHR/RN4QFPvun/ty4+j+zu
	 DTdVv65EtjHid8r2p7N0iCsgkNue2wW+JXI9rBX4o0tjN9ofbVreFHcrv8Ngzv+O+U
	 btfZYI+HHbNq+iF+cdAW+fcgHy3VNykqhUhV4W4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arun Kumar Neelakantam <aneela@codeaurora.org>,
	Deepak Kumar Singh <deesin@codeaurora.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 258/565] rpmsg: glink: Add TX_DATA_CONT command while sending
Date: Thu, 12 Dec 2024 15:57:33 +0100
Message-ID: <20241212144321.669806477@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 35e7291aa9696..ecfa04bc9a78d 100644
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



