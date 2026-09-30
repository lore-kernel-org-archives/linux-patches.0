Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C2736F905;
	Wed, 30 Sep 2026 19:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796877; cv=none; b=WK0YSnjLlMkd3qprY3phA5hUEvbXRs0OpE+ZdJOr3pfRcW+W93lUzwtEileQApchFXajKfrUzJWRm8nhlivFMb6tbX0BynoAQLb1kOstEN3kCTfr2aRF4oKAaf1pKY/ZHAhAD/BkphVxmmfSfRXagUfygQc21rN0UR5y2oXXqcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796877; c=relaxed/simple;
	bh=QwoK+FDVsn3UfSuHoqXhIgfBsXAm9iQB19XkAGG6c58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZvBzM9MhKMnu0e9eAIVAwOnTsDEseAcSGB6wgRTvhADwHeMGRn9HOQewnklJJxZaxUXD91UvqvFpZ6B/PHoTcYzv1uxhFczuyg+Jt3xaoat6jWjcUdDavUvGQGrid62A/bX1D8/nsp7OkhJFPBrnMY+4DuNQyYQe9i3LzCNqld4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NE4aFgFh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NE4aFgFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32D91F00898;
	Wed, 30 Sep 2026 19:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796876;
	bh=keejtJoKiZfRAwMmaSxT0A4F+JexWkb8dt0zNCS6QVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NE4aFgFhy/2V9SPJFfP5yPz7hhPo9pgets3rt3uxPG4hsKIipw6q3uK+9m8Xq6m2M
	 pVssMgDo5ZRuYt7X5ONHP4KKDAaaOiRT8JtVrfM+Me8ywnkkGOluCX7T69nOhEHt83
	 W2e6kUbprtmb5n11BPZgVxgldXLn96nKqq2T6yDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1068/1193] ip_gre: Reject enabling collect metadata through changelink
Date: Wed, 30 Sep 2026 17:29:12 +0200
Message-ID: <20260930152457.950090647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index b5ebfee9a8faf..4e72b2a37a635 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1416,6 +1416,12 @@ static int ipgre_changelink(struct net_device *dev, struct nlattr *tb[],
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
@@ -1448,6 +1454,12 @@ static int erspan_changelink(struct net_device *dev, struct nlattr *tb[],
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



