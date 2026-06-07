Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0509328267;
	Sun,  7 Jun 2026 10:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827832; cv=none; b=mv9hEH99b1H/+TOVEN7b9irE8SRiXNCbmlxYIigicnDVuqfCzP9nJEIFB1DNCCQEmr0ti2gK9AWc/z4G5MG6hNBrgV8QjADPe1ah8Yqo84VjLUuhQEbjVCjKrsqAjDE7G8wnt3fwSJCGpcX4tYB2Xn+P3ZW1r90PBPRylM931f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827832; c=relaxed/simple;
	bh=9Rsuaxusiwxzdy02ZFj1vtpFIKuUIIRr42PNWq7QhZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DstD8ZXysbM9g5hGK+xebkP2luXWnpvW/NypsaWZA0dj0OAXxbeN/YYi8VipYc3ovwbFWSkLQuCgINdgDb/jY9mFIwz9pRUf1bYiW28HSVDgOq2Ikw8U8gWhp7bgnzobYBny2pJEgQKVu9R+MNgLoDPHQshZgpxE54UpTPo5IsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WRdrKMK/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WRdrKMK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751A91F00893;
	Sun,  7 Jun 2026 10:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827829;
	bh=5j05GxVZAT1qmlkJL3noMvG0ptAb6/aX9HWhMvv/u3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WRdrKMK/HJCSJQmhgwrumAjjMX1A8c/pgP63WoDJPN25QzJtte6XES3Wz7gFMnGtS
	 YNaVoxaZgod4800vHPxQuZDR6tS3G9USy4JgxNy7IgK3JMC8KgLmqIx4fpb7QUvQsC
	 9X+s0fbi84XDW+UjjFVCge7w13KbQgRLkr2FXCYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 7.0 125/332] usb: typec: altmodes/displayport: validate count before reading Status Update VDO
Date: Sun,  7 Jun 2026 11:58:14 +0200
Message-ID: <20260607095732.697414584@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 8a18f896e667df491331371b55d4ad644dc51d60 upstream.

A broken/malicious device can send the incorrect count for a status
update VDO, which will cause the kernel to read uninitialized stack data
and send it off elsewhere.

Fix this up by correctly verifying the count for the update object.

Assisted-by: gkh_clanker_t1000
Cc: stable <stable@kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/2026051350-reacquire-sculpture-4244@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/altmodes/displayport.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -405,6 +405,8 @@ static int dp_altmode_vdm(struct typec_a
 				dp->state = DP_STATE_EXIT_PRIME;
 			break;
 		case DP_CMD_STATUS_UPDATE:
+			if (count < 2)
+				break;
 			dp->data.status = *vdo;
 			ret = dp_altmode_status_update(dp);
 			break;


