Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D8037C118;
	Sat, 12 Sep 2026 09:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205380; cv=none; b=MKSttpv9+2noTkMYFixqYfIjRWecI4ucgsPPFy910tZT35xEtjZlIfrlsePfxqVq/6PZL6pS7XcGAd4PrnSbzPwmhkS17QYdPQEI4SSwUDx+h8ec5fSgmnCgiP2bkj8vtCl8oMXRoGeTMek78W6Ehxr46x8LOb1Wzv6bS5UDRFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205380; c=relaxed/simple;
	bh=mrfI7UStcx1obEd9GevDuuHWV5opiQmTzz5PZVU655M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHTAw5oiFkUCG95rS4MperpEbieOUVAqHjTicuuEEGJ3Aed+GRu+x2sewGp54XqzxONSVXwf7SUF0icfm/wRHb+c9I/qV58gy35pcRTcOPp8TY8Rzub0xga6QQCNZCX7rDdaxigjLRnTCL8FpqILmidCDwppIx25fTNXAOkdw3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iVqbhvDJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iVqbhvDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34FAE1F000FF;
	Sat, 12 Sep 2026 09:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205377;
	bh=r6f2eRw/KVAjRDMzLRzQ/LBDHDssPPK8RbdbtLBidWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iVqbhvDJiQp22JjVd1xAT2DUPeQXSCdFIifsfjMNSZ+Ch2YF8egk9drxsdUTQYT7S
	 gf3ASldozf5R32GireEuoUtJZA69xQre5Oq4eUa9YOiSOjOrvsBIL7L9rWvavyqeqD
	 QMjKzKEo6vawdNHZ2jVFTVMJmqdQ8akpi4k75mvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edoardo Pinci <epinci@outlook.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1805/1815] net: dsa: mxl862xx: enable assisted learning on CPU port
Date: Sat, 12 Sep 2026 08:59:15 +0200
Message-ID: <20260912065731.410634786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Edoardo Pinci <epinci@outlook.com>

[ Upstream commit 88c71cc0ad9800d8814bd3627b21a0da9028e057 ]

The MxL862xx driver enables FDB isolation but does not enable assisted
learning on the CPU port. Consequently, MAC addresses learned through a
physical switch port are not updated in hardware when the corresponding
station moves to a foreign bridge port, such as a Wi-Fi interface.

The stale hardware FDB entry continues directing return traffic toward
the original physical port. Traffic entering that same port is then
filtered instead of being forwarded to the CPU and software bridge. This
causes downstream unicast traffic, including DHCP OFFER and ACK packets,
to disappear after a client roams to a local wireless interface. The
client eventually considers the connection unusable and disconnects.

Enable assisted CPU-port learning so DSA installs foreign bridge FDB
entries on the CPU port. This keeps the hardware FDB synchronized with
the software bridge and allows return traffic to reach locally attached
Wi-Fi clients after roaming.

Tested on a BPI R4 PRO with a MxL862xx switch and a BE14000 WiFi interface.
- Without patch, wired uplink on lan6 port (mxl path)
  Wifi clients connect but roam away not getting DHCP offers
- Without patch, wired uplink on wan port (no mxl path)
  Wifi clients connect and roam successfully
- With this patch, uplink on lan6 (mxl path)
  Wifi clients connect and roam successfully

Fixes: 340bdf984613 ("net: dsa: mxl862xx: implement bridge offloading")
Signed-off-by: Edoardo Pinci <epinci@outlook.com>
Link: https://patch.msgid.link/DU0P251MB069949C6DEB4D1D51F31FE87C4A02@DU0P251MB0699.EURP251.PROD.OUTLOOK.COM
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mxl862xx/mxl862xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mxl862xx/mxl862xx.c b/drivers/net/dsa/mxl862xx/mxl862xx.c
index 45d237b3a40f1..cfa7e3e269a28 100644
--- a/drivers/net/dsa/mxl862xx/mxl862xx.c
+++ b/drivers/net/dsa/mxl862xx/mxl862xx.c
@@ -2111,6 +2111,7 @@ static int mxl862xx_probe(struct mdio_device *mdiodev)
 	ds->ops = &mxl862xx_switch_ops;
 	ds->phylink_mac_ops = &mxl862xx_phylink_mac_ops;
 	ds->num_ports = MXL862XX_MAX_PORTS;
+	ds->assisted_learning_on_cpu_port = true;
 	ds->fdb_isolation = true;
 	ds->max_num_bridges = MXL862XX_MAX_BRIDGES;
 
-- 
2.53.0



