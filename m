Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177E145A2B3;
	Tue, 21 Jul 2026 20:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667517; cv=none; b=PfFCLxs8DsqzxHwXC0eZPjzt1oVBM5Ste9b98180hbK5pmeamdWGQ+i9f0O00ekRLmtuV1xuLthbZYs22aZJhGc92a3fWBRZvijp8hEbHnG2RIuEyWEBM8k5KFuprWQ7iUEaxAM7yJCWD1+6yreOrXSpPYOZf+H0KNTfzDqgx7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667517; c=relaxed/simple;
	bh=nujpCZ2Wln0jHfoueVfU6LZEhlJBWKj6BwknRI64B8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2QUa0puxvMrt/Mt0Z7tgjF4y8QoydXyYNAXQUKg20BTc0qsG63arOCysAhC9T8wOjcurre/+0hYj9IhD9WxLNUEk7rPk1jmYjZXiQgj2yOcerN4syGHyjBx/b8SpWbzJPUecadeUOtv2sL1Qnltwlr/xXdjo2blTQOlAa/3PQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h88f14Ml; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h88f14Ml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B7D1F00ACA;
	Tue, 21 Jul 2026 20:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667506;
	bh=ywHEKd/G3N60YL3Y8rZ45+pggN7+UIdHqECvsFcmh9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h88f14MlJhrEYMXq6XIPTe0qk14j/CubtPq3J1qmVxCrD1MBRj/qFIxpy9D/eBW1S
	 tN86BtmdXONDDc59KaSGU3HliNecoeyqnYVBD/wlqI9BQIZ5mmp1rulLBm/5gcUjkW
	 pLEWq1H/EaUnTXC4SMvkI5qDnpGkRTxKpMEvrK3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 1087/1266] net: ipip: require CAP_NET_ADMIN in the device netns for changelink
Date: Tue, 21 Jul 2026 17:25:24 +0200
Message-ID: <20260721152506.135870849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit 8211a26324667980a463c069469a818e71207e02 upstream.

ipip_changelink() operates on at most two netns, dev_net(dev) and the
tunnel link netns t->net. They differ once the device is created in or
moved to a netns other than the one the request runs in. The rtnl
changelink path checks CAP_NET_ADMIN only against dev_net(dev), so a
caller privileged there but not in t->net can rewrite a tunnel that
lives in t->net.

Gate ipip_changelink() on rtnl_dev_link_net_capable() at its top,
before any attribute is parsed.

Reported-by: Xiao Liang <shaw.leon@gmail.com>
Closes: https://lore.kernel.org/netdev/CABAhCOSzP1vaThGV35_VnsRCb=87_CPjPVsTHbq905k8A+BuUg@mail.gmail.com/
Fixes: 6c742e714d8c ("ipip: add x-netns support")
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260612085941.3158249-3-maoyixie.tju@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ipip.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -457,6 +457,9 @@ static int ipip_changelink(struct net_de
 	bool collect_md;
 	__u32 fwmark = t->fwmark;
 
+	if (!rtnl_dev_link_net_capable(dev, t->net))
+		return -EPERM;
+
 	if (ip_tunnel_netlink_encap_parms(data, &ipencap)) {
 		int err = ip_tunnel_encap_setup(t, &ipencap);
 


