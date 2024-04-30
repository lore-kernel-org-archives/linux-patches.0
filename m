Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AE48801;
	Tue, 30 Apr 2024 11:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475941; cv=none; b=Q/raeOGcauTs0o1u/1H9yhuT4F00OONoOxehAp32CKsfZ8hmpU5zW5AWs5HN7eOQmlUarPGMPutT5PVk7JkgNXXHokz7I8/DUTDNaNNT+NlfHIR1W2pNhS4ybx20f+TJjPLLUrikoq8Bj8JsLqvzvV19urXwbUFFyE2+x1fAxqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475941; c=relaxed/simple;
	bh=w0jJagZuWv2PDD+NRCI9+2vNzm50G1UTZ2BaaSLnEv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BVNMFXsD70XQHSZRrue+9MjZlMG6oTCffON6lz1HRmPxGxWJ1xWPCr6pv5t502rKuOVgwUEr2l4jcrSa9xo/f9j7IQzZccbxd78q8J/KusOgkE5Kuoa2b4pVZABqPnhCZhixvjXgCkPiOwdiPHl49aBtXCLSjs4vVLNYQPraGw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/874aR4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/874aR4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5DDC2BBFC;
	Tue, 30 Apr 2024 11:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475940;
	bh=w0jJagZuWv2PDD+NRCI9+2vNzm50G1UTZ2BaaSLnEv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/874aR4ZrE3wmdH7sYGcbfxn53qrdO592lnusuMpjfLVSy1/c+hbQGwm36WzJEu6
	 fqt8oP1lDTxD8Q+f+dxYv9f7Gn2yAgMV0LFEMQOR/eCdZ+egxrm7Cis08XATSLSSQV
	 hAkHQrnGU4sYUIMttBKVtM3Jndfo3zlsX6sifwKo=
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
Subject: [PATCH 5.15 64/80] net: b44: set pause params only when interface is up
Date: Tue, 30 Apr 2024 12:40:36 +0200
Message-ID: <20240430103045.308272680@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2029,12 +2029,14 @@ static int b44_set_pauseparam(struct net
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
 


