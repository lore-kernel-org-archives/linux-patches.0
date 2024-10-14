Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EDE1798C;
	Mon, 14 Oct 2024 14:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916205; cv=none; b=jerRApYnquGSLIIgF1pozzan6J6Ew+KjOxUCtGdP6nZyNOf4DKRNCc8s0L00ozN3ir8lEbdI0tfkj6O020h62q3OuTF1b+TAWAVlowxLMWbQJWmjJmO6YyXptgHI/+j8kUNTYVs2q72AWVtUnoXejuSUNoEot7/Ok4yxiP7rHrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916205; c=relaxed/simple;
	bh=Uq4oR7rJbw5T30/+L20UlI1mjYgDVnzFWLkUHlta6yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0BYNy7n5Pz13psmeugw9PyUrenoPj/UY6qsGTxgwxOzxEGGQ90rgKR+i8OUAS3e6CFwBTAXfbzrHW5wzyJRGg1VhPq8DsWUdN6LJm0NXCm0008QDPXWtboh+YLZCgSV3fbOPnT6qn2K3DjSf+AL/baQif6TU/eCP2JMDfv+5eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltNH4EVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltNH4EVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC41C4CEC3;
	Mon, 14 Oct 2024 14:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916205;
	bh=Uq4oR7rJbw5T30/+L20UlI1mjYgDVnzFWLkUHlta6yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltNH4EVEFA6BZgic1NDjVgnWs7PXFjdPwL5H+KGiSS8vfx30qcXB8+gUXPBR/NiyF
	 QpjIbMZFfyEbIBF4lvgGPfePV0eIrjLwFW/3Iz5X+zQmj0l94gJrncehyfYYZqwssa
	 qvvVh1AoXspQE7olP1OP9AdyR1RERopOHOWRa2v4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 113/214] net: dsa: b53: fix jumbo frames on 10/100 ports
Date: Mon, 14 Oct 2024 16:19:36 +0200
Message-ID: <20241014141049.403340294@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 2f3dcd0d39affe5b9ba1c351ce0e270c8bdd5109 ]

All modern chips support and need the 10_100 bit set for supporting jumbo
frames on 10/100 ports, so instead of enabling it only for 583XX enable
it for everything except bcm63xx, where the bit is writeable, but does
nothing.

Tested on BCM53115, where jumbo frames were dropped at 10/100 speeds
without the bit set.

Fixes: 6ae5834b983a ("net: dsa: b53: add MTU configuration support")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 5b83f9b6cdac3..c39cb119e760d 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2264,7 +2264,7 @@ static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
 		return 0;
 
 	enable_jumbo = (mtu > ETH_DATA_LEN);
-	allow_10_100 = (dev->chip_id == BCM583XX_DEVICE_ID);
+	allow_10_100 = !is63xx(dev);
 
 	return b53_set_jumbo(dev, enable_jumbo, allow_10_100);
 }
-- 
2.43.0



