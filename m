Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66BB3FE5D;
	Wed, 21 Feb 2024 13:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523845; cv=none; b=s6hqwTYZaSXksEncUsDm7anM/Sz/SF3ok8fwHXEEc0ovHiHyvhjRJOWEz9g7VBNFbgtM1/OkmLLpEyuYOvYDBTBKU8po4a6uPeGbEEVvW3k/WSEJHJWyCMRMQXch+vKKH+gpq7q67BeKWqLo0ZmZXSDr9Wul0VkMSjGoHJg7kU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523845; c=relaxed/simple;
	bh=GinWe6V3hCkFphjbr694RSmyWE3LaydsR3Gl9AIusOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ne+0aYoM1F/bxkW7smunrlzlY1+PgZbLA+m1xVXDQWat69Gc3tJARrH7CJmjZN7c7/7ZFTjIyxgbjmTyn0u+RgCthCLimrT9fWLluaIaWz2dulyNfq8D4j4HG/3GEpQzbE0IaPGPfOjUoGagD3gyEutLpKm7dfbMz886jpC1iww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZUKbT/E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZUKbT/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A47C433F1;
	Wed, 21 Feb 2024 13:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523845;
	bh=GinWe6V3hCkFphjbr694RSmyWE3LaydsR3Gl9AIusOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qZUKbT/EnhKAAoI50cVvdxjSUK8H1eGOs7oTVeWHJ5Uji0xr1TELup4WTUusI58to
	 VzlRepBtdyJ19NagxETqPsmqOwU8u5jsFiSX4TwUc2MlXX5+ZE0QzyPx3Ik8vmHwfP
	 35ePSvPnVuUhvy4Foh6xD1+09R+gYuvZ2faYtNLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Robert Foss <rfoss@kernel.org>
Subject: [PATCH 5.10 074/379] drm/bridge: nxp-ptn3460: fix i2c_master_send() error checking
Date: Wed, 21 Feb 2024 14:04:13 +0100
Message-ID: <20240221125957.101270081@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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


