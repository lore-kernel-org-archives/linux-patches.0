Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66DD2222B2;
	Mon,  9 Feb 2026 14:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648136; cv=none; b=GOlI5iLyL5/zbqdsJHzRVK1gb6kJIdqXuhk0Ax6TBiSLt8j3NhZlZi3fXzLR9MGcbXqgM8wZrAO+JfFAEx6V555JiNWJT/4pUkAqVM7knYSUZ21GeSF1zuLsLGgrajCtxb81aHsXMjpStGVO92E4DTlKIuwgU6jIcARRR6ylPsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648136; c=relaxed/simple;
	bh=c1UMRApXBTiMnzPt/qcWbVeu7Zz0zqlYtD3yz5zYEGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nK4s4rjzepfw4ZYqL2yDHhzZMo47E6zw8ChDl6wRolufNq8RDCuRv9SmOOM/8MRJE3tDn29cCh5t9+k7eivNixN+SYNxHIawSiBtz5Ha1tRL8Db9KCCe5xgCOe40P94cKoHinnuBgeHbR1u1fay4/y84BKlxzc7gZPwPnGZdjfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=op3hMYO6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="op3hMYO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B8FC19422;
	Mon,  9 Feb 2026 14:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648136;
	bh=c1UMRApXBTiMnzPt/qcWbVeu7Zz0zqlYtD3yz5zYEGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=op3hMYO6VpMCxv095WNe33KjjUVWLBeU9nTqt0dwLBn1yMqun0qda5HzzJCbF2JyR
	 eFTzRWIAQrKVhIPRQ3qH2rXxE+fgJkqECHEp/Z+KnHjvveW1DidjI/8Uw54J/4HLI4
	 MSO6FD+dmM0/u1My5TrqiiV+qmxGLscLs+Ia1KjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b364457b2d1d4e4a3054@syzkaller.appspotmail.com,
	Moon Hee Lee <moonhee.lee.ca@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 18/69] wifi: mac80211: ocb: skip rx_no_sta when interface is not joined
Date: Mon,  9 Feb 2026 15:23:46 +0100
Message-ID: <20260209142302.584446129@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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

From: Moon Hee Lee <moonhee.lee.ca@gmail.com>

[ Upstream commit ff4071c60018a668249dc6a2df7d16330543540e ]

ieee80211_ocb_rx_no_sta() assumes a valid channel context, which is only
present after JOIN_OCB.

RX may run before JOIN_OCB is executed, in which case the OCB interface
is not operational. Skip RX peer handling when the interface is not
joined to avoid warnings in the RX path.

Reported-by: syzbot+b364457b2d1d4e4a3054@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b364457b2d1d4e4a3054
Tested-by: syzbot+b364457b2d1d4e4a3054@syzkaller.appspotmail.com
Signed-off-by: Moon Hee Lee <moonhee.lee.ca@gmail.com>
Link: https://patch.msgid.link/20251216035932.18332-1-moonhee.lee.ca@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ocb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/ocb.c b/net/mac80211/ocb.c
index fcc326913391d..1e1bfaf12b1aa 100644
--- a/net/mac80211/ocb.c
+++ b/net/mac80211/ocb.c
@@ -48,6 +48,9 @@ void ieee80211_ocb_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	struct sta_info *sta;
 	int band;
 
+	if (!ifocb->joined)
+		return;
+
 	/* XXX: Consider removing the least recently used entry and
 	 *      allow new one to be added.
 	 */
-- 
2.51.0



