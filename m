Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703CE2F2C68;
	Tue, 15 Jul 2025 13:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587918; cv=none; b=jsRDDk+u0YXkvRbjtyIDCs53bsg43Hcnk1Hp4hoHShwPnF8hTkcsRKN8Na/GUQBrkRpsrU3NDXHcSxxStjrLxnmculxKdly+0LwTAFPq9PXOhz77r0fI84McGR745sPWhHjN+m8l9O124+e5isvStOYh5yy7CvDnwd5VrU3VRn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587918; c=relaxed/simple;
	bh=6O/Dr/4f4eZO6DcZ4JVMb4SSqbzl65hEwDTJI+yko9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVxQC20OH3r8VyLXnqJXy4WBvMs8F/9rj+A4fZPl4Fypbed6zWwVp/wHVxMOe6wFs8GqW+QRSALglmVZzbKbx0Spjgy8Ed75m5Y81tSQ7hUYcGLGyGIoE/+z/iEHzgU6qOp5Oc1uy21DtefqyNMEvApuom8EuQK+117FOaBU90o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GcrIpI2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GcrIpI2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BDAC4CEF7;
	Tue, 15 Jul 2025 13:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587918;
	bh=6O/Dr/4f4eZO6DcZ4JVMb4SSqbzl65hEwDTJI+yko9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GcrIpI2PkfcXPoN28FHK1tSe9lG/s59dG2KAfap4d5UDFeC24Dx/WiTjgkKGVL/A1
	 vFR0VqTUGFukH9Pyf4GQB7235CE58+HeK8IOpTSWaQKz810rtrrXRC25EIyCduy7XD
	 ikDom7cQ5oQvDHhdahfTKF8YSgWgEomxzwLrgry4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Sean Nyekjaer <sean@geanix.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 191/208] can: m_can: m_can_handle_lost_msg(): downgrade msg lost in rx message to debug level
Date: Tue, 15 Jul 2025 15:15:00 +0200
Message-ID: <20250715130818.598778962@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Nyekjaer <sean@geanix.com>

[ Upstream commit 58805e9cbc6f6a28f35d90e740956e983a0e036e ]

Downgrade the "msg lost in rx" message to debug level, to prevent
flooding the kernel log with error messages.

Fixes: e0d1f4816f2a ("can: m_can: add Bosch M_CAN controller support")
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Link: https://patch.msgid.link/20250711-mcan_ratelimit-v3-1-7413e8e21b84@geanix.com
[mkl: enhance commit message]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 6181ac277b62f..1c8a7c65530fd 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -522,7 +522,7 @@ static int m_can_handle_lost_msg(struct net_device *dev)
 	struct sk_buff *skb;
 	struct can_frame *frame;
 
-	netdev_err(dev, "msg lost in rxf0\n");
+	netdev_dbg(dev, "msg lost in rxf0\n");
 
 	stats->rx_errors++;
 	stats->rx_over_errors++;
-- 
2.39.5



