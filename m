Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1E047011A;
	Tue, 21 Jul 2026 19:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662999; cv=none; b=DlVxb4ZK8xgy+a1JItcmOGrZGXPYf1cXSyXe0VDWg60yaLO72XnL4mAgVphgMRUsS/TbCEuskB/KwPtakHujeOKew7nVHpfp6WuCXFt/rsYmbWQ9zMT+CteEPx6xgVeggQ+xhOpKNMyHWioGFbPn1LbWhTgdhWgLf+DnFhSpUk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662999; c=relaxed/simple;
	bh=cMju9YiFw1gx1+RSmlSYHMUXaDUS39HHD12SD1LwAEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdaPmSjT1MqJzXxEbMy5vmaTzDm69CmG2UaNPvcRycNggcpXml98ZSOTE0WLBzPmNNN897qJoAYWcr5dv44ZKqNWMe2GNTKyv0HlW3VoxRZngWRex+yqLNDsFIZB7bsHsWmPaic39ogoRpuWMc5c4BE9cxcz/pkrnohgmAlnUIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c72qIVNT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c72qIVNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1321F000E9;
	Tue, 21 Jul 2026 19:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662998;
	bh=McY28KQk11gwQwAp+A6gcSREmsji6eX+UyfG3f6zxWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c72qIVNTiY55G1GWPjy5VxDOCvL1rkPMaEJqN572qFxA84BnKXr5/PrY0OGvgrJqF
	 VtQTXCfyu5hdVlk3SkSX1Sxc4VQ6DZClVnfdvi04gKJO8GeewglQr3X6MQUZa4zokZ
	 8EY3byskpQ7Tf6HQkcRS84Y/8XKWRBIv7ZPUCcqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0658/1276] ipv6: fix error handling in ignore_routes_with_linkdown sysctl
Date: Tue, 21 Jul 2026 17:18:21 +0200
Message-ID: <20260721152500.833171075@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit cf4f2b14401f29ccac56393ca9e4b42a2505f540 ]

When writing to the ignore_routes_with_linkdown sysctl, if
proc_dointvec() fails to parse the input, it returns a negative error
code. The current implementation is overwriting that error for write
operations.

This results in a silent failure, it returns a successful write although
the configuration was not modified at all. When modifying the "all"
variant it can also modify the configuration of existing interfaces to
the wrong value.

Fix this by checking the return value of proc_dointvec() and returning
early on failure.

Fixes: 35103d11173b ("net: ipv6 sysctl option to ignore routes when nexthop link is down")
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260622130857.5115-3-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index b8fb9f429fc50a..d9684be8ec0753 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6658,6 +6658,8 @@ int addrconf_sysctl_ignore_routes_with_linkdown(const struct ctl_table *ctl,
 	lctl.data = &val;
 
 	ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
 
 	if (write)
 		ret = addrconf_fixup_linkdown(ctl, valp, val);
-- 
2.53.0



