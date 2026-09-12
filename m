Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FBA3382CB;
	Sat, 12 Sep 2026 19:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242105; cv=none; b=lIDg8fm70kktytsqeKOfW6tp4FzPVjXE22NQeVZz5Cp7cdFCOB38cJpbPE0Q3ZER4YWE/3aAAEEWDWIIi5I7hMSDkPBJo98TxT96uoWi8hpXD3HE1LG3iAAwGEHXvlryMV5CEgvrucPn6O7D6KI03NIadVu27frvT6Z8iDC9GuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242105; c=relaxed/simple;
	bh=x9U3YPPIcSu/ObA1eaoM7cukx3P/UgLKEKhUyLYmOec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+PIGbPGiDNAD9ulQFWM0TsMefYJRaVUtl2+nFtEkhZ1CmnZYkhmFLqdIfWeGSmmiMmFK8dSfSxD0lI7RGOzMV1le/LiJA6IhynVWmvVWArDM96yZUu25Xa3/K43SHUs7HNWU8wqE6I0acyYm09vMoxTzGlDI5swmu2DX6AEGdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nGTxt/fp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nGTxt/fp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B121F000FF;
	Sat, 12 Sep 2026 19:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242104;
	bh=9t0GpDnTB52j5Ssc+0qW54PqQkoF0GzPFDRbPykWHzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nGTxt/fpoIJ7IJSmHbnXG9O4aUcxR6vuD3g2M6mq6j5i3bBHHQ1WoTJLChOnWd00r
	 7no9U9URDPYJeh09T+mCzmW7K7pOAo6nkjlyQgBGyfPQyrAIb5jsplgZomDLX8ka5u
	 BTqxACsgJLl9xVfCgf4CSRHZE6dkAijdcoNMvC3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.10 244/798] batman-adv: fix stale receive device on merged fragments
Date: Sat, 12 Sep 2026 08:57:52 +0200
Message-ID: <20260912065522.749276342@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -511,6 +511,10 @@ int batadv_batman_skb_recv(struct sk_buf
 	if (!skb)
 		goto err_put;
 
+	/* Merged fragments re-enter here with reused skb metadata. */
+	skb->dev = dev;
+	skb->skb_iif = dev->ifindex;
+
 	/* packet should hold at least type and version */
 	if (unlikely(!pskb_may_pull(skb, 2)))
 		goto err_free;


