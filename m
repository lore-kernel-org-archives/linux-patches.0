Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B27B2FF148;
	Tue, 12 Aug 2025 18:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024076; cv=none; b=fTHqVYjNQ9yvkU1Yk1BSvtPxFfXRFAwwW1b/qnxwi0evLHGTK5L4mr69+oJwCWF8Tp2iH0RVPADufYQZlpS1Mb2V7XLXj5bGjDALvDUBg7XJe4qsDS1r/ZiynUyFXPkHZ3Y3awhu/DmrTyhnoTGSl9SCQs6BMUcvZKU+obZ+YrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024076; c=relaxed/simple;
	bh=KoF4r9imrcNFK4Z9DLvuc2wmjRSkucw3rtkCwoFiCcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uhs62Iinz8aS1qmVElTYYnX5DGat9RGibAG8s7QumeEqgzEzvCMh90sD0e+AY1U5UKQpX+JbPVXkFBh13b8ERw+/fBQvkSlKWqEpJjnbXvlZVnuCrzX/h7gK+CcSvlqg+bho88KDwvhFG3h90LFgp3bwI5w4OaUYlc9UNOPygOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SCpf12Jr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SCpf12Jr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11695C4CEF0;
	Tue, 12 Aug 2025 18:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024076;
	bh=KoF4r9imrcNFK4Z9DLvuc2wmjRSkucw3rtkCwoFiCcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SCpf12JrI3b2gQ8pubyzALi04gOILB3Nf+y6X9LLVLO6moxqHaloDzenbA14vRjiT
	 nO++ljmVi1jRnEGfl+2pwps2YeFr6NzbYXdX87IShX99J6l4xVxeb/sZIPDBuRMJ8W
	 cI+n6QjzDasJw5om64oNIoOkuaGLrFw1TuaAE6mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 266/627] selftests: drv-net: tso: fix vxlan tunnel flags to get correct gso_type
Date: Tue, 12 Aug 2025 19:29:21 +0200
Message-ID: <20250812173429.433456577@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Zahka <daniel.zahka@gmail.com>

[ Upstream commit 2cfbcc5d8af9199823151c21f740e476b223dd2e ]

When vxlan is used with ipv6 as the outer network header, the correct
ip link parameters for acheiving the SKB_GSO_UDP_TUNNEL gso type is
"udp6zerocsumtx udp6zerocsumrx". Otherwise the gso type will be
SKB_GSO_UDP_TUNNEL_CSUM.

This bug was the reason for the second of the three possible
invocations of run_one_stream() invocations, so that can be deleted as
well. We only need to test with the feature off and on.

Fixes: 0d0f4174f6c8 ("selftests: drv-net: add a simple TSO test")
Signed-off-by: Daniel Zahka <daniel.zahka@gmail.com>
Link: https://patch.msgid.link/20250723184740.4075410-3-daniel.zahka@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/hw/tso.py | 37 +++++++------------
 1 file changed, 13 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/hw/tso.py b/tools/testing/selftests/drivers/net/hw/tso.py
index f8386e3d88cd..6461a83b3d0e 100755
--- a/tools/testing/selftests/drivers/net/hw/tso.py
+++ b/tools/testing/selftests/drivers/net/hw/tso.py
@@ -102,7 +102,7 @@ def build_tunnel(cfg, outer_ipver, tun_info):
     remote_addr = cfg.remote_addr_v[outer_ipver]
 
     tun_type = tun_info[0]
-    tun_arg  = tun_info[2]
+    tun_arg  = tun_info[1]
     ip(f"link add {tun_type}-ksft type {tun_type} {tun_arg} local {local_addr} remote {remote_addr} dev {cfg.ifname}")
     defer(ip, f"link del {tun_type}-ksft")
     ip(f"link set dev {tun_type}-ksft up")
@@ -151,29 +151,17 @@ def test_builder(name, cfg, outer_ipver, feature, tun=None, inner_ipver=None):
             remote_v4 = cfg.remote_addr_v["4"]
             remote_v6 = cfg.remote_addr_v["6"]
 
-        tun_partial = tun and tun[1]
-        # Tunnel which can silently fall back to gso-partial
-        has_gso_partial = tun and 'tx-gso-partial' in cfg.hw_features
-
-        # For TSO4 via partial we need mangleid
-        if ipver == "4" and feature in cfg.partial_features:
-            ksft_pr("Testing with mangleid enabled")
-            if 'tx-tcp-mangleid-segmentation' not in cfg.hw_features:
-                ethtool(f"-K {cfg.ifname} tx-tcp-mangleid-segmentation on")
-                defer(ethtool, f"-K {cfg.ifname} tx-tcp-mangleid-segmentation off")
-
         # First test without the feature enabled.
         ethtool(f"-K {cfg.ifname} {feature} off")
-        if has_gso_partial:
-            ethtool(f"-K {cfg.ifname} tx-gso-partial off")
         run_one_stream(cfg, ipver, remote_v4, remote_v6, should_lso=False)
 
-        # Now test with the feature enabled.
-        # For compatible tunnels only - just GSO partial, not specific feature.
-        if has_gso_partial:
+        ethtool(f"-K {cfg.ifname} tx-gso-partial off")
+        ethtool(f"-K {cfg.ifname} tx-tcp-mangleid-segmentation off")
+        if feature in cfg.partial_features:
             ethtool(f"-K {cfg.ifname} tx-gso-partial on")
-            run_one_stream(cfg, ipver, remote_v4, remote_v6,
-                           should_lso=tun_partial)
+            if ipver == "4":
+                ksft_pr("Testing with mangleid enabled")
+                ethtool(f"-K {cfg.ifname} tx-tcp-mangleid-segmentation on")
 
         # Full feature enabled.
         ethtool(f"-K {cfg.ifname} {feature} on")
@@ -239,13 +227,14 @@ def main() -> None:
         query_nic_features(cfg)
 
         test_info = (
-            # name,       v4/v6  ethtool_feature              tun:(type,    partial, args)
+            # name,       v4/v6  ethtool_feature              tun:(type,     args)
             ("",            "4", "tx-tcp-segmentation",           None),
             ("",            "6", "tx-tcp6-segmentation",          None),
-            ("vxlan",        "", "tx-udp_tnl-segmentation",       ("vxlan",  True,  "id 100 dstport 4789 noudpcsum")),
-            ("vxlan_csum",   "", "tx-udp_tnl-csum-segmentation",  ("vxlan",  False, "id 100 dstport 4789 udpcsum")),
-            ("gre",         "4", "tx-gre-segmentation",           ("gre",    False,  "")),
-            ("gre",         "6", "tx-gre-segmentation",           ("ip6gre", False,  "")),
+            ("vxlan",       "4", "tx-udp_tnl-segmentation",       ("vxlan",  "id 100 dstport 4789 noudpcsum")),
+            ("vxlan",       "6", "tx-udp_tnl-segmentation",       ("vxlan",  "id 100 dstport 4789 udp6zerocsumtx udp6zerocsumrx")),
+            ("vxlan_csum",   "", "tx-udp_tnl-csum-segmentation",  ("vxlan",  "id 100 dstport 4789 udpcsum")),
+            ("gre",         "4", "tx-gre-segmentation",           ("gre",    "")),
+            ("gre",         "6", "tx-gre-segmentation",           ("ip6gre", "")),
         )
 
         cases = []
-- 
2.39.5



