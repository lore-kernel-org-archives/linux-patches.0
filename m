Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488E2FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A446AC4339C;
	Mon, 15 May 2023 16:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168950;
	bh=BmY2/NjYOVUdtnWQwfRNC9GZccEWeBLHaTRcXE3hlgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FlRSjoLiHrksc+vUB0twD43EhCI0COlbBZzGRciMP+OY2hqYSXDvAd2HVkBZMrFcY
	 fobcXoiofsqvZ1i4SRZZIv7/FQpz4+mSZ7VvhRcBsAYxkwsg334csZb6csnTKWYrpy
	 Gq8uBL9C44+MFtvHIOFOzi5WhMHYSmA8vGm8GRRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 054/191] vlan: partially enable SIOCSHWTSTAMP in container
Date: Mon, 15 May 2023 18:24:51 +0200
Message-Id: <20230515161709.178139801@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vadim Fedorenko <vadim.fedorenko@linux.dev>

[ Upstream commit 731b73dba359e3ff00517c13aa0daa82b34ff466 ]

Setting timestamp filter was explicitly disabled on vlan devices in
containers because it might affect other processes on the host. But it's
absolutely legit in case when real device is in the same namespace.

Fixes: 873017af7784 ("vlan: disable SIOCSHWTSTAMP in container")
Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/8021q/vlan_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 84ef837721141..c80add6edf598 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -369,7 +369,7 @@ static int vlan_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 	switch (cmd) {
 	case SIOCSHWTSTAMP:
-		if (!net_eq(dev_net(dev), &init_net))
+		if (!net_eq(dev_net(dev), dev_net(real_dev)))
 			break;
 	case SIOCGMIIPHY:
 	case SIOCGMIIREG:
-- 
2.39.2



