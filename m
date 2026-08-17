Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCC03ABD99;
	Mon, 17 Aug 2026 14:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975489; cv=none; b=NcNwqz2hMrKxs98od115oSGjc6gjxXbZfS0kPSi+6Ya6HwmfQjgcPoXu1RMk6hvX+0pECJ+/XoNDI/1aWkhPUlvhwIWZ7forwYDvP9uJhwaiGBA4awQXEzZ2Hf/LY5PkJ8DIshOTzii79wo24W0NyU5X+7y9GjBIl7ZEzKjUWp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975489; c=relaxed/simple;
	bh=Pi2ngAyfZaFA6XpSKaItqsuQfG9nJdU5OKCEOvY+2nA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xb+ry0ByCARMpwDi7xS5o4yA2Wgv2YU+IxJfCJ/FoeO8gFDtftSk2GdutIcOmjsJHgxzsPCoKbt7ae1GQHwSSWJgxLdMRXXFu46ALayGsVIxbdY324Tla0SHHtSSUkVnTir82x6KUeuBX9fjyrag9wpYP7tjelTunsDUzZ5XbFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxmv0JHO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxmv0JHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A0F1F000E9;
	Mon, 17 Aug 2026 14:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975487;
	bh=KuU26ImwyBsKVt23t6bndBYxCbXzzH/wZvjrbMD7Rbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lxmv0JHOBG6pAHZAIOBtkYzLNs86/8l7tZx2uKz7YeTsKSYwZExyepMyzFDdgyEs5
	 hJVIfJUlvSqXW/ehRlMrxxnKYUnXBvhPaLBXATZ4Mjo1KibEwVY81xvplWSX5SoB/y
	 KkoBES95wJpAXhfK35VRdd74MInToHN+MuzP6pI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huihui Huang <hhhuang@smu.edu.sg>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 045/389] wifi: at76c50x-usb: avoid length underflow in at76_guess_freq()
Date: Mon, 17 Aug 2026 15:28:04 +0200
Message-ID: <20260817132540.764238436@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


