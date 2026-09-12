Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE8D4A35;
	Sat, 12 Sep 2026 19:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242570; cv=none; b=kE2eoXatQvXuQCi6Au2L1sjaYjlMgyGPbMA7DmicAsOl+TBTgrJrgRzR8brVILj9q+QpMyJd1GzOJ44emrkMa4+Mo+OCDH9qZmJb0X4heglJH4dADQUj6rBDf7/SuSTorieujsMhOH01t/9wRMwLc8EdxSVeeb8ZO2D5SFR4/Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242570; c=relaxed/simple;
	bh=rdQ4/GUJsAXJeYtPehHhsQF7QjQUergtUNg0H4GuZ+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c0/EPUaU608SmB3zkY8StLcWo9ItiGVU5TQTsY1R2LsOwsK8rekrcZHVvDh0+itkLxESQrbDXheZijJOX6P9uI2Sm7Jdj6n/msI3btsIqp4cQ7QbadqlSeAeKZ8Cfg14zdZpMxFEDvCbZEWZiseZC6pr6EX2QEUSGqR00jtxzJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VgEj4UJp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VgEj4UJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212FB1F000FF;
	Sat, 12 Sep 2026 19:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242569;
	bh=XJob7eGgol4yhvy6AVJP5ccWK1xbazM34ElCsY69U9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VgEj4UJpsaJSq0ApXiAt2AhnQvOZR5rcnTQ1DLCfsLEqoFkQdAgeBi//cfqwf+ivN
	 vd8ibGcOOr3eDrziRRSLFyf3dlH7HmBtQ2X/I3gSvTa5SotRun0+DH0GZaGbyeZOnY
	 qr5Y5+igqtb/1CzIuEkScJNNozvEUo5riH2dXngA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixuan Li <kaixuan.li@ntu.edu.sg>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 450/798] drm/bridge: tc358767: clamp the reported AUX read size to the request
Date: Sat, 12 Sep 2026 09:01:18 +0200
Message-ID: <20260912065527.454887893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1c7dafb5dc088..dc7b7c534f3ef 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -395,7 +395,7 @@ static ssize_t tc_aux_transfer(struct drm_dp_aux *aux,
 	 * address-only transfer
 	 */
 	if (size)
-		size = FIELD_GET(AUX_BYTES, auxstatus);
+		size = min_t(size_t, size, FIELD_GET(AUX_BYTES, auxstatus));
 	msg->reply = FIELD_GET(AUX_STATUS, auxstatus);
 
 	switch (request) {
-- 
2.53.0



