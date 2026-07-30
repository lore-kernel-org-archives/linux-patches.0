Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B821449B04;
	Thu, 30 Jul 2026 16:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427861; cv=none; b=CiYhT2zxUj+zTA28ujPMB7ex/TW47dZReKzoD0Z4QAWfILohP5LAgOeREs5R70i7b/3/kdZfr2k341yfWXAIzBjeERXDA1A+SvFIIE/f8c1OnioLTqm0V/kdaYmHrQZXlKthVHJvYh2YuB6jT7zteLUbYONWB9gfkZlgCn3xTfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427861; c=relaxed/simple;
	bh=dF9B6cu4GtUM7zq+z9XPYzhoXaY55r9fEafGJYw3mSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2OXHUR7F4TaYiKD7I+xkLJoHDlyL5NUPZPylbICGXA9TD2vrBIv3+BXtBmJbN74Y3pUNwwFqNGrtE0Ngg3gyDFsHtlPRLnCFRnJiSMcu94mx4N2a0jYaaPJ59n+VXUOiGULBooFcAW91b5nM7yY8tRLu6KUYfxg1xp1oD2MC4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWXiPJXb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWXiPJXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2C11F000E9;
	Thu, 30 Jul 2026 16:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427860;
	bh=O0hWW61mMk4BhdaZij+cRL3Uc0qh6oEgWl2xVvD/69g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EWXiPJXbVFGOYx6tfVXEmDAU8a5+YBDZXDJ7X/VIxfSnfV/FMuq+2H3HiHeZ78MsE
	 8FBN7Rk7vtebdh9HH5B2NJIUpukwnqZzeeovk+zj+eI8EnEblXKnAeDerKYoL4GbB5
	 iOQDjU7ZEWG2gk+1BhG3DGXMQ3/VzDzfoOOUG9dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 317/484] vxlan: require CAP_NET_ADMIN in the device netns for changelink
Date: Thu, 30 Jul 2026 16:13:34 +0200
Message-ID: <20260730141430.373497960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
@@ -4257,6 +4257,9 @@ static int vxlan_changelink(struct net_d
 	struct vxlan_rdst *dst;
 	int err;
 
+	if (!rtnl_dev_link_net_capable(dev, vxlan->net))
+		return -EPERM;
+
 	dst = &vxlan->default_dst;
 	err = vxlan_nl2conf(tb, data, dev, &conf, true, extack);
 	if (err)


