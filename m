Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E235C4D7D4D;
	Tue, 13 Oct 2026 11:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892052; cv=none; b=pUd55R5JnWKW0s1xC3o0J5Vh4bcObR4ywy9SZ4OGjZ6HVvolwLjD/hmgewo667doeY5/XM+8jExn30OAIommJZAloSkZNHEUMSXXTBe0tEI9M1MI0Xlt0Hv38IbvsX94yFuAzRrgi1u2RPx+1GCt5zbuc8BVE925Oa6xvbfO0Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892052; c=relaxed/simple;
	bh=r1aQHeQ4WcRCSDcSQevju7biG1jJa3mpW6fJm3ASnfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sh/PZ35a885meYF+yhnurs4aJ4JTaOeB4GZOPX08wMO4RNQZCluAwQsb5VFUAqxguIkhimmCkjNHFaUiZqulLa//jTVF/7SWl3ZAYuWR9uaWwQmg7ymurHm0EUNcQGwUlV7Xwzm+nrcLqZcZyCTqzBUUp1l1QF2B5cC3IuCNYC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rW42bzab; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rW42bzab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5EA1F000FF;
	Tue, 13 Oct 2026 11:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892051;
	bh=7pCJ2I/ZwYYkOUP21TzV17mygSeBOSHCNIXRXwV6VsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rW42bzabTuMc8i0444nH/gFK6NzCXNHRnz3JIQ+EhfMOL7KjZFkcfBnnykCMUOSV2
	 04qnf+8DPTxjthp1n9XX9js2m+6P/S9kloxYfiM4NiM4GtnKalDyZnRvyBEW6J91fr
	 6N1phtqKnt+Vg01IH54m8cCBcoEHuCRBSPT5aVZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.2 045/281] Revert "wifi: libertas: reject short monitor TX frames"
Date: Tue, 13 Oct 2026 13:36:01 +0200
Message-ID: <20261013112856.146319903@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 


