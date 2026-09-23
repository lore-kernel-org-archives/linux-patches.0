Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC1F531625;
	Wed, 23 Sep 2026 14:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174934; cv=none; b=o0I6PMF4sU8QDaPT2H87L9zfLKOx6tP5NtZwYqFuYLstLIsZQYdA9pwdHeyJyj/ypuXrTgqfa5KBjocYUCCkTuwFJcZUD5FmyeiFVq1uiY53hp5y55SQ2b97tm5VGuuVktNDQ4Tkx6h3zuHxQxGi0K1p++cdDkQSXMpLUzITTuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174934; c=relaxed/simple;
	bh=sxpvza96YGNgsAYzj4/ss+XzursL10nq4YwKim3q3js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLU/5q88C2KTxZTGg7v5F6frTsde3y8OFnG6vIMRBdY+Z2eHYVHVbSgXmDSAfvMp7cfVyPz5OTESXY1dGC0FGORGDCNyezWvhRnpPjwxwPg7823Sv2fwaH8wL9Dli1Lu/JgQ9G5pCwv6/lyYnW28DGha7zCBb1gjCePJbko6u0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAbno7tQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAbno7tQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6E91F000FF;
	Wed, 23 Sep 2026 14:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174932;
	bh=qZFPdoS7JSc7sAEHE96q/klZ9n4VU4DxBrva6LA4D5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wAbno7tQXWZgLUzTZX7zmIw8s3z5FBTpLzVF3Las8SgsNMBYLuf1EmTPcmkfH+Iry
	 YV22OqsBocQORj4tO2889m2jEQ8op3Ns9IzsDPT2p6mT/5zfTchXRDDv0YQGd6MajK
	 +Nyeb9aP/CGoa5RZdb+bXbo6QHbvU0uBLP+/7NFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gris Ge <cnfourt@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 243/398] net: ip_tunnel: initialize `options_len` before referencing options
Date: Wed, 23 Sep 2026 16:05:17 +0200
Message-ID: <20260923140649.712696637@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Gris Ge <cnfourt@gmail.com>

commit 455ebeadf714f51e1dbbd6a022c74c9215b1cd76 upstream.

The following command triggers a kernel panic:

  ip link add d0 type dummy; ip link set d0 up
  ip route add 10.30.0.0/16 \
    encap ip id 300 geneve_opts 4660:66:11223344 dev d0

  memcpy: detected buffer overflow: 4 byte write of buffer size 0
  kernel BUG at lib/string_helpers.c:1044!
  ...
  ip_tun_parse_opts.part.0.cold+0x10/0x10
  ip_tun_build_state+0x116/0x2a0

On kernels built with GCC 15+ and `CONFIG_FORTIFY_SOURCE`, the fortified
`memcpy()` got 0 sized destination with request of 4 bytes length:

  static int ip_tun_parse_opts_geneve(...)
  {
      ...
      attr = tb[LWTUNNEL_IP_OPT_GENEVE_DATA];
      data_len = nla_len(attr); /* == 4 */

      struct geneve_opt *opt = ip_tunnel_info_opts(info) + opts_len;
      memcpy(opt->opt_data, nla_data(attr), data_len);
      /*     ^^^^^^^^^^^^^ 0 since options_len is assigned afterwards */

Fixed by initializing the counter before the options are referenced.
Matching what `tunnel_key_opts_set()` already does.

Fixes: bb5e62f2d547 ("net: Add options as a flexible array to struct ip_tunnel_info")
Cc: stable@vger.kernel.org
Signed-off-by: Gris Ge <cnfourt@gmail.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://patch.msgid.link/20260913090851.468216-1-cnfourt@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel_core.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 5168d546ea2f..bab42b9e277f 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -680,8 +680,14 @@ static int ip_tun_get_optlen(struct nlattr *attr,
 }
 
 static int ip_tun_set_opts(struct nlattr *attr, struct ip_tunnel_info *info,
-			   struct netlink_ext_ack *extack)
+			   int opts_len, struct netlink_ext_ack *extack)
 {
+	/* `options_len` is the __counted_by() annotation of the `options`
+	 * flexible array, it must be initialized before parsing writes
+	 * into it.
+	 */
+	info->options_len = opts_len;
+
 	return ip_tun_parse_opts(attr, info, extack);
 }
 
@@ -712,7 +718,8 @@ static int ip_tun_build_state(struct net *net, struct nlattr *attr,
 
 	tun_info = lwt_tun_info(new_state);
 
-	err = ip_tun_set_opts(tb[LWTUNNEL_IP_OPTS], tun_info, extack);
+	err = ip_tun_set_opts(tb[LWTUNNEL_IP_OPTS], tun_info, opt_len,
+			      extack);
 	if (err < 0) {
 		lwtstate_free(new_state);
 		return err;
@@ -753,7 +760,6 @@ static int ip_tun_build_state(struct net *net, struct nlattr *attr,
 	}
 
 	tun_info->mode = IP_TUNNEL_INFO_TX;
-	tun_info->options_len = opt_len;
 
 	*ts = new_state;
 
@@ -1006,7 +1012,8 @@ static int ip6_tun_build_state(struct net *net, struct nlattr *attr,
 
 	tun_info = lwt_tun_info(new_state);
 
-	err = ip_tun_set_opts(tb[LWTUNNEL_IP6_OPTS], tun_info, extack);
+	err = ip_tun_set_opts(tb[LWTUNNEL_IP6_OPTS], tun_info, opt_len,
+			      extack);
 	if (err < 0) {
 		lwtstate_free(new_state);
 		return err;
@@ -1040,7 +1047,6 @@ static int ip6_tun_build_state(struct net *net, struct nlattr *attr,
 	}
 
 	tun_info->mode = IP_TUNNEL_INFO_TX | IP_TUNNEL_INFO_IPV6;
-	tun_info->options_len = opt_len;
 
 	*ts = new_state;
 
-- 
2.55.0



