Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78872472798;
	Tue, 16 Jun 2026 18:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634571; cv=none; b=f8E1N1QDzzfiPMn/s4TeAyMsYYRcLYLsN9a8uAG/xZWan8z2HeQkVoIukXjGs2FQrBdcyTB1cSADfxTSPg2Z4+m4tQKTzXcbAaBZHskqmbbWlNIteEp6CgVR6X5b7BjKwyYiE2/HkfwNuFMXxJvl6Dl80atY8jnSOOn6SbEvhNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634571; c=relaxed/simple;
	bh=6mLqzwhDBS6Ar9Gq4zEkdYLVFoTweslWOeaQTitIUrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkNeUwaZ7Q6lo3eCnFNyaRqMVD06ZUzFbTBVk9aG8w2fZ9oCotu2LQO10Wg+O9+FQfuFhPhLOy83zeF0H3Ej2PfDDRjA3KFBnyCrZsyfHJTIEqjqO/AkWDvSkD4jA3K8wmO93Fex7p97oklggSbPO4ab9uqVNkXA8ZkR728VeMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWWBGETi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWWBGETi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582121F000E9;
	Tue, 16 Jun 2026 18:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634570;
	bh=GEFN4eYLHap5bCZesNPK6fuka8EHYHzhtfu6rA/OaJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gWWBGETi89wMqNEWdQoo4kNwgKT/yb+m4qLoF0UPt+Q0wtB1o78n6DUPUHDctCWmG
	 2+gk2oqrVlugNiEQLNSPlg4obdNiPgmKJvFFD21l5skHMC/KAT1Bo8QxiXL2ZpRuq9
	 6DxaFwltehfBddOxDOvqkbnx8NTyVHYmA/d4G3Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
	Johan Hovold <johan@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 289/411] can: ucan: fix devres lifetime
Date: Tue, 16 Jun 2026 20:28:47 +0530
Message-ID: <20260616145116.513446387@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit fed4626501c871890da287bec62a96e52da1af89 ]

USB drivers bind to USB interfaces and any device managed resources
should have their lifetime tied to the interface rather than parent USB
device. This avoids issues like memory leaks when drivers are unbound
without their devices being physically disconnected (e.g. on probe
deferral or configuration changes).

Fix the control message buffer lifetime so that it is released on driver
unbind.

Fixes: 9f2d3eae88d2 ("can: ucan: add driver for Theobroma Systems UCAN devices")
Cc: stable@vger.kernel.org	# 4.19
Cc: Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260327104520.1310158-1-johan@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/ucan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -1396,7 +1396,7 @@ static int ucan_probe(struct usb_interfa
 	 */
 
 	/* Prepare Memory for control transfers */
-	ctl_msg_buffer = devm_kzalloc(&udev->dev,
+	ctl_msg_buffer = devm_kzalloc(&intf->dev,
 				      sizeof(union ucan_ctl_payload),
 				      GFP_KERNEL);
 	if (!ctl_msg_buffer) {


