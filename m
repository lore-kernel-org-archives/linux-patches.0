Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D19346D0AF;
	Tue, 21 Jul 2026 19:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663270; cv=none; b=m/84EfX4F6H2G80Mt6pPwxyg1rQrI8vSramINOkmEm6+KZEf2dRTE23v1i8TLSW2kg7dKQ/Iw8j4RBEdt0J6qLAMWriDy4jPQgLeFy4EC96W488LwROKMb1rjl5Y69m/X0v9BdAZzaVc13edBzj5hgMwcQc6Rqd4KYRIgJAq0xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663270; c=relaxed/simple;
	bh=vNRB9o9rrT59ixv11NZR+WF0P8pYSE5E/Hy/a36p7Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNRKYxxeIpBgEOJUaLrm2L2PIUXcK/5RfMOX6SokASOHSUu8d4iH6Qo/cH48jnUN2TL5dmWHp04OyHZbuPurkIpNE8xk33VvB+THefDP6xK2zn4agUAKVNqpS9qDHJhzeqyZKr7wnf9Xp9Net+eiY3eto+FfOUE4/Dh1i5tQ5Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWv/4hn7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWv/4hn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5461F000E9;
	Tue, 21 Jul 2026 19:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663268;
	bh=gSx6TuV7D9XQhFIjO3gW25uXqpg3aTEF8otuzjhAqWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QWv/4hn7ybG4JWeVmUcRe4yMO+IvxMkiAI07BK/MxdneBHNeyFBb3LUzqJyDmz8PF
	 K8Hl9CX2NVWw+TX8H889fb/4xr/zFxEtXsHvndMeFuLpt6GrygovB11lCACjIMF5QL
	 0d+Y94Bik+mjAmpyY1WEj3s3eUlYAA37+ktfM3/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0759/1276] net: usb: net1080: validate packet_len before pad-byte access in rx_fixup
Date: Tue, 21 Jul 2026 17:20:02 +0200
Message-ID: <20260721152503.060992540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 03f384bc0cb8d4a1301d4f5b0baef2d980258383 ]

For an even packet_len, net1080_rx_fixup() reads the pad byte at
skb->data[packet_len] before the skb->len != packet_len check further
down, and packet_len is only bounded against NC_MAX_PACKET. A malicious
NetChip 1080 device can send a short frame advertising a large even
packet_len (e.g. 0x4000), so the pad-byte read lands past the end of the
skb:

  BUG: KASAN: slab-out-of-bounds in net1080_rx_fixup
  Read of size 1 at addr ffff8880106c83c6 by task ksoftirqd/0/14
   ...
   net1080_rx_fixup (drivers/net/usb/net1080.c:384)
   usbnet_bh (drivers/net/usb/usbnet.c:1589)
   process_one_work (kernel/workqueue.c:3322)
   bh_worker (kernel/workqueue.c:3708)
   tasklet_action (kernel/softirq.c:965)
   handle_softirqs (kernel/softirq.c:622)
   ...

Reject the frame when packet_len >= skb->len before reading.

Fixes: 904813cd8a0b ("[PATCH] USB: usbnet (4/9) module for net1080 cables")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/20260630045121.1565324-1-xmei5@asu.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/net1080.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/net1080.c b/drivers/net/usb/net1080.c
index 5d4a1fd2b5244c..19f6e1222d9315 100644
--- a/drivers/net/usb/net1080.c
+++ b/drivers/net/usb/net1080.c
@@ -381,7 +381,7 @@ static int net1080_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	skb_trim(skb, skb->len - sizeof *trailer);
 
 	if ((packet_len & 0x01) == 0) {
-		if (skb->data [packet_len] != PAD_BYTE) {
+		if (packet_len >= skb->len || skb->data[packet_len] != PAD_BYTE) {
 			dev->net->stats.rx_frame_errors++;
 			netdev_dbg(dev->net, "bad pad\n");
 			return 0;
-- 
2.53.0



