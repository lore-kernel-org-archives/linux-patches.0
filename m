Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF12376A06;
	Tue, 21 Jul 2026 17:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653527; cv=none; b=pjCBPEttlPzgazjGBymbXOFZYnbN8f10GrjFq+WanQaC7SKkdiWUGjo+0aYyvTX+g1wN4l1eY3j+MuAiuDLFcu2x7QG4IqvDDcVQes2c09W46lyv4T//jtGLWYZ3j0uBgtDl8wamOKXvOAacvIERA5ijf76qUOo4HWuuhVn/LwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653527; c=relaxed/simple;
	bh=YrFdFmTpF8ECzHQ6Klq7xFoufQKIgbK9HLhgPzpochI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rtz0NkVcgPSbLXrH70eTuCVv5Ku6ZnLvChH+CHyB5NXbOW02FG/7uB5WfUdEKC3c0fY8tT0quXfgTxWOR4xKupssMemMAxJ6F4+WWU1OdN0Hh7T/MLUo5/hMf/nJUDB3IuxLzfuQcaNaBW9eHUyDNGCbt/yL0d0Wj3FKd7zThRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aaITd77u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aaITd77u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7C51F000E9;
	Tue, 21 Jul 2026 17:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653525;
	bh=hh7R/sODiOxTz+j621JpfmUolQhYxsELlUwB5WURWu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aaITd77uMCJYjQjg/u+Epkgm1R9inHFJTGdd38x2nhgUnSErkYKkJZkKcl7gG5qEh
	 XxnqtoZUcNovcYnFGlJKAczxOnbrbnOulm5nqCmI+WhGrl7pFgWHNr3A3bVnF4Mh8x
	 EWpR52MYSF6jeEvrnBAtRrj4/8Xf+XOUI7cq1CdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1360/2077] selftests: drv-net: tso: dont touch dangerous feature bits
Date: Tue, 21 Jul 2026 17:17:13 +0200
Message-ID: <20260721152624.895943919@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 2f7f2e311106cb838d3f3fb6ef25effdb3f8e366 ]

query_nic_features() detects which offloads depend on tx-gso-partial
by enabling everything, turning tx-gso-partial off, and seeing which
active features drop out. Enabling all hw features is dangerous:
we may end up enabling rx-fcs and loopback for example. For the
ice driver we end up getting into problems with feature dependencies
so the cleanup isn't successful either, and the test exits with
rx-fcs and loopback enabled.

Scope the feature probing just to segmentation bits.

Fixes: 266b835e5e84 ("selftests: drv-net: tso: enable test cases based on hw_features")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Daniel Zahka <daniel.zahka@gmail.com>
Link: https://patch.msgid.link/20260629233923.2151144-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/hw/tso.py | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/hw/tso.py b/tools/testing/selftests/drivers/net/hw/tso.py
index bb675e3dac88f7..abc575e4b34065 100755
--- a/tools/testing/selftests/drivers/net/hw/tso.py
+++ b/tools/testing/selftests/drivers/net/hw/tso.py
@@ -187,28 +187,24 @@ def query_nic_features(cfg) -> None:
         cfg.wanted_features.add(f["name"])
 
     cfg.hw_features = set()
-    hw_all_features_cmd = ""
     for f in features["hw"]["bits"]["bit"]:
         if f.get("value", False):
-            feature = f["name"]
-            cfg.hw_features.add(feature)
-            hw_all_features_cmd += f" {feature} on"
-    try:
-        ethtool(f"-K {cfg.ifname} {hw_all_features_cmd}")
-    except Exception as e:
-        ksft_pr(f"WARNING: failure enabling all hw features: {e}")
-        ksft_pr("partial gso feature detection may be impacted")
+            cfg.hw_features.add(f["name"])
 
     # Check which features are supported via GSO partial
     cfg.partial_features = set()
     if 'tx-gso-partial' in cfg.hw_features:
+        seg_features = {f for f in cfg.hw_features if "segmentation" in f}
+        ethtool(f"-K {cfg.ifname} " +
+                " ".join(f"{f} on" for f in seg_features))
+
         ethtool(f"-K {cfg.ifname} tx-gso-partial off")
 
         no_partial = set()
         features = cfg.ethnl.features_get({"header": {"dev-index": cfg.ifindex}})
         for f in features["active"]["bits"]["bit"]:
             no_partial.add(f["name"])
-        cfg.partial_features = cfg.hw_features - no_partial
+        cfg.partial_features = seg_features - no_partial
         ethtool(f"-K {cfg.ifname} tx-gso-partial on")
 
     restore_wanted_features(cfg)
-- 
2.53.0



