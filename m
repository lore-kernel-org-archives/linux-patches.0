Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5B678C9C;
	Sun,  7 Jun 2026 10:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826771; cv=none; b=Kc23Unz8SrLEcJCOQZP1T0t+CoXJKz1SbK7OrmYweVnVV2juAHfpJCKgMc3dtpNeC+kFP6vRtIKbh/K+6kHXNxperM8mklzkrEWXKzNZL3g3Y1p9x7cek9CT777EcBEYuetgjO/EAGvCCWG5rj8M8f5H92H2RkVBn0uw3c2i4Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826771; c=relaxed/simple;
	bh=GodA7kWoUWgofy4+4FB/bNj6Tcor11TQf61VSD5uPLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lElMKmDaI3y5XZRO5ZyLyPubNAutt+i+TWHqiOI2hhefSxXBXp0w/l42/B/a/g8G2RSO2hRlKzvknHVhL+Dug9FQrH2FjnPwmTlAqfrMkBIO9vOSaSrGr0l98tD0p67B333K41LUyhkL9WT8ykd4g2++guvvbAQk7QRVStEpPXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJIpTwih; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJIpTwih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4933D1F00893;
	Sun,  7 Jun 2026 10:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826769;
	bh=sdgItA8OJLCvvwF7fj8lhPuoAmZIsCsZJ8VUQ/3j3Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UJIpTwihsZmQxWHijdjuBU8041Jk7WA0WVt67uLUCv2GsJGjK4pe533eMqPgF38i4
	 t9c08tZMj4ajKML0fFuKXaYAs3Cd+8IufXwsotaqCps+hGK3lGTfmzqw5TTgv0aV4N
	 DcY0b/oPnkKJdhwEw1h0Jyv2HNOXllH/sJfueaIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 023/332] tun: free page on build_skb failure in tun_xdp_one()
Date: Sun,  7 Jun 2026 11:56:32 +0200
Message-ID: <20260607095728.922672474@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit aa8963fdce667a42fb7f0bdd2909fadcab02f9a8 ]

When build_skb() fails in tun_xdp_one(), the function sets ret to
-ENOMEM and jumps to the out label, which returns without freeing the
page that vhost_net_build_xdp() allocated for the frame. As with the
short-frame rejection path, tun_sendmsg() discards the per-buffer error
and still returns total_len, so vhost_tx_batch() takes the success path
and never frees the page. Each build_skb() failure in a batch leaks one
page-frag chunk.

Free the page before taking the error path, matching the put_page() the
other error exits of tun_xdp_one() already perform.

Fixes: 043d222f93ab ("tuntap: accept an array of XDP buffs through sendmsg()")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260521163312.1479805-2-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 8154d18a2a235a..ca0ae5df73af78 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2437,6 +2437,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 build:
 	skb = build_skb(xdp->data_hard_start, buflen);
 	if (!skb) {
+		put_page(virt_to_head_page(xdp->data));
 		ret = -ENOMEM;
 		goto out;
 	}
-- 
2.53.0



