Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A567DA7D;
	Thu, 15 Aug 2024 13:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730297; cv=none; b=H3r852sdw0tA5xDoU0fBGFxiobqM8vtg1puNCXU1VsxIX/q8RsgF7ilSOFqlzZ2ThZoslN+ybXqerCeAJblnDHSjINloz95JSMv/LTjApjGr3rR3Dwnww+Hs13Ru7Mmsy3/yzDUiaIqn7PUFylJHo0M5ep/CoadltT25oqBCfzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730297; c=relaxed/simple;
	bh=kxNToy70nvYBkQRrCNJNUlwkpYbkzqRfoEZHLlhGN3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NfBOgJveUuIPPN/SW8nil8PCKFM4p1Bb7dR7XH2QdGYr4MzZwL4BJvyB7PxqAFuyk6hEmeTvl65H+PtPXmuPABzt1AmWjv1ohpJsAFhVELiTAhw/D5BLTI7a19W0/qeZW7UnaRwRIwaf2CKW2we5jOQejDk8kD54MZRrrxErcbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mHWJZhit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHWJZhit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30EDC32786;
	Thu, 15 Aug 2024 13:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730297;
	bh=kxNToy70nvYBkQRrCNJNUlwkpYbkzqRfoEZHLlhGN3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mHWJZhitjPMw1HpJIYCPCUSyJG7kU+uj2Q49BTn0hZq7bqm+y5A3v5xH6HJOmMGSK
	 Ff/Wn/62YlQFThNC1qYcLWntmtQj8TYUS7Sa8dKhWDQneTxyA4JDFCDOUZkbE24o9M
	 UPDmXcC+0RtQNfT7peitC1G6UvB9bjsoYQTsiY/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+45ac74737e866894acb0@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 363/484] Bluetooth: l2cap: always unlock channel in l2cap_conless_channel()
Date: Thu, 15 Aug 2024 15:23:41 +0200
Message-ID: <20240815131955.454286862@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit c531e63871c0b50c8c4e62c048535a08886fba3e ]

Add missing call to 'l2cap_chan_unlock()' on receive error handling
path in 'l2cap_conless_channel()'.

Fixes: a24cce144b98 ("Bluetooth: Fix reference counting of global L2CAP channels")
Reported-by: syzbot+45ac74737e866894acb0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=45ac74737e866894acb0
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 43a21a90619d9..4d5dd82f26144 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7767,6 +7767,7 @@ static void l2cap_conless_channel(struct l2cap_conn *conn, __le16 psm,
 	bt_cb(skb)->l2cap.psm = psm;
 
 	if (!chan->ops->recv(chan, skb)) {
+		l2cap_chan_unlock(chan);
 		l2cap_chan_put(chan);
 		return;
 	}
-- 
2.43.0



