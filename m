Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB1151121F;
	Wed, 30 Sep 2026 18:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792100; cv=none; b=dYptempqoJl6sHBpmvzZOB0WaiutwLIJrYrtr792P5OWb534RB72PCv70zOpi9WlyGAw4DvoZVGX+sYzzzq6EcNNepvj30YtXUOp7EKIsWNL19t7AleH9bwjKUoOI4ATKb0rE14//LNRb4Hw056djC5e1/xxCnacMt8btHWz6G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792100; c=relaxed/simple;
	bh=pm2S0zGLvKQZdylH29rx8guYBYvmbFhVbLsEhNh0u64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEUI3BSPvknwtYCpiZNeS8JE9QwK6hneGzABifPGwwZO7IkMye/q9j9gB1a4p2u524JnXUQRn/645u4fnTBLk1osn+5SG10J+O82KWBdFWun0ykpPB3IIzH1egCHabnLXRNCo7zY+P9y7WLlkupDpUBSEkZcXTjZYAKBP3jP/dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3ejGAaN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3ejGAaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44A81F000FF;
	Wed, 30 Sep 2026 18:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792098;
	bh=ucLzt+Yx71n5LETmKU8XtAOvN+E+f97NHSFdMUJIZ1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G3ejGAaNqSx8G9uxjW+HN9IlSq0RpOP2aHPJci7KrmNqCW9jZ75q6GoswsMGTJDhz
	 73JUsPqe34FIfezqckcdAAJozR7zUPljmeIYxjJnmPZauQMlR9Ifk56jsf4XuJnMCL
	 hc+6O6OR4wUca9TV5FfWzCGz4M6mtHjD00Dxw0MQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 535/752] net: wwan: mhi_wwan_mbim: check skb_copy_bits() return value
Date: Wed, 30 Sep 2026 17:26:45 +0200
Message-ID: <20260930152409.826680986@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Guanglei Zhu <zhugl3@xiaopeng.com>

commit 31550d585589fde1ae95bf7f7a8188b2d2fdf1c7 upstream.

mhi_mbim_rx() ignores the return value of skb_copy_bits() when it
copies each datagram out of the NTB.  The datagram offset and length
come from the DPE, which is only checked to lie within the NTB
itself, so a modem can point a datagram outside the received skb.
The copy then fails and the freshly allocated skbn is passed to
netif_rx() with its uninitialized contents still in place, leaking
kernel heap memory into the network stack.

Free the skb and account an error when the copy fails.

Fixes: aa730a9905b7 ("net: wwan: Add MHI MBIM network driver")
Cc: stable@vger.kernel.org
Suggested-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Verified in a QEMU guest with a fault injector pointing a DPE
outside the received NTB: the copy fails, and the unpatched driver
hands the uninitialized skbn to the network stack (observed as
"unknown protocol" on bytes that were never written).  With this
check the failed datagram is dropped and counted as an rx error.

Changes in v2: factor the free-and-count sequence out into
mhi_mbim_rx_drop(), shared with the unknown-protocol path, as
suggested by Loic Poulain.

Link: https://patch.msgid.link/20260911021734.1396599-2-zhugl3@xiaopeng.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/wwan/mhi_wwan_mbim.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/net/wwan/mhi_wwan_mbim.c
+++ b/drivers/net/wwan/mhi_wwan_mbim.c
@@ -240,6 +240,14 @@ static int mbim_rx_verify_ndp16(struct s
 	return ret;
 }
 
+static void mhi_mbim_rx_drop(struct mhi_mbim_link *link, struct sk_buff *skb)
+{
+	dev_kfree_skb_any(skb);
+	u64_stats_update_begin(&link->rx_syncp);
+	u64_stats_inc(&link->rx_errors);
+	u64_stats_update_end(&link->rx_syncp);
+}
+
 static void mhi_mbim_rx(struct mhi_mbim_context *mbim, struct sk_buff *skb)
 {
 	int ndpoffset;
@@ -309,7 +317,10 @@ static void mhi_mbim_rx(struct mhi_mbim_
 				continue;
 
 			skb_put(skbn, dgram_len);
-			skb_copy_bits(skb, dgram_offset, skbn->data, dgram_len);
+			if (skb_copy_bits(skb, dgram_offset, skbn->data, dgram_len)) {
+				mhi_mbim_rx_drop(link, skbn);
+				continue;
+			}
 
 			switch (skbn->data[0] & 0xf0) {
 			case 0x40:
@@ -321,10 +332,7 @@ static void mhi_mbim_rx(struct mhi_mbim_
 			default:
 				net_err_ratelimited("%s: unknown protocol\n",
 						    link->ndev->name);
-				dev_kfree_skb_any(skbn);
-				u64_stats_update_begin(&link->rx_syncp);
-				u64_stats_inc(&link->rx_errors);
-				u64_stats_update_end(&link->rx_syncp);
+				mhi_mbim_rx_drop(link, skbn);
 				continue;
 			}
 


