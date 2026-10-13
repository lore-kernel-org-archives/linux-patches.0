Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201A24FDE61;
	Tue, 13 Oct 2026 12:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892914; cv=none; b=BwRGZm7A8FnynKlLoO8HV0fYFRbsaxjUxoYmmVx9bCUHNaw4NVQRdIsn3mj6pqZkJQyVjznVh0q0kvY/OQ6qImyvZ4iTXpsG/GfxcC3GOoXdMVQKTwjDn+q0DFo/ymONqTCljS3gVijLEUXnXdahsI460ixZIU5Xxvid4skKsRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892914; c=relaxed/simple;
	bh=DyKIM9dVKUj/4WRcR+JuwjG48fOut0adrExQ9qKf0hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+xr/WtcD0vANETuisjHMf/xzwKMEv5hSNC825LTVmZ2ZTTUvfsQPZvmaAZOuMqIyIrubwnLF+61Ky3zbXjzrq8S9kR0BgzFKLbe6cseonM7h3usgKoNVMpz9RC/STW3ah6pHai7SVp5p458HARnMDwBBJFXUXltSh9vkr6nCTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hCrD4BkX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hCrD4BkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5811F008AB;
	Tue, 13 Oct 2026 12:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892913;
	bh=ynknRr5E+AmKbgXIy/K+mydPs9z+lokBKPxMeW3V/C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hCrD4BkXVlm6sfqbzqHZxT4cDZZewLjU2JZ98vvmEJUZqapQFVCacMofejakFe52M
	 Fgo3/UQpLuCpqH9y12ty0iNM6cy9xkpGY3H9iw9ENAlI1MiSneNXD7Rs0hCv9FxVyj
	 IW7mCtu3++HVFTYxchTFBL1A0HXJVq5ewHbUSbJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 049/621] Revert "wifi: libertas: reject short monitor TX frames"
Date: Tue, 13 Oct 2026 13:30:44 +0200
Message-ID: <20261013112922.028189013@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

commit 9727d1c4e1c971fc42b049b645fdda6852758835 upstream.

This reverts commit 13ff543e0b2c713aedeaadadde686686e949dc78.

The 'goto free' just made things worse, causing a spinlock
to be handled incorrectly. Revert this for now.

Reported-by: Takashi Iwai <tiwai@suse.de>
Cc: stable@vger.kernel.org
Fixes: 13ff543e0b2c ("wifi: libertas: reject short monitor TX frames")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/libertas/tx.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/net/wireless/marvell/libertas/tx.c
+++ b/drivers/net/wireless/marvell/libertas/tx.c
@@ -117,13 +117,6 @@ netdev_tx_t lbs_hard_start_xmit(struct s
 	if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR) {
 		struct tx_radiotap_hdr *rtap_hdr = (void *)skb->data;
 
-		if (skb->len < sizeof(*rtap_hdr) + 4 + ETH_ALEN) {
-			lbs_deb_tx("tx err: short monitor frame %u\n", skb->len);
-			dev->stats.tx_dropped++;
-			dev->stats.tx_errors++;
-			goto free;
-		}
-
 		/* set txpd fields from the radiotap header */
 		txpd->tx_control = cpu_to_le32(convert_radiotap_rate_to_mv(rtap_hdr->rate));
 


