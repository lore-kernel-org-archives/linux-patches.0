Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3BD471436;
	Fri,  7 Aug 2026 15:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117482; cv=none; b=Xz3Vk8SXJyAe4/yby0/amXnnBZx9YPDHgyYMIRITtDT08X9XT+9ffkywymhnL0Ib9Z5LKlKjbGB1Wq9PNQNlMdwiEYB6/Wy0bwudYk8f+m13jvk8acSYDWv0Q83Sb/hEWbQgmPycuPvQUo50HnpZEFyBUHY7ElIccehowPsoAZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117482; c=relaxed/simple;
	bh=kSMkEU6wqevhvjxFWgieFYJrLDMdNhVpX8sVn0gTP6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOphkrKecmugPCf+fzdzf1giI9JP5ul2jVztxVIamrIayadm7b5V0bQ35ZsXM+/FipZ7cH68lkc7oppjRmcTUYW5S9vzcRP19qDVQivO65InykEp8wPIPnF/qFJNOCRRRqGBAH9L2A8gAhpV+dGUTJ1pkX732h1FIChWELAhCyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVoN9XIW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVoN9XIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684EF1F00A3E;
	Fri,  7 Aug 2026 15:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117481;
	bh=QiMlpbipj+4dCqoUYBIdksBsVfiIjpf8IrDkVBjIepc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TVoN9XIWdq2DmlsXOifXAjo0n90AsCkAiglXNyRXrdOXkTuVIlnAD3wZZqIigg2Vm
	 OnSyLxcpsNy9BSf5Zvipdg7ArHCVjen1k41/x0lL4CMzbUKYjfOsdRs2Zqs22gN00m
	 qV2C27R8X8xxukUayqlXhtxtIfKBb2vcl7go6spI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 307/438] vxlan: unclone skb head before modifying eth header in route_shortcircuit()
Date: Fri,  7 Aug 2026 16:38:23 +0200
Message-ID: <20260807143434.517251113@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 760d36e737f2b3867762f42af36c663f55babcc4 upstream.

When route_shortcircuit() performs L3 short-circuit routing, it modifies
the Ethernet header of the skb in-place:
    memcpy(eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest, dev->addr_len);
    memcpy(eth_hdr(skb)->h_dest, n->ha, dev->addr_len);

If the incoming skb is cloned (for example by packet sockets, tcpdump, or
dev_queue_xmit), modifying the Ethernet header without uncloning can corrupt
the packet header for other readers holding a reference to the cloned skb.

Ensure the skb header is writable and unshared by calling skb_cow_head(skb, 0)
prior to updating the Ethernet header. If skb_cow_head() fails, abort short-circuiting
and return false to allow standard packet processing fallback.

Fixes: e4f67addf158 ("add DOVE extensions for VXLAN")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260723144249.759100-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan/vxlan_core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2164,6 +2164,10 @@ static bool route_shortcircuit(struct ne
 
 		diff = !ether_addr_equal(eth_hdr(skb)->h_dest, n->ha);
 		if (diff) {
+			if (skb_cow_head(skb, 0)) {
+				neigh_release(n);
+				return false;
+			}
 			memcpy(eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
 				dev->addr_len);
 			memcpy(eth_hdr(skb)->h_dest, n->ha, dev->addr_len);


