Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1893A5433;
	Thu, 30 Jul 2026 14:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423155; cv=none; b=d1YypRFtAnalDjeK2o1cWkaA/4dqry5K8YsQjwtaYWpQuE4VGpjLlvYV4RjDwWOmgq2Rv/BQGAwjvf2Boj7PNk0BCi6x/4NjeKjRGSSt91UBZAtuUa4DGzwfVmY29BzYB4Bo28Kw8udaAFsHmuysflPzNGenNm1NM+AxBKiDsnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423155; c=relaxed/simple;
	bh=IHupllB+buv6QRQ51IhVDOuz9g7uQwptHnYT9XgE4Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRjhVlnrJTqVEbjKNxzynLKaBcKmVWKpv1XSFmdiqMq59N8poPXrRObensKU0tY5+5cSrwX7X+VayFA18LrMwGCvRLbR/89s9ZT30o4dyyF/U3v45l+Gxb2Cf7HR0rcDe2Vl0tN/WCBrOdu3qhjt7SP6Oq1B/lVlFN2ApAD0WtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOQwh72e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOQwh72e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AAE1F00A3D;
	Thu, 30 Jul 2026 14:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423154;
	bh=tHY0ZT1kELQK7brpuHcQ5qsBeIjUID7wSYDf8JfPKaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rOQwh72ejeikTYQy3jJidDtQnu59DpgVxcQqGmbCg6kSvteeI7zTfV7LjyZBxRFfc
	 f+AyThJjCLBDM9l/HLoPbESMv+63adpdYa48tQe+uulyV9QtqNu8cRP4u65Nvy49DW
	 w+syhzuuDMPX2U35NEswIAK93Zk7yypJqi8Xb0Ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Antonio Quartulli <antonio@openvpn.net>
Subject: [PATCH 7.1 684/744] ovpn: hold peer before scheduling keepalive work
Date: Thu, 30 Jul 2026 16:15:57 +0200
Message-ID: <20260730141458.804183663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuvam Pandey <shuvampandey1@gmail.com>

commit a4710ae2e7e322fdaefb4be8604228279cfaf48c upstream.

ovpn_peer_keepalive_send() passes its peer reference to
ovpn_xmit_special(), which ultimately drops it. The keepalive scheduler
currently queues the work first and takes the reference only after
schedule_work() reports that the work was queued.

Once schedule_work() queues the item, another CPU may run the worker
before the caller gets to ovpn_peer_hold(). In that case the worker can
consume a reference that was not acquired for it, corrupting the peer
lifetime accounting.

Take the peer reference before queueing the work and drop it again when
the work was already pending.

Fixes: 3ecfd9349f40 ("ovpn: implement keepalive mechanism")
Cc: stable@vger.kernel.org
Signed-off-by: Shuvam Pandey <shuvampandey1@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ovpn/peer.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ovpn/peer.c
+++ b/drivers/net/ovpn/peer.c
@@ -1285,8 +1285,10 @@ static time64_t ovpn_peer_keepalive_work
 		netdev_dbg(peer->ovpn->dev,
 			   "sending keepalive to peer %u\n",
 			   peer->id);
-		if (schedule_work(&peer->keepalive_work))
-			ovpn_peer_hold(peer);
+		if (WARN_ON(!ovpn_peer_hold(peer)))
+			return 0;
+		if (!schedule_work(&peer->keepalive_work))
+			ovpn_peer_put(peer);
 	}
 
 	if (next_run1 < next_run2)


