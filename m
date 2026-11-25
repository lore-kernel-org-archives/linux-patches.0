Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621998;
	b=hCnwqN+6jyWM1nD9V327uBBdMd6M/8RIl/7WmbNYxgYLVe4r41litZWdGE8HQv53VxUC
	 sa//L1egM5OnfsP8RzKqaKMXu+LX0MUqiWwc/ghUkTAtaulOZtCB9IjPD4Dg4IjZ2oOS9
	 96iD55qWyqr8oMWwdS0t5BsP3+HCydDkBZrqFucQgycbaOpium2dThIBDTzZtMtMsDHqE
	 QG8GYLcYP+cgSrSmkVsXe7aGAhWIsoH5zPLkBb9xYMMilagak7Vq+WY2FgikrlrEopULG
	 MQXfPJXgnTHthhwyTNKS/fjSPKXwcfsAnOFIomvPQEMgfFksfbC3CUEq5r07UX/+MWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=c5NXnLWUStMrbAby/gGa3DtN2BUxG4pGvwa4n/kewfs=;
	b=B7N0j6p5XiUFIq0fPpvci7SEkptKgzHqXdG8MkTRjwzrPzAgejWwKgNL0Xqw3Kk9VOEv
	 xzi6LbJxnQ2BgyIs9xm/flThJPDvcgGV08Le6iET99lapwyGIm3vJY2o0LQ/DocRDWANN
	 V03stC0mexeWwvBxXcIOO/JSYhoJYR+9Tvd7Faz26PqCDm0yliIlNVe0jKj11lt5TIKHD
	 duuNewvMdtIKaDRxd/Qn/iAs3l/q3j209hywAVYYSqw0GyfVC0H8rjXh0H783L5YO0J3d
	 45aAFAlGCW5rXrQqtdJvEyo9JCCPA150OgwQTXWCf/Mw4vg8kXVks+OQSBqVT7+xmlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XCxdedrh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA25606A31E;
	Wed, 25 Nov 2026 15:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XCxdedrh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA811F000CF;
	Wed, 25 Nov 2026 15:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621997;
	bh=c5NXnLWUStMrbAby/gGa3DtN2BUxG4pGvwa4n/kewfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XCxdedrhIi4xQfDA0snG925fnua8aqkZgSfSgBjVFYnFmI4fRyixASjz+N/zSGiMQ
	 HmiL9UaWpcbOD1Cn/AVHPaKgbVWXtVQBZ+CPqePD6FGTt76EU/WESLggAQgAeucHdc
	 HiYm191FD6YZRrzwm1DKxloDDj2ksDKTO/fKiZag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 396/990] ice: xsk: do not free in-flight frags on XDP_TX completion
Date: Wed, 25 Nov 2026 15:29:23 +0100
Message-ID: <20261125143831.373500822@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 5a9b5e315e101dfa02af5d8d3b27d893ba3e5566 ]

ice_xmit_xdp_tx_zc() takes the frags of a multi-buffer frame off
pool->xskb_list but leaves XDP_FLAGS_HAS_FRAGS set on the head. When
the head completes, xsk_buff_free() frees whatever is on the list at
that point, which are the frags of a frame still being received.

If ice_xmit_xdp_tx_zc() completes such a head while cleaning the ring
before sending another frame, xsk_buff_get_frag() returns NULL and
xsk_buff_xdp_get_dma() dereferences it.

Clear the flag on the head once its frags are on the ring. As
xdp_get_buff_len() then covers only the head, count Rx bytes before
running the XDP program, like libeth does.

Fixes: eeb2b5381038 ("ice: xsk: Tx multi-buffer support")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Link: https://patch.msgid.link/20261102124950.958345-5-maciej.fijalkowski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 6dfc6fd34c886..2009744a9f6a4 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -494,6 +494,11 @@ static int ice_xmit_xdp_tx_zc(struct xdp_buff *xdp,
 	tx_desc->cmd_type_offset_bsz |=
 		cpu_to_le64(ICE_TX_DESC_CMD_EOP << ICE_TXD_QW1_CMD_S);
 
+	/* Each frag is now freed via its own Tx buffer. Completing the head
+	 * must not release what is on the pool's frag list at that time.
+	 */
+	xdp_buff_clear_frags_flag(head);
+
 	return ICE_XDP_TX;
 
 busy:
@@ -593,6 +598,7 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring,
 		struct sk_buff *skb;
 		u16 stat_err_bits;
 		u16 vlan_tci;
+		u32 xdp_len;
 
 		rx_desc = ICE_RX_DESC(rx_ring, ntc);
 
@@ -635,6 +641,7 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring,
 
 		((struct libeth_xdp_buff *)first)->desc = rx_desc;
 
+		xdp_len = xdp_get_buff_len(first);
 		xdp_res = ice_run_xdp_zc(rx_ring, first, xdp_prog, xdp_ring,
 					 xsk_pool);
 		if (likely(xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR))) {
@@ -649,7 +656,7 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring,
 			goto construct_skb;
 		}
 
-		total_rx_bytes += xdp_get_buff_len(first);
+		total_rx_bytes += xdp_len;
 		total_rx_packets++;
 
 		first = NULL;
-- 
2.53.0



