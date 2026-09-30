Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6D850254F;
	Wed, 30 Sep 2026 16:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787403; cv=none; b=DAqe/2tU9QHk4Gr5U87ad/kW+AD7utkA9Q6B5B0sUSOXTOmyQsLNsn1X5jIEUTBdjIgwwc5nE2qvWHi/GCl8BkPo0jUhCVmYcd7wXjBOL1VW22CZNQUvObPdh0YxJa+VOoHiIPayy1NHHpoICR6nSNQQHpssl3U3Sxtr6DWgGaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787403; c=relaxed/simple;
	bh=r/IiOX/VYfow3xpi7oz+Dx2NvRmtb5Zmkxk2BlFiq4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6lulVoqnc86JHWg4xNHLC+3AGq251vqfgjbK/MlRG5K01EVtyEQUk7jPExWiqDMUuh+HjzhMQH0mYoJRSWxcf4KJB1aSYXZXG5oJqw1Abva8KzePS/KyVaxcmRidyZxxNOpOUijQYolwEKh79O5umAlYchZhZ2E8Viw/Z+Wi2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=etbF4vEw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="etbF4vEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1FB1F000FF;
	Wed, 30 Sep 2026 16:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787402;
	bh=ctHezGifCfVCSbOd2c7iqbEbsLERbXEYysWdLkhdArg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=etbF4vEwJ80bA8iyjxogFaX1TsC7lgDdlmIy43BXcCZSFVn8VAR0a1zYvf8Gr+mrk
	 P7HF7Gqv7XHTdzQYES0hWglNRF2TOSK1UVeSD7cuf4MTapoNOmZvRRDuDlTwouLapg
	 CZgP6CIFdpWUaL7jJfgqjEPNnImpKnjSCmH+myl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Ankit Garg <nktgrg@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Joshua Washington <joshwash@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 219/457] gve: DQO: fix header length used by gve_can_send_tso() for UDP GSO
Date: Wed, 30 Sep 2026 17:25:24 +0200
Message-ID: <20260930152350.777155377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 83769c23fb1879edc916a526ba424285033baf2d ]

gve_can_send_tso() computes how many buffers each segment of a GSO
packet would span, and for this it needs the length of the headers
that the device replicates in front of every segment.

It unconditionally uses skb_tcp_all_headers(), which reads the doff
field of the TCP header. SKB_GSO_UDP_L4 packets have no TCP header:
tcp_hdrlen() then reads one byte of the UDP payload, and header_len
can be anything in [0, 60] instead of the transport offset plus the
eight bytes of the UDP header that gve_prep_tso() programs into the
TSO context descriptor.

A wrong header length shifts all the segment boundaries computed in
the loop, so the number of buffers per segment can be over or under
estimated. In the first case, GSO is needlessly disabled for this
packet by gve_features_check_dqo() and the stack has to segment it.
In the second case, the driver hands the device a packet whose
segments span more than GVE_TX_MAX_DATA_DESCS buffers.

Use the UDP header length for SKB_GSO_UDP_L4 packets, matching what
gve_prep_tso() does.

Fixes: 014c607f86ab ("gve: add support for UDP GSO for DQO format")
Closes: https://lore.kernel.org/netdev/CANn89i+MS4L60sFQ49=-f-mibeveUfcrpVkD5X+Qy6SOnEpd6w@mail.gmail.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Ankit Garg <nktgrg@google.com>
Cc: Harshitha Ramamurthy <hramamurthy@google.com>
Cc: Joshua Washington <joshwash@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Reviewed-by: Ankit Garg <nktgrg@google.com>
Reviewed-by: Harshitha Ramamurthy <hramamurthy@google.com>
Link: https://patch.msgid.link/20260923145942.731365-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_tx_dqo.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
index 80ab0a449ff54..0f6f7c5dbb2e0 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -918,13 +918,19 @@ static bool gve_can_send_tso(const struct sk_buff *skb)
 {
 	const int max_bufs_per_seg = GVE_TX_MAX_DATA_DESCS - 1;
 	const struct skb_shared_info *shinfo = skb_shinfo(skb);
-	const int header_len = skb_tcp_all_headers(skb);
 	const int gso_size = shinfo->gso_size;
 	int cur_seg_num_bufs;
 	int prev_frag_size;
 	int cur_seg_size;
+	int header_len;
 	int i;
 
+	/* Must match the header length programmed by gve_prep_tso(). */
+	if (skb_is_gso_tcp(skb))
+		header_len = skb_tcp_all_headers(skb);
+	else
+		header_len = skb_transport_offset(skb) + sizeof(struct udphdr);
+
 	cur_seg_size = skb_headlen(skb) - header_len;
 	prev_frag_size = skb_headlen(skb);
 	cur_seg_num_bufs = cur_seg_size > 0;
-- 
2.53.0



