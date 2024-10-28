Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A0715B10D;
	Mon, 28 Oct 2024 06:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097788; cv=none; b=u+gmqdCwx72N/0MlaovkP6AwiJ6JQ2SWVzYZ7UgzsMkF0/FxDULPAGTWPF1sBIpJo+e+n7uAl3POxzE6G4bDa0gAp1zlnQpdKzUHtNi4FZWGWp6MT2JOel54WvRt1ThOg5DER91rXNmH7jaP2QJPdVaHgeNyZ1hc1cfbnQ71tDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097788; c=relaxed/simple;
	bh=+YKQEeK2ruzs4zBPts4jzIHPYJWShNzcLU8qGBwXCsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwsiKVhqYV4JhL3XGgflXNlINozZZsIyILXA50m/oVJD+1k4TTwA8pqTxfLTxDlb/QegKe6fSmYYUno0Pn43M7K1sItkBAN8syvbRKIOBIJN0WhLi7rsTATB+kFeEdJ39+OYeanX84/LFuR7wqeifoQRuxRM0unPj+LPsqU/7do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cDe9Lh6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cDe9Lh6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1167EC4CEC3;
	Mon, 28 Oct 2024 06:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097788;
	bh=+YKQEeK2ruzs4zBPts4jzIHPYJWShNzcLU8qGBwXCsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cDe9Lh6uhDeW6/i7vcjx3UI2ANFXl/JsdvBjgBEBHTR5zh9Fx3PeHxtns73GGsouX
	 G1Q0eFHNj+/7u5YNRPvDfNsLykM2FuLzVm/n/L/pmHlmX+FhI9dFbD5xaeotflC3EO
	 Rrnktf7QMff9HMc5+6lnALdvB3UQNPZ4xtPxaLb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 140/208] octeon_ep: Add SKB allocation failures handling in __octep_oq_process_rx()
Date: Mon, 28 Oct 2024 07:25:20 +0100
Message-ID: <20241028062310.082227971@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit eb592008f79be52ccef88cd9a5249b3fc0367278 ]

build_skb() returns NULL in case of a memory allocation failure so handle
it inside __octep_oq_process_rx() to avoid NULL pointer dereference.

__octep_oq_process_rx() is called during NAPI polling by the driver. If
skb allocation fails, keep on pulling packets out of the Rx DMA queue: we
shouldn't break the polling immediately and thus falsely indicate to the
octep_napi_poll() that the Rx pressure is going down. As there is no
associated skb in this case, don't process the packets and don't push them
up the network stack - they are skipped.

Helper function is implemented to unmmap/flush all the fragment buffers
used by the dropped packet. 'alloc_failures' counter is incremented to
mark the skb allocation error in driver statistics.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 37d79d059606 ("octeon_ep: add Tx/Rx processing and interrupt support")
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeon_ep/octep_rx.c | 27 +++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
index cfbfad95b0211..c7f4e3c058b7f 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
@@ -360,6 +360,27 @@ static void octep_oq_next_pkt(struct octep_oq *oq,
 		*read_idx = 0;
 }
 
+/**
+ * octep_oq_drop_rx() - Free the resources associated with a packet.
+ *
+ * @oq: Octeon Rx queue data structure.
+ * @buff_info: Current packet buffer info.
+ * @read_idx: Current packet index in the ring.
+ * @desc_used: Current packet descriptor number.
+ *
+ */
+static void octep_oq_drop_rx(struct octep_oq *oq,
+			     struct octep_rx_buffer *buff_info,
+			     u32 *read_idx, u32 *desc_used)
+{
+	int data_len = buff_info->len - oq->max_single_buffer_size;
+
+	while (data_len > 0) {
+		octep_oq_next_pkt(oq, buff_info, read_idx, desc_used);
+		data_len -= oq->buffer_size;
+	};
+}
+
 /**
  * __octep_oq_process_rx() - Process hardware Rx queue and push to stack.
  *
@@ -415,6 +436,12 @@ static int __octep_oq_process_rx(struct octep_device *oct,
 		octep_oq_next_pkt(oq, buff_info, &read_idx, &desc_used);
 
 		skb = build_skb((void *)resp_hw, PAGE_SIZE);
+		if (!skb) {
+			octep_oq_drop_rx(oq, buff_info,
+					 &read_idx, &desc_used);
+			oq->stats.alloc_failures++;
+			continue;
+		}
 		skb_reserve(skb, data_offset);
 
 		rx_bytes += buff_info->len;
-- 
2.43.0



