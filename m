Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033E6134AC;
	Mon, 12 Aug 2024 16:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479875; cv=none; b=DZUo/Sa9FgcM8MlCDjcXP+FRaYuetGG+KzrOpyFX6KipfZu7kHojl+h9CJA2YV61lx9ZtylVXxfvi6SCsZzAFmFHvTgHXhpGF+yNSU7Umn1xZyYsy6NE8FJs4+MPYdwgBH59uBvYqhL7cKeIzCuUiYQ/JMCOMSzGEXhMpV7pE5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479875; c=relaxed/simple;
	bh=JOwgg/pDLWWBrzsga8Hm5w/QXB3nDUhPdRTpcgOZ4UU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BsLPDJCbG9zMFI5titmoOuAW0nNz2qSMlKLoF1bjjIHS4+nPZsbdZS4Z0I/DA2yOhM4nh2A6rf0kzHIF5d9R7BLay/hYxMxBmZN/f/DanhBO/O1pr45LFpqdwGC6wPs7TTQdFCRswEdGuKkqwG7OFNgFPR+XkzPWZN7KKa+10Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=niwjlwFQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="niwjlwFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AC2C32782;
	Mon, 12 Aug 2024 16:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479874;
	bh=JOwgg/pDLWWBrzsga8Hm5w/QXB3nDUhPdRTpcgOZ4UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=niwjlwFQOWVnXKB0ojtD/iaA8CLtplueVLR71yK2gDJQuWw5uF4cYuaxQ5D41r84h
	 wZdgKQr5FL/WK70rvL5B7Iw+W8xy2dakZKh5q7sdJ/13RZn4kf76LyUY6P/mAvmJvc
	 CqXp/VFxCYVrNK18In1fn/MKzfE/1g+7icbli4z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+45ac74737e866894acb0@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 028/263] Bluetooth: l2cap: always unlock channel in l2cap_conless_channel()
Date: Mon, 12 Aug 2024 18:00:29 +0200
Message-ID: <20240812160147.618960434@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index c3c26bbb5ddae..9988ba382b686 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6774,6 +6774,7 @@ static void l2cap_conless_channel(struct l2cap_conn *conn, __le16 psm,
 	bt_cb(skb)->l2cap.psm = psm;
 
 	if (!chan->ops->recv(chan, skb)) {
+		l2cap_chan_unlock(chan);
 		l2cap_chan_put(chan);
 		return;
 	}
-- 
2.43.0



