Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273DD18B465;
	Tue, 30 Jul 2024 16:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358025; cv=none; b=uK1w8eaSfwz/ojPF3mdad+9dOZZKaGRL6fWHeV0/mpk8hbVDLDXbaszXb8PdoJ7HgwNC5Pe3fip88HCp7NMkLyWE+ExMNnn7oN3DXXVc/UB0Ng9335tsNx1Y5rmdIQ+EvfzZBWUWYdeiSjnVnGbdepCJ1JJ2p3GCP5uNsBaCxto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358025; c=relaxed/simple;
	bh=1HqYrBjpv6LjmK14oweDYJSDW+/pfnYVDsQMSTqOk7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvz3kbJxykIFkBAs3ZSrJBYlQfAUOT9bCDAGhquDPkU3SDTKVAWo3JYUZQdEHxWIP0fMpPHwRKLm8nDXvED9wc0lj/5P1CRBHahk7srz8bFKbM+rLB0q3LsxOAUEFr09EN3bce930nB3oBmJ3hAKz6sKzhm3YSdiz5vz89Mt8YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3sdeh8x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3sdeh8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995ABC4AF1C;
	Tue, 30 Jul 2024 16:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358025;
	bh=1HqYrBjpv6LjmK14oweDYJSDW+/pfnYVDsQMSTqOk7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3sdeh8xWrKSO34+wLyk1qGf0kNcqtKNFUimcbIW7ZZMG3KIr/YysPvFcGy2PV8gQ
	 osvsD+RaTGFtZ6zQ7XrK3JqJhoFg5NliMqoS50rflOxe4bDn7n13XToyFuvjM3oMtw
	 ibLkQKhdoIXM9QhM9PbcTyMtGrtwuRfWIIgR0AAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <olteanv@gmail.com>,
	Martin Willi <martin@strongswan.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 318/568] net: dsa: b53: Limit chip-wide jumbo frame config to CPU ports
Date: Tue, 30 Jul 2024 17:47:05 +0200
Message-ID: <20240730151652.305711424@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4e27dc913cf71..ae1c4dc35fe33 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2265,6 +2265,9 @@ static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
 	if (is5325(dev) || is5365(dev))
 		return -EOPNOTSUPP;
 
+	if (!dsa_is_cpu_port(ds, port))
+		return 0;
+
 	enable_jumbo = (mtu >= JMS_MIN_SIZE);
 	allow_10_100 = (dev->chip_id == BCM583XX_DEVICE_ID);
 
-- 
2.43.0



