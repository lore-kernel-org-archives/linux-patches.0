Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CE31A6160;
	Tue, 30 Jul 2024 16:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356874; cv=none; b=OKwYIrDzb2O/Iz6tOsSDpyoz0vgS4fhPp5QO2NK6XAmzx+1+qhPG+mZCKk7dlmQOfvGxsXQH7u2sphhdkASH6tkzSvyHg6K0GwR1l8SIHyGb7L4arW7B7Kiz03xoimUxPvKQejJjClhh00yvr6lCeseoSptPLavfbfjHeVMiV7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356874; c=relaxed/simple;
	bh=RjavC9fklaraUhxUaV+J1UZ2MdFKuRTPEwllrWGr4uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLF5MjjFd4Kiz3sIAJmHq6TD/2FeC0kRLKuYBIk4j/VVeWp9f4PBhsFLvpTxKoo72jwlZT3qrHCOnkMGKF8l2/F4oPhXikTB2ubGFrog9gGkvprF7/2j0rgM+JQPZbyOfTFicA7TTDtVlbltqp/CrNFuB8eU4AauR3xAiGqhCGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lR8qTH75; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lR8qTH75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B138C32782;
	Tue, 30 Jul 2024 16:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356874;
	bh=RjavC9fklaraUhxUaV+J1UZ2MdFKuRTPEwllrWGr4uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lR8qTH75VoHgwxZTq+sAql2II44xZNXYhZArUDAuL4uIWlmeINfWbtP+bs7L1DZdV
	 tRfBJmCHzB1qnE3OQo4zTNedbKO5firPmfsBtCg9ksWO5eLZ21JuG0LuTFUHiWLhAC
	 Ok+cIcl2m0HBzo6sjob57u2WydcBYRFFyD4DXnTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <olteanv@gmail.com>,
	Martin Willi <martin@strongswan.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 237/440] net: dsa: b53: Limit chip-wide jumbo frame config to CPU ports
Date: Tue, 30 Jul 2024 17:47:50 +0200
Message-ID: <20240730151625.111513722@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 59cdfc51ce06a..922e5934de733 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2221,6 +2221,9 @@ static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
 	if (is5325(dev) || is5365(dev))
 		return -EOPNOTSUPP;
 
+	if (!dsa_is_cpu_port(ds, port))
+		return 0;
+
 	enable_jumbo = (mtu >= JMS_MIN_SIZE);
 	allow_10_100 = (dev->chip_id == BCM583XX_DEVICE_ID);
 
-- 
2.43.0



