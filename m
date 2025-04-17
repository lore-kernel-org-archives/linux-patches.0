Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C381DEFD4;
	Thu, 17 Apr 2025 18:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913889; cv=none; b=Awd3cERcTBT5HVDnUSaXBn27dm6q+tO0sV5MMnWslDj8ZfFXRRzQEXOg9odOpOXiob6uhur7oRtCaepl3e9AnEISLFHkq2UePYc59u7tb7h+EWTKZnl2ETOK3EUIFqCoyKTlrDvo0ryLOcgXDSO0m2KsRnCi8Pmdg9j3vJeI9xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913889; c=relaxed/simple;
	bh=rrCIOkax/hlu8pBStexiOgeMokMrMPdsWXCB4gbYnJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N5eKeYAUptZq9Om24zXIuTrbwtK8iOD7IHzRdvu1ehDpaMWlSZ999qIzY+VozUXn9uk/yAU9cvvn1FdEJ7OHyz3e6Ip1d2SEKPX7Jrely+2QQSKIsRUzquTD5ZJBTLQd7Rv9KJu+erawbzymBcDVOwjtUhS+QBxVp+Kaw2uxxns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tm3BFXUN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tm3BFXUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1350EC4CEF1;
	Thu, 17 Apr 2025 18:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913888;
	bh=rrCIOkax/hlu8pBStexiOgeMokMrMPdsWXCB4gbYnJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tm3BFXUND9EYK1NCCzebH8oa08q2dFPZGyf4y2LJwRvqZCXPdsGV72PWEq4yPD6QA
	 A7TiPTrEoETUeyYeD38rA2zSP1tbYtOqKvsdjFVFo4NCTOPyD9tnkEZ3isBIL+ceWV
	 3TNZMdh98DvaAfDxEt29pFk4mRQOaascbi1ghV14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+29fc8991b0ecb186cf40@syzkaller.appspotmail.com,
	Arnaud Lecomte <contact@arnaud-lcm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 035/414] net: ppp: Add bound checking for skb data on ppp_sync_txmung
Date: Thu, 17 Apr 2025 19:46:33 +0200
Message-ID: <20250417175112.826729529@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaud Lecomte <contact@arnaud-lcm.com>

[ Upstream commit aabc6596ffb377c4c9c8f335124b92ea282c9821 ]

Ensure we have enough data in linear buffer from skb before accessing
initial bytes. This prevents potential out-of-bounds accesses
when processing short packets.

When ppp_sync_txmung receives an incoming package with an empty
payload:
(remote) gef➤  p *(struct pppoe_hdr *) (skb->head + skb->network_header)
$18 = {
	type = 0x1,
	ver = 0x1,
	code = 0x0,
	sid = 0x2,
        length = 0x0,
	tag = 0xffff8880371cdb96
}

from the skb struct (trimmed)
      tail = 0x16,
      end = 0x140,
      head = 0xffff88803346f400 "4",
      data = 0xffff88803346f416 ":\377",
      truesize = 0x380,
      len = 0x0,
      data_len = 0x0,
      mac_len = 0xe,
      hdr_len = 0x0,

it is not safe to access data[2].

Reported-by: syzbot+29fc8991b0ecb186cf40@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=29fc8991b0ecb186cf40
Tested-by: syzbot+29fc8991b0ecb186cf40@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Arnaud Lecomte <contact@arnaud-lcm.com>
Link: https://patch.msgid.link/20250408-bound-checking-ppp_txmung-v2-1-94bb6e1b92d0@arnaud-lcm.com
[pabeni@redhat.com: fixed subj typo]
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_synctty.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ppp/ppp_synctty.c b/drivers/net/ppp/ppp_synctty.c
index 644e99fc3623f..9c4932198931f 100644
--- a/drivers/net/ppp/ppp_synctty.c
+++ b/drivers/net/ppp/ppp_synctty.c
@@ -506,6 +506,11 @@ ppp_sync_txmunge(struct syncppp *ap, struct sk_buff *skb)
 	unsigned char *data;
 	int islcp;
 
+	/* Ensure we can safely access protocol field and LCP code */
+	if (!pskb_may_pull(skb, 3)) {
+		kfree_skb(skb);
+		return NULL;
+	}
 	data  = skb->data;
 	proto = get_unaligned_be16(data);
 
-- 
2.39.5



