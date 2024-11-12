Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08EB21265F;
	Tue, 12 Nov 2024 10:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408061; cv=none; b=d+rs1whLdxfJ9Yi8Wfq/Pxvs83IyNq4jwiipe3NezLB2/X4oAjcYV5Ehga9fzpy3/RV1Zlrzz0olcnProj+gViM+8tK9lwQ77Sg74s+C/CXoML6yMHXfB5aKfG16EOZh0EWCxnd7DNNsvOifJ+t2uoaGdB6aO+QFqKz8sQYHlTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408061; c=relaxed/simple;
	bh=nAnjQ1wu5HToeIjea4NiCCPcMq75IYfKXJn8Rrx9uWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNEc2T+LwI1ubhcA2s4kIesHWdtXorYpAZhYcFwca+Y0tcoW02MIEkT/Sw21tFxy6zKntUQUE6njaoQ0APu/gglEr1DUzBeHH01mM/gBpks+BmWHuatLze0C+YSi4UZ5GqzEHDxMQtXWyVwEMxklJSM6L2W/MXYAoS32HGqKxk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bdQ+bRK6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bdQ+bRK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A7BC4CECD;
	Tue, 12 Nov 2024 10:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408061;
	bh=nAnjQ1wu5HToeIjea4NiCCPcMq75IYfKXJn8Rrx9uWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdQ+bRK6eN6MQWEkxnHRRocafgUdWMpHlzhBQAyba70y6RH2IIOh78MtEhKMvUcxU
	 EaZ4DLyLQi2C8Tb/z93NHmFKMKiRYGzNxcgvcKvlcI+xiWV05Cka53zvylsx96y/6G
	 5ydEdqUZATGFIKeGthk8zDgnfzJsju6pvALDR32k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 047/184] can: c_can: fix {rx,tx}_errors statistics
Date: Tue, 12 Nov 2024 11:20:05 +0100
Message-ID: <20241112101902.668460792@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/can/c_can/c_can_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/c_can/c_can_main.c b/drivers/net/can/c_can/c_can_main.c
index c63f7fc1e6917..511615dc33419 100644
--- a/drivers/net/can/c_can/c_can_main.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -1011,7 +1011,6 @@ static int c_can_handle_bus_err(struct net_device *dev,
 
 	/* common for all type of bus errors */
 	priv->can.can_stats.bus_error++;
-	stats->rx_errors++;
 
 	/* propagate the error condition to the CAN stack */
 	skb = alloc_can_err_skb(dev, &cf);
@@ -1027,26 +1026,32 @@ static int c_can_handle_bus_err(struct net_device *dev,
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



