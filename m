Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FE947B436;
	Sat, 12 Sep 2026 18:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237066; cv=none; b=GbkUmGUbez2IW9EcSDBxPEfS28+ArC1Fu0vNK4fzaaQzuUp1IML66Wb9azvyyyN0dmOS4Cv9md0QUUD92JGR8JnYpUFjK7xd54m4kqWTcFTK+HGvMQfJDG6aYLgSxx+LYwu/Xgl9IQ8zhCVFANREAb7AySQPgUUR2Ja8z4VPKQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237066; c=relaxed/simple;
	bh=nHrQsIDeIcp60b1tGGVV5XeO0k/TNwwfnZr4t88j6jQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsplWiOi1yFGcoI/01uSECIcmGIXmouCxPom+5TGzmrbzeMP3x2oiaIzVNfpS8qpnEtHjZIt72eJTvCb7PW0cIBxmfGwAJabdxLTJ042mK4lgGlCkWlkoDbEWnfawT7NUDTjIBjMw72eGU9mrSbxl77f6CLcojvtzwu4QhlZ4Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVZXlwkh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVZXlwkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C971F000FF;
	Sat, 12 Sep 2026 18:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237064;
	bh=uYxvGlFuul+vd+JScqix0J7/oEDtOxLZHL3U4geTsuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NVZXlwkhJxIlcx/sJw+GN8Lqk3gQFORL+nSVahmHSbGl5bdJ99R/O51YWMmwIrGpB
	 ztH109sY5TmCcqJcfizD+/ynI23LsaMp+WOYnQdXgoL6xjRxrnr9kRgOZZOmxg2yzh
	 iGk1SliDhIv74dgJGVCAxhrqlPq8XHfD20iGIcGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 184/935] net: ntb_netdev: Count packets dropped on RX refill failure
Date: Sat, 12 Sep 2026 08:53:34 +0200
Message-ID: <20260912065531.035986042@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

commit 31ded341c375bb2faac1d77ab0012a732ba3e2a6 upstream.

When replacement skb allocation fails, ntb_netdev drops a packet that
was received successfully and requeues the original buffer. The drop is
counted, but rx_packets and rx_bytes are not.

Count every good packet before allocating its replacement.

Fixes: d2121faf133a ("NTB: ntb_netdev: Preserve RX queue depth on allocation failure")
Cc: stable@vger.kernel.org
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Link: https://patch.msgid.link/20260819172539.1450821-3-den@valinux.co.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ntb_netdev.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -115,6 +115,9 @@ static void ntb_netdev_rx_handler(struct
 		goto enqueue_again;
 	}
 
+	ndev->stats.rx_packets++;
+	ndev->stats.rx_bytes += len;
+
 	new_skb = netdev_alloc_skb(ndev, ndev->mtu + ETH_HLEN);
 	if (!new_skb) {
 		ndev->stats.rx_dropped++;
@@ -126,8 +129,6 @@ static void ntb_netdev_rx_handler(struct
 	skb->ip_summed = CHECKSUM_NONE;
 
 	netif_rx(skb);
-	ndev->stats.rx_packets++;
-	ndev->stats.rx_bytes += len;
 
 	skb = new_skb;
 


