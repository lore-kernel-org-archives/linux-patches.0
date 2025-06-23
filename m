Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B586136;
	Mon, 23 Jun 2025 21:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714623; cv=none; b=HFDuxZdQu0Ta064s23RTN+Vpvg3XS3FmkLrH6lRXRiqoUbgfHJEiOjo+XVqIDQ5CtJ8W4jH2uvlnFdASS1X0D8Gs31WqG9GY5hGBtX5Q2SVUDffv55fH33VK9GA2OFg43Dhxj/JrTcDG1y+5CNGW8EKoEcTAe2PyVzevGKuhDAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714623; c=relaxed/simple;
	bh=tzvK3DPGMA0KZ0lRfMIKinN32HbaNfTfL7BwbbL+mvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hmah2TEtI4M5FmBpvVfyMF/VmRyMFVtXcZ1RHbjyTrDep1II/qd7hxwRWYsCDaYkEQxfVRxc2EHnUN5jxPJfSc7VcgCRe3h6nNodEtXIQfaQAPvsPZ6TAMrdcBImgnL3Lhkg2ChOo2pd3tg67pAOwjPbvZcTCYRZdS5iC6Ohol0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXKV25Tu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXKV25Tu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C394C4CEEA;
	Mon, 23 Jun 2025 21:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714622;
	bh=tzvK3DPGMA0KZ0lRfMIKinN32HbaNfTfL7BwbbL+mvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXKV25TuBP7nfDK7dUgWUBnrnosiE1SCIddPID+NQn5EXki//zDfZTI3mH+07RzQN
	 FpKf3FC6/ZHAYVjZkAsU0tgBvuPsleO0Lnm0V9hoPYSq9vKSHTZGMv/Ht1ztnUJKCa
	 IxOe/VcHnlgiQG8a8a9mgaguMEbAG902Aus2/UDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirco Barone <mirco.barone@polito.it>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 185/508] wireguard: device: enable threaded NAPI
Date: Mon, 23 Jun 2025 15:03:50 +0200
Message-ID: <20250623130649.824641571@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 895a621c9e267..531332e169df8 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -368,6 +368,7 @@ static int wg_newlink(struct net *src_net, struct net_device *dev,
 	if (ret < 0)
 		goto err_free_handshake_queue;
 
+	dev_set_threaded(dev, true);
 	ret = register_netdevice(dev);
 	if (ret < 0)
 		goto err_uninit_ratelimiter;
-- 
2.39.5



