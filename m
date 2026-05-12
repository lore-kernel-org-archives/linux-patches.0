Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F2D33ADBA;
	Tue, 12 May 2026 18:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609352; cv=none; b=FCcf9EfM1Q1I+5Jq0Y2TsArpVh5DiYWsREiq6UJ+adq2LjjrG/4RHuzfqm1Y/ntE+wgK+UbiUwCNjxmLE+fuS3QsnuQ71MTGCtSpl3EUuZ/SbpOovkQDs0xnbunp/txXp+jvwz8cQrCrMufaM8zha0aty2S7p0nTMdxp9x/20mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609352; c=relaxed/simple;
	bh=K8QTAfpx7KPzD31OuU1V14NISbOpINe4aOlkMccMcm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqOi8clMQ3pI/KmGCuLorFl3d//BY9D5aP+o8rUmkmMI/4Djr9nLSwrZAvGT6tkmMpyG/mXrVFpuCUtQaS123EH9c1/egZr3pd3zh4dfENQeicmSA5vkUxwh+enEjDvlN6o9NAGk2WDVO2jV7C/CVWgLAPh33AvEBcuioD4r6tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mIctzzHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mIctzzHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5B1C2BCB0;
	Tue, 12 May 2026 18:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609352;
	bh=K8QTAfpx7KPzD31OuU1V14NISbOpINe4aOlkMccMcm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mIctzzHSkjy1w17H11OnnejLduvOxuqYbBndetJ5V3XrSyjG5HBO7/NvJ29NqVNPh
	 Xn6ggtrSDQ5jz1xvNWKEHqBvIhF4w4f2I6iqb3WxvhWdCqOXNI3NdRH2C/I09TVmfp
	 zKcgLmS1wAKU2tyCWfo8YqVmyGpuWG8d3gETUy04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 120/307] netpoll: pass buffer size to egress_dev() to avoid MAC truncation
Date: Tue, 12 May 2026 19:38:35 +0200
Message-ID: <20260512173942.659865640@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit 76b93a8107574006b25495664304ea9237494d70 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/netpoll.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -608,14 +608,16 @@ EXPORT_SYMBOL_GPL(__netpoll_setup);
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
 
@@ -645,7 +647,7 @@ static int netpoll_take_ipv6(struct netp
 
 	if (!IS_ENABLED(CONFIG_IPV6)) {
 		np_err(np, "IPv6 is not supported %s, aborting\n",
-		       egress_dev(np, buf));
+		       egress_dev(np, buf, sizeof(buf)));
 		return -EINVAL;
 	}
 
@@ -667,7 +669,7 @@ static int netpoll_take_ipv6(struct netp
 	}
 	if (err) {
 		np_err(np, "no IPv6 address for %s, aborting\n",
-		       egress_dev(np, buf));
+		       egress_dev(np, buf, sizeof(buf)));
 		return err;
 	}
 
@@ -687,14 +689,14 @@ static int netpoll_take_ipv4(struct netp
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
 
@@ -719,7 +721,8 @@ int netpoll_setup(struct netpoll *np)
 		ndev = dev_getbyhwaddr(net, ARPHRD_ETHER, np->dev_mac);
 
 	if (!ndev) {
-		np_err(np, "%s doesn't exist, aborting\n", egress_dev(np, buf));
+		np_err(np, "%s doesn't exist, aborting\n",
+		       egress_dev(np, buf, sizeof(buf)));
 		err = -ENODEV;
 		goto unlock;
 	}
@@ -727,14 +730,14 @@ int netpoll_setup(struct netpoll *np)
 
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


