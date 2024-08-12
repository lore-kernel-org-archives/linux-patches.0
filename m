Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF05130E27;
	Mon, 12 Aug 2024 16:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479211; cv=none; b=EYPtMTak/eB+zg5YLXXSRT2rMTeJZKf+YrGJSgln0h3ibVsuAOnqlcEz3WFNi0SvROpxnow7wC1uMT7AE6Din60geGpPT4YtixO0l5Ur+nRNn4wl67K1kmrd8Y90VN6ExbLO4C6n077Ebkc1T4DhkR11b/0M4t8pGVYTJCEqAyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479211; c=relaxed/simple;
	bh=+/iqUQz8PveP9zg0tz7R3vphdL1Ne2pamtykBGPbBBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBLHHcKucqnnMtoXwQPijgLKnMQJFLLsQy2iBSt8JqVuvd6pyCa7LoBNcOUtU4Ty1z/Xp9yN82M0dKEVz4Zuq/JNOrEFHC71I2w5uRi7UniDnABa2ulu6wTF5jljFKKwIDLh5+x35ng6j8IrVgwYexj8b7YFkVpmoDyr1bvsL+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LYlKe2fC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LYlKe2fC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A8AC4AF0D;
	Mon, 12 Aug 2024 16:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479211;
	bh=+/iqUQz8PveP9zg0tz7R3vphdL1Ne2pamtykBGPbBBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LYlKe2fCZ6K/NYzIiCC/LGJ8AjvjDwifXaU0irrkBn4lPKS/bqIfHCwVa+uhhMf6o
	 5H7kIwE8TgpJNjsqYZHoi2iqebDhEsRxfUd9bNgh3Wuy8i8OkCmG0xQP93RxPoMKAf
	 ht9ORkhT4XQcQZ9XDT6hR4k8dQvR33gSBB73gnK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+45ac74737e866894acb0@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/189] Bluetooth: l2cap: always unlock channel in l2cap_conless_channel()
Date: Mon, 12 Aug 2024 18:01:13 +0200
Message-ID: <20240812160132.806791334@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1164c6d927281..2651cc2d5c283 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6775,6 +6775,7 @@ static void l2cap_conless_channel(struct l2cap_conn *conn, __le16 psm,
 	bt_cb(skb)->l2cap.psm = psm;
 
 	if (!chan->ops->recv(chan, skb)) {
+		l2cap_chan_unlock(chan);
 		l2cap_chan_put(chan);
 		return;
 	}
-- 
2.43.0



