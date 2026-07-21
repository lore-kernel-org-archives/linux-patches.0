Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0023B47DF;
	Tue, 21 Jul 2026 20:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666833; cv=none; b=k62B4JlGGLkGlYrCxTJvBs0ABsQgXUbTHKHnVs6+sttRM52PDZDPgCBqilWxK22OxL9mUdIf6qxMQvlz2GfVHKnleUpSu+kJbxHUI8VFbi7hG7ulwpsIT2r/0Z3QaN/46ojAnNns2C5j+094iD5XFioOl/tnKgQpd2139MC9y+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666833; c=relaxed/simple;
	bh=vtAac+QIV2+5hFqPYj6cjP9Gc8gEmkm6QTibh8v2sjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGJlKasTmRsPndDhwa7O3lFrbYb+QCPIi6TOYm4Rs3Ix/ff9xE2BuZLHNaZU3JiOGdkVcxWgzQkpOgkiBAZxvn8AN7QfOJpi9f1Z0gm8ab2czC1qVRoi+D8OUrQQWavWddB8dXnDbG8u56QD+jUUo1o/wIeiJUIQY+9dmWEKyoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r83wz+aO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r83wz+aO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0811F000E9;
	Tue, 21 Jul 2026 20:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666832;
	bh=rAn4ZO6jTvFvYeTflYfjiPSBRdtuWWFdOvU9nVmtWks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r83wz+aO9/s0BXMsFBaYCpsObOiSsY1bIwp38LXU70PORUb1sSqYfy1/xa7kuR2o6
	 DHireaYkBXD/GG8MqwYc26/IW6tBt/4+d5sPmTULFisVTPtJ9vDPVG3GS78iAxP7ZM
	 gCK2w7RPGnTWTIAeIjz0oG8UCArGD8wqEJT3LFjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0789/1266] ipv6: fix error handling in forwarding sysctl
Date: Tue, 21 Jul 2026 17:20:26 +0200
Message-ID: <20260721152459.517380242@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 058b9b19f9639fe1e1225a17c540f61b65bee6ad ]

When writing to the forwarding sysctl, if proc_dointvec() fails to parse
the input, it returns a negative error code. The current implementation
is overwriting that error for write operations.

This results in a silent failure, it returns a successful write although
the configuration was not modified at all. When modifying the "all"
variant it can also modify the configuration of existing interfaces to
the wrong value.

Fix this by checking the return value of proc_dointvec() and returning
early on failure. In addition, adjust return code of
addrconf_fixup_forwarding() for successful operation.

Fixes: b325fddb7f86 ("ipv6: Fix sysctl unregistration deadlock")
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260622130857.5115-4-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index cd981fbbc60a19..de50c77f087ff7 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -916,7 +916,7 @@ static int addrconf_fixup_forwarding(struct ctl_table *table, int *p, int newf)
 
 	if (newf)
 		rt6_purge_dflt_routers(net);
-	return 1;
+	return 0;
 }
 
 static void addrconf_linkdown_change(struct net *net, __s32 newf)
@@ -6344,6 +6344,8 @@ static int addrconf_sysctl_forward(struct ctl_table *ctl, int write,
 	lctl.data = &val;
 
 	ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
 
 	if (write)
 		ret = addrconf_fixup_forwarding(ctl, valp, val);
-- 
2.53.0



