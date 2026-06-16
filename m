Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABA443CEC7;
	Tue, 16 Jun 2026 15:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622879; cv=none; b=OnEZGcmE2kdVXfyBtLrN3N8V+/gG+SB93x9IF9nds2x3BiAP+voUSjBxxDj0L+uK4yxae6WxNwPZpZS/JpiRTEDDyTOU0wiymEKUzdCjEagLKMBLmpq4uhVugVT+FUhwuThxPAbW/7t/TxRKkL/kaQKbU5MMdVpN/CQBNpPGEgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622879; c=relaxed/simple;
	bh=QjwooAWVjoRofBOdU1ramqjzlW9Jm1nGRqAdk2fBqjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxaLprhme/2pYiUMKp/gM+k5n28V/NsmNNYthJFmMfRsAZ5/T7VqkZZCeMf4rvGXfAPf2/ErvvYnWXxqCljj4oeasa+BrkJptlQoYTS6t0SVquaGw91x9IPj5fr0OpBDI+eulB9AKwjtpBUhu2oCkXu0NQSULriiLNskE1CUZtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3E6h+Zs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3E6h+Zs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA721F00A3A;
	Tue, 16 Jun 2026 15:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622878;
	bh=xXZBNDCq2GCQjBJ09uEzNy+z9SED89iQFTB7wzm9j00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w3E6h+ZsVB1ZcqpOpSfqKKK9I8j1VHBhRWXMblxXKVHZ0lDeQrWTdvyg1YPXUAZRN
	 jCzzN00V3coPwJmMfJFgo3V60bDq2c/gGKxZyUE86uVlgcRuTE0HCyNzw/m7ENl1dv
	 BTpTbQusw0yEtt02k3755BR8hENROcPxd141N5NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 047/378] Bluetooth: bnep: fix incorrect length parsing in bnep_rx_frame() extension handling
Date: Tue, 16 Jun 2026 20:24:38 +0530
Message-ID: <20260616145112.397072449@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dudu Lu <phx0fer@gmail.com>

[ Upstream commit 72b8deccff17a7644e0367e1aaf1a36cfb014324 ]

In bnep_rx_frame(), the BNEP_FILTER_NET_TYPE_SET and
BNEP_FILTER_MULTI_ADDR_SET extension header parsing has two bugs:

1) The 2-byte length field is read with *(u16 *)(skb->data + 1), which
   performs a native-endian read. The BNEP protocol specifies this field
   in big-endian (network byte order), and the same file correctly uses
   get_unaligned_be16() for the identical fields in
   bnep_ctrl_set_netfilter() and bnep_ctrl_set_mcfilter().

2) The length is multiplied by 2, but unlike BNEP_SETUP_CONN_REQ where
   the length byte counts UUID pairs (requiring * 2 for two UUIDs per
   entry), the filter extension length field already represents the total
   data size in bytes. This is confirmed by bnep_ctrl_set_netfilter()
   which reads the same field as a byte count and divides by 4 to get
   the number of filter entries.

   The bogus * 2 means skb_pull advances twice as far as it should,
   either dropping valid data from the next header or causing the pull
   to fail entirely when the doubled length exceeds the remaining skb.

Fix by splitting the pull into two steps: first use skb_pull_data() to
safely pull and validate the 3-byte fixed header (ctrl type + length),
then pull the variable-length data using the properly decoded length.

Fixes: bf8b9a9cb77b ("Bluetooth: bnep: Add support to extended headers of control frames")
Signed-off-by: Dudu Lu <phx0fer@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 6770d3a8acdf ("Bluetooth: bnep: reject short frames before parsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/bnep/core.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/bnep/core.c b/net/bluetooth/bnep/core.c
index b3cef7a4db5412..0de5df690bd0b2 100644
--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -330,11 +330,18 @@ static int bnep_rx_frame(struct bnep_session *s, struct sk_buff *skb)
 				goto badframe;
 			break;
 		case BNEP_FILTER_MULTI_ADDR_SET:
-		case BNEP_FILTER_NET_TYPE_SET:
-			/* Pull: ctrl type (1 b), len (2 b), data (len bytes) */
-			if (!skb_pull(skb, 3 + *(u16 *)(skb->data + 1) * 2))
+		case BNEP_FILTER_NET_TYPE_SET: {
+			u8 *hdr;
+
+			/* Pull ctrl type (1 b) + len (2 b) */
+			hdr = skb_pull_data(skb, 3);
+			if (!hdr)
+				goto badframe;
+			/* Pull data (len bytes); length is big-endian */
+			if (!skb_pull(skb, get_unaligned_be16(&hdr[1])))
 				goto badframe;
 			break;
+		}
 		default:
 			kfree_skb(skb);
 			return 0;
-- 
2.53.0



