Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79961C07DF;
	Tue, 15 Oct 2024 13:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997866; cv=none; b=YLnmjoXkX0mszzHSr0UQvN7caqEG4k0xaPu+KT0WFvoGKrQHePIVD/GiR418Op4UayW0rq2tGa+3pLmWsh3Ji3ZiJ+9W/MFhzntRWutyEcwL25s29vd0+JCh+kdEryfAd3FSy0SRx9duwWiTCCNC5VXLbbCkCoC3kjf37RczNAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997866; c=relaxed/simple;
	bh=sqNGJmy0gB4doe0nFuL0NQddvlUzzk0g57ku7REpnhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CuGRH5OhjMzfUTnvLOD8Df5FLVAimwTVoaA0ldJdFbFF/zFPs7f85oKp9Lpwuwugd+9GrRXab1sS/7DsOFEHeOlhhfhz2hX23GzqaCf2EcZgsGjtLszqpfncJd0AesNVPAhEBD/tW4WKuMJSX3bhVJOd/I5X5FfBtWG7+P29ElE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pafkvyKV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pafkvyKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A94CC4CEC6;
	Tue, 15 Oct 2024 13:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997866;
	bh=sqNGJmy0gB4doe0nFuL0NQddvlUzzk0g57ku7REpnhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pafkvyKVf2EPaTIyxJOQCo+OxgpMdiU0doZhWfQyR4IlPVpSQgiKmzJ8OzlfUFR7A
	 3jmkALQFm4woViNI9iICNpGDoQ8CV8LhW2iacIRGMLyhhsbDPtJY9o3OCCjAgpClHY
	 tbR/j/X+XX+1VZxrLUu+UzP7nU3hjDKUDEuulD2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 311/518] ipv4: Check !in_dev earlier for ioctl(SIOCSIFADDR).
Date: Tue, 15 Oct 2024 14:43:35 +0200
Message-ID: <20241015123928.985315718@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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
index 9ac7d47d27b81..7868f316a477f 100644
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



