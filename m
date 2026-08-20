Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC479442FDA;
	Thu, 20 Aug 2026 17:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247735; cv=none; b=fnfA25tz+ThkYAvh+aq5HUEXvhYF/hL4ivJ+Iu08HbVe4o6xkCAvpTiLpUjpUiyfOUXFSNmqqKyCFk5LfrqZh7nujKxGHZpLV0PI0GnVfGSYcN17FkvkNZOz69hWDR5QLSw2bDRQKuv/5QC7cfdXbMxGZSDqB6mHPp3BoSiv65w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247735; c=relaxed/simple;
	bh=XyfS9VPw+ftpDo7W0VbrkQbeUSK21YtmS9MlHQnk5dA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVk2z721RoxDck3Ae0eHyLuroSvp5vniUW3/MxvTwgVku2Nc7kycGVG0HbEjNaxQptJaliYWVTf3AeZNSRM2cEfnMlxghDVLCCR/q4MDl7X2Z6QbY/7aVqkMpMZDRsyS3TmGJvbsZzqNVPZuG6kscS99EMcpU8SMkmkrwsNxJvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZCkmgGA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZCkmgGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4967A1F000E9;
	Thu, 20 Aug 2026 17:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247733;
	bh=igkasf44YdtX1ZZRmRJ0HgOe6bKGfHhnjwuk5Ovon5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qZCkmgGA4oZPwVcisJz+3LUAqZPTrHBNDw9HgsJoc4MTsT7xW8kifd8+p7chOYmqv
	 llli/uXmJNO2T+vmI8UIo+NQqocvbNUIhc4rA9806eAb0hVjyo41ZKqoQeoXxrrtzp
	 cvFnR/EpvVbsEgVzVbPhBnY6uN0B4dcs9YcfnOUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+30b93b6845b19cc38581@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 149/166] af_packet: Dont send zero-byte data in tpacket_snd().
Date: Thu, 20 Aug 2026 16:56:48 +0200
Message-ID: <20260820145215.652411777@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 6bcd76c134c55c697148acb5c0194e9666abdf84 ]

syzbot reported a WARNING in __dev_queue_xmit() triggered via tpacket_snd():

skb_assert_len
WARNING: at include/linux/skbuff.h:2753 skb_assert_len
WARNING: at __dev_queue_xmit+0x21bc/0x4970 net/core/dev.c:4781

Call Trace:
 <TASK>
 dev_queue_xmit include/linux/netdevice.h:3448 [inline]
 packet_xmit+0x243/0x310 net/packet/af_packet.c:276
 tpacket_snd net/packet/af_packet.c:2907 [inline]
 packet_sendmsg+0x28d6/0x4eb0 net/packet/af_packet.c:3134

When sending 0-byte packets via TPACKET ring buffer on devices with no
hard header (e.g. dev->hard_header_len == 0), tpacket_fill_skb()
populates an skb with skb->len == 0 and returns 0. tpacket_snd() then
forwards this empty skb to packet_xmit(), causing __dev_queue_xmit() to
hit skb_assert_len(skb).

Similar checks exist in packet_snd() via commit dc633700f00f
("net/af_packet: check len when min_header_len equals to 0") and in
packet_sendmsg_spkt() via commit 6a341729fb31 ("af_packet: Don't send
zero-byte data in packet_sendmsg_spkt().").

Return -EINVAL in tpacket_fill_skb() when skb->len is zero to reject
zero-length packets in tpacket_snd().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+30b93b6845b19cc38581@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a79e807.01d0871a.3a0d52.00ac.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20260810150447.1220864-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 89f7a43bed565..455a70aa9a9e9 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2719,6 +2719,9 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 		len = ((to_write > len_max) ? len_max : to_write);
 	}
 
+	if (unlikely(!skb->len))
+		return -EINVAL;
+
 	packet_parse_headers(skb, sock);
 
 	return tp_len;
-- 
2.53.0



