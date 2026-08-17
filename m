Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D1D317144;
	Mon, 17 Aug 2026 14:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975350; cv=none; b=q7yHJ6pFxkRTFIqri2Aazcl93roBkkPrsaZDsP9R7iiKgxvCbq9ZfgwIflNnSDC/c/rlAAX+85uilk/V+Wojlg5keogzhh1MA1DqQ6YO6ZxkW54gtxjP+sVBPCSjZbR6d1csx/uQ/ytSKftkDtF4IzXnqllmk2VDMgqjE9eeP1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975350; c=relaxed/simple;
	bh=KHKEC9lkeg1+Uv6/yzpesiXVHtqbrekjmJ9mftePcJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDIn5mnEX7japKaaa+HGNA6eNX0kE7AtQOZPg8D/SnXXWjIi1n7/l78JPW7S8fsKCwfiaaDRZJmz30VnHPdkGYcMPVSj0xtVD/AwK2kD2GSqmGR1vt8OoXCfx04FJkeiNeeoAkK1fo5KM6PN9e/5jjlTrVyfY63HZoHroVGBWKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SwT4hdcm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SwT4hdcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0F11F000E9;
	Mon, 17 Aug 2026 14:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975348;
	bh=TM+Fk6RBZEDEtiePZa/aNbSU5w++Hb3xjLqVgmH2ndM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SwT4hdcmyWLHlMBBuQIg6X6a2nc0xJstxMM2s2SBcZOhivDW7QT5iKBh7ekQ8QkWr
	 cXXLUahDD52XzYsnf1ENsOlFlz+ZvxapL3WQ41FPmjy+LjMrTtdhHvGG6XIKZZxxuT
	 bOZ90Mab2ORPmF21C8sh1Ufu37fNOf5lN1ng4GLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.18 249/250] netfilter: always set route tuple out ifindex
Date: Mon, 17 Aug 2026 15:33:30 +0200
Message-ID: <20260817132546.659522197@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit 2bdc536c9da7fa08baf0fafe9d91243b83cb9c8b upstream.

Always set nf_flow_route tuple out ifindex even if the indev is not one
of the flowtable configured devices since otherwise the outdev lookup in
nf_flow_offload_ip_hook() or nf_flow_offload_ipv6_hook() for
FLOW_OFFLOAD_XMIT_NEIGH flowtable entries will fail.
The above issue occurs in the following configuration since IP6IP6
tunnel does not support flowtable acceleration yet:

$ip addr show
5: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:11:22:33:22:55 brd ff:ff:ff:ff:ff:ff link-netns ns1
    inet6 2001:db8:1::2/64 scope global nodad
       valid_lft forever preferred_lft forever
    inet6 fe80::211:22ff:fe33:2255/64 scope link tentative proto kernel_ll
       valid_lft forever preferred_lft forever
6: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:22:22:33:22:55 brd ff:ff:ff:ff:ff:ff link-netns ns3
    inet6 2001:db8:2::1/64 scope global nodad
       valid_lft forever preferred_lft forever
    inet6 fe80::222:22ff:fe33:2255/64 scope link tentative proto kernel_ll
       valid_lft forever preferred_lft forever
7: tun0@NONE: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1452 qdisc noqueue state UNKNOWN group default qlen 1000
    link/tunnel6 2001:db8:2::1 peer 2001:db8:2::2 permaddr a85:e732:2c37::
    inet6 2002:db8:1::1/64 scope global nodad
       valid_lft forever preferred_lft forever
    inet6 fe80::885:e7ff:fe32:2c37/64 scope link proto kernel_ll
       valid_lft forever preferred_lft forever

$ip -6 route show
2001:db8:1::/64 dev eth0 proto kernel metric 256 pref medium
2001:db8:2::/64 dev eth1 proto kernel metric 256 pref medium
2002:db8:1::/64 dev tun0 proto kernel metric 256 pref medium
default via 2002:db8:1::2 dev tun0 metric 1024 pref medium

$nft list ruleset
table inet filter {
        flowtable ft {
                hook ingress priority filter
                devices = { eth0, eth1 }
        }

        chain forward {
                type filter hook forward priority filter; policy accept;
                meta l4proto { tcp, udp } flow add @ft
        }
}

Fixes: b5964aac51e0 ("netfilter: flowtable: consolidate xmit path")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_flow_table_path.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -203,6 +203,9 @@ static void nft_dev_forward_path(struct
 	if (nft_dev_fill_forward_path(route, dst, ct, dir, ha, &stack) >= 0)
 		nft_dev_path_info(&stack, &info, ha, &ft->data);
 
+	if (info.outdev)
+		route->tuple[dir].out.ifindex = info.outdev->ifindex;
+
 	if (!info.indev || !nft_flowtable_find_dev(info.indev, ft))
 		return;
 
@@ -213,7 +216,6 @@ static void nft_dev_forward_path(struct
 	}
 	route->tuple[!dir].in.num_encaps = info.num_encaps;
 	route->tuple[!dir].in.ingress_vlans = info.ingress_vlans;
-	route->tuple[dir].out.ifindex = info.outdev->ifindex;
 
 	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
 		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);


