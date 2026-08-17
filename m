Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F863BD65D;
	Mon, 17 Aug 2026 13:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974297; cv=none; b=Q7Xb7lMq1foig7xCRg7HOtqDC8lUOwtveVTZFMUgVdP1RYWoJgFzGap4HfoVeWp3mvhtJJSXppMZCw69CqLvtKovyKdQjJerr18b03jyT9CS5dAjdG7x5M0ohWN+9ChgEM010+Aa4oWOa1dcnNXL9sUi3dELRXk+oFw0AJzsiRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974297; c=relaxed/simple;
	bh=WRsU3lcZaH1OhVPslU/xxz6iNHcDPajaZbl3i6v4nq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7XgcFrxSr7RL7FvJzRmMafi8WYdUktEpMW4OD/z9nzSH0eak32LkojHRfqsHjgf9+FNfcxabbJsjR3V4YQy0bPl2lsoYQvHkDIEu8e3aW8Xy4OP98S3t1aaLh1Th4LqgypdZCB2RrBIqxJu6z43lsuhkgYJFo2v7SuwPSO6e5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iSN+dwW3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iSN+dwW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CEA31F000E9;
	Mon, 17 Aug 2026 13:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974289;
	bh=OBB7bhg6rEQmUvHI8C2dtSE3SVy8CdTyXeXhUAfmXes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iSN+dwW3X5KS6q4PLkViTsskKsssmO9B/WLA3JoOdlosMUHvH81B3WhWFtIYCY2Vq
	 STc0uN7+JIyQBGdssg8+24RyIq+DeU9YhYvbG29XHd5rCiFBUC/X0q8vHw9aOOV+kJ
	 mlqcCpc1+yXI/cYZhNdjp1jc8JVT12drGxW/kvD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohsin Bashir <hmohsin@meta.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Sun Jian <sun.jian.kdev@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 153/271] net: fix skb length accounting after generic XDP frag adjustment
Date: Mon, 17 Aug 2026 15:31:18 +0200
Message-ID: <20260817132543.202154577@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

From: Sun Jian <sun.jian.kdev@gmail.com>

commit 33f2b2eb33d666ecac68031e0f31424fb70528db upstream.

Generic XDP exposes non-linear skb fragments through an xdp_buff. If an
XDP program adjusts the fragment area, bpf_prog_run_generic_xdp() copies
xdp_frags_size back to skb->data_len but leaves skb->len containing the
old fragment contribution.

After a fragment shrink, this makes skb_headlen() larger than the actual
linear area. In the reproduced UDP receive path, __skb_datagram_iter()
copied 1024 bytes past the actual linear tail to userspace, starting at
struct skb_shared_info. The copied bytes included the affected skb's
nr_frags, xdp_frags_size and a kernel pointer from
skb_shinfo(skb)->frags[0]. Real packet data was displaced by the same
amount and truncated at the end.

Subtract the old data_len before replacing it and add the new data_len
afterwards, keeping skb->len and skb->data_len synchronized.

A 60000-byte UDP datagram on a veth pair with MTU 64000 was shortened by
1024 bytes from its fragment area. Before the fix, all 10 runs produced
corrupted payloads. After the fix, all 10 runs matched the expected
payload exactly.

Fixes: e6d5dbdd20aa ("xdp: add multi-buff support for xdp running in generic mode")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/al9T9Eto%2FhRIzP5W@boxer/
Reviewed-by: Mohsin Bashir <hmohsin@meta.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
Link: https://patch.msgid.link/20260804054040.613675-2-sun.jian.kdev@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5515,12 +5515,16 @@ u32 bpf_prog_run_generic_xdp(struct sk_b
 	}
 
 	/* XDP frag metadata (e.g. nr_frags) are updated in eBPF helpers
-	 * (e.g. bpf_xdp_adjust_tail), we need to update data_len here.
+	 * (e.g. bpf_xdp_adjust_tail). Remove the old fragment contribution
+	 * from skb->len before updating data_len, then add the new one back.
 	 */
-	if (xdp_buff_has_frags(xdp))
+	skb->len -= skb->data_len;
+	if (xdp_buff_has_frags(xdp)) {
 		skb->data_len = skb_shinfo(skb)->xdp_frags_size;
-	else
+		skb->len += skb->data_len;
+	} else {
 		skb->data_len = 0;
+	}
 
 	/* check if XDP changed eth hdr such SKB needs update */
 	eth = (struct ethhdr *)xdp->data;


