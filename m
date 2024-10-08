Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55CD1DC759;
	Tue,  8 Oct 2024 12:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391476; cv=none; b=OqgeFygb6oR4QSLfSMxsUrGRjrq/uATuhdxDpcJ3Q/kjJ8nUoJhKIXLrX9h3TCfZ7+vaKmh72oAUitB0K2dNtRNyy/bz8Y6UPQIoAuoZV0RWPTZKhJvliiGpnct9wdE+f/xwqa3/hHGgVipY+UWKiKHsB6CwJJuaEpclZDmiU5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391476; c=relaxed/simple;
	bh=7hZOdFkkecq9Fr0W2I5jDwX+VYRGhxBNJCGDzs6MNBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMKnQI0/AysnDEtbcY0ZrZ1J/395VkttZFSD+2dDseuiv0LgOIhgLY5ndDNcXdhac1SOc+gErte8R0Nq3T/kWBqTchEioyhgYkGLGznfff7UHeUjPlSizTypBSJ/k/KR2DnSt+6G0RDILOAK7qmfhPy4roQrwPLF+wUd4CCntuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EgIKD5IR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgIKD5IR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528AFC4CECD;
	Tue,  8 Oct 2024 12:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391475;
	bh=7hZOdFkkecq9Fr0W2I5jDwX+VYRGhxBNJCGDzs6MNBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EgIKD5IRsEXpZm6DcoGOkHdk6eIN3lUq3flEBG7cYJol67Werwz+Rq/1xu3/g3aYl
	 f3x20vFnJAZijxjYsWWpXZXGS85NSfQ3zL+IfvhvPP8PU9egQiPgft1r4uVoayXYWV
	 whmw7NnvmcnioC+O3naibL89qwSU+MJ8Zh6DNFG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 126/558] ipv4: Check !in_dev earlier for ioctl(SIOCSIFADDR).
Date: Tue,  8 Oct 2024 14:02:36 +0200
Message-ID: <20241008115707.323205806@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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
index d96f3e452fef6..ddab151164542 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -574,10 +574,6 @@ static int inet_set_ifa(struct net_device *dev, struct in_ifaddr *ifa)
 
 	ASSERT_RTNL();
 
-	if (!in_dev) {
-		inet_free_ifa(ifa);
-		return -ENOBUFS;
-	}
 	ipv4_devconf_setall(in_dev);
 	neigh_parms_data_state_setall(in_dev->arp_parms);
 	if (ifa->ifa_dev != in_dev) {
@@ -1184,6 +1180,8 @@ int devinet_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr)
 
 		if (!ifa) {
 			ret = -ENOBUFS;
+			if (!in_dev)
+				break;
 			ifa = inet_alloc_ifa();
 			if (!ifa)
 				break;
-- 
2.43.0



