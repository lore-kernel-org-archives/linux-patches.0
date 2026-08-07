Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D4D313527;
	Fri,  7 Aug 2026 15:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115350; cv=none; b=MaiP05EFyGRgqUlvHAdQ5gyTAS5dq7CF9sOEfmGcvzToSUL3QWWF8/WBU4gd6odOapTZmBmouR+n0iJXJV/jNpV7N5zufJiL6N7SinTIZ7HnvKuv9RdauTGbVRiAjFeKvb3Vc38QDznpSNZQ8gP9i3dWPlJpyrcXoLDOV14b1Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115350; c=relaxed/simple;
	bh=wrAbZvSzKQQUKkhl8yQfxBARDohuP3V01gG1vl4UnWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkGJ+npkK4GVn1QTb8NU/N8rEUfWelbY8cCovYwxzuLlgP/CVwEpAaofLJC2Kq+6Sbh1Cu7B1PDDd8PYc1W6Qt78uiC2/lbrp41sBMg59xoCDgqPamNkQFr76Dp1I/Nr/99MdgvrhsF9yxpe+pti5uPfyHtkqETkWKhP/STuvDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTHMscdz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTHMscdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7030A1F000E9;
	Fri,  7 Aug 2026 15:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115349;
	bh=XzbL6rKhuca/wJPL1moAT5SctOO74hsj3aw+sWGCdPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DTHMscdzFOkVbp/VvuoHg5I0qWBHURLOSihyPHRi0EmVYgcIYnwzb5/TjGXkuAl6p
	 T3FRx+hs3e+HakVB64voVIL9z4M7j1BcG8yQyL6JH+tvx6YpndXU+p1q31Stn2O2VB
	 cMfA8gLOkmYvFdBNSdS8xVIlm3I3cvcD7cMempUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 246/396] vxlan: unclone skb head before modifying eth header in route_shortcircuit()
Date: Fri,  7 Aug 2026 16:36:46 +0200
Message-ID: <20260807143429.559146523@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
@@ -2167,6 +2167,10 @@ static bool route_shortcircuit(struct ne
 
 		diff = !ether_addr_equal(eth_hdr(skb)->h_dest, n->ha);
 		if (diff) {
+			if (skb_cow_head(skb, 0)) {
+				neigh_release(n);
+				return false;
+			}
 			memcpy(eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
 				dev->addr_len);
 			memcpy(eth_hdr(skb)->h_dest, n->ha, dev->addr_len);


