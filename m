Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8014A4CCDC7;
	Fri,  4 Sep 2026 06:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502960; cv=none; b=lxaQyjj+QKWV9Y+pIlwmzJkeP6lHWMuPOzLw1JCpqmG0o1zEzHsdEZhPStuYdUw2iNKPAkYUzZZ6y681SworS4D4c2WhwcZRfP1uG/gMOG3lp4816qG94h+EjSQAn5cRhv54WXG9u4SYtbTLgHSHNCiUkUkgLR6XspppABAsBL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502960; c=relaxed/simple;
	bh=csRvNQmu45miuig2DjVIAxnOeNSkr1a+BG+j4SPA2m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4wJ19AGK2U04a5yhWT765ejnwr96Uw7Qm5PKZNlKNOWPvbiMFsfFh/deDXyy1VUxNfowNoz4FNQfy6v6OBdLNaIg+Pm1YiCLK6RWqzcJkMzkwkNO0q5QBGc54z1JsmVUzHkFfnhGx1llmltgfJqWxHjgAdXsW+ZyepDMuP02JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBFj3Dlw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBFj3Dlw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7FC1F00A3D;
	Fri,  4 Sep 2026 06:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502959;
	bh=qXfqKQQk/Zk8277Sp4zPCMsHC4PPQX3l6JKQNi0i6YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IBFj3DlwL49bUZ+1ZK9d7lXlGeY+q1T/q1yZb2pYPj+6T0h17WKo3KEflseOMAKjw
	 EEzE6HR94uUDjv7Kyjx+Bd+vRpWpTBkc4A0TBHGc3hYTRuSuUozk+8M3agsugCnRwn
	 xWevQLGyVbchSkHfIQqMgltPrdbQxzkRg9n2gVok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.12 390/403] wifi: rtw88: Fix potential memory leak in rtw_txq_push_skb()
Date: Fri,  4 Sep 2026 07:03:13 +0200
Message-ID: <20260904045743.657529510@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
@@ -614,6 +614,7 @@ static int rtw_txq_push_skb(struct rtw_d
 	ret = rtw_hci_tx_write(rtwdev, &pkt_info, skb);
 	if (ret) {
 		rtw_err(rtwdev, "failed to write TX skb to HCI\n");
+		ieee80211_free_txskb(rtwdev->hw, skb);
 		return ret;
 	}
 	return 0;


