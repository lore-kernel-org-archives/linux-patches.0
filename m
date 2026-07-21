Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3974028CA;
	Tue, 21 Jul 2026 18:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659358; cv=none; b=ca+dPzkXhQrJbHkDliLTCK9B9YBWkqrcVmnhp5pl7qUTowJ0+6oB74uj3zvV4vzYYshXgNvQ8gtDR6MZ+BeunrYE+Tuz5k04dbxnewU/fkdR5H98Od5ZVAX5TEREZLWM838kAz8S2OtJjr72hU4gY1Kyi+MXrI/B/Rp8Kt5YPEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659358; c=relaxed/simple;
	bh=a2xFiJ0xS8zQbji4xjZT6J8z8rwV6iDb9SMyLTUPe5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sgpt/VoPn5/IiJCyoGS3Y+mw18owZWuXP1NL3yhc0/kOFcsMhMyo/RfhuoP7c2QmjHDAt3fYr32FhtEpIvI0cYJoFDG7seWYmou4KgOIgLu9SV+IeWd7p7ujyG0mnbVdSUYvMQKcqO5w1NB58isUXt+pzHqIY2Yfdppt065of+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDbgciQT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDbgciQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1635A1F000E9;
	Tue, 21 Jul 2026 18:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659356;
	bh=Ef9NAp1nam8dqLauEVYOHJjREtZT+vLmiNt2QbdZTwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NDbgciQTYfu61rETlYB7yNENMbaD2RNxBUYwzeiuiv0cZy14q3O9pHbUpbm1yt7x5
	 kJWoPvrGzlF0+HI/boQ1cMKspIbJcjTArI56bMZ3gJuOXIOgYfmF7JwEHuDx7WwYPp
	 kmzoP4HjPF1cpVnOW7uQcl3JPCTs0i56nnA4QrzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixuan Li <kaixuan.li@ntu.edu.sg>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 1483/1611] wifi: brcmfmac: cyw: fix heap overflow on a short auth frame
Date: Tue, 21 Jul 2026 17:26:39 +0200
Message-ID: <20260721152548.802772202@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit 240c8d2c717b3f8153e7e877b22a82518d78dbdc upstream.

brcmf_notify_auth_frame_rx() takes the frame length from the firmware
event and copies the frame body with the management header offset
subtracted:

	u32 mgmt_frame_len = e->datalen - sizeof(struct brcmf_rx_mgmt_data);
	...
	memcpy(&mgmt_frame->u, frame,
	       mgmt_frame_len - offsetof(struct ieee80211_mgmt, u));

The only length check is e->datalen >= sizeof(*rxframe), so mgmt_frame_len
can be anything from 0 up. offsetof(struct ieee80211_mgmt, u) is 24. When
mgmt_frame_len is below that, the subtraction wraps as an unsigned value to
a huge length. The memcpy then runs far past the kzalloc'd buffer. A
malicious or malfunctioning AP can make the frame short during the
external SAE auth exchange, so this is a remotely triggered heap overflow.

Reject frames shorter than the management header offset before the copy.

Fixes: 66f909308a7c ("wifi: brcmfmac: cyw: support external SAE authentication in station mode")
Link: https://lore.kernel.org/r/178214417708.2368577.16740907093694208834@maoyixie.com
Cc: stable@vger.kernel.org
Co-developed-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260627131313.3878893-1-maoyixie.tju@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
@@ -294,6 +294,12 @@ brcmf_notify_auth_frame_rx(struct brcmf_
 		return -EINVAL;
 	}
 
+	if (mgmt_frame_len < offsetof(struct ieee80211_mgmt, u)) {
+		bphy_err(drvr, "Event %s (%d) frame too small. Ignore\n",
+			 brcmf_fweh_event_name(e->event_code), e->event_code);
+		return -EINVAL;
+	}
+
 	wdev = &ifp->vif->wdev;
 	WARN_ON(!wdev);
 


