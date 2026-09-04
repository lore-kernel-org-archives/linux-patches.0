Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D262248BE;
	Fri,  4 Sep 2026 06:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502837; cv=none; b=GkxXxgdkBbFppU1lKj9+V0JkCi1yzBFZAg8GWzg7YYNR/4WaNZp9xhjoaEPINRtkcvdFtyBgF61tyleAkUogBWYXym7jHp+E3LEGmCWy0+5c3wj1oOUuQqb6Jg0TS96bC6VBrkG8oDfmwA1D8PcvefbqP5hcRF3y6Bz+GYnGEO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502837; c=relaxed/simple;
	bh=ZqfM9XwCVRTKfkdWZbKFSFjzwEtQdPuj8Zh3SbJS92g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eca+Ta0V4R8qQqCd08QkRIygr/kaL+dSy+oKqddTwzhQ3bEtJO5Q8tR3KGgokZ4u3A2Pvm5mkSvo487A3yKP6nCWkbp5Uf35Wy06qqijrbPGFg4/lhtK40dg3VgwWz9gQO/tlv+wzt1iCkdmqAhBNzo8f1Z4PVak7+Kul+t5TmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQUPnYd5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQUPnYd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB00F1F00A3D;
	Fri,  4 Sep 2026 06:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502836;
	bh=CTulZjG0oNzTSJyPIC+BNAKFGqKKX18pG5S7YJVBwt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQUPnYd529IfK0mGns/Sqqu3oJaEUa1rfqG2FjVECgCV7ctZYJ6yiLGaYumnUcg+3
	 ueY1A0cEN1cFmwuNXDrxum1xekYrux8PZ1hMYsuLHgmVReD9MMMmRi2j5YzgZugKwL
	 38WkMVkpYhenvYmfmrCKUlTubfM2NUc0/QbIkUJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Ye <fy15309206903@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 346/403] net: thunderbolt: Mark the connection down when bringing it up fails
Date: Fri,  4 Sep 2026 07:02:29 +0200
Message-ID: <20260904045742.682976579@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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


