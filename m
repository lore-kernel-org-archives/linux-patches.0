Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B2D2E92DA;
	Tue, 15 Jul 2025 13:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587684; cv=none; b=NzcVY8aAY6X4zrYd+hiXOcTO1a3COOPdYF4N0NAOnKiCPrQo7tTlWl67J3Wo1cJzWA7U9Y4kTf3TrtxxV/GZnZD6dAqtX1aFcwWf7MDuMTsj8dUZugsd7/X4YjKGHTZwgMGPOO/pneB5mQOOHhVw6OH+Tp4TPizSUZyabMLh/VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587684; c=relaxed/simple;
	bh=UXNO/t+IljRi4L2BSGiwZ0eaKdma8rScPQtKfVehPEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7mWS1gGFyWcAzRCUEa8JcyLdi3V2MPXQX7JjvmietMLrJ5gAkD4X6Dnn2ySh0Ukb5wnBC4dzS31ATASKKsCcoFVWI3uuWImaCYM974gsMoPUao6jJ6c5asBGH80GoMGCHIHpkPhe05FVOz3SfKD7GZSsHHC9C8MZLvxyG0jBRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zA8xYEOq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zA8xYEOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254FAC4CEE3;
	Tue, 15 Jul 2025 13:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587684;
	bh=UXNO/t+IljRi4L2BSGiwZ0eaKdma8rScPQtKfVehPEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zA8xYEOqGLkrUfKGdDB192H2P/Y+1ywk2B+OsnIyGaOOxsvAvOO+73L9PK8gKYVfE
	 44ZHS04Jn72Yk5nLJgjSv9c7DbRe157ekzxebjkZYpwYrSMlstQot0+i/sCFW7RujV
	 ft0BxlzfoA4+keoRircjJuVNPZlSObzTJdyyjVEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8b512026a7ec10dcbdd9@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/208] wifi: mac80211: drop invalid source address OCB frames
Date: Tue, 15 Jul 2025 15:13:34 +0200
Message-ID: <20250715130815.153496790@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit d1b1a5eb27c4948e8811cf4dbb05aaf3eb10700c ]

In OCB, don't accept frames from invalid source addresses
(and in particular don't try to create stations for them),
drop the frames instead.

Reported-by: syzbot+8b512026a7ec10dcbdd9@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/6788d2d9.050a0220.20d369.0028.GAE@google.com/
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Tested-by: syzbot+8b512026a7ec10dcbdd9@syzkaller.appspotmail.com
Link: https://patch.msgid.link/20250616171838.7433379cab5d.I47444d63c72a0bd58d2e2b67bb99e1fea37eec6f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 65fea564c9c00..b46c4c770608c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4097,6 +4097,10 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 		if (!multicast &&
 		    !ether_addr_equal(sdata->dev->dev_addr, hdr->addr1))
 			return false;
+		/* reject invalid/our STA address */
+		if (!is_valid_ether_addr(hdr->addr2) ||
+		    ether_addr_equal(sdata->dev->dev_addr, hdr->addr2))
+			return false;
 		if (!rx->sta) {
 			int rate_idx;
 			if (status->encoding != RX_ENC_LEGACY)
-- 
2.39.5



