Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96F0432311;
	Mon, 17 Aug 2026 14:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977101; cv=none; b=cAcnHuyN4f5c7VLSJKjATOwopL9v4nVgm4eZdTpyon4tBKLMRMD4kg0zCS2zanEJUOSZZ1GN1Sp3wRXByEVpR3BAsqQIK8E2qtYfJOobpVjeRzzZUw+0oZ71ibjEThmX5YIVAQk8aF9y1I6BWWOrl9vGmSOtoL8FOl/GmTaJu5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977101; c=relaxed/simple;
	bh=1DgR0zgUghZ2geCoL/m9JvmCP2G6X4Xat5WDMGdEOcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chVTmRHHbKIdD/yMR5POT/Z86IvILhAUtXoftQ+B8wu15M4B1YNb0ay9AkB3b94ms1KvVLhj+dxfakYbXwdnFeohTp7JFtjpBejUCmHGnlc9Sd0aNXr/JHSkvfQ3BLFV7i0l9Uf6zm/Ps2N8shaYr65aNXo4iljTsfjnGJ3krkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MAT/UHDb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MAT/UHDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406871F000E9;
	Mon, 17 Aug 2026 14:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977099;
	bh=cR9weTSbLYr7vzXTu6v2IWojzT0d+u3gXuR1a2rYv48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MAT/UHDbVVwuSa+6AKf3T32sqkNkrU+TQv+NWuLpCwmghUubTdHXNWIybcVqxbbNT
	 k3k47pf0tTFsQLnYM2bXihz0YA1cpcKBXZNLXSznjX6iKRhwg3vm/+2g1C6lYxCWua
	 KCxyhLJrKLUvxUNwN8v/rUfdEwxtGvpOKcpAc5Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 212/456] vxlan: require CAP_NET_ADMIN in the device netns for changelink
Date: Mon, 17 Aug 2026 15:30:02 +0200
Message-ID: <20260817132548.458716382@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4259,6 +4259,9 @@ static int vxlan_changelink(struct net_d
 	struct vxlan_rdst *dst;
 	int err;
 
+	if (!rtnl_dev_link_net_capable(dev, vxlan->net))
+		return -EPERM;
+
 	dst = &vxlan->default_dst;
 	err = vxlan_nl2conf(tb, data, dev, &conf, true, extack);
 	if (err)


