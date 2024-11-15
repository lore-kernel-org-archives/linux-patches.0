Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFE2185924;
	Fri, 15 Nov 2024 06:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652865; cv=none; b=Pzl0ilen7yPtyvt5JoovAI/6g8OAC7E6IFzYoauxWWtVYYh4hasQabRT9/6fGbHCY6EQ1gMYGq9i728URq015MZ2G0mPjihikZpDYYmTPPhQN3XCeuebfvBErIA+v5MA2Ypx3U3pwj1tCW7fRUvT88kAmVVP3b+kuKM2elAIK5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652865; c=relaxed/simple;
	bh=VsGLonHks7/Ul6NJ9Jlh65eNtRwVZgQ2em34sNFJoec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGmWqdo3zN8T6lFjg5GlI1SR2AlvlfoZ3v+2zHjBWSGLIMPqeWJmuclORfcCwcbB90vqz44VqoCSYgWMk8Bb7+LsIOt7jblqOoAziIMykKvT8+g5Ttqs/pRy2IefC3IHa/BkyAWkzL9IcfiL56ZxMITLgVLUdzvqqa3AKESDKNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jM4KEAGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jM4KEAGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7636C4CECF;
	Fri, 15 Nov 2024 06:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652865;
	bh=VsGLonHks7/Ul6NJ9Jlh65eNtRwVZgQ2em34sNFJoec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jM4KEAGnzRsBuHK/0SY7SoOit8ybt9Gtd4cWu6hX+XUrcKxjsdDofd5oPSgYtcqzN
	 AWKQP6MLL65eI0x3raYOYNya/ObDkGy4ko4n0PKOXS9FflVTiVWPGmMq6eHd8BjjSs
	 cYAPyfOd/jNrYbi9/VkVEkUzgO4XXXCq479vK0bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/52] can: c_can: fix {rx,tx}_errors statistics
Date: Fri, 15 Nov 2024 07:37:21 +0100
Message-ID: <20241115063723.154781027@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

[ Upstream commit 4d6d26537940f3b3e17138987ed9e4a334780bf7 ]

The c_can_handle_bus_err() function was incorrectly incrementing only the
receive error counter, even in cases of bit or acknowledgment errors that
occur during transmission. The patch fixes the issue by incrementing the
appropriate counter based on the type of error.

Fixes: 881ff67ad450 ("can: c_can: Added support for Bosch C_CAN controller")
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Link: https://patch.msgid.link/20241014135319.2009782-1-dario.binacchi@amarulasolutions.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/c_can/c_can.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 2278c5fff5c69..8e72c379740c7 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -991,7 +991,6 @@ static int c_can_handle_bus_err(struct net_device *dev,
 
 	/* common for all type of bus errors */
 	priv->can.can_stats.bus_error++;
-	stats->rx_errors++;
 
 	/* propagate the error condition to the CAN stack */
 	skb = alloc_can_err_skb(dev, &cf);
@@ -1008,26 +1007,32 @@ static int c_can_handle_bus_err(struct net_device *dev,
 	case LEC_STUFF_ERROR:
 		netdev_dbg(dev, "stuff error\n");
 		cf->data[2] |= CAN_ERR_PROT_STUFF;
+		stats->rx_errors++;
 		break;
 	case LEC_FORM_ERROR:
 		netdev_dbg(dev, "form error\n");
 		cf->data[2] |= CAN_ERR_PROT_FORM;
+		stats->rx_errors++;
 		break;
 	case LEC_ACK_ERROR:
 		netdev_dbg(dev, "ack error\n");
 		cf->data[3] = CAN_ERR_PROT_LOC_ACK;
+		stats->tx_errors++;
 		break;
 	case LEC_BIT1_ERROR:
 		netdev_dbg(dev, "bit1 error\n");
 		cf->data[2] |= CAN_ERR_PROT_BIT1;
+		stats->tx_errors++;
 		break;
 	case LEC_BIT0_ERROR:
 		netdev_dbg(dev, "bit0 error\n");
 		cf->data[2] |= CAN_ERR_PROT_BIT0;
+		stats->tx_errors++;
 		break;
 	case LEC_CRC_ERROR:
 		netdev_dbg(dev, "CRC error\n");
 		cf->data[3] = CAN_ERR_PROT_LOC_CRC_SEQ;
+		stats->rx_errors++;
 		break;
 	default:
 		break;
-- 
2.43.0



