Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C76337FF60;
	Sat, 12 Sep 2026 11:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213823; cv=none; b=M4VyQxTj1gS18i+fnn44g5yocZxVIeZi2LDcQ3qPP4FP6IaLvTfFORO2QCGqabvwMQM1fPTh3VRbW3T1lFlonGjea3y0nlU84UptK3W3DJSz1LHKpvI3HiVMFDz3Q2Gz7egzdw5ZbvG1kx/cEnzeHuxRvujl2RfzXVakiUVZw5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213823; c=relaxed/simple;
	bh=EUXOGlwfok5jM6dlqIlsH1fj0JM/XoriNNKSCYe8Mbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6QXNdc4AlFhDnVKTh5Bl0zD/AZ0nlwPhCk0U1xYhPNMzqOUi71wnsRTNnAmjhfHA/Iq5orq/31sr/n+BOu6KmTIdHeJzAsJonFcX10M9BsjU0eFZ9+bR4kV/zFaPjC0lxpf018f9jcHLSVCOCOl0mvoobipanHXv4ZbSEfkpW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSMP+E0D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSMP+E0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39BF1F000FF;
	Sat, 12 Sep 2026 11:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213822;
	bh=kEsbtss0Rt7aByrB7dHgMMpAAMfrTskVVE4sGntxIYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VSMP+E0DkoVrajXU2jggQFjhwM4JszWhyPnWOxRXZqEfOnfcF1FoCIRib0pu/jDQ8
	 L4RakATjkl80NlZwocrkHvUB9Po16j/qKLwpwmiVDLLTD6cI4PibLft6S6RgQvre4s
	 ZR0UtHSo7bYQbEvCqSCSUtKjeTyDtO/Ms0RfQ2m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0201/1376] media: nxp: imx8-isi: Fix stream ID validation bypass in crossbar routing
Date: Sat, 12 Sep 2026 08:43:47 +0200
Message-ID: <20260912065612.029935617@linuxfoundation.org>
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


