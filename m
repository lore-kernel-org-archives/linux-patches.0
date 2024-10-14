Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E471AF4F6;
	Mon, 14 Oct 2024 15:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918853; cv=none; b=qn+tjKaF6K+nD7pALxEnpX9qVGTtIMqG0XLKbRBMtSar1FdYQpzsfYRWctmKNqaxdwZYiaifmGFz23Noc9GBz4i/dYtW5ZlbA0cvQg7K2jLRnyfJCvg47P8num2RABsU8We1zAIE/IpYG+0Aq1HW7tLHcT0aG9lY+oF051Ibmog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918853; c=relaxed/simple;
	bh=Vb9jA3LZiVrVgI/SEnvAbzuXlQhpgfTEbXGlQJ2aI2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AL9ko238sVtDTnqxmhTNaJTRB+TJqxKrgE+xR/4fEC8RbBxqW/2IgNWJUt3br9/ygsMn0c+kCgpeJF0XHwYNDLsB3xq2E0QyoEDZPfUAz6pGrpq3Tnuw8vOMevx81rHdfcqckAlpARA3Q7fPmZ9JAUtGc9JwU0LbkP4sQh2mrzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVdCKF5e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVdCKF5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EC8C4CECF;
	Mon, 14 Oct 2024 15:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918852;
	bh=Vb9jA3LZiVrVgI/SEnvAbzuXlQhpgfTEbXGlQJ2aI2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVdCKF5ekI231UpvOtI5iZ4TnpLgjR2sRV6P2dY1T42ySmSqC5/vc/I7ewRRG96Ix
	 I8/mRrREOWOf1XZ5VoijxuQREGVNVGjpUqd876pUSxKsJLO0wNmrGLhJI0W3aAQJHj
	 ZVX/EOvB3cCyVexvvIpmE+eEWJwHkXVxurfLw2RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 442/798] ipv4: Check !in_dev earlier for ioctl(SIOCSIFADDR).
Date: Mon, 14 Oct 2024 16:16:36 +0200
Message-ID: <20241014141235.336898556@linuxfoundation.org>
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
index bb0d1252cad86..f07778c340984 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -567,10 +567,6 @@ static int inet_set_ifa(struct net_device *dev, struct in_ifaddr *ifa)
 
 	ASSERT_RTNL();
 
-	if (!in_dev) {
-		inet_free_ifa(ifa);
-		return -ENOBUFS;
-	}
 	ipv4_devconf_setall(in_dev);
 	neigh_parms_data_state_setall(in_dev->arp_parms);
 	if (ifa->ifa_dev != in_dev) {
@@ -1153,6 +1149,8 @@ int devinet_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr)
 
 		if (!ifa) {
 			ret = -ENOBUFS;
+			if (!in_dev)
+				break;
 			ifa = inet_alloc_ifa();
 			if (!ifa)
 				break;
-- 
2.43.0



