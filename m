Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA28A2DCC02;
	Tue,  8 Jul 2025 16:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992538; cv=none; b=qhCuj8Q20g4icjv0xuWVh191VLC2UyiIOQ03rvQAd/s/59wQRGjmImzPJO1Y3Wjk9iO+TPlYh+mH2hjo4w97NReX74y2EH0bPptEnT1u7xyiqPxMCR/qlyg5jiG6fYxy6IV0QlaUmRGsE+8NErjqqMLYhXS09jJZz/jCms8TlRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992538; c=relaxed/simple;
	bh=+Ca/04lR2oONIl3+DHdFr1Y1ssfSIHT2hQ7AD/ExJEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCPjiEkyB0/H+BCe+Ip/wKrSlepTGW9+zwmby4P76UIL5bReK1ts4U7cnsUK61jlNCAPeJ4mixTDap8kYn4aTluEAgC6+AkTB2BF1qcZVkydnCi4wF/8KbCBWjosCmcBGbnCBCwTzoSt8fAcogC+g6O4jHgcYQYnqv0J1wApYF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EEX+cFNo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EEX+cFNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72202C4CEED;
	Tue,  8 Jul 2025 16:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992537;
	bh=+Ca/04lR2oONIl3+DHdFr1Y1ssfSIHT2hQ7AD/ExJEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EEX+cFNomi3aD20R/4AvIlKtH9qgw7YZIpH63y3MTeNhxYsYALQTND2FHMIMbTsHc
	 Mu9PKJjUShvLDrYmKLNrthBe9H0XDArqd/KmgvB06kYj88kqMNH2NPnZblnWeiz2Dk
	 koM6VNgpl5I2AFbMjCd1IWBhCpMPtsqOxBXZSQFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 126/132] usb: typec: displayport: Fix potential deadlock
Date: Tue,  8 Jul 2025 18:23:57 +0200
Message-ID: <20250708162234.216240363@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

From: Andrei Kuchynski <akuchynski@chromium.org>

commit 099cf1fbb8afc3771f408109f62bdec66f85160e upstream.

The deadlock can occur due to a recursive lock acquisition of
`cros_typec_altmode_data::mutex`.
The call chain is as follows:
1. cros_typec_altmode_work() acquires the mutex
2. typec_altmode_vdm() -> dp_altmode_vdm() ->
3. typec_altmode_exit() -> cros_typec_altmode_exit()
4. cros_typec_altmode_exit() attempts to acquire the mutex again

To prevent this, defer the `typec_altmode_exit()` call by scheduling
it rather than calling it directly from within the mutex-protected
context.

Cc: stable <stable@kernel.org>
Fixes: b4b38ffb38c9 ("usb: typec: displayport: Receive DP Status Update NAK request exit dp altmode")
Signed-off-by: Andrei Kuchynski <akuchynski@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250624133246.3936737-1-akuchynski@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/altmodes/displayport.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -324,8 +324,7 @@ static int dp_altmode_vdm(struct typec_a
 	case CMDT_RSP_NAK:
 		switch (cmd) {
 		case DP_CMD_STATUS_UPDATE:
-			if (typec_altmode_exit(alt))
-				dev_err(&dp->alt->dev, "Exit Mode Failed!\n");
+			dp->state = DP_STATE_EXIT;
 			break;
 		case DP_CMD_CONFIGURE:
 			dp->data.conf = 0;


