Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED96E3B3C10;
	Sat, 12 Sep 2026 18:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237511; cv=none; b=JBjilrICBZIvq4b0/Jx+kqozMuWgsh+z4jvxzJDnLmRxV48842QvKBlzCTV3jhr08arpwyfnypgd0aEWGkU2GgRKSpc/bgBSgK1R8WviEbpKT1keqdCTS74a0ePpIuLDTlvWmmYYUQwRORjVt+PbEajAIv1wcZV/CX8TTphHeCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237511; c=relaxed/simple;
	bh=mNmJTPsKsqKXppPSaLHXfB0o4l1jANes0lfGOXDuhis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SMBq6i2cC9ui3xkoOmCNsM1w6mC5cgtjPrJsXlhQoIqdyCNTu0JnP3TAQSfnnzvxu/dKd73pSGbjX8i5hShUvT7UaVJJQt7aEsgUgMRvnn89PXGWfvbOY6KK8chrUco1eU5mA73dx2md0b8sM5zkTRqa7gApjs1a+4tVjn3GOU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQbbwFAF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQbbwFAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FC71F000FF;
	Sat, 12 Sep 2026 18:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237509;
	bh=GODos5Ue6VCRUIcDF10cD6CGdv7gmO++lpyyESEkVws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dQbbwFAFHaVq1++ecT00dgM+ZKGW8Zbqt3UJfNI8ZL5/o5N1GjsLCegeuVufsm/YJ
	 haRvVGOuzgpy/efH1MTfGaC78Ia3LrPvur1oxwj05PzlcKPB1NkMdYSEQC/2d39YrY
	 hA3krfjaMZHKR/SIWDF1kpaNAosv5jhQwtACdDqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.15 274/935] batman-adv: fix stale receive device on merged fragments
Date: Sat, 12 Sep 2026 08:55:04 +0200
Message-ID: <20260912065533.109450689@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

commit ad46c907d7d9975a285c1e89a4adde652eaa93f5 upstream.

Fragment reassembly reuses the skb from the highest-numbered buffered
fragment as the merged packet. When that fragment was received on a hard
interface which is deleted before the chain completes, the merged skb can
re-enter the receive path with a stale skb->dev and skb_iif.

batadv_batman_skb_recv() passes such merged packets through the normal
receive handlers again. DAT and bridge loop avoidance both derive the ARP
header length from skb->dev, so they can dereference the freed net_device
before the packet reaches the local mesh interface.

Refresh the receive device metadata from the current receive device before
running the packet handlers. This keeps internally reinjected merged
fragments consistent with the normal receive path after hard interface
teardown.

Fixes: 610bfc6bc99b ("batman-adv: Receive fragmented packets and merge")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/main.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -457,6 +457,10 @@ int batadv_batman_skb_recv(struct sk_buf
 	if (!skb)
 		goto err_put;
 
+	/* Merged fragments re-enter here with reused skb metadata. */
+	skb->dev = dev;
+	skb->skb_iif = dev->ifindex;
+
 	/* packet should hold at least type and version */
 	if (unlikely(!pskb_may_pull(skb, 2)))
 		goto err_free;


