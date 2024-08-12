Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D191EA8D;
	Mon, 12 Aug 2024 16:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478697; cv=none; b=Tbq3AnT0HU/XMDAaJltfSjZClZ+wPteBPcthvrr3N2c6hxmkqIzYWG/Bk1vdNN5DRWBDHYGqkaDzlchIhGWIx4WXmPE2g0xjoWHviDXQO3ACyC+P9IZ8WVjv+1xLYm/m3zs7dVLWeLw5G5TbnN6QHlgbl27/RCHCpBE4POXDdbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478697; c=relaxed/simple;
	bh=7KdsjgEvMow1EyG2Ga/pgxObuZPwoZjtNs2H4xcxTYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQcN+NwMJQBgnRm5p296zbgsuCizX6JUb9oRII5yOV1jVcVi2KUx1Y2fQbe12x9uxvRdU5BWjjneA998wpd+MwsKyzD+O6WufLMcVNFzfByfKaXRmQQFvz6e/puEwGVfSlhj9Arqf83PKYq4b/iBwfZV5j+50gE1nl7T9dP8Mtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ClhLRwSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ClhLRwSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC5DC32782;
	Mon, 12 Aug 2024 16:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478697;
	bh=7KdsjgEvMow1EyG2Ga/pgxObuZPwoZjtNs2H4xcxTYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ClhLRwSbG/3ef8ooWG2nfiOfBO7+/1gWEnK1tDtm+hO7F2EKN/wPpqgz/rUlzIj5K
	 EXSb1hXaj7QsF8m8q4FArgSCXHg4xtYb8V7asUjW0tvsxfpNdA0TZzXU8NFuIVA2TC
	 SFnlU8F23ORk6Y4cey2uFtC8iFryDU0kfIyUxIdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+45ac74737e866894acb0@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/150] Bluetooth: l2cap: always unlock channel in l2cap_conless_channel()
Date: Mon, 12 Aug 2024 18:01:32 +0200
Message-ID: <20240812160125.590709729@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 98dabbbe42938..209c6d458d336 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7811,6 +7811,7 @@ static void l2cap_conless_channel(struct l2cap_conn *conn, __le16 psm,
 	bt_cb(skb)->l2cap.psm = psm;
 
 	if (!chan->ops->recv(chan, skb)) {
+		l2cap_chan_unlock(chan);
 		l2cap_chan_put(chan);
 		return;
 	}
-- 
2.43.0



