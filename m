Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A017E110;
	Wed, 21 Feb 2024 14:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525065; cv=none; b=hQiPvPn9DrFaeaL32sSm0En5TEiCkpfu+KmphDFhGdbjn2I6iV6dPN354YPHuHolHK/+TNx6R13P90r7+GLRQyVFhL9IWT/oRdULSmfTnVMLlQ5DLXkjc3ASgijGSXUVJP5+JSQ3Wi5Nae3MF2IR7s1jPGltx4iaot8+2JcfihU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525065; c=relaxed/simple;
	bh=xEFNDpiNcW5jMbt4RJBjG25s751zRXLqvN7GXqUiJBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HjG/nBek5f+Yvzmlgw7uL2Eaf/B2olCSTKYUnVBb96r4l0jINv2bmWRls3JFz5v1J9prsEs4P9quy6h0JgRVDKCw0O6XO80p2Jb36vEXYceef8J8W+gjGBUdKWHkX854i3w8F/7rP6+FjFZzAnasCFtDOdSlkImJ8uo1el4XV2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hydfFRL7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hydfFRL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD15EC433C7;
	Wed, 21 Feb 2024 14:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525065;
	bh=xEFNDpiNcW5jMbt4RJBjG25s751zRXLqvN7GXqUiJBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hydfFRL7nGj2+lNcqEQXoSQADk+UQUCFvTFObt/8gY/gMIKYeNh5J9+9eZyzoFQ8p
	 F3ASe5tUMFZeqjokTl9mjSoOK0qppdHQppRRcYUVN6aCi50NVjPHV3CqqTc9Jr8bvO
	 ABm+Aj3OUqma1jz6WBuSJRBRMYHEFFyWAVsGkmx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Robert Foss <rfoss@kernel.org>
Subject: [PATCH 5.4 051/267] drm/bridge: nxp-ptn3460: simplify some error checking
Date: Wed, 21 Feb 2024 14:06:32 +0100
Message-ID: <20240221125941.606948469@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 28d3d0696688154cc04983f343011d07bf0508e4 upstream.

The i2c_master_send/recv() functions return negative error codes or
they return "len" on success.  So the error handling here can be written
as just normal checks for "if (ret < 0) return ret;".  No need to
complicate things.

Btw, in this code the "len" parameter can never be zero, but even if
it were, then I feel like this would still be the best way to write it.

Fixes: 914437992876 ("drm/bridge: nxp-ptn3460: fix i2c_master_send() error checking")
Suggested-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/04242630-42d8-4920-8c67-24ac9db6b3c9@moroto.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/nxp-ptn3460.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/bridge/nxp-ptn3460.c
+++ b/drivers/gpu/drm/bridge/nxp-ptn3460.c
@@ -54,15 +54,15 @@ static int ptn3460_read_bytes(struct ptn
 	int ret;
 
 	ret = i2c_master_send(ptn_bridge->client, &addr, 1);
-	if (ret <= 0) {
+	if (ret < 0) {
 		DRM_ERROR("Failed to send i2c command, ret=%d\n", ret);
-		return ret ?: -EIO;
+		return ret;
 	}
 
 	ret = i2c_master_recv(ptn_bridge->client, buf, len);
-	if (ret != len) {
+	if (ret < 0) {
 		DRM_ERROR("Failed to recv i2c data, ret=%d\n", ret);
-		return ret < 0 ? ret : -EIO;
+		return ret;
 	}
 
 	return 0;
@@ -78,9 +78,9 @@ static int ptn3460_write_byte(struct ptn
 	buf[1] = val;
 
 	ret = i2c_master_send(ptn_bridge->client, buf, ARRAY_SIZE(buf));
-	if (ret != ARRAY_SIZE(buf)) {
+	if (ret < 0) {
 		DRM_ERROR("Failed to send i2c command, ret=%d\n", ret);
-		return ret < 0 ? ret : -EIO;
+		return ret;
 	}
 
 	return 0;


