Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94F1318BB3;
	Sat, 12 Sep 2026 14:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221788; cv=none; b=Uf6OGFO4fHxsin3w4r+qKE/Xy47KqgO93cK9PHqGGbqKNAqUAw6zIJyFYlviEo3Qz0pKvjP6Pszw45byDzKpS7maoaPY0gZNXLuf2a+Vca9PZmPikC91c4K9fhqI0N34d3Tfdgu2zwXm+MzMQ2Nbpd2fPhZZ1SG0AyfIVdZLIGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221788; c=relaxed/simple;
	bh=on0ghxvz0McSbBKLV6/UGiTEZqamvsyz3IAL7WYy1nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jR0yNZ4TJQue9qFDRs6vZZstNKAUyDzvKNVUj4julpaVPDsptcYoalKUrsZG0lqkijMvSS5zLBFcg1CfdkmO10r7zP5Ef0Cx3ys4ewwkYmfxqtCqx7hnUfOAGpNwV+s1ibRW64FXOLfxFq66Ktp0Y0b1OAjnBGuue3zA29aHAMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NzI8U8bz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NzI8U8bz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E211F000FF;
	Sat, 12 Sep 2026 14:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221786;
	bh=dN4dljlVk+HvCN7kIp3BwV3Oa7+fc8PQCpuF7w27G48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NzI8U8bzT0RFUC4tUFOAvciUt/X9ek6oUodRzIXvV2cQKx1Op0+ayZC2t4+OYnqe2
	 uo8ZbvJTLB5YFskJH7J3dgzgQcCLTE2EjLs4tiJjLQ8k3I6KBbUd6AzBBwr8b+liBe
	 UbfK/D63yWkPtuxKRtcccB45iVoI3IpTzEzskkJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0455/1424] media: nxp: imx8-isi: Fix stream ID validation bypass in crossbar routing
Date: Sat, 12 Sep 2026 08:48:07 +0200
Message-ID: <20260912065617.474557447@linuxfoundation.org>
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


