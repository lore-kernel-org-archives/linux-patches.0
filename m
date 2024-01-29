Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F63755F1;
	Mon, 29 Jan 2024 17:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548602; cv=none; b=rFcmPBi9OT5S5uFWiGZ4HH+z7nnWhF50BFzcuySU8p3D/MvIWeLDC80xHYNdRLGW4Ff4I3bKeOeF1KwIhiBc4mVXhgyukfiVahCjHFn5jjtEJlTrFNsJshgYETmHjlIsLK/d8xOLl7dKLIUGRTO5qR2txIo28vRS25YQtQPedB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548602; c=relaxed/simple;
	bh=MpelEEXapeUJWGM2dzKa6l2kTgwm5fMgd/D/ji9toVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPuUnGv5Lz6+y2bT2P63sDjLX1BuuIGVqW/Zc3aeZgOSxpNBcyAN9IbdXMdu+7T38FZYbHDmMeZgNc7SvxYXrcSafZ9V8rgI+W4YHIv4nafzRKIkGfkOUKjb+MvydR+ghEX/j5pAuIcBVZyicWxhCLMkKmmh2td/l1T1i0tZe5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bcOJ2bbz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bcOJ2bbz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F36DC43390;
	Mon, 29 Jan 2024 17:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548602;
	bh=MpelEEXapeUJWGM2dzKa6l2kTgwm5fMgd/D/ji9toVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bcOJ2bbzGYiN1uho/KPpuc4/olackbWVOTjKPupyZ5UtaTbNpYSczhuw/1EHY4O2m
	 UHHa4+pkDDBvxSI5emBdikDezpthDFlXJe/5kJ30hBKfxLzeW8a03b9aK3gSQT/LIe
	 Cmz3/dfzhg/XaJ/LYbBpf4Dia9FDFAtE4wmRil5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Robert Foss <rfoss@kernel.org>
Subject: [PATCH 6.6 265/331] drm/bridge: nxp-ptn3460: simplify some error checking
Date: Mon, 29 Jan 2024 09:05:29 -0800
Message-ID: <20240129170022.619408075@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


