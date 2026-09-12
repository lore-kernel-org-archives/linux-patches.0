Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B81D318BB3;
	Sat, 12 Sep 2026 13:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220846; cv=none; b=sByWPkDPSFLOv3ef7MNHnYlz19c15qV3t+oPqkcWNQ3pj8BOvpLh0uLDX7cDvEVuCseJeAC6JRUXk5DABB2uDZ+LrTGmM4xAPPui/kAYHk9h4NH0uT5aJHjIOj/ThECc8X0d0fVBU7culXwYTrM1CPZfamQHJjeKnMIlu9yLXPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220846; c=relaxed/simple;
	bh=NGLI2jJzty8yqnozyxaqxt+TQBKrYL0pHXj1D1+jOhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktRtlJGYlHVuXX47hbpNrTHh0kG1RhMGV2UvKtmnaFJAENHubbSxcsBlDY8oR2qifaLE4fPJrVh+q26OoQ8R3A5PQivHUzj+jD6LlRczeECPkMlAcoQrJNokt9vK5r6q7f64PId+XPOUqVmE/xiXqP/UsXryAkE9ldY9Nqy4Th0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzhs76Ev; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzhs76Ev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C4E1F000FF;
	Sat, 12 Sep 2026 13:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220845;
	bh=YfjrvcdYIs4bxNQG7Rn88vk2tcVfBmtPEmwxdwpHAks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uzhs76Evi5wOTPFgMn1K883NK9yMQ4fFbifHafhEKwL+u7W8tLusCPTYxqPIiN2hM
	 MSvwOxe1d70+rgmzvl9h/7NpxZFB4RSps+MWdsikIFKMmlTXJlZ8IxcD1WDN+OXx/X
	 4ZS48LjFy3fSc9adKE8j1ImNPGzyXqBuYmXjfQBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Ye <fy15309206903@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0262/1424] net: thunderbolt: Mark the connection down when bringing it up fails
Date: Sat, 12 Sep 2026 08:44:54 +0200
Message-ID: <20260912065613.145916827@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Ye <fy15309206903@gmail.com>

commit 3c8b26ebf525ba5960510f48c6e9936a79ebe76f upstream.

Every failure path in tbnet_connected_work() undoes its own work and
returns without clearing login_sent, so the connection still looks
established. The next tbnet_tear_down() therefore takes its main branch
and repeats a teardown that already happened: it stops rings that are
already stopped, which is a dev_WARN() and fatal under panic_on_warn,
and it releases net->remote_transmit_path even on the HopID mismatch
path, where this connection never owned that id, silently freeing one
that someone else is still using.

Clear login_sent on those paths. That is enough for tbnet_tear_down() to
leave the unwound state alone, and login_received has to stay set: it
records that the peer has logged in and carries the transmit path it gave
us, which nothing on this side can make the peer send again. Two things
change beyond keeping the teardown out of the way: the logout request in
that block is no longer sent, and the peer's next login request now
re-queues our login work rather than connected_work, giving the
connection a fresh login instead of a retry on stale state.

Fixes: e69b6c02b4c3 ("net: Add support for networking over Thunderbolt cable")
Cc: <stable@vger.kernel.org> # 5.13+
Signed-off-by: Fan Ye <fy15309206903@gmail.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260811-b4-tbnet-hopid-v3-2-9e75d1b51331@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/thunderbolt/main.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/net/thunderbolt/main.c
+++ b/drivers/net/thunderbolt/main.c
@@ -629,6 +629,14 @@ static int tbnet_alloc_tx_buffers(struct
 	return 0;
 }
 
+static void tbnet_connect_failed(struct tbnet *net)
+{
+	/* Leave login_received set: only the peer can make it true again. */
+	mutex_lock(&net->connection_lock);
+	net->login_sent = false;
+	mutex_unlock(&net->connection_lock);
+}
+
 static void tbnet_connected_work(struct work_struct *work)
 {
 	struct tbnet *net = container_of(work, typeof(*net), connected_work);
@@ -652,6 +660,7 @@ static void tbnet_connected_work(struct
 		netdev_err(net->dev, "failed to allocate Rx HopID\n");
 		if (ret >= 0)
 			tb_xdomain_release_in_hopid(net->xd, ret);
+		tbnet_connect_failed(net);
 		return;
 	}
 
@@ -696,6 +705,7 @@ err_stop_rings:
 	tb_ring_stop(net->rx_ring.ring);
 	tb_ring_stop(net->tx_ring.ring);
 	tb_xdomain_release_in_hopid(net->xd, net->remote_transmit_path);
+	tbnet_connect_failed(net);
 }
 
 static void tbnet_login_work(struct work_struct *work)


