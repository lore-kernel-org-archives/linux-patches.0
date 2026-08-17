Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E67B3DB636;
	Mon, 17 Aug 2026 14:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975851; cv=none; b=c1YA69bNmA/tvezasBbrCmi4F3ujqtrFt+PzfJlDYux66Bj9DsxgBQ7CxU1A90G1RX0/ZsHhBQnnanmQwKnVgJYPvYdku8xOgakHbLQSvSdo0O7LL7eyILOEMfU1NtuYasRcFNPVdsQfNFLVYyUgOm6WbrtWX15W4mVJoUYy/0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975851; c=relaxed/simple;
	bh=OCpfyqqeD9PGV6C59RzRSp0/GXYt4bqWD6P9U7fZnc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgzeyFeoDj95+1QymzeZZ77jHQDAMkryJ2mnmD81nwD1FdQxAJ0ERW8ueluJX+BRw6cwbWO1svdmiyGKMtyicxlEkN3j8SirJN986CBKq4ujWxDf2fuERYNGiYNuiUfLfaOqy0eLjn+/Y0pKgh5SH41Uohzx35lJxKnHltDoO/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmIjuZBq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmIjuZBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F631F000E9;
	Mon, 17 Aug 2026 14:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975850;
	bh=ebEbcpRTiQhRq4jOkac9cg4k7xvwEKgZNDvRVlW9l48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wmIjuZBqcTvpxEMdGV4jJ7wQcZUYf1Y8IwnZXddSJ8kJodmq4U9LtMFzlZCojfEhj
	 GyP+uz+afCUdrFDBMK5R7AWglFqbtgn9dJeeU6JUW/EW8FdPzoRCOCytzxsl2+a1kv
	 f2oprAYq53+IgCcl6zvrtM1IBTpvO9sqr3YYQ/EI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 170/389] vxlan: require CAP_NET_ADMIN in the device netns for changelink
Date: Mon, 17 Aug 2026 15:30:09 +0200
Message-ID: <20260817132545.806847643@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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
@@ -4255,6 +4255,9 @@ static int vxlan_changelink(struct net_d
 	struct vxlan_rdst *dst;
 	int err;
 
+	if (!rtnl_dev_link_net_capable(dev, vxlan->net))
+		return -EPERM;
+
 	dst = &vxlan->default_dst;
 	err = vxlan_nl2conf(tb, data, dev, &conf, true, extack);
 	if (err)


