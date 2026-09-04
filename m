Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A5D415F22;
	Fri,  4 Sep 2026 06:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501867; cv=none; b=aheABohqs7aR/O2HxIW5ugQOfcTB9zaphEZFBXh0aXZEJFbGnKl3E9VpDP6brGk89alZySJDcqna/sXsVXIEyXKH6m6ivICCk0yoXecYEsQAE5D/Eh6tF8+D02ckDVvi+tJ/Kn0GCJH5HuhQJN4LJ+FPgk5mxAJ122WTzprqF+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501867; c=relaxed/simple;
	bh=+4ReXf5sVgcCxaC76OesV9MCnwmqvmou8tGYIxtDj9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYQmXZ1ExAUupsOHbnKp08Ia4iI9Iq3Ii9PeDhJinnUNmk3YR9TKwOCfzFLipQ6pkPkAFCE+kiYaddTRCMavOYytLyEYaFfhh/Sw4SUNSwT0dy133mcawfo7lBmQcDcwMhoXW2ybDC/lSx92vxrpMURluWrbvkD78iN3/ThmdvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWdiI65a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWdiI65a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9E91F00A3D;
	Fri,  4 Sep 2026 06:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501866;
	bh=kca3tkOgeHQXs4FZCQ0iV2xX6cTYtVDMdrpkir0GmPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yWdiI65aOk55z0P10VmIMUy45B4rX0HOlINPcn6N8D0pAq+dRVaHG1g5HW5BNp0jI
	 uT6lB59EVJaED7c3LSQjMOBbLcZoBymZHmJ/BZvz5d76zu2tTEH+UYBsEJQmT9bWQW
	 b0gEdejDfZdjL0IQsAbGYmUG9P47KsadnLxUVYao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.18 531/552] wifi: rtw88: Fix potential memory leak in rtw_txq_push_skb()
Date: Fri,  4 Sep 2026 07:01:28 +0200
Message-ID: <20260904045802.657389784@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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


