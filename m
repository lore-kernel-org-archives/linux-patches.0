Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC5D57981E;
	Wed,  9 Sep 2026 14:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963616; cv=none; b=s9Sh6t0J/kJ8EBv7/zqcTJ8ed//Rx9wPl3PNke64fd9ibnXPwVSqEOwmWtfnv/zbf88cYJ5TLIAjf7/o+/N7GJOJurlFoWbF/lfM84x3w0+0oAtZmozMgqQRhmIDHz8oectExyvLj3KJtnZaxtHDwSXap1yg4F/2jmzkJtu9nK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963616; c=relaxed/simple;
	bh=K8a4EWeoqZIoA/oOLOPcTzZ4CdKRzmrntO2QC9rs7Mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMaEhKYgB963skj31ujBpY402B/ABF6WwAWDL5MNUXpTeEJXBioJjYo75wH+LfE7FnkzCprLI6w9EbTSXs85Op+V+PF9bpJslCfY+oswBiCXV+mVHEiEbVtPJmaSl2ppuYXu2a88oeROShBiCAnmlKQiAl3aRv3P8PCHaYTzHMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsQXdBB7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsQXdBB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97A91F00A3A;
	Wed,  9 Sep 2026 14:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963615;
	bh=cQhYfDONgqYekuXCPRjZIVQf3FjNwQrqmYEcDBLxcSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dsQXdBB7ebkoxowVTqKj0pRigd0aYMkpfWI9IcLjpA+QSmNZTbj80So72v1g2Qvr6
	 uHf3JRtADF49hFIJPtAzRCryR+i2RcgGOoxlWgxj3luSTBlob4Lrfvbg93eBNRnCaw
	 2bEIMOsblbWyCVwiy/m/vLZohv/A5s8xRrjQ1zAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 140/583] batman-adv: fix stale receive device on merged fragments
Date: Wed,  9 Sep 2026 15:37:05 +0200
Message-ID: <20260909134243.001777570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -436,6 +436,10 @@ int batadv_batman_skb_recv(struct sk_buf
 	if (!skb)
 		goto err_put;
 
+	/* Merged fragments re-enter here with reused skb metadata. */
+	skb->dev = dev;
+	skb->skb_iif = dev->ifindex;
+
 	/* packet should hold at least type and version */
 	if (unlikely(!pskb_may_pull(skb, 2)))
 		goto err_free;


