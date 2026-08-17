Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8B83E025C;
	Mon, 17 Aug 2026 14:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976707; cv=none; b=fG1k4nGnlpvEdvcY1qOOLH6H+cnuEA+TNa+fmoPW4y5Oe+/95LosvVHrzGrgK4FtMnhMOhGX7jCo7JlTxVxIEWNk8REhJLu8gc19dTyIxlbWm6PGNUcVNObPdnk8akgSnVQbqeMvxhjRIvBKounb9RBf8MOsQhkInWxTuuSpFis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976707; c=relaxed/simple;
	bh=ne6N5thVeIz5yXDQBksXN3QVZjMcbJsgS6q+gCJmi9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2q4VGquYvioR6FxBoBVwFefQtJcFXMku1Gi+ck00lhea06A+XibqfHyyJajHu5VPBI6FrR2IBXV7zTJ1r7UvfH9kmDbfJrr2bi6SFFO7iH0JvnQIkB/J6tRo68X5N6tTLzRjKBieMOStYkn260NvVPRLbaU6eX6fKtv7DX9jrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mVkp88ZK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mVkp88ZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625221F000E9;
	Mon, 17 Aug 2026 14:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976705;
	bh=IDg1yIuNez+vp6PJNe+bSfOH+cX9hcUWyBonvo0c7Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mVkp88ZKglSQ4rbhSG1Pd9vTWpHw3Kk/C0MAwJmY3Ad2v7j74n6flTl0FSra97Uvl
	 Tb0G2jVOn47C7Jn0AZ0VMw1xH/aKc49nO4/OjHOL9fouqFpgMjsqmJMJ15d+zQp3bw
	 yq0ncwSu1A+vSzcoupgTKoeNp6AEE6+9jJK4TPX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huihui Huang <hhhuang@smu.edu.sg>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 059/456] wifi: at76c50x-usb: avoid length underflow in at76_guess_freq()
Date: Mon, 17 Aug 2026 15:27:29 +0200
Message-ID: <20260817132542.353372865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Huihui Huang <hhhuang@smu.edu.sg>

commit 61a799ffd1e5a4fd3702d547828b7ff3d161468e upstream.

at76_guess_freq() checks only that the received frame is at least a bare
802.11 header (24 bytes) before subtracting the fixed management-body
offset:

	len -= el_off;

For both beacon and probe response frames, el_off is 36. If the frame is
shorter than el_off, subtracting it causes the calculated IE length to
wrap. The length is eventually passed to cfg80211_find_elem_match() as a
very large unsigned value, so the element walk runs beyond the RX skb.

This path is reached from at76_rx_tasklet() while scanning. If the device
delivers a truncated beacon or probe response, the oversized IE length
causes an out-of-bounds read during scanning.

Skip the IE lookup if the frame does not reach the variable elements,
before subtracting el_off.

Fixes: 1264b951463a ("at76c50x-usb: add driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Huihui Huang <hhhuang@smu.edu.sg>
Link: https://patch.msgid.link/20260715140815.1242033-1-hhhuang@smu.edu.sg
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/atmel/at76c50x-usb.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/atmel/at76c50x-usb.c
+++ b/drivers/net/wireless/atmel/at76c50x-usb.c
@@ -1527,13 +1527,16 @@ static inline int at76_guess_freq(struct
 
 	if (ieee80211_is_probe_resp(hdr->frame_control)) {
 		el_off = offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
-		el = ((struct ieee80211_mgmt *)hdr)->u.probe_resp.variable;
 	} else if (ieee80211_is_beacon(hdr->frame_control)) {
 		el_off = offsetof(struct ieee80211_mgmt, u.beacon.variable);
-		el = ((struct ieee80211_mgmt *)hdr)->u.beacon.variable;
 	} else {
 		goto exit;
 	}
+
+	if (len < el_off)
+		goto exit;
+
+	el = priv->rx_skb->data + el_off;
 	len -= el_off;
 
 	el = cfg80211_find_ie(WLAN_EID_DS_PARAMS, el, len);


