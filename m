Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3EF3AAF6D;
	Mon, 17 Aug 2026 15:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979546; cv=none; b=cizugCqDBqt92j5ZHQqiqWnFaELDvKSunK9zq5en8NbxUiiHYFnyEJiSvgedWFMfM/N9ijoLnI9yeP9y1sg45p++eLanYJTxawfYHaI5G06A5LNjqZJcPQkuti0qp59C2DKH18HF99eGe+P2wue8VqaJ70xra3ZRJwzDcybt7xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979546; c=relaxed/simple;
	bh=U8zz4/M4KA+bte22AJxftknAAFix+qXp3SR0X8k/JHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5k6/tY3uBI9TAoiZl521Tla9wCLuHYfnPHCLMJklJXq5xla2Xx/o3rm7OvAwIj2aAvrqJv9hrxG9RsFL+Abb/ZBfpu7gqR1C65QxOW21LtcsNkEobIqCsp6uqDQWP2wZdRZcRpofCBAHbm4fcZojs5npmq4pdhFD6n3vT4/OaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnzj6y+J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnzj6y+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D539D1F000E9;
	Mon, 17 Aug 2026 15:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979545;
	bh=Hp6TzcoPWMgls2tYP1G1YUlBVZB6bTeLw5cYrqhMQRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rnzj6y+JxAzT6Juo3T0AVu4X1/qul6EP3jqb0Bb73iYwSWau7LLqjLtXAqxrYor3p
	 dAksUABesUqx6IwuEDVnM4PzWecX6MqcLPUqoEzygIK8hMBv6qqvaHWEFuuF9DQnT7
	 mj291oFqDFIttIAL6dLNLQmWF1GihTJVqo4+5mCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 262/609] vxlan: require CAP_NET_ADMIN in the device netns for changelink
Date: Mon, 17 Aug 2026 15:29:18 +0200
Message-ID: <20260817132552.877393097@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doruk Tan Ozturk <doruk@0sec.ai>

commit 3a61bd9637f3d929aa846e4eb3d98b48c26fcb0e upstream.

A tunnel changelink() operates on at most two netns, dev_net(dev) and
the sticky underlay netns vxlan->net. They differ once the device is
created in or moved to a netns other than the one the request runs in.
The rtnl changelink path checks CAP_NET_ADMIN only against dev_net(dev),
so a caller privileged there but not in vxlan->net can rewrite a vxlan
device whose underlay lives in vxlan->net.

vxlan_changelink() validates and applies the new configuration against
vxlan->net (vxlan_config_validate(vxlan->net, ...)) and can reopen the
underlay socket in that netns, so the same reasoning as the tunnel
changelink series applies here.

Gate vxlan_changelink() with rtnl_dev_link_net_capable(), at the top of
the op before any attribute is parsed, matching ipgre_changelink() and
the rest of the "require CAP_NET_ADMIN in the device netns for
changelink" series.

Found by 0sec automated security-research tooling (https://0sec.ai).

Fixes: 8bcdc4f3a20b ("vxlan: add changelink support")
Cc: stable@vger.kernel.org
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20260716203500.70573-2-doruk@0sec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan/vxlan_core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -4249,6 +4249,9 @@ static int vxlan_changelink(struct net_d
 	struct vxlan_rdst *dst;
 	int err;
 
+	if (!rtnl_dev_link_net_capable(dev, vxlan->net))
+		return -EPERM;
+
 	dst = &vxlan->default_dst;
 	err = vxlan_nl2conf(tb, data, dev, &conf, true, extack);
 	if (err)


