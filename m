Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB43D27F16D;
	Tue, 27 May 2025 17:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368340; cv=none; b=dCfwsAZj8foUl28TMqPOcrdPZLcNz14SKc86ypbAs0fFzph58+I4/6E8qJw+CmTi3BsleEFa4T4RkFLcdUh6Lx13XWgfx39BTrkaxjYywRQN494kNgtzBq9J0Fe6+yV8csjN2X+FJbzyrkootXGUuQAbzPvCYOfZoM7icVTVh3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368340; c=relaxed/simple;
	bh=cjXxtciFfJHL+rfEDzGVlbEuqevLudF5Hwtvbq6Z45g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BO+Ld7BVL0cGfJ1yh/axgerfaPZY0pG7PlVQvLuv1SfJS66bQI3m3k49xmRdYCHhoLYqpp+Os0IOH8v5NqG7OxKGRPd8FyPYN6U4yAnuyOXvJrPTuBvp+dPESskfCm1t0tA6xVWs6Ml5tKynXtsJv8hmEmXykHadiACnH1FqDFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fn+XMn5j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fn+XMn5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9C7C4CEE9;
	Tue, 27 May 2025 17:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368340;
	bh=cjXxtciFfJHL+rfEDzGVlbEuqevLudF5Hwtvbq6Z45g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fn+XMn5jSmqECu9HjgpW/LJMRM+n5Pr6WlBhdsCb1TsAyDYHqK397LKZsAaUqXJdQ
	 WTjDY8J3lMTzCqJ9qhYAB3UOHikksJIyUKrebSXz27wyvV4iktM9aBQ18BUVJT3p8V
	 xHsGN8tSMAsHgWv+aRv+qkkGk5hY4vTjP5qHJCw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Marco Leogrande <leogrande@google.com>,
	Antoine Tenart <atenart@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 646/783] net-sysfs: restore behavior for not running devices
Date: Tue, 27 May 2025 18:27:23 +0200
Message-ID: <20250527162539.447575268@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 75bc3dab4e49b4daccb27ad6ce8ce2fcd253fc1b ]

modprobe dummy dumdummies=1

Old behavior :

$ cat /sys/class/net/dummy0/carrier
cat: /sys/class/net/dummy0/carrier: Invalid argument

After blamed commit, an empty string is reported.

$ cat /sys/class/net/dummy0/carrier
$

In this commit, I restore the old behavior for carrier,
speed and duplex attributes.

Fixes: 79c61899b5ee ("net-sysfs: remove rtnl_trylock from device attributes")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Marco Leogrande <leogrande@google.com>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Link: https://patch.msgid.link/20250221051223.576726-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net-sysfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 07cb99b114bdd..88e001a4e0810 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -232,11 +232,12 @@ static ssize_t carrier_show(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
 	struct net_device *netdev = to_net_dev(dev);
-	int ret = -EINVAL;
+	int ret;
 
 	if (!rtnl_trylock())
 		return restart_syscall();
 
+	ret = -EINVAL;
 	if (netif_running(netdev)) {
 		/* Synchronize carrier state with link watch,
 		 * see also rtnl_getlink().
@@ -266,6 +267,7 @@ static ssize_t speed_show(struct device *dev,
 	if (!rtnl_trylock())
 		return restart_syscall();
 
+	ret = -EINVAL;
 	if (netif_running(netdev)) {
 		struct ethtool_link_ksettings cmd;
 
@@ -292,6 +294,7 @@ static ssize_t duplex_show(struct device *dev,
 	if (!rtnl_trylock())
 		return restart_syscall();
 
+	ret = -EINVAL;
 	if (netif_running(netdev)) {
 		struct ethtool_link_ksettings cmd;
 
-- 
2.39.5



