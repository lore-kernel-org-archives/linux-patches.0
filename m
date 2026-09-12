Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02B79463;
	Sat, 12 Sep 2026 14:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223569; cv=none; b=rSvCD/ruB2ehL8/IDrWriAdZNOtidgKQNtWpYHycJjVVwgh9LrFe9wmALCHPWNk098FgyOyP7L5vzbmKV6rqr+HcgfbrD7b2rdgvZzdS/vNwYIex3BPA8d6NzTGRxInEgPbZZUB+w9R0dBKX+uDSeaojJUsJJ6qaTf/32R8FPyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223569; c=relaxed/simple;
	bh=+Q8qiKOnAbCnbCZsg/j2g41gxokD5ljcHODSSuCPZWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3wQhekQxEXlMHkM2Q4xXILU1sBacwSPs1tu3Inho73J2+ATdAIF0uoxaxPCb00QCesQmK3IJMHo9lg0fsdHwxJRGSHwRHuo1sNwNqy06ZfvUDZeeoloW50zmjZUhm8g2gui9fjjorlTl090Fh84ZE8CbneSnKH937GJUd+J/ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Am4wmdog; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Am4wmdog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF451F000FF;
	Sat, 12 Sep 2026 14:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223567;
	bh=ZSP8zMsmvTTswNBeU6DtmZYMJHLcdja29s2a+GZpKeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Am4wmdogWztAVpYT2vnboVtcCRwkSdiHifkjKH1VWSD2kbE6yEjtQkUnE0jg02ZAt
	 KuSmkt1xXkC/S1T0Mhb0O2MICxs66OHsbJwTuyEFm1q03SpJ28/dl5IpEvPu1LV1jb
	 23MafbGLCclDS/0i5BMI4H2nHsN7DUODtamgWNtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixuan Li <kaixuan.li@ntu.edu.sg>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0773/1424] drm/bridge: tc358767: clamp the reported AUX read size to the request
Date: Sat, 12 Sep 2026 08:53:25 +0200
Message-ID: <20260912065624.609794010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

[ Upstream commit ec6444a00c49e6c2b5e9a507272a28126677f9ee ]

tc_aux_transfer() clamps an AUX read to the payload limit:

	size_t size = min_t(size_t, DP_AUX_MAX_PAYLOAD_BYTES - 1, msg->size);

After the transfer it replaces size with the byte count the controller
reports in AUX_BYTES:

	if (size)
		size = FIELD_GET(AUX_BYTES, auxstatus);

AUX_BYTES is GENMASK(15, 8), so it can be up to 255. Nothing clamps it
back to the request. tc_aux_read_data() reads that many bytes into the
16-byte auxrdata stack buffer, then copies them into the caller buffer. A
reported count of 255 makes the read run to 256 bytes and overruns both.

The controller should never report more than it was asked to transfer, so
this is defense in depth rather than a live hole. The reported count is
only lightly trusted, and the check is cheap. Clamp it back to the request,
the same way ti-sn65dsi86 does in commit aca58eac52b8 ("drm/bridge:
ti-sn65dsi86: Never store more than msg->size bytes in AUX xfer").

Fixes: 12dfe7c4d9c5 ("drm/bridge: tc358767: Use reported AUX transfer size")
Co-developed-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260701064440.1541418-1-maoyixie.tju@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358767.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/tc358767.c b/drivers/gpu/drm/bridge/tc358767.c
index 6a3f29390313b..b503b5e35a6cf 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -441,7 +441,7 @@ static ssize_t tc_aux_transfer(struct drm_dp_aux *aux,
 	 * address-only transfer
 	 */
 	if (size)
-		size = FIELD_GET(AUX_BYTES, auxstatus);
+		size = min_t(size_t, size, FIELD_GET(AUX_BYTES, auxstatus));
 	msg->reply = FIELD_GET(AUX_STATUS, auxstatus);
 
 	switch (request) {
-- 
2.53.0



