Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA191CFEA9;
	Tue, 15 Oct 2024 11:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993483; cv=none; b=kZOBJrX7dObpyo1usqQb6tCLqSVIAV04EsYzo7ywLU8YL8mwlvmU3MsHxi9WhHsPsgjNPZVy/BpUB8guK2Zfy+U77B4uCBKqupWpSl6mSbhKZ/fsjLADDyytC/y5NStLe4ZRhe6kNfLYZH0dvTqV3CKw9qq3pdcpLYHelW7iNPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993483; c=relaxed/simple;
	bh=ZW7Fno8RrYgmRYU0amYruOl+/dVUgzmAC7fSbwyi7/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i22ghpEB0qblKKKjPdvRjB7WMGXUAlbpLDUZBR0sKIK13Iigwwq/7dsXdJ7wzVppfe358cMvCaH8yufxXDOUP2UAp1rBwJ96NRAgQSg2CglnIv+B65btfnGv9lrM5ZOCChCB4xclFmspnIGr9we0r9K7FZYUpyWnRPmyi27pAKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDLd5nlL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDLd5nlL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B32C4CECE;
	Tue, 15 Oct 2024 11:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993483;
	bh=ZW7Fno8RrYgmRYU0amYruOl+/dVUgzmAC7fSbwyi7/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDLd5nlLLmJpu195LMA24RkoktK5cdgkFccNSyYH6e4cl62pVMDT3Ky8mPAjRiog6
	 yj+Z0At0jwYxz1PeFxaQYrXdV8Opo3rvyv0UN7eOOKhmnJIV5WrnYPBYDCC0UH/FNj
	 1qBjwQ5mrhqMCC7BPlp8FOnaLNaVIkUrDw1a4j80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 426/691] ipv4: Check !in_dev earlier for ioctl(SIOCSIFADDR).
Date: Tue, 15 Oct 2024 13:26:14 +0200
Message-ID: <20241015112457.251123256@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 425dfa8e4fd0a..da0f49d77c011 100644
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
@@ -1149,6 +1145,8 @@ int devinet_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr)
 
 		if (!ifa) {
 			ret = -ENOBUFS;
+			if (!in_dev)
+				break;
 			ifa = inet_alloc_ifa();
 			if (!ifa)
 				break;
-- 
2.43.0



