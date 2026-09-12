Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99644346AE3;
	Sat, 12 Sep 2026 07:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198755; cv=none; b=Lrh/ey0bOSjQqWFamunEAg95w8jObKU7w4srxTtjssfY/i1Clf+q5zn5PrmrKsKwbGLuhgVE+xK3kIUSmvUSg79J758xP+K/N8yx/nzp/772Zj3Wsp9+VPTxrax90arrxyQSsAI8wAIQN0h8us+gff+LI5FKSgjh1i3IXppm818=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198755; c=relaxed/simple;
	bh=lLqEhPX8gmis4xts/+JP9FQTdSGBheGlPsuPH9uypRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItGBcCga9rnrySbSZpuFdUjVB2EmBvOMAysmHFaY3xNxcANpNgb6B9LQYFxQdQLlH09V62Ty1mwZhpdvM252m+IAQ9oVLfwiwwMog8u9d2++mMMHVVFjex/pzgCAdbkNQEeFGMS5Cj/pZ5pJ6K6Ndx4YrDzvBYHEkEH0VB5mJzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGrBk5qd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGrBk5qd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5125B1F000FF;
	Sat, 12 Sep 2026 07:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198753;
	bh=Sg1eXcW9mU+UB7sXQfUhs5um7tPsjHJy03GxSHIsrA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KGrBk5qduhmLifvFApe1cfN4RF5hPSXewyvUEgnILZPLteTQjVElXEp7ZIwTxtMKb
	 WIjP81k8zCT4pf6t0hPH6nsy1FYfK4T7FZiO3IuWSl6YObbObbklbRAeMdfoHI6N6a
	 znZzrZlXLkjNkW2ZBG8zycI+KzMPCcI8nbI5X/IY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixuan Li <kaixuan.li@ntu.edu.sg>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0444/1815] drm/bridge: tc358767: clamp the reported AUX read size to the request
Date: Sat, 12 Sep 2026 08:36:34 +0200
Message-ID: <20260912065659.317606494@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index 7188935fdb826..948bb7b2867a0 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -527,7 +527,7 @@ static ssize_t tc_aux_transfer(struct drm_dp_aux *aux,
 	 * address-only transfer
 	 */
 	if (size)
-		size = FIELD_GET(AUX_BYTES, auxstatus);
+		size = min_t(size_t, size, FIELD_GET(AUX_BYTES, auxstatus));
 	msg->reply = FIELD_GET(AUX_STATUS, auxstatus);
 
 	switch (request) {
-- 
2.53.0



