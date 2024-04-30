Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FE112C47F;
	Tue, 30 Apr 2024 10:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473866; cv=none; b=sxxjtol1K06ihJW7qoq1RIC6fD7VzG6CnCYxZqWzbMFhnVzWuBuHlUV2E9mxFqtP2oLq037ibXa//qGqsMignRrUqXlF5mVoG9hp+yGutS/OcwfNg9ULZMZbDn5g6wrXldTTvCctWwn16m47tP38khDnVVDbenlzatbLWrpanWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473866; c=relaxed/simple;
	bh=MB8QriwIfkD1lNFwuTVNyVkaDp3Ol7xJK7EeEVdNaCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YVPvzM7YVL+PM7jKtLQziXxixvbrU2Kj9ikw14yZEclxxlNzYD2oNbU0am3MKnDA9mGgxZrMm39uhOJIBRU+uYv+S4lX9p8+6+zrCxQSRUvWfHDGALqMSKZCRBdEVpo/9yATYHn+6qIua7uvvq+idN+3N43IDsVAJmvHRxTxC7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkv0+3IT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkv0+3IT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2E2C2BBFC;
	Tue, 30 Apr 2024 10:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473865;
	bh=MB8QriwIfkD1lNFwuTVNyVkaDp3Ol7xJK7EeEVdNaCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wkv0+3ITvx5JI0fnCICc4MMCgTlkiSHV0nowkbbhQrBISJjsHVh4Yd1LvCY5Z/Zrm
	 dlUjF1SyVWigZoyQnE7Oe4arWf/ELo6dfYC0GGOeh4fp3XsnlEWLrBfEvNVX4WW67Z
	 Fr2yBQTBAVTmTlzGZ38D7awQZuI065Yzntbmti8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Peter=20M=C3=BCnster?= <pm@a16n.net>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Vaclav Svoboda <svoboda@neng.cz>,
	Andrew Lunn <andrew@lunn.ch>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 65/77] net: b44: set pause params only when interface is up
Date: Tue, 30 Apr 2024 12:39:44 +0200
Message-ID: <20240430103043.057412305@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
User-Agent: quilt/0.67
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Münster <pm@a16n.net>

commit e3eb7dd47bd4806f00e104eb6da092c435f9fb21 upstream.

b44_free_rings() accesses b44::rx_buffers (and ::tx_buffers)
unconditionally, but b44::rx_buffers is only valid when the
device is up (they get allocated in b44_open(), and deallocated
again in b44_close()), any other time these are just a NULL pointers.

So if you try to change the pause params while the network interface
is disabled/administratively down, everything explodes (which likely
netifd tries to do).

Link: https://github.com/openwrt/openwrt/issues/13789
Fixes: 1da177e4c3f4 (Linux-2.6.12-rc2)
Cc: stable@vger.kernel.org
Reported-by: Peter Münster <pm@a16n.net>
Suggested-by: Jonas Gorski <jonas.gorski@gmail.com>
Signed-off-by: Vaclav Svoboda <svoboda@neng.cz>
Tested-by: Peter Münster <pm@a16n.net>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Peter Münster <pm@a16n.net>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/87y192oolj.fsf@a16n.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/b44.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -2033,12 +2033,14 @@ static int b44_set_pauseparam(struct net
 		bp->flags |= B44_FLAG_TX_PAUSE;
 	else
 		bp->flags &= ~B44_FLAG_TX_PAUSE;
-	if (bp->flags & B44_FLAG_PAUSE_AUTO) {
-		b44_halt(bp);
-		b44_init_rings(bp);
-		b44_init_hw(bp, B44_FULL_RESET);
-	} else {
-		__b44_set_flow_ctrl(bp, bp->flags);
+	if (netif_running(dev)) {
+		if (bp->flags & B44_FLAG_PAUSE_AUTO) {
+			b44_halt(bp);
+			b44_init_rings(bp);
+			b44_init_hw(bp, B44_FULL_RESET);
+		} else {
+			__b44_set_flow_ctrl(bp, bp->flags);
+		}
 	}
 	spin_unlock_irq(&bp->lock);
 


