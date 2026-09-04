Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E551D4CCDC7;
	Fri,  4 Sep 2026 05:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500207; cv=none; b=LkcKx3FZw4IHFCz3kpxbxrlShwUWMDi/BAT4SKifaRXi4BHUaJyhsiEu2XgnhZleJGfdC9BcInz8cKuAv7UunqX7MOy8XxHT9MB0z8yM9ro+nrRz7C0FcsKArjbdHA2RVdndgk0lwlIaqfa3RDLJmMi7K824bV/0IPG3uT6YuKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500207; c=relaxed/simple;
	bh=TFH+rn130qAEmHesqL8Ldtlc5Q2v8jmGJ0psRirHy4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utNXqySYqjC3KMqo06c6wkyIIjwhTwneMKiQ6Btv02Gi6G+SAKNcdbFzVkKYT0sa+cNeR1XGV8t4hLymCNG4v60niNoH9AZGBbr62nAD2U9VQ7SJ+E68qfGyvm2TEaCXKLyZqiCMTfA6xGZPI895Ao8uSslTBMHNvKMbGC5/N1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9UbNEb/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9UbNEb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443071F00A3D;
	Fri,  4 Sep 2026 05:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500205;
	bh=u5svkUEWh3ySIc7fEKUg1j/WUgnT3/5E3eW0uq8cVio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k9UbNEb/san2Wsk1AsFeNATD4ppkZa9rsq3aroYwWGL6ehscv0L4vUupxl0suPuOT
	 xyL39yU52mDDnq/dFaaFcvx1ygPke66BG4LZzfov9N6++/gqoophUWHNYmVTPj53Xp
	 jBDWZaWloGaHmBXyOP8NPMjCWZI0FND9ZPttRoi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 7.2 689/713] wifi: rtw88: Fix potential memory leak in rtw_txq_push_skb()
Date: Fri,  4 Sep 2026 07:00:57 +0200
Message-ID: <20260904045819.285941354@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 9f2948010764d708bda27369d09ce6f194abe8e3 upstream.

The skb passed to the rtw_hci_tx_write() is expected to be freed when
the function fails, but the error path in rtw_txq_push_skb() does not
free the skb before returning. This can lead to a memory leak in
rtw_txq_push() where a dequeued skb is passed to rtw_txq_push_skb().

Fixes: aaab5d0e6737 ("rtw88: kick off TX packets once for higher efficiency")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260727064223.61836-1-nihaal@cse.iitm.ac.in
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/tx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/realtek/rtw88/tx.c
+++ b/drivers/net/wireless/realtek/rtw88/tx.c
@@ -619,6 +619,7 @@ static int rtw_txq_push_skb(struct rtw_d
 	ret = rtw_hci_tx_write(rtwdev, &pkt_info, skb);
 	if (ret) {
 		rtw_err(rtwdev, "failed to write TX skb to HCI\n");
+		ieee80211_free_txskb(rtwdev->hw, skb);
 		return ret;
 	}
 	return 0;


