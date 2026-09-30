Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B8251EE14;
	Wed, 30 Sep 2026 18:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793202; cv=none; b=alOtDgN8cPhcERS1q+m/Zs8Z+AgjzOG4KuwugHPIVkd6g2zHlDDDTKwr5qR8evbaJYrMkpB725QfiTLUdkr/agLkBuXKkRAYLX0hgAWr3MoRWzOacfsu1t8wOTJmDhAHo248qoYDIjbMRHUIApMsnIxZqQ4l6mEl2evq//l5jYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793202; c=relaxed/simple;
	bh=P2/XQkqDTGK4mKzl/BHyNsPb44rjjt2deoNNQktkbXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dt1LOoJTNFMUr4yjgqAAFpbH+zWMuyipBYJJlOXyorasbrpRtAYNOUGQag8N4ZFD67bV5m4/8gvToe0e3nMwEIIdEChAkasmGplRqqZbmAI2NtUqkY4Syc86d+IBt4fiPkSGlHm+GcAiwVcrJ9XWmy5cYskY6+aakMnbhL6Ri9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RFyXm3dP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RFyXm3dP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C1E1F000FF;
	Wed, 30 Sep 2026 18:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793200;
	bh=g8U9/UUd2aSTH2tDrHea0WPjEt2rbS/od2at9636mb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RFyXm3dP/pyw7pKANXmV9hiW4qs2Agy0xKqYENfzw9tjGwhxFyMztsRKTfyM9UWvS
	 KC8JAt9SP4btl4Djtnq048i3CykvAnGEvaN3AXVrYMATLvkG+PrbGCXwgHcOHIriw1
	 JGGOyCVPBc/LzPoT6RolqUym+Vvxfn5bMwYEVgQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 169/395] ip_gre: Reject enabling collect metadata through changelink
Date: Wed, 30 Sep 2026 17:27:11 +0200
Message-ID: <20260930152344.317874746@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 300b802125db2..b15cc4ee0d920 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1459,6 +1459,12 @@ static int ipgre_changelink(struct net_device *dev, struct nlattr *tb[],
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
@@ -1491,6 +1497,12 @@ static int erspan_changelink(struct net_device *dev, struct nlattr *tb[],
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



