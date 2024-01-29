Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F2B15B110;
	Mon, 29 Jan 2024 17:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548218; cv=none; b=knSyYxHU5+fJaD7+wwbaSKl6RQljcPvA/Jup9oXOmSpia5x2b/bgcQD9KoY432TJz10cP0vEcQTkjeSDMHGX1txbYkcNjLaulYTuq3fuWV7y4/n4YOmfbGXebNnPBseG9XNTsV/4kVW1qDQmQ9Gl5Me2J2Oe0svKff4U6G83pQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548218; c=relaxed/simple;
	bh=sC5kgF6TCj7kAN/DJhTN20COMfo9qXFChkOuiC5z5Ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmet8NOZy7YQ9MIfeKhWfJdEC52L/top/QNzU1LE1pwxRehz1TkLSNMMz1h1WvvEsIveVgC9Qn5aGice7ZCfmzYLksqRdyC0u/pn7EtZxacmrq88m7xYqarjGwzFp5xgbmiFGw5fhs+amlikmJJ/676r5X4xAg1v5AdBY200TKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NyebupEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NyebupEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD6BC433C7;
	Mon, 29 Jan 2024 17:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548218;
	bh=sC5kgF6TCj7kAN/DJhTN20COMfo9qXFChkOuiC5z5Ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NyebupEjxPNZDuSppj2f4jFtL2QB/zn8chVKuu8BjdMixhJo4nIr8k6M+3XhfPd+r
	 tBLlAa7eDnVFuKGbxa7IDBD3KdgmNTCbbXGoHsYT4zprLQpXBj62sFU9pKthOn2OBG
	 Dqe50Ds84mi3Ap4ws1ifyCwJGbmEn+1PRljbg3NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Robert Foss <rfoss@kernel.org>
Subject: [PATCH 6.7 250/346] drm/bridge: nxp-ptn3460: fix i2c_master_send() error checking
Date: Mon, 29 Jan 2024 09:04:41 -0800
Message-ID: <20240129170023.773248407@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 914437992876838662c968cb416f832110fb1093 upstream.

The i2c_master_send/recv() functions return negative error codes or the
number of bytes that were able to be sent/received.  This code has
two problems.  1)  Instead of checking if all the bytes were sent or
received, it checks that at least one byte was sent or received.
2) If there was a partial send/receive then we should return a negative
error code but this code returns success.

Fixes: a9fe713d7d45 ("drm/bridge: Add PTN3460 bridge driver")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/0cdc2dce-ca89-451a-9774-1482ab2f4762@moroto.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/nxp-ptn3460.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/bridge/nxp-ptn3460.c
+++ b/drivers/gpu/drm/bridge/nxp-ptn3460.c
@@ -56,13 +56,13 @@ static int ptn3460_read_bytes(struct ptn
 	ret = i2c_master_send(ptn_bridge->client, &addr, 1);
 	if (ret <= 0) {
 		DRM_ERROR("Failed to send i2c command, ret=%d\n", ret);
-		return ret;
+		return ret ?: -EIO;
 	}
 
 	ret = i2c_master_recv(ptn_bridge->client, buf, len);
-	if (ret <= 0) {
+	if (ret != len) {
 		DRM_ERROR("Failed to recv i2c data, ret=%d\n", ret);
-		return ret;
+		return ret < 0 ? ret : -EIO;
 	}
 
 	return 0;
@@ -78,9 +78,9 @@ static int ptn3460_write_byte(struct ptn
 	buf[1] = val;
 
 	ret = i2c_master_send(ptn_bridge->client, buf, ARRAY_SIZE(buf));
-	if (ret <= 0) {
+	if (ret != ARRAY_SIZE(buf)) {
 		DRM_ERROR("Failed to send i2c command, ret=%d\n", ret);
-		return ret;
+		return ret < 0 ? ret : -EIO;
 	}
 
 	return 0;


