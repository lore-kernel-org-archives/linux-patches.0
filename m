Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E6F3B3BE9;
	Wed, 23 Sep 2026 14:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173747; cv=none; b=rAQ5+DMpEuvZiOO02s6X9oUw2hMSn6ye9boInafWVLkeSdeToBeHBEekoUInqjr7K3xp2wLi3kXCfmO+V5lR3FolWpn0p+Ky4xqJLGiB3Ph8PY6YfSw2lEXjpuJ781GVcS4WqEo0+A8MXS6ixVwPZv4QNFdnrikpnsK74mrqVXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173747; c=relaxed/simple;
	bh=3ORtoJc8iH/AWA1zP9FXGCeOmiqQfeFEkuyfzwWXXFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQrtczu/0TRiGDuV+MW6RfZeslYpmOQZEKQ/wKTqKxdJjeyznz7OAujN5T1ZYiV1QhanfuSc1SMwZAKmKZ+rhFTWdoRyj7y45vEFTEF+f3QltJqKEZhs6bXQFcCAGnB3laeycLCgE7AJuykux0Ff1EUNhcugw3IzvAWuEADPwvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxBTmfAH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxBTmfAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AB21F000FF;
	Wed, 23 Sep 2026 14:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173746;
	bh=A0lb1NOKYLNvJbAYQaiXMPQxb6SeJYWRa5oGLom8BX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jxBTmfAHoLpSiNhob5+EdTgXhVp29fF920ODE3kcg0OA4pd7mSL4y2uX6l2uwnxB4
	 /nCCdbHJcBdfFjDBX7MplzFngBAOQ1ghLBOwkrwa690v0ou9d/1QJTFuQp749+W/Om
	 J8NxxXssdrwt5Cs0V6rD0c1TNUsWPIMqWksS5MSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Amirkan <markdamirkan@gmail.com>,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 296/438] net: lan743x: fix RX checksum use-after-free
Date: Wed, 23 Sep 2026 16:05:17 +0200
Message-ID: <20260923140652.451445888@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Amirkan <markdamirkan@gmail.com>

commit a9ce4053dc945c5372dedba5017ee675b30dc0c5 upstream.

lan743x_rx_process_buffer() adds each non-first receive buffer to the
head skb's frag_list.  On the last descriptor, lan743x_rx_trim_skb()
linearizes the head and frees the fragment skb metadata.

The checksum-success path then writes ip_summed through the local skb
pointer, which still points to the final fragment.  This causes a
use-after-free write when a packet spans more than one receive buffer.

Set ip_summed on the surviving head skb instead.  Multi-buffer receive
can occur after a live MTU increase because existing ring entries keep
their old buffer size until they are replenished.

A KUnit test invoking lan743x_rx_process_buffer() with a two-buffer
packet produced a one-byte KASAN use-after-free write before this change.
The same test passed after the change.  The driver object also builds
with W=1.  This was not tested on physical LAN743x hardware.

Fixes: cd6910501cfd ("net: lan743x: Add support for Rx IP & TCP checksum offload")
Cc: stable@vger.kernel.org
Signed-off-by: Mark Amirkan <markdamirkan@gmail.com>
Reviewed-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Link: https://patch.msgid.link/20260913-b4-send-lan743x-uaf-v1-1-73d563d08ba9@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2594,7 +2594,7 @@ process_extension:
 							rx->adapter->netdev);
 		if (rx->adapter->netdev->features & NETIF_F_RXCSUM) {
 			if (!is_ice && !is_tce && !is_icsm)
-				skb->ip_summed = CHECKSUM_UNNECESSARY;
+				rx->skb_head->ip_summed = CHECKSUM_UNNECESSARY;
 		}
 		netdev_dbg(netdev, "sending %d byte frame to OS",
 			   rx->skb_head->len);


