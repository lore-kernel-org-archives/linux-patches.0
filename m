Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081F41DF736;
	Wed,  6 Nov 2024 12:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894840; cv=none; b=YPn2CTfYN3Plwzq3f9RtgVHzie9WBuQN+rI1bVbm6Roc3y3JEHa/DRmsNgbWeAPLOW9gtKhiOPA+1PcF1gETA80pyQ9HApcgz2jE7sapSr4uvvXcfqx3zxo7KYkyrzSCOWJ4oins2zhGrEi241IzsvkH9QkI+0osT2VJuc+VBkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894840; c=relaxed/simple;
	bh=Yd5YIghYxqMP9I2IKjKrI4RgLL9cX7zl05o/y0t6TDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSZnkXhZ8Jz56SxK+w3DNchoKLGzagaGmzO6cV0xgtNhZHF0MOz7OQNibeLTHTUYKbKXql7DA4vH0NnCrKXvoVySajcT/azGWKSKN/cDGp9NwzWlN19xc+5frFswe9dWGuCLVP6iYqqPUhoZdqzm1jAzKPdz4QbhkIbhCbx0ILU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v7ursI6j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v7ursI6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811BEC4AF09;
	Wed,  6 Nov 2024 12:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894839;
	bh=Yd5YIghYxqMP9I2IKjKrI4RgLL9cX7zl05o/y0t6TDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v7ursI6jFa9TiihhIBOjJiRn97NeBswN6ShVgTAulteB1u2zvlYO62QKuadL1aOeJ
	 f6L4GARIVt5IclBzs/kVHQJTgS+JQDnKM0Za/+CAIGtAvNvtdU8MGftBAvO4+5m3hU
	 EHfBpa9tgM1KHsUn8pNFZ+6LgGDN67nWGy/jgUO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Chou <jacky_chou@aspeedtech.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 010/350] net: ftgmac100: Enable TX interrupt to avoid TX timeout
Date: Wed,  6 Nov 2024 12:58:58 +0100
Message-ID: <20241106120321.125744522@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 0653d8176e6a..6349e7c7c074 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.h
+++ b/drivers/net/ethernet/faraday/ftgmac100.h
@@ -97,7 +97,7 @@
 			    FTGMAC100_INT_RPKT_BUF)
 
 /* All the interrupts we care about */
-#define FTGMAC100_INT_ALL (FTGMAC100_INT_RPKT_BUF  |  \
+#define FTGMAC100_INT_ALL (FTGMAC100_INT_RXTX  |  \
 			   FTGMAC100_INT_BAD)
 
 /*
-- 
2.43.0



