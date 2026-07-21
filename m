Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18BC44AB9F;
	Tue, 21 Jul 2026 22:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674406; cv=none; b=mUuyrrDK86slp3WVQ9UucsJbW4QF3WMDT/72Tzldru1xsQMvMq0zFZudJcBr4/aoqaajw6O5Z1+nq/Dh2owdedZvar/yyEBXUuPAs4B6vidMAY9GZqkAS5oK5VPCyDnwXmLP+MwCSA0sKq72jJu8JvPL3RpRWfyshngeXQR3cXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674406; c=relaxed/simple;
	bh=MTed4CodgJaFEJqNx3hje86ztzc6fsAiMR0dNebgRgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9T3nM09zn9Wrzrx/bXGASUDQ/q0SpqFbbejFsViSifBnpTvxqPfEf4q/SoEXF8z+C7lZkHclWqooxWb7ohhEOVzdz69SQBwqiTDZ1qKmiPC3WOM0xdIx61Gglv9RsqcwId+OVarW4WFEw80szt2+e2PeF+hQCfP9my4BUxtj8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DAe+Qgb5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DAe+Qgb5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296231F000E9;
	Tue, 21 Jul 2026 22:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674405;
	bh=Kp5kr+xEFiNFGLAObPPOdP8Uyn4Usz7rTBa0ADB8Rsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DAe+Qgb5o1SNNq3s2/cXbX1ZXsov6Zk3TT9OoLAUmk9S/t/Qj70Wi9CI5HviKB2tj
	 IHyI429ChtHODi4G4wG8a1rqttWA5eviWrfH7QlmsVqRMIOEfZTTojTvAg5NnzWvtI
	 39Dt6dJSGsjzeMMLXE8j3ZbQeFRAtB/RK0k4lzpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 528/699] net: sit: require CAP_NET_ADMIN in the device netns for changelink
Date: Tue, 21 Jul 2026 17:24:47 +0200
Message-ID: <20260721152407.606675260@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit 27ccb68e7cccead5d8c611665a45d23032d468b3 upstream.

ipip6_changelink() operates on at most two netns, dev_net(dev) and the
tunnel link netns t->net. They differ once the device is created in or
moved to a netns other than the one the request runs in. The rtnl
changelink path checks CAP_NET_ADMIN only against dev_net(dev), so a
caller privileged there but not in t->net can rewrite a tunnel that
lives in t->net.

Gate ipip6_changelink() on rtnl_dev_link_net_capable() at its top,
before any attribute is parsed. sit was the one tunnel type not covered
by the recent series that added this check to the other changelink()
handlers.

Fixes: 5e6700b3bf98 ("sit: add support of x-netns")
Link: https://lore.kernel.org/netdev/20260612085941.3158249-1-maoyixie.tju@gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260618070817.3378283-1-maoyixie.tju@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/sit.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1670,6 +1670,9 @@ static int ipip6_changelink(struct net_d
 	__u32 fwmark = t->fwmark;
 	int err;
 
+	if (!rtnl_dev_link_net_capable(dev, net))
+		return -EPERM;
+
 	if (dev == sitn->fb_tunnel_dev)
 		return -EINVAL;
 


