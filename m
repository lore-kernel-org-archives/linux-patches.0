Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0353B14AB;
	Wed, 23 Sep 2026 14:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173683; cv=none; b=WIAgWm8ypFmmFG3QLv0XD42IFJPkGzlT/PG6ld5oYfiAdKspRwekqnFvFAoM83OX4BrrHwMbHcUoWamdDAnKfTwWIAuUxmoPcOiBt3GX15HdEXnSUS3aQ0SIvxbivdx5egs3f0xHBDaPzRex+INHyBb0p74yQjBKUCkRhzPFFFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173683; c=relaxed/simple;
	bh=xapTjpJhBkTaCuxPYiZ2yCdJwrnpZDYxrJmz8Lktlhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kajxkIOd4uTfDyeWTi0i1HlwxBocrPI5JzALKlLTAXJE8XRCI4O+g1RT+I684PvtxA2nMqHmV4Mxi1syx7N4NLfraZbo78brWdctULiy+HawN1tK5BTGpJZ6xUE7x2KG8j1iQIS1it1HdLfjOdsT0ybe+9W1qcFiESngW0iOAP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kX/uB11x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kX/uB11x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4620D1F00893;
	Wed, 23 Sep 2026 14:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173681;
	bh=Fyu2a9KQSFPSl2ZUe4CPem+ewfmVNOl4lnnyT4EjGgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kX/uB11xMMn/oVaQGmg+yd+Sri86kyJsRCXf4IVhfbNEE280Hn2MGA+by+ecmXamF
	 HtwNelDPaBozt/TxEtPaPBndp67wvqrwOMEbWNhML//UWs43w1AGTsNvAAzrmMVDMu
	 TCDkKw380pAZQgwhE8ln3tw1kHiMsz6zWFlKFHYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gris Ge <cnfourt@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 295/438] net: ip_tunnel: initialize `options_len` before referencing options
Date: Wed, 23 Sep 2026 16:05:16 +0200
Message-ID: <20260923140652.423334554@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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
 net/ipv4/ip_tunnel_core.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -680,8 +680,14 @@ static int ip_tun_get_optlen(struct nlat
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
 
@@ -712,7 +718,8 @@ static int ip_tun_build_state(struct net
 
 	tun_info = lwt_tun_info(new_state);
 
-	err = ip_tun_set_opts(tb[LWTUNNEL_IP_OPTS], tun_info, extack);
+	err = ip_tun_set_opts(tb[LWTUNNEL_IP_OPTS], tun_info, opt_len,
+			      extack);
 	if (err < 0) {
 		lwtstate_free(new_state);
 		return err;
@@ -753,7 +760,6 @@ static int ip_tun_build_state(struct net
 	}
 
 	tun_info->mode = IP_TUNNEL_INFO_TX;
-	tun_info->options_len = opt_len;
 
 	*ts = new_state;
 
@@ -1006,7 +1012,8 @@ static int ip6_tun_build_state(struct ne
 
 	tun_info = lwt_tun_info(new_state);
 
-	err = ip_tun_set_opts(tb[LWTUNNEL_IP6_OPTS], tun_info, extack);
+	err = ip_tun_set_opts(tb[LWTUNNEL_IP6_OPTS], tun_info, opt_len,
+			      extack);
 	if (err < 0) {
 		lwtstate_free(new_state);
 		return err;
@@ -1040,7 +1047,6 @@ static int ip6_tun_build_state(struct ne
 	}
 
 	tun_info->mode = IP_TUNNEL_INFO_TX | IP_TUNNEL_INFO_IPV6;
-	tun_info->options_len = opt_len;
 
 	*ts = new_state;
 


