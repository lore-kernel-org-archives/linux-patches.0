Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03ADB33C1BE;
	Sat, 12 Sep 2026 15:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227908; cv=none; b=k1wIaQXBXed5CDmutzfTyFYZv63NhvVAb6IG/QrqhSFf6RxG+zcf+/CgUki4DlrPftorkpjnw9CiQKlCaPiGnn93dkFLbWa+/233URj43/Fg9lli//bEAiQ/vJEdceD7ebcL5nUWaM4tLSxzO0JOhfcmcOtGVcG7T5fRw38WKUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227908; c=relaxed/simple;
	bh=Ff+H0OaMhqvM52JChxCtxX1s1PZeKXTiO+D7LQ4fQ1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VBejCgNS3P/Y3m9XNpV01Y5dt2+01342RKK8E/U6doQSmWgu2Yx9XsdssQMM84ieWxq930JkAkjsmeEiDNYSF0obLkK7EXWYo9pp3mvnpX6qrcZnSgeuMR0HTx8k0bRtnhuHyCnPPgvPsc9D7BEIyTHybe0IYt3u0B7FbzHtXI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cw2VD97b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cw2VD97b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7426E1F000FF;
	Sat, 12 Sep 2026 15:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227906;
	bh=CR5NeR72IXN0xcKSPfDZrxiqFUTcYUa5rHn3z44lG+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cw2VD97bWNJ1NsvbtNk9WdT6IJ3vxPUV96222HLg44IRgDykagSLT5/GXOnovOT2E
	 OeRnm+7EYIxSoZzkXddN39WQ646P9uubbYpLYTR1HNqgQvHRrAjb/gdEEpVrWN7gLv
	 i62wkf4ang4296CGN/b7LPMt1kTqSPZY7mpJyVQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.1 0240/1191] wifi: rtw88: Fix potential memory leak in rtw_txq_push_skb()
Date: Sat, 12 Sep 2026 08:49:28 +0200
Message-ID: <20260912065553.602845420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -590,6 +590,7 @@ static int rtw_txq_push_skb(struct rtw_d
 	ret = rtw_hci_tx_write(rtwdev, &pkt_info, skb);
 	if (ret) {
 		rtw_err(rtwdev, "failed to write TX skb to HCI\n");
+		ieee80211_free_txskb(rtwdev->hw, skb);
 		return ret;
 	}
 	rtwtxq->last_push = jiffies;


