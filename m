Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A4317966F;
	Wed,  3 Jul 2024 11:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004876; cv=none; b=T/w8wmgEVotkUpWp2dnViRH3PuH8P9XUec4wNghkDQ+fQIUvrGrm980/RH0dWEPTdjxBS6jIWrUc+kgdO7Q01Mn0a6Na4k3J4CX+unMmjrvgVfBgLWYkkxe2TpmmA20C7QZ557OK11YXlxqzXySi03ClHQl4iek6+OWDxzLiJY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004876; c=relaxed/simple;
	bh=z+X6yyUlAgB70yJzb3+Sezmf9AaLlz4QM7/VXmBrQ4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0fIyJH4d+W+WfvgrZ59MzJDTk8eHHJVZCXl5ik+nKxlowJtSGnSflYRkSNoKCOUssMI8OkNi5qGEiA9oIXnYwcJKUo1ovL3Hmr/HIgKbX07GZws3fUsxPZ/ybUdPWoW8aUWEnAiG5It1E/JoUnj2ssPTiunZ6tSkgH96pTT43A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTjO1VSk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTjO1VSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B618C2BD10;
	Wed,  3 Jul 2024 11:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004876;
	bh=z+X6yyUlAgB70yJzb3+Sezmf9AaLlz4QM7/VXmBrQ4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTjO1VSku+HZujYsT7VKI5ECRJi2tDy6WGn4fEiMXN1qqzGvjNpPJPq0rrPqu510n
	 p3LWHW/KeOSvrXeRKwmokhb4ago0crE2JGD6kKI6J2Q8HN2+P5BqN9thQduxImFrab
	 fcppx+JPVGFDL5UfacgG+QW6fkx9MTOCfGhO5NfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 185/290] r8169: improve rtl_tx
Date: Wed,  3 Jul 2024 12:39:26 +0200
Message-ID: <20240703102911.159114636@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit ca1ab89cd2d654661f559bd83ad9fc7323cb6c86 ]

We can simplify the for() condition and eliminate variable tx_left.
The change also considers that tp->cur_tx may be incremented by a
racing rtl8169_start_xmit().
In addition replace the write to tp->dirty_tx and the following
smp_mb() with an equivalent call to smp_store_mb(). This implicitly
adds a WRITE_ONCE() to the write.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/c2e19e5e-3d3f-d663-af32-13c3374f5def@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c71e3a5cffd5 ("r8169: Fix possible ring buffer corruption on fragmented Tx packets.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 84c8362a65cd1..0847b64fbb2f4 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4469,11 +4469,11 @@ static void rtl8169_pcierr_interrupt(struct net_device *dev)
 static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 		   int budget)
 {
-	unsigned int dirty_tx, tx_left, bytes_compl = 0, pkts_compl = 0;
+	unsigned int dirty_tx, bytes_compl = 0, pkts_compl = 0;
 
 	dirty_tx = tp->dirty_tx;
 
-	for (tx_left = READ_ONCE(tp->cur_tx) - dirty_tx; tx_left; tx_left--) {
+	while (READ_ONCE(tp->cur_tx) != dirty_tx) {
 		unsigned int entry = dirty_tx % NUM_TX_DESC;
 		struct sk_buff *skb = tp->tx_skb[entry].skb;
 		u32 status;
@@ -4497,7 +4497,6 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 
 		rtl_inc_priv_stats(&tp->tx_stats, pkts_compl, bytes_compl);
 
-		tp->dirty_tx = dirty_tx;
 		/* Sync with rtl8169_start_xmit:
 		 * - publish dirty_tx ring index (write barrier)
 		 * - refresh cur_tx ring index and queue status (read barrier)
@@ -4505,7 +4504,7 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 		 * a racing xmit thread can only have a right view of the
 		 * ring status.
 		 */
-		smp_mb();
+		smp_store_mb(tp->dirty_tx, dirty_tx);
 		if (netif_queue_stopped(dev) &&
 		    rtl_tx_slots_avail(tp, MAX_SKB_FRAGS)) {
 			netif_wake_queue(dev);
-- 
2.43.0



