Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E2D1CA8D;
	Mon, 14 Oct 2024 15:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919906; cv=none; b=gQRcylZ7xRLw7jNv4o6qcwJfzHR6ZgBqXKASOvO7zSb74rx4qXwaSaZG9Jg1q2HMp8BieAzs7iu4o7bLrpIYADeL4jOqOPZ8f18kj2nkiTlXM6GlKz29mXN+EqqYXl3X8+s6PjcNx3kHxS5GsTCdSGM+42gnCMHr397D/3OX9uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919906; c=relaxed/simple;
	bh=D5MoLRtUBYAyvjeaCJYr2k6OftlHTMwJWabnCsxuYH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=coRQm0YuTZfAhBbYD+m/1JKrIwMIvON6dn1LMIponrkBU3hml60diXJBuEUFlxCTP3BOIuj1kROXNm4HMM7srYhFFA9zDWKNCJmNa3GN78kwVYywBFq8oGe9C0UeEtTFuL5NnjfTwg0JhR2RmizC+AlfOzAck4lnhKsQ7+cCNL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WT8PjsD+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WT8PjsD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BB1C4CEC3;
	Mon, 14 Oct 2024 15:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919905;
	bh=D5MoLRtUBYAyvjeaCJYr2k6OftlHTMwJWabnCsxuYH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WT8PjsD+Tt+k65Z/Ol8NY7nwGDITXca3tKUJ++Kj1IPL8Gxe4HgzUl5soA8mXHg/Q
	 9A3EvI/a6cCGjhRtfkX7KIZmyxP4bifdIIMH/WqFdRb3SvyLjB8/sDbr6eMkJwqRC2
	 omqtKylnHUv41epr2p9AadIu08FQ2idUThUL/ICQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 742/798] net: dsa: b53: fix jumbo frame mtu check
Date: Mon, 14 Oct 2024 16:21:36 +0200
Message-ID: <20241014141247.221786958@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 42fb3acf6826c6764ba79feb6e15229b43fd2f9f ]

JMS_MIN_SIZE is the full ethernet frame length, while mtu is just the
data payload size. Comparing these two meant that mtus between 1500 and
1518 did not trigger enabling jumbo frames.

So instead compare the set mtu ETH_DATA_LEN, which is equal to
JMS_MIN_SIZE - ETH_HLEN - ETH_FCS_LEN;

Also do a check that the requested mtu is actually greater than the
minimum length, else we do not need to enable jumbo frames.

In practice this only introduced a very small range of mtus that did not
work properly. Newer chips allow 2000 byte large frames by default, and
older chips allow 1536 bytes long, which is equivalent to an mtu of
1514. So effectivly only mtus of 1515~1517 were broken.

Fixes: 6ae5834b983a ("net: dsa: b53: add MTU configuration support")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 922e5934de733..862150c54e88e 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2224,7 +2224,7 @@ static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
 	if (!dsa_is_cpu_port(ds, port))
 		return 0;
 
-	enable_jumbo = (mtu >= JMS_MIN_SIZE);
+	enable_jumbo = (mtu > ETH_DATA_LEN);
 	allow_10_100 = (dev->chip_id == BCM583XX_DEVICE_ID);
 
 	return b53_set_jumbo(dev, enable_jumbo, allow_10_100);
-- 
2.43.0



