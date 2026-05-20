Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CD73F39EE;
	Wed, 20 May 2026 18:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301716; cv=none; b=aREKm+v92X6XULddlxXSgv83Xr87JDRNDk9vpRuhjrvYUAeHUYAngQucAtC5Kul0d3dKRlVhzozTKkuA1o3pT1JBzBGjlKX08kUPIiDGtTNRAmZe6hPUuULe2M8DusB7vkdpv5qNGvKkv/tod+oBhW3k2AqQIteCiuoPqLA5LDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301716; c=relaxed/simple;
	bh=TPkLz3f4w1iZNlNG4C4A/qx9t1S5+CE468q/QUNZu8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5Ref0v4FswA8WlJJrMGSAn0gY/xQXgBY0a4Fbb5B6hjl5ZLyX8Fe8Jm4t1SiNdm2Ke0X2JG+aN90ykwK51YLfzRaBGEH1yLlrS5L4NIZWZEW7U5QQlykHNfjFHhEeu4vUhYzQr6ZqrlJ5Sh3L6YsWX0htAs5zESAt5+mZd4aHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9iPPSW5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9iPPSW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BD41F000E9;
	Wed, 20 May 2026 18:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301715;
	bh=ytHbiwkHixxoClUuYrpOey8KbTW7u3q7XfCs4g1XhPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E9iPPSW58co273jTaDL0eKblr2KOAkpeKPVSJ0iqzlxK4q/3veZjKkeuIzClvSdIn
	 GAXtNTmZcRfgZjeq1jTbqj8ZOv0gw6MgJ+AQG4rNJyhm2WiHx3k/vVvKQVvdS4NI6z
	 FhU9CMDQUSY1nrlOofEsHz1s7tQjpgkvdMa84oXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 608/666] netpoll: pass buffer size to egress_dev() to avoid MAC truncation
Date: Wed, 20 May 2026 18:23:39 +0200
Message-ID: <20260520162124.447892384@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 76b93a8107574006b25495664304ea9237494d70 ]

egress_dev() formats np->dev_mac via snprintf() but receives buf as
a bare char *, so it cannot derive the buffer size from the pointer. The
size argument was hardcoded to MAC_ADDR_STR_LEN (3 * ETH_ALEN - 1 = 17),
which is silly wrong in two ways:

 1) misleading kernel log output on the MAC-selected target path
    (np->dev_name[0] == '\0'); for example "aa:bb:cc:dd:ee:ff doesn't
    exist, aborting" was logged as "aa:bb:cc:dd:ee:f doesn't exist,
    aborting".

 2) the second argument of snprintf is the size of the buffer, not the
    size of what you want to write.

Add a bufsz parameter to egress_dev() and pass sizeof(buf) from each
caller, matching the standard snprintf() idiom and removing the
hardcoded size from the helper.

Every caller already declares "char buf[MAC_ADDR_STR_LEN + 1]" so the
formatted MAC continues to fit.

Tested by booting with
  netconsole=6665@/aa:bb:cc:dd:ee:ff,6666@10.0.0.1/00:11:22:33:44:55
on a kernel without a matching device. Pre-fix dmesg shows
"aa:bb:cc:dd:ee:f doesn't exist, aborting"; post-fix shows the full
"aa:bb:cc:dd:ee:ff doesn't exist, aborting".

Fixes: f8a10bed32f5 ("netconsole: allow selection of egress interface via MAC address")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260501-netpoll_snprintf_fix-v1-1-84b0566e6597@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netpoll.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 59cb4d4d28e10..c48a47601c2f3 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -695,14 +695,16 @@ EXPORT_SYMBOL_GPL(__netpoll_setup);
 /*
  * Returns a pointer to a string representation of the identifier used
  * to select the egress interface for the given netpoll instance. buf
- * must be a buffer of length at least MAC_ADDR_STR_LEN + 1.
+ * is used to format np->dev_mac when np->dev_name is empty; bufsz must
+ * be at least MAC_ADDR_STR_LEN + 1 to fit the formatted MAC address
+ * and its NUL terminator.
  */
-static char *egress_dev(struct netpoll *np, char *buf)
+static char *egress_dev(struct netpoll *np, char *buf, size_t bufsz)
 {
 	if (np->dev_name[0])
 		return np->dev_name;
 
-	snprintf(buf, MAC_ADDR_STR_LEN, "%pM", np->dev_mac);
+	snprintf(buf, bufsz, "%pM", np->dev_mac);
 	return buf;
 }
 
@@ -732,7 +734,7 @@ static int netpoll_take_ipv6(struct netpoll *np, struct net_device *ndev)
 
 	if (!IS_ENABLED(CONFIG_IPV6)) {
 		np_err(np, "IPv6 is not supported %s, aborting\n",
-		       egress_dev(np, buf));
+		       egress_dev(np, buf, sizeof(buf)));
 		return -EINVAL;
 	}
 
@@ -754,7 +756,7 @@ static int netpoll_take_ipv6(struct netpoll *np, struct net_device *ndev)
 	}
 	if (err) {
 		np_err(np, "no IPv6 address for %s, aborting\n",
-		       egress_dev(np, buf));
+		       egress_dev(np, buf, sizeof(buf)));
 		return err;
 	}
 
@@ -774,14 +776,14 @@ static int netpoll_take_ipv4(struct netpoll *np, struct net_device *ndev)
 	in_dev = __in_dev_get_rtnl(ndev);
 	if (!in_dev) {
 		np_err(np, "no IP address for %s, aborting\n",
-		       egress_dev(np, buf));
+		       egress_dev(np, buf, sizeof(buf)));
 		return -EDESTADDRREQ;
 	}
 
 	ifa = rtnl_dereference(in_dev->ifa_list);
 	if (!ifa) {
 		np_err(np, "no IP address for %s, aborting\n",
-		       egress_dev(np, buf));
+		       egress_dev(np, buf, sizeof(buf)));
 		return -EDESTADDRREQ;
 	}
 
@@ -823,7 +825,8 @@ int netpoll_setup(struct netpoll *np)
 		ndev = dev_getbyhwaddr(net, ARPHRD_ETHER, np->dev_mac);
 
 	if (!ndev) {
-		np_err(np, "%s doesn't exist, aborting\n", egress_dev(np, buf));
+		np_err(np, "%s doesn't exist, aborting\n",
+		       egress_dev(np, buf, sizeof(buf)));
 		err = -ENODEV;
 		goto unlock;
 	}
@@ -831,14 +834,14 @@ int netpoll_setup(struct netpoll *np)
 
 	if (netdev_master_upper_dev_get(ndev)) {
 		np_err(np, "%s is a slave device, aborting\n",
-		       egress_dev(np, buf));
+		       egress_dev(np, buf, sizeof(buf)));
 		err = -EBUSY;
 		goto put;
 	}
 
 	if (!netif_running(ndev)) {
 		np_info(np, "device %s not up yet, forcing it\n",
-			egress_dev(np, buf));
+			egress_dev(np, buf, sizeof(buf)));
 
 		err = dev_open(ndev, NULL);
 		if (err) {
-- 
2.53.0



