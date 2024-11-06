Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3321DF24A;
	Wed,  6 Nov 2024 12:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895259; cv=none; b=BRpllNZMijldMHuKTw7uPxC3Klpqy4iD5lZ8ekeJB8mzEY65OAifgbraOHJ3Bk+D8NlHVnP04EFj8iJcbjZ3qLRoG/M6MxQd9k97rEOE7vjEhfckorBdW75p/yoQLTvloTUtIeXCRP0yEmeB/mdIZR5bixvtgqK7jCbVxw6x+yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895259; c=relaxed/simple;
	bh=fFZ4iRhkovHR0TcO3/gM1smk0wCyYkGzy3KqQ18LpP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4WVdR4gIMQ3VmF7t3dvSSrHTBd2UpmW3RICYjeshom3frhc7U4aiqMlWwuSkMnKwIJmmFroTYfjlEMpPF4xZpTaxzTQqt+n68P10WuMuTHpNLD6qBlXOXc1nSHXmsSlxBLNZiFhm29CfPrmlz+EAr9QtDwK7yWEsRQu8D0aWFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xb/aOU2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xb/aOU2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D01DC4CED2;
	Wed,  6 Nov 2024 12:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895258;
	bh=fFZ4iRhkovHR0TcO3/gM1smk0wCyYkGzy3KqQ18LpP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xb/aOU2Kp8mKTnb+xzluO7olLE6np1y6ko7dpXUSUw3Wiqb25YUzlCDmQkeETorVU
	 tEB+sTc3d4MivSKw83SCwU1RzisBGVQJfHxKe7LnTSrd5Z7hanscmRXttsLvxzCLl6
	 +HBBGBKEDFK1xBhzb4xFOs1JlLtTcHF3aFodsT24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 157/350] ipv4: Check !in_dev earlier for ioctl(SIOCSIFADDR).
Date: Wed,  6 Nov 2024 13:01:25 +0100
Message-ID: <20241106120324.798168898@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index e2ab8cdb71347..e4fea3adb0652 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -541,10 +541,6 @@ static int inet_set_ifa(struct net_device *dev, struct in_ifaddr *ifa)
 
 	ASSERT_RTNL();
 
-	if (!in_dev) {
-		inet_free_ifa(ifa);
-		return -ENOBUFS;
-	}
 	ipv4_devconf_setall(in_dev);
 	neigh_parms_data_state_setall(in_dev->arp_parms);
 	if (ifa->ifa_dev != in_dev) {
@@ -1113,6 +1109,8 @@ int devinet_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr)
 
 		if (!ifa) {
 			ret = -ENOBUFS;
+			if (!in_dev)
+				break;
 			ifa = inet_alloc_ifa();
 			if (!ifa)
 				break;
-- 
2.43.0



