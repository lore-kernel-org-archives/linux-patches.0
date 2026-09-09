Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C22563FCF;
	Wed,  9 Sep 2026 14:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964082; cv=none; b=nLxzyIEyjKvwTGobFRvnrHOFQAWWECKrdJNagPczQD34ikxCwYjQ7rk3YgcaHCJXFLT1vyxwdpgCfe4xCGUtgej8Lwgzr1aa99S9OpKX625f5YqEP539m+H3lqrLqLZPxy+bY02QR23jz78x492505c3epxZW+khi4S9OS3Cz90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964082; c=relaxed/simple;
	bh=I2SNm0xnqsHPkvomqERzz7fibgWPVkGVRtW6TVHS+P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+mQOQa8pWml+nQ2FOt5FJ3hFtrndrYhrzu1kgPvnLW5ztYO4ueyKgzmmQoc64Wl5u/B1SrBNnw1OQI4Z6O+41qFMX4OTM37J36FsadiS0FcMaWL5oX1lc/pty8gDNu0MU3a7yxc2ER71RNP9Q2pfInQ1WzD74F4B1PLfgcb1hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1c/oFThc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1c/oFThc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD861F00A3A;
	Wed,  9 Sep 2026 14:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964081;
	bh=fnvgd90jJRof7Pwq4il98BRBRVW1Z10BJiWab55s5sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1c/oFThcYIJgjolZss0UXMr04EyI4rlT38uZ12sBbwviKVyCalfRqENt+zVUmyX1c
	 FxynVBBYLNq+/93F0cdFcMoCTvBqj/HmIPDp67FXjfLDezfD9PsEdZvC8pZY2iXgTT
	 vTWSGGonaUmStcy+4DkMIL62CRoHXlByajuiCpbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 299/583] media: nxp: imx8-isi: Fix stream ID validation bypass in crossbar routing
Date: Wed,  9 Sep 2026 15:39:44 +0200
Message-ID: <20260909134248.384306054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoniu Zhou <guoniu.zhou@oss.nxp.com>

commit 795bd2863591f2fee33fab8f10cf9c383c94342e upstream.

The crossbar routing validation has a critical bug where it validates
the wrong routing table, allowing userspace to bypass validation entirely.

The __mxc_isi_crossbar_set_routing() function is called to validate and
apply a new routing table from userspace. However, the validation loop
iterates over state->routing (the currently active routing table) instead
of the routing parameter (the new table being validated):

    for_each_active_route(&state->routing, route) {

This means userspace can submit any invalid routing configuration and it
will pass validation as long as the currently active routing is valid.
This is a security issue as it allows userspace to configure routes that
violate hardware constraints, potentially causing undefined hardware
behavior.

Fix by validating the routing table that will actually be applied.

Fixes: cf21f328fcaf ("media: nxp: Add i.MX8 ISI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guoniu Zhou <guoniu.zhou@oss.nxp.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260720-isi-v2-1-45845bc5d4fa@oss.nxp.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-crossbar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-crossbar.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-crossbar.c
@@ -107,7 +107,7 @@ static int __mxc_isi_crossbar_set_routin
 		return ret;
 
 	/* The memory input can be routed to the first pipeline only. */
-	for_each_active_route(&state->routing, route) {
+	for_each_active_route(routing, route) {
 		if (route->sink_pad == xbar->num_sinks - 1 &&
 		    route->source_pad != xbar->num_sinks) {
 			dev_dbg(xbar->isi->dev,


