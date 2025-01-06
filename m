Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A0F14D28C;
	Mon,  6 Jan 2025 15:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178061; cv=none; b=Xc8k1Q+//V3NWPYWYYU0nRdysA7nl62DJEd4wrDNpeJewIGUEVkHxcwrY6MD0reA067owooTD4C2SilGsSi49gPF2SgcnxMl0uc7DiLUR3LOW5bNo77SXsRZX3yJzgfgRQM7eBUv4ggaUqKkRHiE6zJviij30FUG179Tsct81XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178061; c=relaxed/simple;
	bh=WXq8ZSSv45DBk4S/mVfJMPJ5pn94N2rkEzADTcBhUfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5kenBag06TxbPCa9pVceyPRLeruQpmHzdcygAMl0YxylCrJWiCC22RIi3Cj2n+h64G9uSq0wCvb2XgaKhsSQbM1BQ/jGjK9iHQTX8u3ipekabeveQnMoIx15sH+7Zn9G+CF+RqPOE2COUxVjvct4K61zr6tuzNaUd2dIqvSCUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qF93mY/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qF93mY/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EA1C4CED2;
	Mon,  6 Jan 2025 15:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178060;
	bh=WXq8ZSSv45DBk4S/mVfJMPJ5pn94N2rkEzADTcBhUfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qF93mY/VkjIga1jFGinaAF5TovGN5LFFsRMWcNGnlmit/xmz3hOvhyFaO57miepMO
	 8w5GzKxGcDtNSeB8V7/n12A41AULQsJYEWdajDhdA+gFBKqbosIeqLlXQmbXf2CT50
	 YEcv6lSm0F8rGkCIF2tstv2KxF1NykVrTVh/YgAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Washington <joshwash@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Shailend Chand <shailend@google.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.12 147/156] gve: guard XDP xmit NDO on existence of xdp queues
Date: Mon,  6 Jan 2025 16:17:13 +0100
Message-ID: <20250106151147.264656389@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Washington <joshwash@google.com>

commit ff7c2dea9dd1a436fc79d6273adffdcc4a7ffea3 upstream.

In GVE, dedicated XDP queues only exist when an XDP program is installed
and the interface is up. As such, the NDO XDP XMIT callback should
return early if either of these conditions are false.

In the case of no loaded XDP program, priv->num_xdp_queues=0 which can
cause a divide-by-zero error, and in the case of interface down,
num_xdp_queues remains untouched to persist XDP queue count for the next
interface up, but the TX pointer itself would be NULL.

The XDP xmit callback also needs to synchronize with a device
transitioning from open to close. This synchronization will happen via
the GVE_PRIV_FLAGS_NAPI_ENABLED bit along with a synchronize_net() call,
which waits for any RCU critical sections at call-time to complete.

Fixes: 39a7f4aa3e4a ("gve: Add XDP REDIRECT support for GQI-QPL format")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Washington <joshwash@google.com>
Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
Reviewed-by: Praveen Kaligineedi <pkaligineedi@google.com>
Reviewed-by: Shailend Chand <shailend@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_main.c |    3 +++
 drivers/net/ethernet/google/gve/gve_tx.c   |    5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1904,6 +1904,9 @@ static void gve_turndown(struct gve_priv
 
 	gve_clear_napi_enabled(priv);
 	gve_clear_report_stats(priv);
+
+	/* Make sure that all traffic is finished processing. */
+	synchronize_net();
 }
 
 static void gve_turnup(struct gve_priv *priv)
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -837,9 +837,12 @@ int gve_xdp_xmit(struct net_device *dev,
 	struct gve_tx_ring *tx;
 	int i, err = 0, qid;
 
-	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
+	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK) || !priv->xdp_prog)
 		return -EINVAL;
 
+	if (!gve_get_napi_enabled(priv))
+		return -ENETDOWN;
+
 	qid = gve_xdp_tx_queue_id(priv,
 				  smp_processor_id() % priv->num_xdp_queues);
 


