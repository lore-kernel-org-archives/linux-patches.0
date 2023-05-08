Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687A5168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D86C433D2;
	Mon,  8 May 2023 10:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540227;
	bh=RfxrjrlKLSFEzzkUPSJSpddJkAyVyldJ1gwff5YhI7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2qjd9KouecxIooLZDoIq90QLwLOQtCMv2BPchgJqKT4A1iKSMFqZdrbxYufovL/h
	 G2Gga1d/ogqoml49mcgQ4bdCclE2Netct9+B4212iGcIe5/QFMr4DgyywjRkjztaP8
	 4TJmWo+MXhbKU0y6eIOXjprvWYVjKZE1YWbxwnGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 285/611] vlan: partially enable SIOCSHWTSTAMP in container
Date: Mon,  8 May 2023 11:42:07 +0200
Message-Id: <20230508094431.643719575@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
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
index e1bb41a443c43..07e86d03d4bae 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -365,7 +365,7 @@ static int vlan_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 	switch (cmd) {
 	case SIOCSHWTSTAMP:
-		if (!net_eq(dev_net(dev), &init_net))
+		if (!net_eq(dev_net(dev), dev_net(real_dev)))
 			break;
 		fallthrough;
 	case SIOCGMIIPHY:
-- 
2.39.2



