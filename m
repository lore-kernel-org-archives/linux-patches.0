Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FE62D73A6;
	Sat, 17 Oct 2026 17:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257328; cv=none; b=RABguOnyTmaqAf9DYPDfFUp98xL69fZT020lw6H4rLBZPZA5MKKW+pWAVoN5o+16Ce2gJrkQWRIXmDzGMiofLKK7c1H5WSb0iegHvFpdAXfuiGEDBPOTEV7FtOavjT3AW6S8eW4zH5hbHvXTwAqH/B9D3KjRzBD+zG0SLtc5dOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257328; c=relaxed/simple;
	bh=rSDRW0Ginal37zTkxp7qrm5f9EH9Wvz3iPSk8HW7OJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJ+LO4VGmFUNA1ErbnRP1LnBQr8/gsYbXdSvPi+0896zJ/0vA10UusequlmbkUQSN9n1iIiaB3SB3XvzhjWqpd6DiyKEwiDZib990YG/f88nN/uedHDjOCgcpa5kVID/dCdEOTk9gJ0y7xhF38QHVaGSb3Dh696FRI5PvSkSco4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lz/Wk653; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lz/Wk653"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF1A1F000C4;
	Sat, 17 Oct 2026 17:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257327;
	bh=t8+VL/l5/6rFemwkUPdJ3sAsgWxCwBss5UTzh6D1UwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lz/Wk653XJ3gst4yEh6cg0XI2CzKsWn+FBswS2ufnfcPL4MocSmfVg0MZT7GOnCWF
	 pUip/WXmMahFQEvJxulwhrYqqFFSjEP15MCxeajU+aqqoo4B4S9DjdqmNQmwbBqwXL
	 1PAcxzJmcNM+wHALhbhrDQDmmxRRjCW1wK0CEPNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 0482/1674] Revert "wifi: libertas: reject short monitor TX frames"
Date: Sat, 17 Oct 2026 17:45:54 +0200
Message-ID: <20261017160443.485592369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
 


