Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F18331200;
	Fri,  7 Aug 2026 14:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114628; cv=none; b=mBgo0hKvNLkorv6uxquHvMdAKZ6oeVvT/co5UV8/t/AF8IzgCaAuYgxWIzqDC5Gxod4warQl21wDjrXERN7SeClm0llsq3mi72P5UAaSYqNUaD2qrsUUW7NA59L7Wn3fATw265vhsOqaIHf/N1eIJbVZTAyWHPXbUQL1tTl6QXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114628; c=relaxed/simple;
	bh=FVbx4VSmuMwtATLkqYtJrq+abEVxsv+vrOdsreefMAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijes/RSRKtpqi5YOvjUwXmz23oxXQCNxmBzJsGAeZnhi4wkVMk+h+DBn9/XY5rwORx14ttKgyMPjmER2PXJay396ba/eqax+0Sqlw5t1+4o6LzETfYqLZhKmDNsR9s9ooLzlZpJtZjpWGs4rFEhY7hjq/EtZo4bhu975FeX1Lho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABra4gM4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABra4gM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06861F00A3D;
	Fri,  7 Aug 2026 14:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114619;
	bh=PFkd3NFehkxlubiAZU0Pkwt1y10VMDXUK9TM5GyZh3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ABra4gM46Q2z5M0Vwey1+E8hlAe8tUEJe56jLUl51BEYnR+LRPkURZKbk7smqvJ+p
	 L/imNps5CEtDHDtYRgQDXbhuzrjHlbjjmwRkwKOmUivuxZQPQYoY2f6xk1URWYR9hN
	 o/MmVQW3+YwSnbXucIvQV44eH3wqD/8Ja214iZEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 328/337] rxrpc: Generate rtt_min
Date: Fri,  7 Aug 2026 16:38:51 +0200
Message-ID: <20260807143425.652017439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit c637bd066841de6d0a204898a62f1d9bb8fa1b7f ]

Generate rtt_min as this is required by RACK-TLP.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20241204074710.990092-27-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e4d2878369d5 ("rxrpc: Fix irq-disabled in local_bh_enable()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/win_minmax.c        |    1 +
 net/rxrpc/ar-internal.h |    2 ++
 net/rxrpc/rtt.c         |   20 ++++++++++++++++----
 3 files changed, 19 insertions(+), 4 deletions(-)

--- a/lib/win_minmax.c
+++ b/lib/win_minmax.c
@@ -97,3 +97,4 @@ u32 minmax_running_min(struct minmax *m,
 
 	return minmax_subwin_update(m, win, &val);
 }
+EXPORT_SYMBOL(minmax_running_min);
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -349,6 +349,8 @@ struct rxrpc_peer {
 	spinlock_t		rtt_input_lock;	/* RTT lock for input routine */
 	ktime_t			rtt_last_req;	/* Time of last RTT request */
 	unsigned int		rtt_count;	/* Number of samples we've got */
+	unsigned int		rtt_taken;	/* Number of samples taken (wrapping) */
+	struct minmax		min_rtt;	/* Estimated minimum RTT */
 
 	u32			srtt_us;	/* smoothed round trip time << 3 in usecs */
 	u32			mdev_us;	/* medium deviation			*/
--- a/net/rxrpc/rtt.c
+++ b/net/rxrpc/rtt.c
@@ -127,16 +127,27 @@ static void rxrpc_set_rto(struct rxrpc_p
 	peer->rto_us = rxrpc_bound_rto(rto);
 }
 
-static void rxrpc_ack_update_rtt(struct rxrpc_peer *peer, long rtt_us)
+static void rxrpc_update_rtt_min(struct rxrpc_peer *peer, ktime_t resp_time, long rtt_us)
+{
+	/* Window size 5mins in approx usec (ipv4.sysctl_tcp_min_rtt_wlen) */
+	u32 wlen_us = 5ULL * NSEC_PER_SEC / 1024;
+
+	minmax_running_min(&peer->min_rtt, wlen_us, resp_time / 1024,
+			   (u32)rtt_us ? : jiffies_to_usecs(1));
+}
+
+static void rxrpc_ack_update_rtt(struct rxrpc_peer *peer, ktime_t resp_time, long rtt_us)
 {
 	if (rtt_us < 0)
 		return;
 
-	//rxrpc_update_rtt_min(peer, rtt_us);
+	/* Update RACK min RTT [RFC8985 6.1 Step 1]. */
+	rxrpc_update_rtt_min(peer, resp_time, rtt_us);
+
 	rxrpc_rtt_estimator(peer, rtt_us);
 	rxrpc_set_rto(peer);
 
-	/* RFC6298: only reset backoff on valid RTT measurement. */
+	/* Only reset backoff on valid RTT measurement [RFC6298]. */
 	peer->backoff = 0;
 }
 
@@ -157,9 +168,10 @@ void rxrpc_peer_add_rtt(struct rxrpc_cal
 		return;
 
 	spin_lock(&peer->rtt_input_lock);
-	rxrpc_ack_update_rtt(peer, rtt_us);
+	rxrpc_ack_update_rtt(peer, resp_time, rtt_us);
 	if (peer->rtt_count < 3)
 		peer->rtt_count++;
+	peer->rtt_taken++;
 	spin_unlock(&peer->rtt_input_lock);
 
 	trace_rxrpc_rtt_rx(call, why, rtt_slot, send_serial, resp_serial,


