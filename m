Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A844723CE;
	Wed,  7 Aug 2024 15:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042926; cv=none; b=B/vuUBwVWvIaD13VYrOySKJKAYPM+x0hrEuRRa9UuHH78yFC/ErWlYZVlxLhzGMcsWx7GvxHOmJyTgngCwa8Z9pEUzC5e2raJ32jvyCLpB/UqYs371j45SBWPb5Tmj/cvIQHS42IfgUhbfTtsULyUU1514OG3gtVWpEObcdO2BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042926; c=relaxed/simple;
	bh=ldz1amlNmF4b3lz0Ro4+awzmu/2D5x7gtAu37PrxjtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKxxDhXGRf0sCd6euDn2rj07URJcmHfpqDaoryaas0oyfQEUVthleTFix7WEMBOIbELPM3177WbLhOJ38IuM0vZfnPyJmVUbkWWrP5lDLXguIznXeokyOURIug148cp8sNvljFF0X9rFQnGkRWXkjDIhWK0xt7j0grmOjRkukpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qswRUuN/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qswRUuN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380B4C4AF0B;
	Wed,  7 Aug 2024 15:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042926;
	bh=ldz1amlNmF4b3lz0Ro4+awzmu/2D5x7gtAu37PrxjtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qswRUuN/AsOtmc6CjXOeEJKjApD+sH6xXtpOsCgxTigOBiZwMxiYREbfRV9TDX1OL
	 UaDjbbGNPYh7RUD+8nFNaa3w+cb7IVjwhDpcrKUedrWOC9zAzTA2ajeEVejTBHPL5q
	 Yy3EtGg/HgSLTwFtlG8ENISmsw5wn+7FrNq+YQZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Joe Damato <jdamato@fastly.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 026/123] ethtool: rss: echo the context number back
Date: Wed,  7 Aug 2024 16:59:05 +0200
Message-ID: <20240807150021.661582647@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit f96aae91b0d260f682e630e092ef70a05a718a43 ]

The response to a GET request in Netlink should fully identify
the queried object. RSS_GET accepts context id as an input,
so it must echo that attribute back to the response.

After (assuming context 1 has been created):

  $ ./cli.py --spec netlink/specs/ethtool.yaml \
             --do rss-get \
	     --json '{"header": {"dev-index": 2}, "context": 1}'
  {'context': 1,
   'header': {'dev-index': 2, 'dev-name': 'eth0'},
  [...]

Fixes: 7112a04664bf ("ethtool: add netlink based get rss support")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Joe Damato <jdamato@fastly.com>
Link: https://patch.msgid.link/20240724234249.2621109-3-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/ethtool.yaml     | 1 +
 Documentation/networking/ethtool-netlink.rst | 1 +
 net/ethtool/rss.c                            | 8 +++++++-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
index 3632c1c891e94..238145c31835e 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -1638,6 +1638,7 @@ operations:
         reply:
           attributes:
             - header
+            - context
             - hfunc
             - indir
             - hkey
diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 160bfb0ae8bae..0d8c487be3993 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1800,6 +1800,7 @@ Kernel response contents:
 
 =====================================  ======  ==========================
   ``ETHTOOL_A_RSS_HEADER``             nested  reply header
+  ``ETHTOOL_A_RSS_CONTEXT``            u32     context number
   ``ETHTOOL_A_RSS_HFUNC``              u32     RSS hash func
   ``ETHTOOL_A_RSS_INDIR``              binary  Indir table bytes
   ``ETHTOOL_A_RSS_HKEY``               binary  Hash key bytes
diff --git a/net/ethtool/rss.c b/net/ethtool/rss.c
index 71679137eff21..5c4c4505ab9a4 100644
--- a/net/ethtool/rss.c
+++ b/net/ethtool/rss.c
@@ -111,7 +111,8 @@ rss_reply_size(const struct ethnl_req_info *req_base,
 	const struct rss_reply_data *data = RSS_REPDATA(reply_base);
 	int len;
 
-	len = nla_total_size(sizeof(u32)) +	/* _RSS_HFUNC */
+	len = nla_total_size(sizeof(u32)) +	/* _RSS_CONTEXT */
+	      nla_total_size(sizeof(u32)) +	/* _RSS_HFUNC */
 	      nla_total_size(sizeof(u32)) +	/* _RSS_INPUT_XFRM */
 	      nla_total_size(sizeof(u32) * data->indir_size) + /* _RSS_INDIR */
 	      nla_total_size(data->hkey_size);	/* _RSS_HKEY */
@@ -124,6 +125,11 @@ rss_fill_reply(struct sk_buff *skb, const struct ethnl_req_info *req_base,
 	       const struct ethnl_reply_data *reply_base)
 {
 	const struct rss_reply_data *data = RSS_REPDATA(reply_base);
+	struct rss_req_info *request = RSS_REQINFO(req_base);
+
+	if (request->rss_context &&
+	    nla_put_u32(skb, ETHTOOL_A_RSS_CONTEXT, request->rss_context))
+		return -EMSGSIZE;
 
 	if ((data->hfunc &&
 	     nla_put_u32(skb, ETHTOOL_A_RSS_HFUNC, data->hfunc)) ||
-- 
2.43.0



