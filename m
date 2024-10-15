Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD47C1C07D9;
	Tue, 15 Oct 2024 12:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996871; cv=none; b=KtEI9OjC1NseERZEosnAHLXEVEUub+q1q3hNR5pntGRyqu9iuWCtzI/vtxpQncbQe8uwdFia3LCdS6r3M5MxahS/YZjhnxG2vyrXY9XzgoCt7F8iMINQ006sewM3eJR0JN7aaMWD4h0Hp0/Ie3TSCtKNKjT5y6aBlHMtroSD068=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996871; c=relaxed/simple;
	bh=95B9oq5HPlQ+zio29UL0fK/w+SaSxooQNMkXj0pIHE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdFKSpEwvIZwJGwAweHhjRVYTAvHIfao9UN4V5ZotOozPC1l9Q6Zhs1C2oSAgRX+R8VP8MW7haRcP8zmsCl+ZY4wch6BaP0X32/1R9pX5pSH+bSSw/gVLB3FaASPAvFjrxKo8nA/VVQESSW9vb3lvSnHrp69kQ2+AP2WlaxfcGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OV3XErgr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OV3XErgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D805C4CEC6;
	Tue, 15 Oct 2024 12:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728996871;
	bh=95B9oq5HPlQ+zio29UL0fK/w+SaSxooQNMkXj0pIHE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OV3XErgrLAHJAgl6F1QTzI38Ft7gaGmkVrlhFz1HihxQhSN8gRykjiYTQiC6xttys
	 MJWJnHkA9I+Nt/99OSbBu8dDgZ91pwc3vH3mFVzlC0dh16G1UsNw42OUwvyWKWfQu9
	 Jza0RLQiHNkS0Vs4XpL+T6hoyvQiLuGH/YokTdAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Chou <jacky_chou@aspeedtech.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/518] net: ftgmac100: Enable TX interrupt to avoid TX timeout
Date: Tue, 15 Oct 2024 14:38:47 +0200
Message-ID: <20241015123917.894800849@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacky Chou <jacky_chou@aspeedtech.com>

[ Upstream commit fef2843bb49f414d1523ca007d088071dee0e055 ]

Currently, the driver only enables RX interrupt to handle RX
packets and TX resources. Sometimes there is not RX traffic,
so the TX resource needs to wait for RX interrupt to free.
This situation will toggle the TX timeout watchdog when the MAC
TX ring has no more resources to transmit packets.
Therefore, enable TX interrupt to release TX resources at any time.

When I am verifying iperf3 over UDP, the network hangs.
Like the log below.

root# iperf3 -c 192.168.100.100 -i1 -t10 -u -b0
Connecting to host 192.168.100.100, port 5201
[  4] local 192.168.100.101 port 35773 connected to 192.168.100.100 port 5201
[ ID] Interval           Transfer     Bandwidth       Total Datagrams
[  4]   0.00-20.42  sec   160 KBytes  64.2 Kbits/sec  20
[  4]  20.42-20.42  sec  0.00 Bytes  0.00 bits/sec  0
[  4]  20.42-20.42  sec  0.00 Bytes  0.00 bits/sec  0
[  4]  20.42-20.42  sec  0.00 Bytes  0.00 bits/sec  0
[  4]  20.42-20.42  sec  0.00 Bytes  0.00 bits/sec  0
[  4]  20.42-20.42  sec  0.00 Bytes  0.00 bits/sec  0
[  4]  20.42-20.42  sec  0.00 Bytes  0.00 bits/sec  0
[  4]  20.42-20.42  sec  0.00 Bytes  0.00 bits/sec  0
[  4]  20.42-20.42  sec  0.00 Bytes  0.00 bits/sec  0
[  4]  20.42-20.42  sec  0.00 Bytes  0.00 bits/sec  0
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval          Transfer    Bandwidth      Jitter   Lost/Total Datagrams
[  4]   0.00-20.42  sec  160 KBytes 64.2 Kbits/sec 0.000 ms 0/20 (0%)
[  4] Sent 20 datagrams
iperf3: error - the server has terminated

The network topology is FTGMAC connects directly to a PC.
UDP does not need to wait for ACK, unlike TCP.
Therefore, FTGMAC needs to enable TX interrupt to release TX resources instead
of waiting for the RX interrupt.

Fixes: 10cbd6407609 ("ftgmac100: Rework NAPI & interrupts handling")
Signed-off-by: Jacky Chou <jacky_chou@aspeedtech.com>
Link: https://patch.msgid.link/20240906062831.2243399-1-jacky_chou@aspeedtech.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/faraday/ftgmac100.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.h b/drivers/net/ethernet/faraday/ftgmac100.h
index 63b3e02fab16..4968f6f0bdbc 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.h
+++ b/drivers/net/ethernet/faraday/ftgmac100.h
@@ -84,7 +84,7 @@
 			    FTGMAC100_INT_RPKT_BUF)
 
 /* All the interrupts we care about */
-#define FTGMAC100_INT_ALL (FTGMAC100_INT_RPKT_BUF  |  \
+#define FTGMAC100_INT_ALL (FTGMAC100_INT_RXTX  |  \
 			   FTGMAC100_INT_BAD)
 
 /*
-- 
2.43.0



