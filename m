Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326261DE4CD;
	Tue,  8 Oct 2024 13:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393284; cv=none; b=JyDPrIW5nQ39E6SF/oIRcmE0AZGoem5rsyMzMmgmNahA5udaGxDuLcirvIzjw1pylTw5J4S/5zFLLCpa9xWSSIOWNPqx5gnQOgxaq6G2GD8Iu/zLwvh/y0YxoOpmDAYU+b+niU7YRtDfuXp6PlJ0wbzFLGZ3I563fP0t4hwW8Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393284; c=relaxed/simple;
	bh=b2ImvXYhi4xnNxCHu737vQmqxx1sksf0QPZVVokgBf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahLwwRpw6jui76PX7yhremNwaA18NSGo1Nj+mJCgjbbZiwvo3gDnG6EZgr15J+sZXAMTQ0GIBZXI/wP9/AemP/sNSmkTbiqTRBHF7PHa/OAXIn/wDz43NupEwOTi0gzFzamPIn51LW1UPYkpBiSRNxWhIJCdae2Hxak1tsGKErE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bz5Ukl/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bz5Ukl/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3260BC4CEC7;
	Tue,  8 Oct 2024 13:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393283;
	bh=b2ImvXYhi4xnNxCHu737vQmqxx1sksf0QPZVVokgBf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bz5Ukl/7DbqBay3ai+GSOs6z9Icrc1JoJeCSC6T6fN8K+JzhymffXyn+21jLzWzDa
	 O0ETLal8Blxp8Jv734iG/fpbapBa3mBIbmN3NGulG0+nptOC8dWF7wNrXUBfdNCm02
	 3mQhAtAQbHmdWudMZzAfZ7lolIncw2J/EGzeL9I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/386] ipv4: Check !in_dev earlier for ioctl(SIOCSIFADDR).
Date: Tue,  8 Oct 2024 14:05:34 +0200
Message-ID: <20241008115632.957697811@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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
index bc74f131fe4df..cb0c80328eebf 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -569,10 +569,6 @@ static int inet_set_ifa(struct net_device *dev, struct in_ifaddr *ifa)
 
 	ASSERT_RTNL();
 
-	if (!in_dev) {
-		inet_free_ifa(ifa);
-		return -ENOBUFS;
-	}
 	ipv4_devconf_setall(in_dev);
 	neigh_parms_data_state_setall(in_dev->arp_parms);
 	if (ifa->ifa_dev != in_dev) {
@@ -1174,6 +1170,8 @@ int devinet_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr)
 
 		if (!ifa) {
 			ret = -ENOBUFS;
+			if (!in_dev)
+				break;
 			ifa = inet_alloc_ifa();
 			if (!ifa)
 				break;
-- 
2.43.0



