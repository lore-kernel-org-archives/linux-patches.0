Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4DF17A30A;
	Sat, 12 Sep 2026 13:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221022; cv=none; b=opeIJ/C3p1xyAvPuhiYStqKJlfbmml7h0jgF/GUsPzIgI29R9OHxEIZMzgNxH8/dM6to6Rq76QyP7j7garUvGl/KECf7ivyX7WW8g8O9qNcTUCMZP/aOEUQpdAcFVu0aJSYe6QeI2PpocOsVpJNg7wfP1QfDnnRMpLP/vPfYJiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221022; c=relaxed/simple;
	bh=DB8iF+CPeO2PS9uuWpkamQNwS1afX5kF3BoLPnaS//Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zo2se717iWAI1T3LD5xE/xD/kUUNZUiiAkx139nVLJjBbPR87Qvz2wF8JoYtBdX7ZlIx5KxF2ITh8uSyk3/vkZ6NzFJQuUoGfsCRaK65GFcmjeaLZ0XS5yCS8Z/itJxJug0fY00M1e6YRCbPyhdT/KemKNmZ75AfT11ElqeXCRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHX98W0M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHX98W0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2881F000FF;
	Sat, 12 Sep 2026 13:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221021;
	bh=bKrcdT3VdAE8YRDARgRvx8+m/w/B2sxIv12ZMOMwPro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kHX98W0MRGP+aHQJfPCPK1e6oQVJGA2LAr9paG8NswPr0Dw36RMwRS3qZ8nHo2+OY
	 nWvXpNkpLJcK9Wy7C2IfYfKYaERIgtGJg1jfC3vAeBncqp6DqPRyoCKKfuKMfiScG3
	 Y4isGsrpcnoe6sFPKiDh8f2AyPwv98mElqyMrs24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.6 0296/1424] wifi: rtw88: Fix potential memory leak in rtw_txq_push_skb()
Date: Sat, 12 Sep 2026 08:45:28 +0200
Message-ID: <20260912065613.913973961@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -609,6 +609,7 @@ static int rtw_txq_push_skb(struct rtw_d
 	ret = rtw_hci_tx_write(rtwdev, &pkt_info, skb);
 	if (ret) {
 		rtw_err(rtwdev, "failed to write TX skb to HCI\n");
+		ieee80211_free_txskb(rtwdev->hw, skb);
 		return ret;
 	}
 	return 0;


