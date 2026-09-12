Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777322D0C75;
	Sat, 12 Sep 2026 12:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215824; cv=none; b=vA1wzI3ZhlXJ8ZaPLqltRCphXRSfiFK3uE2tzzlBWwMNQgyXmotn66Ir5MygRyEW5nyIm1AL7OJ/w1cE3zF4d8oWt0leESUlm90r4LNGChpgvrXjL4wm8sB7tCJ/C1hDWn7CquvO+FM1T+3Z7Kj8Vu7/6qnZwsGdUyrhyluSHmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215824; c=relaxed/simple;
	bh=JOpptYUwb+PEFDOIa0tUh8rb6X4wITM+WiNu5M9ZVL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUVSfeOXCqY8UFqELuDzmcFcMITbm4tMwpdAHN3jnxFj84VxfeQzukj2EqMLD+MPAVT/RAqdP/7JyqSXuwgkxqL/sHIOPJ9sw7jfdGKpn6AJ1NHXTbl+0GBhGNmK7SS9wddWs7QsHGqP/OaWE4ko/pKYJbKmzCgHVn3EjYxgbVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFyqGsnA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFyqGsnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9529B1F000FF;
	Sat, 12 Sep 2026 12:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215823;
	bh=4kf8Dxl0dl7Y5XXZoMQFtvoRgs9NC2Nsp+IJbZI5k4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UFyqGsnAfpuzQUQ2mwxPaLVpOhrlLwedCGXt7kc6iiVX/Vs1ETABcg4UvDx9qzsIk
	 26WMHCsrOvMXm2h1D+63L/f5cXdo+H0eQkqWUOfnT2jeou/A9A99uYN+mlie4KNKzl
	 8jRLVbx2Gli4eAjlWmezqDa0O5WYGrN6DWpab25s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixuan Li <kaixuan.li@ntu.edu.sg>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0558/1376] drm/bridge: tc358767: clamp the reported AUX read size to the request
Date: Sat, 12 Sep 2026 08:49:44 +0200
Message-ID: <20260912065619.972359992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 47189587643a1..47c9b2d4369ea 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -519,7 +519,7 @@ static ssize_t tc_aux_transfer(struct drm_dp_aux *aux,
 	 * address-only transfer
 	 */
 	if (size)
-		size = FIELD_GET(AUX_BYTES, auxstatus);
+		size = min_t(size_t, size, FIELD_GET(AUX_BYTES, auxstatus));
 	msg->reply = FIELD_GET(AUX_STATUS, auxstatus);
 
 	switch (request) {
-- 
2.53.0



