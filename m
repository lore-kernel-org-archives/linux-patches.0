Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544F3198A17;
	Tue, 13 Oct 2026 12:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895744; cv=none; b=CuA9CRJNUTXB26UG5WDRQnJGAI5rJy+AzhSNtUUCUB28z1Wjk31/tch051vNOQBw/gd/WFD6zcxgwXLZRikb455PgADRjGqmvHgGmvVg0Vo+BXJNKndaejQr1oEWlfEWhnHIlU6xB1gd7Kvssmf70+51cv2v4S2M0mg05HB0A9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895744; c=relaxed/simple;
	bh=8Ta8fb4OeFgEba+BPFbRXLxFsneioe547inQ1LiXCSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/yvLpiDQnXjMBDp+p3suJbTJF9biFRcofqDFsTTiyRwNNl5ABPVt0MZbgrOpLTOEup+nqkRvD75CUSBHk2ECgfHg//gr2E8C2vKtUbG5UWIJ/H21NuGyOLznCA4f9wzJfHB0HvR9YKj6Z6JWhH0wSW62nLZzsTlp23hcwj4DvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YC8uPOcz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YC8uPOcz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA6F1F000FF;
	Tue, 13 Oct 2026 12:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895743;
	bh=LBmZfEZNIPSn6tPfd3++yokP9qM2BeW4EL5YJsNpiek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YC8uPOczUnEjAK5K7uc6pCPdm+11wvVALwrbEXcMFre88MmwYm/jyAzaLsVjW/Fz7
	 5weM8uLWHSX28kVNHvz0NkLjBAH4KgSHVi3Bw+p9oK2Z0Dc9Gv6c+EjfCPrglIPwsz
	 YGPzuvViWZv/o0R1VLBW8D8JxJYQ1eir93AfwT4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 379/497] Revert "wifi: libertas: reject short monitor TX frames"
Date: Tue, 13 Oct 2026 13:39:06 +0200
Message-ID: <20261013112916.893874775@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


