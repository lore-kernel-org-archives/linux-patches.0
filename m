Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B180E248BB5;
	Wed, 15 Jan 2025 10:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938769; cv=none; b=CXkxWmCd1MEd99qsNUt3ff85D7sveZnZUptSbiRAAKJWVvLCvLPA8BPWB+RwrtTFd7z5MSRF4Hp9lMrrH4RFC6GwGIqZydNX5COcZVwwP+IsAE2vUMOu2gB4iC5aKDQgkr8pJ+mRi0MDzolntGszMzrHF0+hybEVyzRixLkyWqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938769; c=relaxed/simple;
	bh=WmY97jwT9vIQwufZCCPcIpX6ZZc/tTSa2UcTF1vHstk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3vDXPpWeH5pDWzwgI/vddc+jBUKxOQLsvu7xhUVV6NJBMq81MTD794ca6x1BIRbYr/siQVTbIkmj9GW0ArOROSuEvfiU104YIwJPDfa2LmfGmxhLDaMpOrZmLP/ILV9dOJrtd4qVzKLzBNO+RP0Rd/f3nbjxFr/uL+OVR58DZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skfskoCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skfskoCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAA8C4CEDF;
	Wed, 15 Jan 2025 10:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938769;
	bh=WmY97jwT9vIQwufZCCPcIpX6ZZc/tTSa2UcTF1vHstk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=skfskoCGg61Wiq5wW/SsAwXdQFPmsRgiIPKsTFO89LQAeunHWVjzFmRoGOVYFy87u
	 lUevh1IKe0qb9Y/eyaAWtbUwmehHiuPgT1FEiwunrG7bSPvSDm/fezv0Y5IX+DAg/B
	 7LU4F60RMBep9zEtRLvNFDKkapi9vujv/GPrN2+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jun Yan <jerrysteve1101@gmail.com>
Subject: [PATCH 6.6 093/129] USB: usblp: return error when setting unsupported protocol
Date: Wed, 15 Jan 2025 11:37:48 +0100
Message-ID: <20250115103558.078034927@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jun Yan <jerrysteve1101@gmail.com>

commit 7a3d76a0b60b3f6fc3375e4de2174bab43f64545 upstream.

Fix the regression introduced by commit d8c6edfa3f4e ("USB:
usblp: don't call usb_set_interface if there's a single alt"),
which causes that unsupported protocols can also be set via
ioctl when the num_altsetting of the device is 1.

Move the check for protocol support to the earlier stage.

Fixes: d8c6edfa3f4e ("USB: usblp: don't call usb_set_interface if there's a single alt")
Cc: stable <stable@kernel.org>
Signed-off-by: Jun Yan <jerrysteve1101@gmail.com>
Link: https://lore.kernel.org/r/20241212143852.671889-1-jerrysteve1101@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usblp.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -1337,11 +1337,12 @@ static int usblp_set_protocol(struct usb
 	if (protocol < USBLP_FIRST_PROTOCOL || protocol > USBLP_LAST_PROTOCOL)
 		return -EINVAL;
 
+	alts = usblp->protocol[protocol].alt_setting;
+	if (alts < 0)
+		return -EINVAL;
+
 	/* Don't unnecessarily set the interface if there's a single alt. */
 	if (usblp->intf->num_altsetting > 1) {
-		alts = usblp->protocol[protocol].alt_setting;
-		if (alts < 0)
-			return -EINVAL;
 		r = usb_set_interface(usblp->dev, usblp->ifnum, alts);
 		if (r < 0) {
 			printk(KERN_ERR "usblp: can't set desired altsetting %d on interface %d\n",


