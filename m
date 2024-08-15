Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EF21AC893;
	Thu, 15 Aug 2024 14:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732795; cv=none; b=r31Sd28xicKb7bcDyFqAJiNXR2GxUwFRrMt82arH6dc9rc1Ad1q4RkbhyylVnBa8UZ3VS3aaWLq8tTOnv9KmKAVDt1855vgrHslm+VAWnDITZv3O/owB9nSuh40SQ61avmGYCA4fDfIiyKRZLiht7HnP/kRyaRE0v+1t473MQPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732795; c=relaxed/simple;
	bh=FKV8PMejnlAujtY8rvAhW0om8knqWLw9DWfS+tW/qFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVR/3Bo9Sj61F/UJ82gIEZ5/0km17sk6maiwllgaP27oOhyPflIS36OCh4bVlByFPsRkP0E9x6ZsCTK/3esJ09B+c24xXJU7MmADgGcZpCxn9N1rqViR1Xee6gZvMPsnW1l5nvZrZgbLW5BbJTHbN6+kMIGJ85mF94Jz4tsOCAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVqy96kw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVqy96kw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E45FC32786;
	Thu, 15 Aug 2024 14:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732795;
	bh=FKV8PMejnlAujtY8rvAhW0om8knqWLw9DWfS+tW/qFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVqy96kw3wPMvVe/JcjeHCfTtSAUqytQHCER15ms7kmD36+IF253D363xPDLiLaJK
	 23luN7vC1AIx3+6M4Hgki06ipnZ0QMM1sbc8upbvHppTGc/FxbpYOBsnpSoqHb+cQ6
	 jlF7xFTXyDE0cTUj2R97zDQwrII1jgUsxOKiWgPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+45ac74737e866894acb0@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 257/352] Bluetooth: l2cap: always unlock channel in l2cap_conless_channel()
Date: Thu, 15 Aug 2024 15:25:23 +0200
Message-ID: <20240815131929.377484542@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9cc034e6074c1..23fc03f7bf312 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7762,6 +7762,7 @@ static void l2cap_conless_channel(struct l2cap_conn *conn, __le16 psm,
 	bt_cb(skb)->l2cap.psm = psm;
 
 	if (!chan->ops->recv(chan, skb)) {
+		l2cap_chan_unlock(chan);
 		l2cap_chan_put(chan);
 		return;
 	}
-- 
2.43.0



