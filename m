Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD63F2264DD;
	Tue, 17 Jun 2025 16:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179008; cv=none; b=RqvsnXtniZyqzCrOjtRhqCcIVcr9rHoA8sX81KOATQvhHY5K2rJc3u/r3f38vGNq0RnszA+2SOfACk2GlN+RAkmRtR+AThfee1RXlYH62qyjsRm0rOtX5gjQlj1I0uac/IMhfXjGyhqaXtAiqv94JvOPK6qeTCGKkqFjHB03RaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179008; c=relaxed/simple;
	bh=heYX4dZHq1fty3MM64zkVXGgfmJudrtpFjkKob0YR4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FBz9wuLfn8AqkadQxThGbSQZyWpCMVR+HctJqeN4P2x0GUe8JltKYrS8M5TrmgE95R50433OcRGeTmlUxSP/PuJYTi4sCYqCD5y4E4KvwgoqxC9QeMPj+sy6rB8pkTaZ2Te60I8LVDPUruhgyDoehDPJdwNmn4ds2qSwbHvppp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jgWqI+eV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jgWqI+eV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42118C4CEE3;
	Tue, 17 Jun 2025 16:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179007;
	bh=heYX4dZHq1fty3MM64zkVXGgfmJudrtpFjkKob0YR4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jgWqI+eVsR45sCt1YVgzJizPHbI8CStdp98Hw6qRVZqOdNbqDQ4fHRRXZxfRt7tuK
	 +2Ekig4SO6o4cQCOCQVEVIzEtNbWUWgS7n4BvnFsDnQbR7M+rRUxhCjJN0qg6e/Hyo
	 jsx/Ym/lRkzFmP5xTrCnPaZEV2kmkjc1lRk8s7Oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirco Barone <mirco.barone@polito.it>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 620/780] wireguard: device: enable threaded NAPI
Date: Tue, 17 Jun 2025 17:25:28 +0200
Message-ID: <20250617152516.726685146@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mirco Barone <mirco.barone@polito.it>

[ Upstream commit db9ae3b6b43c79b1ba87eea849fd65efa05b4b2e ]

Enable threaded NAPI by default for WireGuard devices in response to low
performance behavior that we observed when multiple tunnels (and thus
multiple wg devices) are deployed on a single host.  This affects any
kind of multi-tunnel deployment, regardless of whether the tunnels share
the same endpoints or not (i.e., a VPN concentrator type of gateway
would also be affected).

The problem is caused by the fact that, in case of a traffic surge that
involves multiple tunnels at the same time, the polling of the NAPI
instance of all these wg devices tends to converge onto the same core,
causing underutilization of the CPU and bottlenecking performance.

This happens because NAPI polling is hosted by default in softirq
context, but the WireGuard driver only raises this softirq after the rx
peer queue has been drained, which doesn't happen during high traffic.
In this case, the softirq already active on a core is reused instead of
raising a new one.

As a result, once two or more tunnel softirqs have been scheduled on
the same core, they remain pinned there until the surge ends.

In our experiments, this almost always leads to all tunnel NAPIs being
handled on a single core shortly after a surge begins, limiting
scalability to less than 3× the performance of a single tunnel, despite
plenty of unused CPU cores being available.

The proposed mitigation is to enable threaded NAPI for all WireGuard
devices. This moves the NAPI polling context to a dedicated per-device
kernel thread, allowing the scheduler to balance the load across all
available cores.

On our 32-core gateways, enabling threaded NAPI yields a ~4× performance
improvement with 16 tunnels, increasing throughput from ~13 Gbps to
~48 Gbps. Meanwhile, CPU usage on the receiver (which is the bottleneck)
jumps from 20% to 100%.

We have found no performance regressions in any scenario we tested.
Single-tunnel throughput remains unchanged.

More details are available in our Netdev paper.

Link: https://netdevconf.info/0x18/docs/netdev-0x18-paper23-talk-paper.pdf
Signed-off-by: Mirco Barone <mirco.barone@polito.it>
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://patch.msgid.link/20250605120616.2808744-1-Jason@zx2c4.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireguard/device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index 3ffeeba5dccf4..4a529f1f9beab 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -366,6 +366,7 @@ static int wg_newlink(struct net_device *dev,
 	if (ret < 0)
 		goto err_free_handshake_queue;
 
+	dev_set_threaded(dev, true);
 	ret = register_netdevice(dev);
 	if (ret < 0)
 		goto err_uninit_ratelimiter;
-- 
2.39.5



