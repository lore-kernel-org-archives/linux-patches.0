Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782BA1E1C33;
	Wed,  6 Nov 2024 13:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898349; cv=none; b=uJoaE3wAP8mXt2Zn2Ux+40Rpa+S7yoeja7jRr8mXx6ofzv/ARLxpsI+yhPpCK5YlO9xtTp1QaFfbWjt9fbqMn0a+uWp57/LKjH2nVduyfK5ZIw1nnEldvWa0+KviyeX6AnPIM/ZrVZvib+o9r4fV+keWZmsJyW4AK6ZjscM95Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898349; c=relaxed/simple;
	bh=wcBLnzZkVDj3QTpH1s7TDbKkVBvxTuxflzGvGA+oBpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLuX47Z9KySEnxpgAvdPIPuIQoA8/B4zqycgLWHNZYLwJitsMOlLNmdcGH0tP+IN0Yu8bxgPUxaDgHMJGKQauVZg8hUdHv7NCBgK2CE5yXCJPau4QqFKmsQ2IYDsi3sPj13IwFFQzdWT9zFKzTdMW90lsl+XSgp9Q9I8uhuCYKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JujdwSPg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JujdwSPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7DAC4CECD;
	Wed,  6 Nov 2024 13:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898349;
	bh=wcBLnzZkVDj3QTpH1s7TDbKkVBvxTuxflzGvGA+oBpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JujdwSPgU4DNaVJPkrqrh8XVZj5kzInciRlW9o1JIFF99J+y4c/deYEUmXO8+xd5n
	 8DYrhCIBzRpxFQYsCY9JEFEXA60VLybMg0crVpZV1X5jSOp0BimctDK3Sv9JuEvYcQ
	 Gxp96FN/MYtWQUQI7TT+n+lwHBVa9rLVTuyvnFlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 208/462] ipv4: Check !in_dev earlier for ioctl(SIOCSIFADDR).
Date: Wed,  6 Nov 2024 13:01:41 +0100
Message-ID: <20241106120336.654954673@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit e3af3d3c5b26c33a7950e34e137584f6056c4319 ]

dev->ip_ptr could be NULL if we set an invalid MTU.

Even then, if we issue ioctl(SIOCSIFADDR) for a new IPv4 address,
devinet_ioctl() allocates struct in_ifaddr and fails later in
inet_set_ifa() because in_dev is NULL.

Let's move the check earlier.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20240809235406.50187-2-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/devinet.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index ed00b233cee2e..dec884bf73f05 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -566,10 +566,6 @@ static int inet_set_ifa(struct net_device *dev, struct in_ifaddr *ifa)
 
 	ASSERT_RTNL();
 
-	if (!in_dev) {
-		inet_free_ifa(ifa);
-		return -ENOBUFS;
-	}
 	ipv4_devconf_setall(in_dev);
 	neigh_parms_data_state_setall(in_dev->arp_parms);
 	if (ifa->ifa_dev != in_dev) {
@@ -1150,6 +1146,8 @@ int devinet_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr)
 
 		if (!ifa) {
 			ret = -ENOBUFS;
+			if (!in_dev)
+				break;
 			ifa = inet_alloc_ifa();
 			if (!ifa)
 				break;
-- 
2.43.0



