Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60021D435F;
	Mon, 17 Aug 2026 14:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975263; cv=none; b=ctGKlPYhozlFVGz3/iGM2W9ucaJg9TNzdG4135Lkgui4+cWGxuUdVeg3tQ793yGt1wfydxhMOcf0opn/mH3tRHeksA9irdcG9/dN8JbYjkRqFoDshsUTuN6D7eppZkaVaLlldtxmR1dHrl+blNvDCqwuvsGuYjAX7A4v7qmGE0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975263; c=relaxed/simple;
	bh=NaMUa+bpu5NoV2bE5Q529FImP5I957rgAkmdElmkoKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SuRc2Z1Gto2xVH34hl00reeIXYvzV9Qlk0qkijVidU8vDpkDjP+AOVM9u24/aFoDp2ffT65eNLo6lTHYPuN9v5Ubi6RP5HQO6MA/F0I98emhkLhQ2AgCyh7Hxstw3aVhSSOf0ngHtqzbN+cc8/jvNWRxcWcQ2UlvwIHP0mw8NVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPIWwrlc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPIWwrlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9411F000E9;
	Mon, 17 Aug 2026 14:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975261;
	bh=bK638LTNF7rpQfKetx3mvn6T8446P4ryyIPlZ342FG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zPIWwrlcIUuUdC7xJzLQoii2eGGnnEqn2ZSVWTOMj+cnFYP1RdDqYIltjKVnZ9toh
	 miaKjjapfu5o8z1d/LQZPigDcBH4SxO2PC3WDVgiF99BbOJ+7jU7XZ4ttgsZGtVrcB
	 /jDNn5wL/iucXdA2abpwKIme7hy2C1glORsL1+Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohsin Bashir <mohsin.bashr@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Sun Jian <sun.jian.kdev@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 218/250] veth: fix skb length accounting after XDP frag adjustment
Date: Mon, 17 Aug 2026 15:32:59 +0200
Message-ID: <20260817132545.433523279@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Sun Jian <sun.jian.kdev@gmail.com>

commit cb6379feaaff11c4e1e79c26c745ffa23182768a upstream.

veth exposes non-linear skb fragments through an xdp_buff. If an XDP
program adjusts the fragment area, veth_xdp_rcv_skb() copies
xdp_frags_size back to skb->data_len but leaves skb->len containing the
old fragment contribution.

After a fragment shrink, this makes skb_headlen() larger than the actual
linear area. In the reproduced UDP receive path, __skb_datagram_iter()
copied 1024 bytes past the actual linear tail to userspace, starting at
struct skb_shared_info. The copied bytes included the affected skb's
nr_frags, xdp_frags_size, and a kernel pointer from
skb_shinfo(skb)->frags[0]. Real packet data was displaced by the same
amount and truncated at the end.

Subtract the old data_len before replacing it and add the new data_len
afterwards, keeping skb->len and skb->data_len synchronized.

Additionally, bpf_xdp_pull_data() can advance data_end while leaving
frags present. The skb is then still non-linear, so the old
__skb_put(skb, off) triggers SKB_LINEAR_ASSERT().

Use skb_set_tail_pointer() and update skb->len explicitly instead,
following bpf_prog_run_generic_xdp(). Unlike __skb_put(),
skb_set_tail_pointer() does not require a linear skb.

A 60000-byte UDP datagram on a veth pair with MTU 64000 was shortened by
1024 bytes from its fragment area. Before the fix, all 10 runs produced
corrupted payloads. After the fix, all 10 runs matched the expected
payload exactly. A forced-tailroom reproducer also exercises
bpf_xdp_pull_data() with frags still present; the old code triggers
SKB_LINEAR_ASSERT(), while this fix passes 10/10 runs.

Fixes: 718a18a0c8a6 ("veth: Rework veth_xdp_rcv_skb in order to accept non-linear skb")
Cc: stable@vger.kernel.org
Reported-by: Mohsin Bashir <mohsin.bashr@gmail.com>
Link: https://lore.kernel.org/bpf/80687d9c-9c27-494c-b3f2-efd0230b1895@gmail.com/
Suggested-by: Lorenzo Bianconi <lorenzo@kernel.org>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
Link: https://patch.msgid.link/20260804054040.613675-3-sun.jian.kdev@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/veth.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -865,18 +865,24 @@ static struct sk_buff *veth_xdp_rcv_skb(
 
 	skb_reset_mac_header(skb);
 
-	/* check if bpf_xdp_adjust_tail was used */
-	off = xdp->data_end - orig_data_end;
-	if (off != 0)
-		__skb_put(skb, off); /* positive on grow, negative on shrink */
-
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
+
+	/* Synchronize the skb tail with XDP's updated linear area. */
+	off = xdp->data_end - orig_data_end;
+	if (off != 0) {
+		skb_set_tail_pointer(skb, xdp->data_end - xdp->data);
+		skb->len += off; /* positive on grow, negative on shrink */
+	}
 
 	skb->protocol = eth_type_trans(skb, rq->dev);
 


