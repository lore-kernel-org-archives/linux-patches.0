Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12231547FE;
	Mon,  6 Jan 2025 15:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177594; cv=none; b=jZ07ziNChN4C1J1HGqOnjdxQJ2XqzGQNvalXLrFyIjy2tNuKZjbFfgC2P+xJEN1qgZOtSCZij6TAE+tAvz9wXMblnAfHzWy4i7zOG6zRI7wuqxlSt6LG8Uz6AGHrONSVUulo3sYP1lqCZgwlU8TbQ0dlweUL8AoBmfTvf+LrTEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177594; c=relaxed/simple;
	bh=AzIVrfELyFRq+5E738w1OuPCu7ENnWnSy0WL4KTBblA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRt+a4j1XMsDMADoYL//5oOlPJJFFKNM+eWvdCdV9U3Tlc/ErhAjtn+uJoIlinpv5j5iCn+wsCli/rqP/Q9GKStufnMn1AdHsteoxzPMwpo/sbU+wlOZk4Trmat/WoFuP5ghEPYX1V2qbGizajV+vPG6CGgZXLeZnhkCS3I11AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qqOK8/rN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qqOK8/rN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6442C4CED2;
	Mon,  6 Jan 2025 15:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177593;
	bh=AzIVrfELyFRq+5E738w1OuPCu7ENnWnSy0WL4KTBblA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qqOK8/rNxU/+svAWYu4mMprtM3g91RIY89ZQ5l0PThzSUVw1dtqJVg7hM7QNPDbLv
	 ou3KvX6MozBxqXi/4cvT2yDgMLaUpHcD7d/hqPULB/FWjW8UKcXz/HxAeSMSyphPRq
	 I+mwCugnzXk8FqdAACZgOKtTJOAlwwQZ7Ed4jZ14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Washington <joshwash@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Shailend Chand <shailend@google.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 214/222] gve: guard XDP xmit NDO on existence of xdp queues
Date: Mon,  6 Jan 2025 16:16:58 +0100
Message-ID: <20250106151158.868999254@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1755,6 +1755,9 @@ static void gve_turndown(struct gve_priv
 
 	gve_clear_napi_enabled(priv);
 	gve_clear_report_stats(priv);
+
+	/* Make sure that all traffic is finished processing. */
+	synchronize_net();
 }
 
 static void gve_turnup(struct gve_priv *priv)
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -777,9 +777,12 @@ int gve_xdp_xmit(struct net_device *dev,
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
 


