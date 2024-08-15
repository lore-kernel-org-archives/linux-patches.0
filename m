Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C5C210FB;
	Thu, 15 Aug 2024 14:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732356; cv=none; b=OKZn+Ip89BQsytiLLA4FwqdlR40INJZKCnrd1VRMWK3vwR0knhCV6r8lA68M9GnvOq5HPSH7zjkxBEwzlJZni/oCtADiv3Ws1AcD85VBD9Y5W0EW+udrmSDdtL1kpiWoIMrgnrrZlj0xoupSRLGwlrH8ys/DgqxXDoMK7zBTu7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732356; c=relaxed/simple;
	bh=Tki2Q8pG5mp1Qlgp4W3sUKxBZ+8waB2tCT3TZApz9Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aej8HnbW4QmYKAwctODPhihtYmMEwU+UEOpnGfu0n6hvmIOfy0naADV15fWHRDTwS6rT1M5a3TTWfN7iKEICQaoNESvAjj4Q0wphwmoPDSY3a8U7F/GOgV0wjkfwQ5WZUvfZOJXwCQwLivr6RLrus40Q2nnqi7lIB6kBQwj81PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKZx6b0z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKZx6b0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E703C32786;
	Thu, 15 Aug 2024 14:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732355;
	bh=Tki2Q8pG5mp1Qlgp4W3sUKxBZ+8waB2tCT3TZApz9Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKZx6b0z2oSRn0GrtPlwb/940j5S9bTWETiEGRgWajxtf1EJlUCBTjhQDT5NkquNF
	 lxSDXgji5wAX8Z2MqJQygH3pbqz7R3zoBHvIxR9IQTUXghYiZzXIbHfd69NwbsX5OY
	 i/djv95CkCSrFqT/E/wdrhn/NIUYAEtPt9wShNYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <olteanv@gmail.com>,
	Martin Willi <martin@strongswan.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/352] net: dsa: b53: Limit chip-wide jumbo frame config to CPU ports
Date: Thu, 15 Aug 2024 15:22:59 +0200
Message-ID: <20240815131923.623099332@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

From: Martin Willi <martin@strongswan.org>

[ Upstream commit c5118072e228e7e4385fc5ac46b2e31cf6c4f2d3 ]

Broadcom switches supported by the b53 driver use a chip-wide jumbo frame
configuration. In the commit referenced with the Fixes tag, the setting
is applied just for the last port changing its MTU.

While configuring CPU ports accounts for tagger overhead, user ports do
not. When setting the MTU for a user port, the chip-wide setting is
reduced to not include the tagger overhead, resulting in an potentially
insufficient chip-wide maximum frame size for the CPU port.

As, by design, the CPU port MTU is adjusted for any user port change,
apply the chip-wide setting only for CPU ports. This aligns the driver
to the behavior of other switch drivers.

Fixes: 6ae5834b983a ("net: dsa: b53: add MTU configuration support")
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Martin Willi <martin@strongswan.org>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index d3b37cebcfde8..2bf07a3980544 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2180,6 +2180,9 @@ static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
 	if (is5325(dev) || is5365(dev))
 		return -EOPNOTSUPP;
 
+	if (!dsa_is_cpu_port(ds, port))
+		return 0;
+
 	enable_jumbo = (mtu >= JMS_MIN_SIZE);
 	allow_10_100 = (dev->chip_id == BCM583XX_DEVICE_ID);
 
-- 
2.43.0



