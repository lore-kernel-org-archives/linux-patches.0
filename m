Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A25C5158B7;
	Wed, 30 Sep 2026 16:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787352; cv=none; b=h4eGvkFApe5Oo2cn9EHZmkYOF71pZuYBQEbCuGctlVMJ8UITW14TTZDyN0onMMhOAXgITD5p9UEz6UgU8RveFtZ4IIFUmyMw+EYBl9zeOdjHLWbolO/0Kr6zzzrL+zkDRUWRQQIWfsN+nu3DP6ffOKHyN+N9JQARd2Jpm8Rmbz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787352; c=relaxed/simple;
	bh=ktbOIypLK8GnjrcWSE1S/W6UqOaacUsQ02XyoVwmG6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWgIX2Drp3Xi4GjxFce6W4tteei58p9ILfY1ROjpzCVsV0twG1QZ9Cu3Mq7znIDRkMGaaYHOmtnSinJfSiAlocsNN1y7kYn2Bhdr8fB7Bp2eObGs1jyn8IQp2+sGy4UD1xEisdn+/ikdqPXzdWExOpru+qtouflf9C3M5Sjkd7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XkZw5o/y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XkZw5o/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C091D1F000FF;
	Wed, 30 Sep 2026 16:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787351;
	bh=YCgJxaLGscOXYoDTXEc6wcI5X1Jg8qu9GIAM8gNqGdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XkZw5o/yRWRbE0wpzjKRDklTr6FX1ifh1vlvBMaOeoxtLkvGsU2JMH+JqjjIq5+Jm
	 aIr5rCiMGlK+PnlPTzurW4KZxCCh01Bc777QNz4AltanjweknYFD+xk1GtvxqmJ738
	 4ONHF/RKmIqzXnLY1EvdxyffRu/jA7gj/giDLJv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 198/457] ip_gre: Reject enabling collect metadata through changelink
Date: Wed, 30 Sep 2026 17:25:03 +0200
Message-ID: <20260930152350.327448621@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 0ba1e94e9012c..384c02b9700b8 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1460,6 +1460,12 @@ static int ipgre_changelink(struct net_device *dev, struct nlattr *tb[],
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
@@ -1492,6 +1498,12 @@ static int erspan_changelink(struct net_device *dev, struct nlattr *tb[],
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



