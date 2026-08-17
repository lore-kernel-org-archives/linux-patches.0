Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1F3439F71;
	Mon, 17 Aug 2026 14:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978482; cv=none; b=Ds0p+/TRp8KHzO1L2HMJMVpwergm/aNCrDch+rk2EQQaIbh2He45rruAvBJNRMYMO0bsdj4upTTwVf/L+IwXxvMx9lIoLkRNvVot60mopDu2lZntjLAgX93aEOPRKVqjYotkLxLHLxQd24fYZLSiRcIyOCOep7WDqX4969rS/68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978482; c=relaxed/simple;
	bh=rwuHcmNLhQrAB6C6jF7PuXd4hDuQzK/jGDxzHAHcJOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e6O7CMCsv4PZDMQWvzR9yQPO2R88phRiIOC7fuMmDp/fU0fcmxBh1W6Hh1pgwATEOZ0LjpHTd0xdYYbXlimUiRA4z47HCaVx+C15fFs5j86e1n9Q3gCI/8PnYUm+NPk7v4CWIy6nAqxsFz+FUYRv6wUIKTmOMFrLscIno4G9KaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYSJYI42; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYSJYI42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7A81F000E9;
	Mon, 17 Aug 2026 14:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978479;
	bh=xoMaovTKYiIVPKDzmJfZu7v0b/fkH+/B+ldLxUMcYbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oYSJYI42ocQNgzm8KSV2PIYUdEkTxqYDkv3k6cmAb1A/yg2s0s69YHyNTswX6yl2L
	 iVZ+zlgPuMixadeb/DBSmO7nMuLp87x/4h1lpQCipHCHkcqbgRLD+OvcfIrVXFdq9r
	 amk4ivsWAzGHba7puCEf0WptfPaahXsg9e47YRrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan XinRan <shinjiangjiang@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/156] net: thunderbolt: Tear down DMA paths before stopping the rings
Date: Mon, 17 Aug 2026 15:33:06 +0200
Message-ID: <20260817132536.627414761@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

From: Fan XinRan <shinjiangjiang@gmail.com>

[ Upstream commit 68bf02b6b4ad3f748c6db71fd77b6c0402d252f4 ]

tbnet_tear_down() stops both rings and frees their frame buffers before
calling tb_xdomain_disable_paths().  tb_ring_stop() zeroes the ring's
descriptor base and tbnet_free_buffers() unmaps and frees the pages the
frames sit in, so by the time __tb_path_deactivate_hop() polls the hop's
'pending' bit, anything still in flight has nowhere to drain to.

The teardown sequence has been in this order since the driver was added.
The setup path has not: commit ff7cd07f3064 ("net: thunderbolt: Enable
DMA paths only after rings are enabled") moved the path enable to the end
of tbnet_connected_work() and documented why:

	/* Both logins successful so enable the rings, high-speed DMA
	 * paths and start the network device queue.
	 *
	 * Note we enable the DMA paths last to make sure we have primed
	 * the Rx ring before any incoming packets are allowed to
	 * arrive.
	 */

Teardown was never updated to match, so the rings and the paths now come
down in the same order they go up instead of in reverse.

On an ASMedia ASM4242 host router the 'pending' bit then never clears:
every teardown burns the full 500 ms timeout and
__tb_path_deactivate_hop() returns -ETIMEDOUT.  Raising the timeout to
5 s does not help, so the hop is not slow to drain, it never drains
at all.

The failure is invisible above the thunderbolt core.
__tb_path_deactivate_hops() is void and only calls tb_port_warn();
tb_path_deactivate(), tb_tunnel_deactivate() and
__tb_disconnect_xdomain_paths() are void as well, and
tb_disconnect_xdomain_paths() ends in an unconditional "return 0".  So
tb_xdomain_disable_paths() reports success and the netdev_warn() below
it never fires.  Repeated teardowns eventually take the XDomain control
channel down, after which the peer node is gone and only a power cycle
brings the controller back.

Deactivating the paths first fixes it.  Measured with kretprobes on a
stock v6.17 tree with no other patches applied, on a link that was up
and had just carried traffic:

  before: __tb_path_deactivate_hop() returns 0 for the first hop, then
          -ETIMEDOUT for the second 500335 us later
  after:  0 for both, 525 us apart

Alternating the two orderings ABBA over three load levels, four
teardowns per arm: every teardown failed before the change (21 of 21
that ran), none failed after (0 of 24).  The before arms ran short
because the link died partway through.  The same split shows up when
the interface is enslaved to a bond instead of just brought down, which
is how I ran into this in the first place.  Throughput and latency after
the change are unchanged.

Hosts whose routers drain the hop despite the stale descriptor base see
no functional difference, since the paths end up deactivated either way.

Fixes: e69b6c02b4c3 ("net: Add support for networking over Thunderbolt cable")
Signed-off-by: Fan XinRan <shinjiangjiang@gmail.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://patch.msgid.link/20260803-b4-tbnet-teardown-v2-1-27de6a13ca2d@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/thunderbolt/main.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/thunderbolt/main.c b/drivers/net/thunderbolt/main.c
index 960839a651e51..ceaba08cd378a 100644
--- a/drivers/net/thunderbolt/main.c
+++ b/drivers/net/thunderbolt/main.c
@@ -389,11 +389,16 @@ static void tbnet_tear_down(struct tbnet *net, bool send_logout)
 				break;
 		}
 
-		tb_ring_stop(net->rx_ring.ring);
-		tb_ring_stop(net->tx_ring.ring);
-		tbnet_free_buffers(&net->rx_ring);
-		tbnet_free_buffers(&net->tx_ring);
-
+		/* Tear the paths down before stopping the rings.  This mirrors
+		 * tbnet_connected_work(), which enables the paths last so the
+		 * Rx ring is primed before packets can arrive.  Stopping a
+		 * ring zeroes its descriptor base and tbnet_free_buffers()
+		 * unmaps and frees the frame buffers, leaving anything still
+		 * in flight with nowhere to drain to;
+		 * __tb_path_deactivate_hop() then waits for the hop's
+		 * 'pending' bit, which on some host routers never clears in
+		 * that state.
+		 */
 		ret = tb_xdomain_disable_paths(net->xd,
 					       net->local_transmit_path,
 					       net->tx_ring.ring->hop,
@@ -402,6 +407,11 @@ static void tbnet_tear_down(struct tbnet *net, bool send_logout)
 		if (ret)
 			netdev_warn(net->dev, "failed to disable DMA paths\n");
 
+		tb_ring_stop(net->rx_ring.ring);
+		tb_ring_stop(net->tx_ring.ring);
+		tbnet_free_buffers(&net->rx_ring);
+		tbnet_free_buffers(&net->tx_ring);
+
 		tb_xdomain_release_in_hopid(net->xd, net->remote_transmit_path);
 		net->remote_transmit_path = 0;
 	}
-- 
2.53.0



