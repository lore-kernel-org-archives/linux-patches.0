Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54E87E110;
	Mon,  8 Apr 2024 13:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582839; cv=none; b=tnGyiE3dz29pLUaTy65iKlLTiJ8AVvZk5f4J2zd6UZ3qN9yHOv+XWpKkrHt4OuIv3YURNN0oH4UKfeVbe3iervA6OYdZgNfeP4/vcmrjmvY5kI7GmKNTQ62yfNNCtEwQznlonxDNcAgTodyd7VTZHETK+JwGRafrdzOteCFq85M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582839; c=relaxed/simple;
	bh=STWTIzK5uMrjE9gO3GUywL3P1+QP5V+OW0ePb5lxLKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jK9IZrokXMIxcDHO6YXDzV47BJ+r8S1LwFpVgpRudhDcMf63eACXopgO5vU3wituG+Ur5ymHxWgLLpJOfO4DlWAUGlaOW/wsD3W56GP0ut8AljDQCk+fxAF6PxHyclDS66GEEnogdZGZzuSXK8h2NLP4BVg3IjkUg627tZCkUQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yi+dmntC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yi+dmntC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5073BC433F1;
	Mon,  8 Apr 2024 13:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582839;
	bh=STWTIzK5uMrjE9gO3GUywL3P1+QP5V+OW0ePb5lxLKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yi+dmntChIbu6k1GccLPUTEMW1SGwfUw6Xgu433EveLivCa9XKLt7jyyAXRVykWFw
	 HBt3bfuoD2uNt39ajd5prUCAhaqUKG9F0CyfITIq/JO5oFXhdqFPtvfTsZZQ7Lgq2C
	 nprHFqTfQxOPnPuVaTcQcMVjYmr9MLU7kmHEofpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balazs Nemeth <bnemeth@redhat.com>,
	Joshua Hay <joshua.a.hay@intel.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Salvatore Daniele <sdaniele@redhat.com>,
	Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
	Krishneil Singh <krishneil.k.singh@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.8 109/273] idpf: fix kernel panic on unknown packet types
Date: Mon,  8 Apr 2024 14:56:24 +0200
Message-ID: <20240408125312.688443857@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Hay <joshua.a.hay@intel.com>

commit dd19e827d63ac60debf117676d1126bff884bdb8 upstream.

In the very rare case where a packet type is unknown to the driver,
idpf_rx_process_skb_fields would return early without calling
eth_type_trans to set the skb protocol / the network layer handler.
This is especially problematic if tcpdump is running when such a
packet is received, i.e. it would cause a kernel panic.

Instead, call eth_type_trans for every single packet, even when
the packet type is unknown.

Fixes: 3a8845af66ed ("idpf: add RX splitq napi poll support")
Reported-by: Balazs Nemeth <bnemeth@redhat.com>
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Salvatore Daniele <sdaniele@redhat.com>
Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Tested-by: Krishneil Singh <krishneil.k.singh@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/idpf/idpf_txrx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -2940,6 +2940,8 @@ static int idpf_rx_process_skb_fields(st
 	rx_ptype = le16_get_bits(rx_desc->ptype_err_fflags0,
 				 VIRTCHNL2_RX_FLEX_DESC_ADV_PTYPE_M);
 
+	skb->protocol = eth_type_trans(skb, rxq->vport->netdev);
+
 	decoded = rxq->vport->rx_ptype_lkup[rx_ptype];
 	/* If we don't know the ptype we can't do anything else with it. Just
 	 * pass it up the stack as-is.
@@ -2950,8 +2952,6 @@ static int idpf_rx_process_skb_fields(st
 	/* process RSS/hash */
 	idpf_rx_hash(rxq, skb, rx_desc, &decoded);
 
-	skb->protocol = eth_type_trans(skb, rxq->vport->netdev);
-
 	if (le16_get_bits(rx_desc->hdrlen_flags,
 			  VIRTCHNL2_RX_FLEX_DESC_ADV_RSC_M))
 		return idpf_rx_rsc(rxq, skb, rx_desc, &decoded);


