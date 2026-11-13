Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590281;
	b=2/oioA6Ta+RoPjADQazwG4mOZHGh4uz4PTlLBYOF6+g1ZEgHo75iJPe8op4W14wiOXHc
	 ikfKeOagv6ixLcE1pV3S/T0IxzSivn3eACgF63Jh2GMdQWA/hVBiRq7Wv+O+F2LTcupwa
	 UhV8FSUJ556VQNFmuC3bSM1Od+SJawQPMJ1t14g+6TKDJ8Ss/c36o57fsq5ZrZfg4zP5Y
	 jGtYu3oO4exKjVC9opBcQOv+4ueAAPePvMfo+qnT3yNbrQ/0QSAmMafstM3w7Uur1Y9DV
	 Q9J1cpFsJIycZ7QVghZs1JPcGm0WphBuyFjTAdTgetlfFoH3V6kSCINoV3dkzrZ6vYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wjth3pPIrep+kHUkINki0xk/wLKO440sTVvng7DG5Fo=;
	b=RYcdqFGmphIsXZquTQviGEzdjjvMpTqTABC0QiyU8Spa0mkwRHvsh3Flxunxtr/K8toZ
	 D5OvKiWr+A0/vlq6ouQLyfpRgYIQjNjTOiWsa+Ilz3tg5NwUTZLhp9Zxtu6Pd7t5VkEsx
	 PR9Sl57VgDq0DzH2asN0rmm7C/UuFdzbwv81wOqM3IIEma/xHFfvHcR2FAGA33LOyCDGs
	 cknsW7LOPdwtFKaUhWrLNgTLX+T1zjMCwZIR9/tujiknV3VFNpa13DBrls94kzrYc4ARf
	 yWEQfhnKVtUIOBFhR8HZ57gqBc2AD9dIP8/ljyx7WFd6Jsp6Ju5B+Uq0vXTVg5VzI6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TFn4cJ08;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B99E606CEED;
	Fri, 13 Nov 2026 17:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TFn4cJ08
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1768E1F000C4;
	Fri, 13 Nov 2026 17:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590281;
	bh=wjth3pPIrep+kHUkINki0xk/wLKO440sTVvng7DG5Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TFn4cJ087jvcxFrvwwuBKWcJd6GGniE8Z7lubEbTS87dzJZk+T+0erbXw7sQs8zCS
	 iayz4pgJkJZ1Md7Gwx5bUcuF8xSObi7vjWoekCX9DCs+QOep6ODAsAYdwf7IpBTb1l
	 NSfZsD3sd1PIKI6B+OOX+BzpaqHvpwvw7U2EOOBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Xia Yan <yana06070@163.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 269/686] veth: keep carrier off when resizing channels with a down peer
Date: Fri, 13 Nov 2026 10:46:42 -0500
Message-ID: <20261113153830.131532862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xia Yan <yana06070@163.com>

[ Upstream commit 2d02191779345b13de91048db441191b20264d16 ]

veth_set_channels() temporarily turns carrier off while reconfiguring a
running interface. It then turns carrier on for both ends without
checking whether the peer is administratively up. If only one end is up,
changing its channel counts therefore reports LOWER_UP even though the
peer remains down.

For example, after creating a pair with two RX and TX queues per end:

  ip link set vca up
  ethtool -L vca rx 1 tx 1

vca incorrectly reports LOWER_UP while vcb is still down.

Only restore carrier when the peer has IFF_UP, matching veth_open().
The local interface is already known to be running at this point.

Found during LLM-assisted source review and reproduced with a veth pair
in network namespaces, without kernel instrumentation or error injection.
The companion veth.sh test reproduces the two mixed up/down failures
before the fix and passes after it.

Fixes: 4752eeb3d891 ("veth: implement support for set_channel ethtool op")
Cc: stable@vger.kernel.org
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Signed-off-by: Xia Yan <yana06070@163.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20261029024259.3700-1-yana06070@163.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 25cdbba5dfa9b..c2b8b9d02e357 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1371,9 +1371,10 @@ static int veth_set_channels(struct net_device *dev,
 		 * to identify the range we have to disable
 		 */
 		veth_disable_range_safe(dev, new_rx_count, old_rx_count);
-		netif_carrier_on(dev);
-		if (peer)
+		if (peer && (peer->flags & IFF_UP)) {
+			netif_carrier_on(dev);
 			netif_carrier_on(peer);
+		}
 	}
 
 	/* update XDP supported features */
-- 
2.53.0



