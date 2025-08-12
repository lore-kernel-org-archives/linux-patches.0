Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7561F2FE597;
	Tue, 12 Aug 2025 18:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024072; cv=none; b=cSR0r2fuNmVCcu4vyVC8FNvo5os54rdUKACyiDXIPHJY+M14sfAHi+0bu6MBL4Gt8mDRzpQ276EK3beRB5OwXAweHhKnIniWfCV801HHjZga6NRN22MEMRm3Q0b2EeuyMnwTm254CMqliZ0e+hHT+Iby1iGCVL2IKktO1bqtnm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024072; c=relaxed/simple;
	bh=qjyTg59mKKDtHJa8XPtQ8L96vN6B9azkA3gbr2aH/jA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZlmilO5wzchdzYe1LRoLDpAyBx1YF7y8C6Gm2UZp/n1GAdyny4L5b+cKuGrdkPJVzEfv9obtne7QQTDO4IUZoOb++NFyaoYfjhh4FfzD3Sq5JVpuambb+3BYYoTYqBIk0MkDtX1YwD5oOTFPBPzYUy+4HNJhc4EAcHCTrzTWX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eARJVwhB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eARJVwhB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91FAC4CEF0;
	Tue, 12 Aug 2025 18:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024072;
	bh=qjyTg59mKKDtHJa8XPtQ8L96vN6B9azkA3gbr2aH/jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eARJVwhBe+Q+f5E3++hDBkeFaIN8GNAQzML4z4soLLROyTClabiTW7HliLWzHraO9
	 knyBjNwFNOImgLRpgh3SpxyEQ5RsqwudveurI4iMNshwYs5bj7OQCWqLK7YIVUIWqH
	 9As/0FqEe3U3NJ097eJyMdcJ04Wfu2WzvqQu7/X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 265/627] selftests: drv-net: tso: enable test cases based on hw_features
Date: Tue, 12 Aug 2025 19:29:20 +0200
Message-ID: <20250812173429.395114829@linuxfoundation.org>
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

[ Upstream commit 266b835e5e84a0f8fec7fd988ee81925890e8d89 ]

tso.py uses the active features at the time of test execution
as the set of available gso features to test. This means if a gso
feature is supported but toggled off at test start, the test will be
skipped with a "Device does not support {feature}" message.

Instead, we can enumerate the set of toggleable features by capturing
the driver's hw_features bitmap. To avoid configuration side-effects
from running the test, we also snapshot the wanted_features flag set
before making any feature changes, and then attempt to restore the
same set of wanted_features before test exit.

Fixes: 0d0f4174f6c8 ("selftests: drv-net: add a simple TSO test")
Signed-off-by: Daniel Zahka <daniel.zahka@gmail.com>
Link: https://patch.msgid.link/20250723184740.4075410-2-daniel.zahka@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/hw/tso.py | 52 ++++++++++++++-----
 1 file changed, 40 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/hw/tso.py b/tools/testing/selftests/drivers/net/hw/tso.py
index 3370827409aa..f8386e3d88cd 100755
--- a/tools/testing/selftests/drivers/net/hw/tso.py
+++ b/tools/testing/selftests/drivers/net/hw/tso.py
@@ -119,15 +119,30 @@ def build_tunnel(cfg, outer_ipver, tun_info):
     return remote_v4, remote_v6
 
 
+def restore_wanted_features(cfg):
+    features_cmd = ""
+    for feature in cfg.hw_features:
+        setting = "on" if feature in cfg.wanted_features else "off"
+        features_cmd += f" {feature} {setting}"
+    try:
+        ethtool(f"-K {cfg.ifname} {features_cmd}")
+    except Exception as e:
+        ksft_pr(f"WARNING: failure restoring wanted features: {e}")
+
+
 def test_builder(name, cfg, outer_ipver, feature, tun=None, inner_ipver=None):
     """Construct specific tests from the common template."""
     def f(cfg):
         cfg.require_ipver(outer_ipver)
+        defer(restore_wanted_features, cfg)
 
         if not cfg.have_stat_super_count and \
            not cfg.have_stat_wire_count:
             raise KsftSkipEx(f"Device does not support LSO queue stats")
 
+        if feature not in cfg.hw_features:
+            raise KsftSkipEx(f"Device does not support {feature}")
+
         ipver = outer_ipver
         if tun:
             remote_v4, remote_v6 = build_tunnel(cfg, ipver, tun)
@@ -138,12 +153,12 @@ def test_builder(name, cfg, outer_ipver, feature, tun=None, inner_ipver=None):
 
         tun_partial = tun and tun[1]
         # Tunnel which can silently fall back to gso-partial
-        has_gso_partial = tun and 'tx-gso-partial' in cfg.features
+        has_gso_partial = tun and 'tx-gso-partial' in cfg.hw_features
 
         # For TSO4 via partial we need mangleid
         if ipver == "4" and feature in cfg.partial_features:
             ksft_pr("Testing with mangleid enabled")
-            if 'tx-tcp-mangleid-segmentation' not in cfg.features:
+            if 'tx-tcp-mangleid-segmentation' not in cfg.hw_features:
                 ethtool(f"-K {cfg.ifname} tx-tcp-mangleid-segmentation on")
                 defer(ethtool, f"-K {cfg.ifname} tx-tcp-mangleid-segmentation off")
 
@@ -161,11 +176,8 @@ def test_builder(name, cfg, outer_ipver, feature, tun=None, inner_ipver=None):
                            should_lso=tun_partial)
 
         # Full feature enabled.
-        if feature in cfg.features:
-            ethtool(f"-K {cfg.ifname} {feature} on")
-            run_one_stream(cfg, ipver, remote_v4, remote_v6, should_lso=True)
-        else:
-            raise KsftXfailEx(f"Device does not support {feature}")
+        ethtool(f"-K {cfg.ifname} {feature} on")
+        run_one_stream(cfg, ipver, remote_v4, remote_v6, should_lso=True)
 
     f.__name__ = name + ((outer_ipver + "_") if tun else "") + "ipv" + inner_ipver
     return f
@@ -176,23 +188,39 @@ def query_nic_features(cfg) -> None:
     cfg.have_stat_super_count = False
     cfg.have_stat_wire_count = False
 
-    cfg.features = set()
     features = cfg.ethnl.features_get({"header": {"dev-index": cfg.ifindex}})
-    for f in features["active"]["bits"]["bit"]:
-        cfg.features.add(f["name"])
+
+    cfg.wanted_features = set()
+    for f in features["wanted"]["bits"]["bit"]:
+        cfg.wanted_features.add(f["name"])
+
+    cfg.hw_features = set()
+    hw_all_features_cmd = ""
+    for f in features["hw"]["bits"]["bit"]:
+        if f.get("value", False):
+            feature = f["name"]
+            cfg.hw_features.add(feature)
+            hw_all_features_cmd += f" {feature} on"
+    try:
+        ethtool(f"-K {cfg.ifname} {hw_all_features_cmd}")
+    except Exception as e:
+        ksft_pr(f"WARNING: failure enabling all hw features: {e}")
+        ksft_pr("partial gso feature detection may be impacted")
 
     # Check which features are supported via GSO partial
     cfg.partial_features = set()
-    if 'tx-gso-partial' in cfg.features:
+    if 'tx-gso-partial' in cfg.hw_features:
         ethtool(f"-K {cfg.ifname} tx-gso-partial off")
 
         no_partial = set()
         features = cfg.ethnl.features_get({"header": {"dev-index": cfg.ifindex}})
         for f in features["active"]["bits"]["bit"]:
             no_partial.add(f["name"])
-        cfg.partial_features = cfg.features - no_partial
+        cfg.partial_features = cfg.hw_features - no_partial
         ethtool(f"-K {cfg.ifname} tx-gso-partial on")
 
+    restore_wanted_features(cfg)
+
     stats = cfg.netnl.qstats_get({"ifindex": cfg.ifindex}, dump=True)
     if stats:
         if 'tx-hw-gso-packets' in stats[0]:
-- 
2.39.5



