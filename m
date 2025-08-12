Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202F62FDC4F;
	Tue, 12 Aug 2025 18:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024080; cv=none; b=GhKi3xZZMcFe7yH4/w1evbctS5oKav1d60pt8Z0GeHd8dOC7X2TDKWzOnI6fpfshKGYxXHLyo943/DCZJIn08YFOMDPbWycZKDypDC9d71M44C7dwkXct7H4Ss+126MOKQwk9IhfJU+J2fwVCz6jYW4s9tq6gcxKykskh0wn1DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024080; c=relaxed/simple;
	bh=amfLlVlbKNislitfMwK+gq4rJw4v7oN98V8llIiLD6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIx3f+A/DxCD8hmER937wgXNiE1QPm7lvnuuifTt129XWRKjIm59REr1gpUEKGmrp0VX8hGekO+Gqp6LpRa9P0Dmq5rojeuiYFkhK2HL+7fNzdntalopaTnHDMmQ+lKYYEurFg1NUjMM58d8R8St71TAqUwlrJtsYsU9Xk+kpOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Obx6wXSS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Obx6wXSS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84827C4CEF0;
	Tue, 12 Aug 2025 18:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024080;
	bh=amfLlVlbKNislitfMwK+gq4rJw4v7oN98V8llIiLD6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Obx6wXSSm7hfD6ZJwaqE4YrVmSKXKoBFIPVUidHK9rCVj2EE4u4grGq8Obt7Fg3u2
	 Un8K0z1C6/alIg5p3NdNdvDO6Tg+KJq8yXCO96T+LgvuQsyVbfkZ5BU40MBXbLaoyG
	 M+8DzxbBmi/NTH5xQH9NT+112iTuSbxmOTBTKHMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 267/627] selftests: drv-net: tso: fix non-tunneled tso6 test case name
Date: Tue, 12 Aug 2025 19:29:22 +0200
Message-ID: <20250812173429.470080870@linuxfoundation.org>
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

[ Upstream commit b25b44cd178cc54277f2dc0ff3b3d5a37ae4b26b ]

The non-tunneled tso6 test case was showing up as:
ok 8 tso.ipv4

This is because of the way test_builder() uses the inner_ipver arg in
test naming, and how test_info is iterated over in main(). Given that
some tunnels not supported yet, e.g. ipip or sit, only support ipv4 or
ipv6 as the inner network protocol, I think the best fix here is to
call test_builder() in separate branches for tunneled and non-tunneled
tests, and to make supported inner l3 types an explicit attribute of
tunnel test cases.

  # Detected qstat for LSO wire-packets
  TAP version 13
  1..14
  ok 1 tso.ipv4
  # Testing with mangleid enabled
  ok 2 tso.vxlan4_ipv4
  ok 3 tso.vxlan4_ipv6
  # Testing with mangleid enabled
  ok 4 tso.vxlan_csum4_ipv4
  ok 5 tso.vxlan_csum4_ipv6
  # Testing with mangleid enabled
  ok 6 tso.gre4_ipv4
  ok 7 tso.gre4_ipv6
  ok 8 tso.ipv6
  # Testing with mangleid enabled
  ok 9 tso.vxlan6_ipv4
  ok 10 tso.vxlan6_ipv6
  # Testing with mangleid enabled
  ok 11 tso.vxlan_csum6_ipv4
  ok 12 tso.vxlan_csum6_ipv6
  # Testing with mangleid enabled
  ok 13 tso.gre6_ipv4
  ok 14 tso.gre6_ipv6
  # Totals: pass:14 fail:0 xfail:0 xpass:0 skip:0 error:0

Fixes: 0d0f4174f6c8 ("selftests: drv-net: add a simple TSO test")
Signed-off-by: Daniel Zahka <daniel.zahka@gmail.com>
Link: https://patch.msgid.link/20250723184740.4075410-4-daniel.zahka@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/hw/tso.py | 26 ++++++++++---------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/hw/tso.py b/tools/testing/selftests/drivers/net/hw/tso.py
index 6461a83b3d0e..5fddb5056a20 100755
--- a/tools/testing/selftests/drivers/net/hw/tso.py
+++ b/tools/testing/selftests/drivers/net/hw/tso.py
@@ -227,14 +227,14 @@ def main() -> None:
         query_nic_features(cfg)
 
         test_info = (
-            # name,       v4/v6  ethtool_feature              tun:(type,     args)
-            ("",            "4", "tx-tcp-segmentation",           None),
-            ("",            "6", "tx-tcp6-segmentation",          None),
-            ("vxlan",       "4", "tx-udp_tnl-segmentation",       ("vxlan",  "id 100 dstport 4789 noudpcsum")),
-            ("vxlan",       "6", "tx-udp_tnl-segmentation",       ("vxlan",  "id 100 dstport 4789 udp6zerocsumtx udp6zerocsumrx")),
-            ("vxlan_csum",   "", "tx-udp_tnl-csum-segmentation",  ("vxlan",  "id 100 dstport 4789 udpcsum")),
-            ("gre",         "4", "tx-gre-segmentation",           ("gre",    "")),
-            ("gre",         "6", "tx-gre-segmentation",           ("ip6gre", "")),
+            # name,       v4/v6  ethtool_feature               tun:(type, args, inner ip versions)
+            ("",           "4", "tx-tcp-segmentation",         None),
+            ("",           "6", "tx-tcp6-segmentation",        None),
+            ("vxlan",      "4", "tx-udp_tnl-segmentation",     ("vxlan", "id 100 dstport 4789 noudpcsum", ("4", "6"))),
+            ("vxlan",      "6", "tx-udp_tnl-segmentation",     ("vxlan", "id 100 dstport 4789 udp6zerocsumtx udp6zerocsumrx", ("4", "6"))),
+            ("vxlan_csum", "", "tx-udp_tnl-csum-segmentation", ("vxlan", "id 100 dstport 4789 udpcsum", ("4", "6"))),
+            ("gre",        "4", "tx-gre-segmentation",         ("gre",   "", ("4", "6"))),
+            ("gre",        "6", "tx-gre-segmentation",         ("ip6gre","", ("4", "6"))),
         )
 
         cases = []
@@ -244,11 +244,13 @@ def main() -> None:
                 if info[1] and outer_ipver != info[1]:
                     continue
 
-                cases.append(test_builder(info[0], cfg, outer_ipver, info[2],
-                                          tun=info[3], inner_ipver="4"))
                 if info[3]:
-                    cases.append(test_builder(info[0], cfg, outer_ipver, info[2],
-                                              tun=info[3], inner_ipver="6"))
+                    cases += [
+                        test_builder(info[0], cfg, outer_ipver, info[2], info[3], inner_ipver)
+                        for inner_ipver in info[3][2]
+                    ]
+                else:
+                    cases.append(test_builder(info[0], cfg, outer_ipver, info[2], None, outer_ipver))
 
         ksft_run(cases=cases, args=(cfg, ))
     ksft_exit()
-- 
2.39.5



