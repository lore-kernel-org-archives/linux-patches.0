Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E0E379C35;
	Wed, 30 Sep 2026 15:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783841; cv=none; b=EcHRNuWscUlbwROVnVSGuBWX9exJS36t3Gssj8RVoFIITMCmSVa+cOR1vKcE42pNTtcTd24125Y+2WrFIBPBoLNbjFL6jM8m3RN65gfz7I37CdZaCRRqv+PgdvCxN8JIhjun+Sgw1mWpxFpl0Zf3w7zlX8fDkIaBp9UD72YmKeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783841; c=relaxed/simple;
	bh=VNjzi6VDWqfxDQLyMUdvZhvQfRKSs5Z/pPdxeNmDb3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VG57x/LaZnsXJdnDvPfRE1oFpXl78szyO4S+RbSYiHYnyZZ5ECjQ71NeiK1TkKWcvA0q7N1YgYjjn9/2wYUTSjXnWyxY5r5Y5cEaB7RRPGFVvC7GPaEnbV0ZPH/9Ch/i3JMTz5cjtimX3zJBRMRQZ7o4ngSpgjhZxxON31ec2o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A7TPSzMG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A7TPSzMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D6E1F00893;
	Wed, 30 Sep 2026 15:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783835;
	bh=3uokCi/QnGuYFrL3aUDx5yw9V6cX1ZGi46O3M9/Pgd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A7TPSzMGhJUW8ZRTwdcZXhNWieiJsV4fIoQpijAi1NJtmQTbOVZXxmSYfqST2htxF
	 PEd1TTmgtCud2Skr5nnJuHvlGnwVXMX2U4hA6zWR3zj2WkC80e2PokCt01BctiPBJU
	 ZZC3wOyXA9EsdtaL+/sRGhxT9+qy1Xz4INPe/ZEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 537/595] ip_gre: Reject enabling collect metadata through changelink
Date: Wed, 30 Sep 2026 17:27:10 +0200
Message-ID: <20260930152359.258456510@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

[ Upstream commit a3f315be9d30eeb6938d11fa17fd4b32d52f7c42 ]

ipgre_netlink_parms() can enable collect_md on an existing GRE, GRETAP
or ERSPAN device. Unlike newlink, changelink does not enforce metadata
tunnel uniqueness. Converting a non-metadata device can therefore
replace the metadata receive entry for another device of the same type
in the same netns. Deleting either device then clears the shared entry,
breaking metadata receive lookup for the surviving device.

If parameter validation fails after collect_md is set, deleting the
modified device can also clear an entry it never owned.

Reject enabling metadata mode in both changelink callbacks before any
encapsulation or tunnel parameters are modified. Allow requests that
repeat the metadata attribute on an existing metadata device.

Fixes: 2e15ea390e6f ("ip_gre: Add support to collect tunnel metadata.")
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20260921031859.9283-1-xuanqiang.luo@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_gre.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 213d29fe190c1..edab2f31fd85a 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1410,6 +1410,12 @@ static int ipgre_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (!rtnl_dev_link_net_capable(dev, t->net))
 		return -EPERM;
 
+	if (data && data[IFLA_GRE_COLLECT_METADATA] && !t->collect_md) {
+		NL_SET_ERR_MSG(extack,
+			       "Enabling collect_md on an existing device is not supported");
+		return -EOPNOTSUPP;
+	}
+
 	err = ipgre_newlink_encap_setup(dev, data);
 	if (err)
 		return err;
@@ -1442,6 +1448,12 @@ static int erspan_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (!rtnl_dev_link_net_capable(dev, t->net))
 		return -EPERM;
 
+	if (data && data[IFLA_GRE_COLLECT_METADATA] && !t->collect_md) {
+		NL_SET_ERR_MSG(extack,
+			       "Enabling collect_md on an existing device is not supported");
+		return -EOPNOTSUPP;
+	}
+
 	err = ipgre_newlink_encap_setup(dev, data);
 	if (err)
 		return err;
-- 
2.53.0



