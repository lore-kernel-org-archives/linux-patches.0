Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C5D2BE7CD;
	Fri,  9 Oct 2026 14:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556105; cv=none; b=WKtnD+hv3GIb6DRQ5Q53mR2qicEIqOGnVOQ/jRnaOTxn7CRFgxhUE28KJ7NPGbe0E3dF2YQM7wzE7ZDVw2JHHt+Eb+FFE1a2bHMsFZ2KVeD8bJqdk4Ei9Rv7IPPWb5n0TiWFRzytOKHyypLSAckEuceS56yi4R6uW3hDNMKK4a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556105; c=relaxed/simple;
	bh=caJ16YkZ+FZb5Q3MIjeZN6xZnTdabcSTySDPkyVpmxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjEYZXoYaYF5Wg5px0MNUJMvRUnTHWoSLiDWmgwYtnTh0W6Gb/2Y6u8QW6d3RJ1qv0UGVXgBLRf+zPnc2w2LZRRjV6YqZZ6GVV/odXT8JLUtILum6RAaHZXyRgVZdXjVda7HNMPv7VHA7gILZwC7Tv9dHSAF7pp9nIjqh8GyliQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=veiiFMvy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="veiiFMvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C361F000FF;
	Fri,  9 Oct 2026 14:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556104;
	bh=E0GkdugJ91EC+KY7xt9hyz4ChrnnpWiEGL9kbO9iPeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=veiiFMvybuR580772m9EfBZsSKTYpvLHcVwPQrpzjZhXgKw9aCh6OkjiPbymK5GUW
	 60ITeU2wKMpBJzfIRTYDZxs7VkGsPLLX7hbcKEkxtwuOnOLWWP9n0pYXAK0ZGf7OjJ
	 mAjqDnYKzL1yECL2k/jGrW626rAuAfvlzbg+nvOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 121/428] net: systemport: Fix RUNT MIB counter register offset calculation
Date: Fri,  9 Oct 2026 16:07:38 +0200
Message-ID: <20261009140948.850977814@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 242935adfeb096f09b29fb2cfcf12f9eb2911fc6 ]

In UniMAC hardware, there is a 0xC byte gap between the RX MIB counters
and the TX MIB counters, and a second 0xC byte gap between the TX MIB
counters and the RX RUNT MIB counters.

In bcm_sysport_update_mib_counters(), 'offset' was only set to
UMAC_MIB_STAT_OFFSET (0xC) for all non-RX counters, omitting the second
0xC gap for BCM_SYSPORT_STAT_RUNT counters. As a result, all 4 RUNT MIB
counters were read from unmapped gap register space.

Fix this by setting offset to 2 * UMAC_MIB_STAT_OFFSET (0x18) when
reading BCM_SYSPORT_STAT_RUNT counters.

Fixes: 80105befdb4b ("net: systemport: add Broadcom SYSTEMPORT Ethernet MAC driver")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260922232440.598918-6-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index db627cd15fb7a..78909f5168231 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -391,8 +391,10 @@ static void bcm_sysport_update_mib_counters(struct bcm_sysport_priv *priv)
 			if (priv->is_lite)
 				continue;
 
-			if (s->type != BCM_SYSPORT_STAT_MIB_RX)
+			if (s->type == BCM_SYSPORT_STAT_MIB_TX)
 				offset = UMAC_MIB_STAT_OFFSET;
+			else if (s->type == BCM_SYSPORT_STAT_RUNT)
+				offset = 2 * UMAC_MIB_STAT_OFFSET;
 			val = umac_readl(priv, UMAC_MIB_START + j + offset);
 			break;
 		case BCM_SYSPORT_STAT_RXCHK:
-- 
2.53.0



